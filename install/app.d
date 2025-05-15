import std.stdio;
import std.file;
import std.path;
import std.process;
import std.string;
import std.conv;
import std.getopt;
import std.json;
import std.exception;
import std.net.curl;
import std.algorithm;
import std.array;
import std.zip;
import std.datetime;
import std.system;

version(Windows)
    enum platform = "windows";
else version(linux)
    enum platform = "linux";
else version(OSX)
    enum platform = "macos";
else
    static assert(0, "Unsupported platform");

version(X86_64)
    enum arch = "x86_64";
else version(X86)
    enum arch = "x86";
else version(AArch64)
    enum arch = "arm64";
else version(ARM)
    enum arch = "arm";
else
    static assert(0, "Unsupported architecture");

enum cfitsioVersion = "4.4.0"; // Change as needed
enum baseUrl = "https://github.com/chrischtel/cfitsio-d/releases/download/v" ~ cfitsioVersion ~ "/";

string archiveName()
{
    version(Windows)
        return platform ~ "-" ~ arch ~ ".zip";
    else
        return platform ~ "-" ~ arch ~ ".tar.gz";
}

string[] neededFiles()
{
    version(Windows) return ["cfitsio.dll", "cfitsio.lib"];
    version(linux) return ["libcfitsio.so"];
    version(OSX) return ["libcfitsio.dylib"];
    static assert(0, "Unsupported platform");
}

void downloadFile(string url, string dest)
{
    writeln("Downloading ", url, " ...");
    auto tmp = dest ~ ".tmp";
    try {
        download(url, tmp);
        rename(tmp, dest);
    } catch (Exception e) {
        if (exists(tmp)) remove(tmp);
        throw e;
    }
    writeln("Saved to ", dest);
}

void extractZip(string zipPath, string[] files, string destDir)
{
    import std.zip;
    auto data = cast(ubyte[]) read(zipPath);
    auto archive = new ZipArchive(data);
    foreach (file; files) {
        auto member = archive.byName(file);
        enforce(member !is null, "File " ~ file ~ " not found in archive!");
        auto outPath = buildPath(destDir, file);
        write(outPath, member.decompress());
        writeln("Extracted ", file, " to ", outPath);
    }
}

void extractTarGz(string tarGzPath, string[] files, string destDir)
{
    import std.process : executeShell;
    // Use system tar for simplicity (cross-platform D tar/gz is possible but verbose)
    string cmd = format("tar -xzf %s -C %s %s", tarGzPath, destDir, files.join(" "));
    auto result = executeShell(cmd);
    enforce(result.status == 0, "Failed to extract archive: " ~ result.output);
    foreach (file; files)
        writeln("Extracted ", file, " to ", destDir);
}

void updateDubJson()
{
    if (!exists("dub.json")) return;
    auto content = readText("dub.json");
    auto json = parseJSON(content);
    bool changed = false;

    // Add "cfitsio" to "libs"
    if (!("libs" in json))
        json["libs"] = [];
    auto libs = json["libs"].array;
    if (!libs.canFind("cfitsio")) {
        libs ~= "cfitsio";
        json["libs"] = libs;
        changed = true;
    }

    // Add linker flags
    string[][string] flags = [
        "lflags-windows": ["-L."],
        "lflags-posix": ["-L."],
        "lflags-osx": ["-rpath", "@executable_path/"],
        "lflags-linux": ["-rpath=$$ORIGIN"]
    ];
    foreach (k, v; flags) {
        if (!(k in json)) json[k] = [];
        auto arr = json[k].array;
        foreach (flag; v)
            if (!arr.canFind(flag)) arr ~= flag;
        json[k] = arr;
        changed = true;
    }

    if (changed) {
        writeln("Updating dub.json with cfitsio linker flags...");
        write("dub.json", json.toString());
    } else {
        writeln("dub.json already contains correct linker flags.");
    }
}

void main(string[] args)
{
    bool updateDub = true;
    bool quiet = false;
    getopt(args,
        "no-update-dub", &updateDub,
        "quiet|q", &quiet
    );

    auto say = (string msg) { if (!quiet) writeln(msg); };

    say("cfitsio-d install script");
    auto files = neededFiles();
    auto archive = archiveName();
    auto url = baseUrl ~ archive;
    auto localArchive = buildPath(".", archive);

    // Download archive if not present
    if (!exists(localArchive)) {
        try {
            downloadFile(url, localArchive);
        } catch (Exception e) {
            stderr.writeln("Error downloading archive: ", e.msg);
            return;
        }
    } else {
        say("Archive already downloaded: " ~ localArchive);
    }

    // Extract files
    try {
        version(Windows)
            extractZip(localArchive, files, ".");
        else
            extractTarGz(localArchive, files, ".");
    } catch (Exception e) {
        stderr.writeln("Error extracting archive: ", e.msg);
        return;
    }

    // Optionally update dub.json
    if (updateDub)
        updateDubJson();

    say("Done! You can now build your project with cfitsio-d.");
}
