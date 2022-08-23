package grafex.states.substates;

import grafex.system.log.GrfxLogger;
import grafex.system.Paths;
import grafex.system.statesystem.MusicBeatState;
import grafex.util.PlayerSettings;
import grafex.util.ClientPrefs;
import grafex.util.Highscore;
import sys.Http;
import sys.io.File;
import sys.FileSystem;
import grafex.data.EngineData;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.input.keyboard.FlxKey;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import grafex.util.Utils;

// TODO: rewrite this, maybe? - Xale
// TODO: Also merge this state with FlashingState

using StringTools;

class PrelaunchingState extends MusicBeatState
{
    public static var muteKeys:Array<FlxKey> = [FlxKey.ZERO];
	public static var volumeDownKeys:Array<FlxKey> = [FlxKey.NUMPADMINUS, FlxKey.MINUS];
	public static var volumeUpKeys:Array<FlxKey> = [FlxKey.NUMPADPLUS, FlxKey.PLUS];

    public static var link:String = 'https://raw.githubusercontent.com/JustXale/fnf-grafex/raw/versionCheck.txt'; // i hate github now

    var connectionFailed:Bool = false;

    var txt:FlxText = new FlxText(0, 0, FlxG.width,
        "Hello there,
        \nYou are playing
        \nthe outdated version of Grafex
        \nconsider updating, please
        \n\nhttps://github.com/JustXale/fnf-grafex
        \n\nPress ENTER to open the page \nor ESCAPE to ignore this",
    32);

    override function create()
    {

        FlxG.game.focusLostFramerate = 60;
		FlxG.sound.muteKeys = muteKeys;
		FlxG.sound.volumeDownKeys = volumeDownKeys;
		FlxG.sound.volumeUpKeys = volumeUpKeys;
		FlxG.keys.preventDefaultKeys = [TAB];
        FlxG.camera.zoom = 1;

		PlayerSettings.init();

        FlxG.save.bind('grafex', 'Grafex Team');
		ClientPrefs.loadPrefs();

		Highscore.load();

        #if VERSION_CHECK
        connectionFailed = false;
        
        var version:String = null;
   
        try {     
            File.saveContent('./localVersion.txt', Http.requestUrl(link)); // will save version from github locally
        } catch(e) {
            connectionFailed = true;
            GrfxLogger.log('error', e.message == 'EOF' ? 'Connection timed out' : e.message);
            GrfxLogger.log('error', "Couldn't update version");        
        }
        version = requestVersion();
        
        if(version != null)
            if (version == EngineData.grafexEngineVersion)
            {
                GrfxLogger.log('info', 'Engine is up-to-date');
                MusicBeatState.switchState(new TitleState());
            }    
            else
            {
                GrfxLogger.log('warning', 'Player should update the engine');
                txt.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
                txt.borderColor = FlxColor.BLACK;
                txt.borderSize = 3;
                txt.borderStyle = FlxTextBorderStyle.OUTLINE;
                txt.screenCenter();
                add(txt);
            }
        else #end MusicBeatState.switchState(new TitleState());
    }

    override function update(elapsed:Float)
    {
        if (FlxG.keys.justPressed.ENTER /*|| controls.ACCEPT*/)
            {
                Utils.browserLoad("https://github.com/JustXale/fnf-grafex");
            }
        if (FlxG.keys.justPressed.ESCAPE /*|| controls.BACK*/) // idk y the controls don't work, i'm stupid i know - Xale
        {
            FlxTween.tween(txt, {alpha: 0}, 0.8);
            new FlxTimer().start(0.8, function(tmr:FlxTimer)
                {
                    MusicBeatState.switchState(new TitleState());
                });
            
            FlxG.sound.play(Paths.sound('cancelMenu'));
        }
    }

   
   function requestVersion():String
       {
            // More flexible thing for those, whose Ethernet is DEAD :skull: - Xale
            GrfxLogger.log('info', 'Current engine version is ' + EngineData.grafexEngineVersion);

            !connectionFailed ? try {
               GrfxLogger.log('info', 'Current GitHub version is ' + Http.requestUrl(link));
               return Http.requestUrl(link);
            } catch(e) {
                connectionFailed = true;
                GrfxLogger.log('warning', e.message == 'EOF' ? 'Connection timed out' : e.message);    
            } : {
                GrfxLogger.log('warning', "Couldn't connect to GitHub; Checking by local file");

                if(FileSystem.exists('./localVersion.txt')) { // Trying to check for the local txt version - Xale
                   GrfxLogger.log('info', "Local version is " + File.getContent('localVersion.txt').trim().split('\n')[0]);
                   return File.getContent('localVersion.txt').trim().split('\n')[0];      
                }
                else
                {
                    GrfxLogger.log('warning', "Couldn't check version by local file");
                    return null; // YOU DELETED THAT FILE HOW DARE YOU - Xale                
                }  
            }
            GrfxLogger.log('warning', "Couldn't check version by both methods");
            return null; 
            // NOTHING WORKS, HOW DID YOU DO THAT?! - Xale
       }
}