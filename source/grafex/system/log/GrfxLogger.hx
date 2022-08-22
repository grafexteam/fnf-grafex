package grafex.system.log;

import lime.app.Application;
import sys.io.Process;
import haxe.PosInfos;
import haxe.io.Path;
import external.Discord.DiscordClient;
import sys.io.FileOutput;
import sys.FileSystem;
import sys.io.File;

using StringTools;

class GrfxLogger
{
    static var path:String = './logs/latest.log';
    static var debugPath:String = './logs/debug/latestDebug.log';

    private static var logo:String = "
 _____            __            _____            _            
|  __ \\          / _|          |  ___|          (_)           
| |  \\/_ __ __ _| |_ _____  __ | |__ _ __   __ _ _ _ __   ___ 
| | __| '__/ _` |  _/ _ \\ \\/ / |  __| '_ \\ / _` | | '_ \\ / _ \\
| |_\\ \\ | | (_| | ||  __/>  <  | |__| | | | (_| | | | | |  __/
 \\____/_|  \\__,_|_| \\___/_/\\_\\ \\____/_| |_|\\__, |_|_| |_|\\___|
                                            __/ |             
                                           |___/                                                          
    "; // Cool logo by Olega - Xale :p

    /**
        Initialies log system. 
        Used only in Main.hx and is NOT recommended to use anywhere else
    **/
    private static function init()
    {
        haxe.Log.trace = function(v:Dynamic, ?infos:PosInfos) {
            log('trace', v, infos);
        }

        var date = Date.now().toString();

        if (!FileSystem.exists("./logs/"))
            FileSystem.createDirectory("./logs/");
        if(!FileSystem.exists("./logs/debug/"))
            FileSystem.createDirectory("./logs/debug/");

        File.saveContent(path, '$logo\n[$date][INFO]: Logger initialized');
        File.saveContent(debugPath, '$logo\n[$date][DEBUG]: Debug Logger initialized\n[$date][DEBUG]: Platform type: ' + Sys.systemName());

        Sys.println('[$date][INFO]: Logger initialized');
    }

    /**
        Outputs `message` with logType `type` in default logs, also copies info to debug logs with the PosInfos
    **/
    public static function log(type:String, message:Dynamic, ?filePos:PosInfos)
    {
        var output:FileOutput = File.append(path, false);
        var date = Date.now().toString();
        var typeString = (type != null && type != '') ? type.toUpperCase() : 'INFO';   
      
        output.writeString('\n[$date][$typeString]: $message', UTF8);
        output.close();

        #if !debug Sys.println('[$date][$typeString]: $message'); #end
        debug(message, filePos);
    }

    /**
        Outputs `message` with logType `[DEBUG]` in debug logs with the PosInfos
    **/
    public static function debug(message:Dynamic, ?filePos:PosInfos)
    {
        var output:FileOutput = File.append(debugPath, false);
        var date = Date.now().toString();

        var filePosInfo:String = filePos.fileName + ':' + filePos.lineNumber;
        
        output.writeString('\n[$date][DEBUG]:$filePosInfo: $message', UTF8);
        output.close();
        #if debug Sys.println('[$date][DEBUG]:$filePosInfo: $message'); #end
    }

    /**
        Closes GrfxLogger process
    **/
    public static function close() 
    {
        var output:FileOutput = File.append(path, false);
        var debugOutput:FileOutput = File.append(debugPath, false);

        var date = Date.now().toString();

        output.writeString('\n[$date][INFO]: Terminating', UTF8);
        output.close();

        debugOutput.writeString('\n[$date][DEBUG]: Terminating', UTF8);
        debugOutput.close();

        File.saveContent('./logs/Grafex.log', File.getContent(path));
        FileSystem.rename('./logs/Grafex.log', './logs/Grafex_' + Date.now().toString().replace(" ", "_").replace(":", "-") + '.log');

        File.saveContent('./logs/debug/DebugGrafex.log', File.getContent(debugPath));
        FileSystem.rename('./logs/debug/DebugGrafex.log', './logs/debug/DebugGrafex_' + Date.now().toString().replace(" ", "_").replace(":", "-") + '.log');
    }
    /**
        Called, when game crashes. Opens CrashHandler (or Alert Window, if Crash Handler is missing) and displays an error.
        Used only in Main.hx and is NOT recommended to use anywhere else)
    **/
    private static function crash(e:String)
    {
        var date = Date.now().toString();
        var errorMsg:String = '\n[$date]Fatal Error occured: $e\n> Please report this error to the GitHub page: https://github.com/JustXale/fnf-grafex/issues/new/choose';
        var crashReportPath:String = './logs/crash/Crash_Grafex_' + Date.now().toString().replace(" ", "_").replace(":", "-") + '.log';

        if(!FileSystem.exists('./logs/crash/'))
            FileSystem.createDirectory("./logs/crash/");
       
        File.saveContent('./logs/crash/Crash_Grafex.log', '$logo' + errorMsg + '\n\n----------------------------\n--- DEBUG LOG ---\n----------------------------\n' + File.getContent(debugPath));  

		log("error", '$e');
		log("info", "Crash dump saved in " + Path.normalize('./logs/crash'));
        
        FileSystem.rename('./logs/crash/Crash_Grafex.log', crashReportPath);

		var crashDialoguePath:String = "GrafexCrashHandler";

        #if windows
        crashDialoguePath += ".exe";
        #end
		if (FileSystem.exists(crashDialoguePath))
		{
			log("info", "Found crash dialog: " + crashDialoguePath);
            new Process('$crashDialoguePath', ['$crashReportPath']);
			//Sys.command("cd crashHandler && GrafexCrashHandler.exe --report_path ../" + crashReportPath);
		}
		else
		{
			// I had to do this or the stupid CI won't build :distress:
			log('warning',"No crash dialog found! Making a simple alert instead...");      
			Application.current.window.alert(errorMsg, "Fatal error detected");
		}
        close();
        
		DiscordClient.shutdown();
		Sys.exit(1);
    }
}