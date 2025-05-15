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
import std.zip : ZipArchive, ArchiveMember;
import std.datetime;
import std.system;
import std.format;

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

/**
 * Console colors and formatting
 */
struct ConsoleHelper {
    static enum Color {
        black   = 0,
        red     = 1,
        green   = 2,
        yellow  = 3,
        blue    = 4,
        magenta = 5,
        cyan    = 6,
        white   = 7,
        default_ = 9
    }

    static enum Style {
        reset     = 0,
        bold      = 1,
        dim       = 2,
        italic    = 3,
        underline = 4,
        blink     = 5,
        inverse   = 7,
    }

    private bool useColors;

    this(bool enableColors) {
        version(Windows) {
            // Enable ANSI escape sequence processing on Windows
            try {
                auto result = executeShell("powershell -Command \"if ($Host.UI.RawUI.WindowSize.Width -eq 0) { exit 1 } else { exit 0 }\"");
                useColors = enableColors && result.status == 0;
            } catch (Exception) {
                useColors = false;
            }
        } else {
            useColors = enableColors;
        }
    }

    string colored(string text, Color fg, Color bg = Color.default_, Style style = Style.reset) {
        if (!useColors) return text;
        
        return format("\033[%d;%d;%dm%s\033[0m", 
            style, 
            30 + cast(int)fg, 
            40 + cast(int)bg,
            text);
    }

    string bold(string text, Color color = Color.default_) {
        return colored(text, color, Color.default_, Style.bold);
    }

    string dim(string text, Color color = Color.default_) {
        return colored(text, color, Color.default_, Style.dim);
    }

    string success(string text) {
        return bold(text, Color.green);
    }

    string error(string text) {
        return bold(text, Color.red);
    }

    string warning(string text) {
        return bold(text, Color.yellow);
    }

    string info(string text) {
        return bold(text, Color.cyan);
    }
    
    string highlight(string text) {
        return bold(text, Color.magenta);
    }
    
    void clearLine() {
        if (useColors) {
            write("\033[2K\r");  // Clear entire line and move cursor to beginning
            stdout.flush();
        }
    }
}

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
    );    auto log = Logger(config.quiet);
    
    if (showHelp) {
        log.header("cfitsio-d install script");
        log.info("Platform: " ~ platform ~ "-" ~ arch);
        log.info("");
        defaultGetoptPrinter("Usage: dub run cfitsio-d:install [options]", helpInfo.options);
        return;
    }

    log.header("cfitsio-d install script");
    log.info("Platform: " ~ platform ~ "-" ~ arch);
    log.highlight("CFITSIO version: " ~ config.version_);
    
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
            
        log.success("Done! You can now build your project with cfitsio-d.");
    }    catch (Exception e) {
        log.error("Error: " ~ e.msg);
        return;
    }
}

struct Logger {
    bool quiet;
    ConsoleHelper console;
    
    this(bool quiet) {
        this.quiet = quiet;
        this.console = ConsoleHelper(!quiet);
    }
    
    void info(string msg) {
        if (quiet) return;
        writeln(msg);
    }
    
    void success(string msg) {
        if (quiet) return;
        writeln(console.success(msg));
    }
    
    void error(string msg) {
        // Errors are always shown, even in quiet mode
        stderr.writeln(console.error(msg));
    }
    
    void warning(string msg) {
        if (quiet) return;
        writeln(console.warning(msg));
    }
    
    void header(string msg) {
        if (quiet) return;
        writeln(console.bold(msg));
    }
    
    void detail(string msg) {
        if (quiet) return;
        writeln(console.dim("  " ~ msg));
    }
    
    void highlight(string msg) {
        if (quiet) return;
        writeln(console.highlight(msg));
    }
    
    void progress(size_t dlTotal, size_t dlNow) {
        if (quiet) return;
        
        enum width = 50;
        auto percentage = dlTotal > 0 ? cast(int)(dlNow * 100 / dlTotal) : 0;
        auto bars = dlTotal > 0 ? cast(int)(dlNow * width / dlTotal) : 0;
        
        // Clear the current line
        console.clearLine();
        
        // Show progress bar with color based on completion
        write("[");
        for (int i = 0; i < width; i++) {
            if (i < bars) {
                if (percentage < 30)
                    write(console.colored("█", ConsoleHelper.Color.red));
                else if (percentage < 70)
                    write(console.colored("█", ConsoleHelper.Color.yellow));
                else
                    write(console.colored("█", ConsoleHelper.Color.green));
            } else {
                write(" ");
            }
        }
        
        // Show percentage with bold formatting
        write("] ");
        write(console.bold(format("%3d%%", percentage)));
        
        // Show speed/ETA if enough data
        if (dlTotal > 0 && dlNow > 1000) {
            write(" " ~ console.dim(format("(%s/%s)", 
                formatSize(dlNow), 
                formatSize(dlTotal))));
        }
        
        stdout.flush();
        
        if (dlNow >= dlTotal)
            writeln();
    }
    
    private string formatSize(size_t bytes) {
        if (bytes < 1024)
            return format("%d B", bytes);
        else if (bytes < 1024 * 1024)
            return format("%.2f KB", bytes / 1024.0);
        else if (bytes < 1024 * 1024 * 1024)
            return format("%.2f MB", bytes / (1024.0 * 1024.0));
        else
            return format("%.2f GB", bytes / (1024.0 * 1024.0 * 1024.0));
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
                log.warning("Could not remove archive file: " ~ e.msg);
            }
        }
    }
    
    private string[] getNeededFiles() {
        debug pragma(msg, "Platform detection check");
        
        version(Windows) {
            debug pragma(msg, "Windows detected");
            return ["cfitsio.dll", "cfitsio.lib", "zlib.dll", "zlib.lib"];
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
                        log.warning("Could not create backup: " ~ e.msg);
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
            log.info("Reading ZIP archive: " ~ zipPath);
            
            // Try using an external tool (PowerShell) to extract the file instead of D's ZipArchive
            log.info("Trying PowerShell extraction method...");
            
            try {
                // Create PowerShell command to extract the files
                string psCommand = "powershell -Command \"Expand-Archive -Path " ~ 
                                  zipPath.replace("\\", "\\\\") ~ 
                                  " -DestinationPath " ~ destDir.replace("\\", "\\\\") ~ 
                                  " -Force\"";
                
                log.info("Executing: " ~ psCommand);
                auto result = executeShell(psCommand);
                
                if (result.status != 0) {
                    log.info("PowerShell extraction failed: " ~ result.output);
                    throw new Exception("PowerShell extraction failed with status " ~ result.status.to!string);
                }
                
                log.info("PowerShell extraction succeeded");
                
                // Verify files were extracted
                foreach (file; files) {
                    auto outPath = buildPath(destDir, file);
                    if (!exists(outPath)) {
                        // Try to find the file with a case-insensitive search
                        bool found = false;
                        foreach (string name; dirEntries(destDir, SpanMode.shallow)) {
                            if (std.string.toLower(baseName(name)) == std.string.toLower(file)) {
                                // Found file with different case, rename it
                                log.info("Found file with different case: " ~ name);
                                if (name != outPath) {
                                    log.info("Renaming to correct case: " ~ outPath);
                                    rename(name, outPath);
                                }
                                found = true;
                                break;
                            }
                        }
                        
                        if (!found) {
                            throw new Exception("Expected file not extracted: " ~ file);
                        }
                    }
                    
                    auto fileSize = getSize(outPath);
                    log.success("Verified " ~ file ~ " (" ~ fileSize.to!string ~ " bytes)");
                      if (fileSize == 0) {
                        log.warning("File " ~ file ~ " is empty!");
                    }
                }
            }
            catch (Exception e) {
                log.info("PowerShell extraction failed: " ~ e.msg);
                log.info("Falling back to ZipArchive method...");
                
                // Fall back to the D ZipArchive method
                auto data = cast(ubyte[]) read(zipPath);
                log.info("ZIP archive size: " ~ data.length.to!string ~ " bytes");
                
                auto archive = new ZipArchive(data);
                log.info("Archive contains " ~ archive.directory.length.to!string ~ " files");
                
                // Debug: List all files in archive
                log.info("Files in archive:");
                foreach (name; archive.directory.keys) {
                    log.info(" - " ~ name ~ " (" ~ archive.directory[name].expandedSize.to!string ~ " bytes)");
                }
                
                foreach (file; files) {
                    log.info("Looking for " ~ file ~ " in archive...");
                    ArchiveMember member = null;
                    string foundName;
                    
                    // First try direct lookup
                    if (file in archive.directory) {
                        log.info("Found exact match: " ~ file);
                        member = archive.directory[file];
                        foundName = file;
                    }
                    else {
                        // Try case-insensitive search and look for files in subdirectories too
                        foreach (name, m; archive.directory) {
                            if (std.string.toLower(name) == std.string.toLower(file) || 
                                std.string.toLower(baseName(name)) == std.string.toLower(file)) {
                                log.info("Found match: " ~ name);
                                member = m;
                                foundName = name;
                                break;
                            }
                        }
                    }
                    
                    enforce(member !is null, "File " ~ file ~ " not found in archive!");
                    auto outPath = buildPath(destDir, file);
                    
                    // Debug info
                    log.info(
                        "Extracting " ~ foundName ~ " to " ~ file ~
                        " (compressed: " ~ member.compressedSize.to!string ~
                        " bytes, expanded: " ~ member.expandedSize.to!string ~ " bytes)"
                    );
                    
                    // Try writing directly without using expandedData
                    try {
                        std.file.write(outPath, member.expandedData);
                        log.info("Wrote " ~ member.expandedData.length.to!string ~ " bytes to " ~ outPath);
                    } 
                    catch (Exception e) {
                        log.info("Error writing file: " ~ e.msg);
                        throw new Exception("Failed to write " ~ file ~ ": " ~ e.msg);
                    }
                    
                    auto fileSize = getSize(outPath);
                    log.info("Extracted " ~ file ~ " (" ~ fileSize.to!string ~ " bytes)");
                    
                    if (fileSize == 0) {
                        log.warning("Extracted " ~ file ~ " is empty!");
                    }
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
            bool foundLib = false;
            foreach (lib; libs) {
                if (lib.type == JSONType.string && lib.str == "cfitsio") {
                    foundLib = true;
                    break;
                }
            }
            
            if (!foundLib) {
                libs ~= JSONValue("cfitsio");
                json["libs"] = JSONValue(libs);
                changed = true;
            }

            // Set linker flags to use the configured output directory
            string outDir = config.outputDir;
            string[][string] flags = [
                "lflags-windows": ["/LIBPATH:" ~ outDir],
                "lflags-posix": ["-L" ~ outDir],
                "lflags-osx": ["-rpath", "@executable_path/", "-L" ~ outDir],
                "lflags-linux": ["-rpath=$$ORIGIN", "-L" ~ outDir]
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
                log.success("Updated dub.json successfully.");
            } 
            else {
                log.info("dub.json already contains correct configuration.");
            }
        } 
        catch (Exception e) {
            log.warning("Failed to update dub.json: " ~ e.msg);
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