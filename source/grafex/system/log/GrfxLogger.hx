package grafex.system.log;

import haxe.io.Path;
import external.Discord.DiscordClient;
import lime.app.Application;
import sys.io.FileOutput;
import sys.FileSystem;
import sys.io.File;

using StringTools;

class GrfxLogger
{
    static var path:String = './logs/latest.log';

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

    public static function init()
    {
        var date = Date.now().toString();

        if (!FileSystem.exists("./logs/"))
            FileSystem.createDirectory("./logs/");

        File.saveContent(path, '$logo\n[$date][INFO]: Logger initialized');
        trace('[$date][INFO]: Logger initialized');
    }

    public static function log(type:String, message:String)
    {
        var output:FileOutput = File.append(path, false);
        var date = Date.now().toString();
        var typeString = type.toUpperCase();   
      
        output.writeString('\n[$date][$typeString]: $message', UTF8);
        output.close();

        trace('\n[$date][$typeString]: $message');
    }

    public static function close() 
    {
        File.saveContent('./logs/Grafex.log', File.getContent(path));
        FileSystem.rename('./logs/Grafex.log', './logs/Grafex_' + Date.now().toString().replace(" ", "_").replace(":", "'") + '.log');
    }

    public static function crash(e:String)
    {
        var date = Date.now().toString();
        var errorMsg:String = '\n[$date]Fatal Error occured: $e\n\n> Please report this error to the GitHub page: https://github.com/JustXale/fnf-grafex/issues/new/choose';

        close();

        if(!FileSystem.exists('./logs/crash/'))
            FileSystem.createDirectory("./logs/crash/");
       
        File.saveContent('./logs/crash/Crash_Grafex.log', '\n$logo' + errorMsg);
        FileSystem.rename('./logs/crash/Crash_Grafex.log', './logs/crash/Crash_Grafex_' + Date.now().toString().replace(" ", "_").replace(":", "'") + '.log');

		Sys.println(e);
		Sys.println("Crash dump saved in " + Path.normalize('./logs/crash'));

		Application.current.window.alert(errorMsg, "Error!");
		DiscordClient.shutdown();
		Sys.exit(1);
    }
}