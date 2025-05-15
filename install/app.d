/**
 * cfitsio-d installer
 * 
 * Downloads and installs the appropriate CFITSIO binary libraries for the
 * current platform and configures dub.json for building with cfitsio-d.
 */
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

// Platform detection
version(Windows)
    enum platform = "windows";
else version(linux)
    enum platform = "linux";
else version(OSX)
    enum platform = "macos";
else
    static assert(0, "Unsupported platform");

// Architecture detection
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

struct Config {
    string version_ = "4.6.2";
    bool updateDub = true;
    bool quiet = false;
    bool force = false;
    string outputDir = ".";
    bool keepArchive = false;
    bool backupFiles = true;
    string proxyUrl = null;
}

void main(string[] args)
{
    Config config;
    bool showHelp = false;
    
    // Parse command line arguments
    auto helpInfo = getopt(args,
        "version|v", "CFITSIO version to install (default: " ~ config.version_ ~ ")", &config.version_,
        "no-update-dub", "Don't update dub.json with library configuration", &config.updateDub,
        "quiet|q", "Suppress non-error output", &config.quiet,
        "force|f", "Force download even if files exist", &config.force,
        "output|o", "Output directory for library files", &config.outputDir,
        "keep-archive|k", "Keep downloaded archive file", &config.keepArchive,
        "no-backup", "Don't create backups of existing files", &config.backupFiles,
        "proxy", "Proxy URL to use for downloads", &config.proxyUrl,
        "help|h", "Show this help", &showHelp
    );

    auto log = Logger(config.quiet);
    
    if (showHelp) {
        log.info("cfitsio-d install script");
        log.info("Platform: " ~ platform ~ "-" ~ arch);
        log.info("");
        defaultGetoptPrinter("Usage: dub run cfitsio-d:install [options]", helpInfo.options);
        return;
    }

    log.info("cfitsio-d install script");
    log.info("Platform: " ~ platform ~ "-" ~ arch);
    log.info("CFITSIO version: " ~ config.version_);
    
    try {
        // Ensure output directory exists
        if (!exists(config.outputDir))
            mkdirRecurse(config.outputDir);
    
        // Calculate file paths and URLs
        auto installer = new CfitsioInstaller(config);
        
        // Install the library
        installer.install();
        
        // Update dub.json if requested
        if (config.updateDub)
            installer.updateDubJson();
            
        log.info("Done! You can now build your project with cfitsio-d.");
    }
    catch (Exception e) {
        stderr.writefln("Error: %s", e.msg);
        return;
    }
}

struct Logger {
    bool quiet;
    
    void info(string msg) {
        if (!quiet) writeln(msg);
    }
    
    void progress(size_t dlTotal, size_t dlNow) {
        if (quiet) return;
        
        enum width = 50;
        auto percentage = dlTotal > 0 ? cast(int)(dlNow * 100 / dlTotal) : 0;
        auto bars = dlTotal > 0 ? cast(int)(dlNow * width / dlTotal) : 0;
        
        write("\r[");
        for (int i = 0; i < width; i++)
            write(i < bars ? "#" : " ");
        writef("] %3d%%", percentage);
        stdout.flush();
        
        if (dlNow >= dlTotal)
            writeln();
    }
}

class CfitsioInstaller {
    private Config config;
    private Logger log;
    private string baseUrl;
    private string archiveName;
    private string[] libraryFiles;
    private string localArchivePath;
    
    this(Config config) {
        this.config = config;
        this.log = Logger(config.quiet);
        
        baseUrl = "https://github.com/chrischtel/cfitsio-d/releases/download/cfitsio-" ~ config.version_ ~ "/";
        archiveName = platform ~ "-" ~ arch ~ (platform == "windows" ? ".zip" : ".tar.gz");
        libraryFiles = getNeededFiles();
        localArchivePath = buildPath(config.outputDir, archiveName);
    }
    
    void install() {
        // Download the archive
        downloadArchive();
        
        // Extract the files
        extractFiles();
        
        // Clean up if requested
        if (!config.keepArchive && exists(localArchivePath)) {
            log.info("Removing archive file...");
            try {
                remove(localArchivePath);
            } catch (Exception e) {
                log.info("Warning: Could not remove archive file: " ~ e.msg);
            }
        }
    }
    
    private string[] getNeededFiles() {
        debug pragma(msg, "Platform detection check");
        
        version(Windows) {
            debug pragma(msg, "Windows detected");
            return ["cfitsio.dll", "cfitsio.lib"];
        }
        else version(linux) {
            debug pragma(msg, "Linux detected");
            return ["libcfitsio.so"];
        }
        else version(OSX) {
            debug pragma(msg, "macOS detected");
            return ["libcfitsio.dylib"];
        }
        else {
            debug pragma(msg, "No platform detected");
            static assert(0, "Unsupported platform");
        }
    }
    
    private void downloadArchive() {
        auto url = baseUrl ~ archiveName;
        
        if (exists(localArchivePath) && !config.force) {
            log.info("Archive already exists: " ~ localArchivePath);
            return;
        }
        
        log.info("Downloading " ~ url ~ " ...");
        auto tmpPath = localArchivePath ~ ".tmp";
        
        try {
            auto http = HTTP();
            
            // Configure proxy if specified
            if (config.proxyUrl !is null) {
                http.proxy = config.proxyUrl;
            }
            
            // Set up progress callback
            http.onProgress = (size_t dlTotal, size_t dlNow, size_t ulTotal, size_t ulNow) {
                log.progress(dlTotal, dlNow);
                return 0;
            };
            
            download(url, tmpPath, http);
            rename(tmpPath, localArchivePath);
            log.info("Downloaded to " ~ localArchivePath);
        } 
        catch (Exception e) {
            if (exists(tmpPath)) try { remove(tmpPath); } catch (Exception) {}
            throw new Exception("Failed to download CFITSIO: " ~ e.msg);
        }
    }
    
    private void extractFiles() {
        log.info("Extracting library files...");
        
        // Backup existing files if needed
        if (config.backupFiles) {
            foreach (file; libraryFiles) {
                auto destPath = buildPath(config.outputDir, file);
                if (exists(destPath)) {
                    auto backupPath = destPath ~ ".bak";
                    log.info("Backing up " ~ destPath ~ " to " ~ backupPath);
                    try {
                        if (exists(backupPath)) remove(backupPath);
                        rename(destPath, backupPath);
                    } 
                    catch (Exception e) {
                        log.info("Warning: Could not create backup: " ~ e.msg);
                    }
                }
            }
        }
        
        try {
            version(Windows)
                extractZip(localArchivePath, libraryFiles, config.outputDir);
            else
                extractTarGz(localArchivePath, libraryFiles, config.outputDir);
        } 
        catch (Exception e) {
            throw new Exception("Failed to extract library files: " ~ e.msg);
        }
    }
    
    private void extractZip(string zipPath, string[] files, string destDir) {
        auto data = cast(ubyte[]) read(zipPath);
        auto archive = new ZipArchive(data);
        
        foreach (file; files) {
            try {
                // Find file in archive
                auto member = file in archive.directory ? archive.directory[file] : null;
                enforce(member !is null, "File " ~ file ~ " not found in archive!");
                
                auto outPath = buildPath(destDir, file);
                std.file.write(outPath, member.expandedData);
                log.info("Extracted " ~ file ~ " to " ~ outPath);
            } 
            catch (Exception e) {
                throw new Exception("Failed to extract " ~ file ~ ": " ~ e.msg);
            }
        }
    }
    private void extractTarGz(string tarGzPath, string[] files, string destDir) {
        // Use system tar for simplicity
        string cmd = format("tar -xzf %s -C %s %s", tarGzPath, destDir, files.join(" "));
        auto result = executeShell(cmd);
        
        if (result.status != 0) {
            throw new Exception("Failed to extract archive: " ~ result.output);
        }
        
        foreach (file; files) {
            auto outPath = buildPath(destDir, file);
            if (!exists(outPath)) {
                throw new Exception("Expected file not extracted: " ~ file);
            }
            log.info("Extracted " ~ file ~ " to " ~ outPath);
        }
    }
    
    void updateDubJson() {
        string dubJsonPath = "dub.json";
        if (!exists(dubJsonPath)) {
            log.info("No dub.json found, skipping configuration.");
            return;
        }
        
        log.info("Updating dub.json with cfitsio configuration...");
        
        try {
            auto content = readText(dubJsonPath);
            auto json = parseJSON(content);
            bool changed = false;
            
            // Create a backup of dub.json
            if (config.backupFiles) {
                auto backupPath = dubJsonPath ~ ".bak";
                log.info("Backing up " ~ dubJsonPath ~ " to " ~ backupPath);
                std.file.write(backupPath, content);
            }

            // Add "cfitsio" to "libs"
            if (!("libs" in json)) {
                json["libs"] = parseJSON("[]");
            }
            
            auto libs = json["libs"].array;
            bool found = false;
            foreach (lib; libs) {
                if (lib.type == JSONType.string && lib.str == "cfitsio") {
                    found = true;
                    break;
                }
            }
            
            if (!found) {
                libs ~= JSONValue("cfitsio");
                json["libs"] = JSONValue(libs);
                changed = true;
            }

            // Add necessary linker flags
            string[][string] flags = [
                "lflags-windows": ["-L."],
                "lflags-posix": ["-L."],
                "lflags-osx": ["-rpath", "@executable_path/"],
                "lflags-linux": ["-rpath=$$ORIGIN"]
            ];
            
            foreach (k, v; flags) {
                if (!(k in json)) {
                    json[k] = parseJSON("[]");
                }
                
                auto arr = json[k].array;
                foreach (flag; v) {
                    bool found = false;
                    foreach (item; arr) {
                        if (item.type == JSONType.string && item.str == flag) {
                            found = true;
                            break;
                        }
                    }
                    
                    if (!found) {
                        arr ~= JSONValue(flag);
                        changed = true;
                    }
                }
                
                json[k] = JSONValue(arr);
            }

            if (changed) {
                // Format JSON with indentation for better readability
                std.file.write(dubJsonPath, toPrettyJson(json));
                log.info("Updated dub.json successfully.");
            } 
            else {
                log.info("dub.json already contains correct configuration.");
            }
        } 
        catch (Exception e) {
            log.info("Warning: Failed to update dub.json: " ~ e.msg);
        }
    }

}

// Helper function to format JSON with indentation
string toPrettyJson(JSONValue value, int indent = 0) {
    import std.format : format;
    
    string indentStr = "    ";
    string currIndent = "";
    for (int i = 0; i < indent; i++) currIndent ~= indentStr;
    
    final switch (value.type) {
        case JSONType.null_:
            return "null";
        case JSONType.string:
            return `"` ~ value.str.replace(`"`, `\"`) ~ `"`;
        case JSONType.integer:
            return format("%d", value.integer);
        case JSONType.uinteger:
            return format("%d", value.uinteger);
        case JSONType.float_:
            return format("%g", value.floating);
        case JSONType.true_:
            return "true";
        case JSONType.false_:
            return "false";
        case JSONType.object:
            if (value.object.length == 0) return "{}";
            
            string result = "{\n";
            bool first = true;
            
            foreach (key, val; value.object) {
                if (!first) result ~= ",\n";
                first = false;
                result ~= currIndent ~ indentStr ~ `"` ~ key ~ `": ` ~ toPrettyJson(val, indent + 1);
            }
            
            result ~= "\n" ~ currIndent ~ "}";
            return result;
        case JSONType.array:
            if (value.array.length == 0) return "[]";
            
            // Simple format for short string arrays
            if (value.array.length < 5 && value.array.all!(v => v.type == JSONType.string)) {
                string result = "[ ";
                foreach (i, val; value.array) {
                    if (i > 0) result ~= ", ";
                    result ~= toPrettyJson(val);
                }
                result ~= " ]";
                return result;
            }
            
            string result = "[\n";
            foreach (i, val; value.array) {
                if (i > 0) result ~= ",\n";
                result ~= currIndent ~ indentStr ~ toPrettyJson(val, indent + 1);
            }
            result ~= "\n" ~ currIndent ~ "]";
            return result;
    }
}