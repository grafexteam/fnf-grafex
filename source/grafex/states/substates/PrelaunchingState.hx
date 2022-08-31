package grafex.states.substates;

import flixel.tweens.FlxTween;
import lime.app.Application;
import flixel.addons.transition.FlxTransitionableState;
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
import grafex.util.Utils;

// TODO: rewrite this, maybe?

using StringTools;

class PrelaunchingState extends MusicBeatState
{
    public static var muteKeys:Array<FlxKey> = [FlxKey.ZERO];
	public static var volumeDownKeys:Array<FlxKey> = [FlxKey.NUMPADMINUS, FlxKey.MINUS];
	public static var volumeUpKeys:Array<FlxKey> = [FlxKey.NUMPADPLUS, FlxKey.PLUS];

    public static var leftState:Bool = false;
    private static var alreadySeen:Bool = false;

    public static var link:String = 'https://raw.githubusercontent.com/JustXale/fnf-grafex/raw/versionCheck.txt'; // i hate github now

    var connectionFailed:Bool = false;

    var curSelected = 0;

    public var arrowSine:Float = 0;
	public var arrowTxt:FlxText;

    var txt:FlxText;
    var txts:Array<Array<String>> = [
        [
            "Disclaimer!\nThis game contains some flashing lights!\nYou've been warned!\n\nYou can disable them in Options Menu", ""
        ]
    ];

    override function create()
    {
        super.create();

        Application.current.window.title = Main.appTitle;
        
        FlxG.mouse.visible = false;
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
        
        var version:Array<Int> = null;
   
        try {     
            File.saveContent('./localVersion.txt', Http.requestUrl(link)); // will save version from github locally
        } catch(e) {
            connectionFailed = true;
            GrfxLogger.log('error', e.message == 'EOF' ? 'Connection timed out' : e.message);
            GrfxLogger.log('error', "Couldn't update version");        
        }
        version = requestVersion();
        
        if(version != null)
        {
            //if(version >= EngineData.grafexEngineVersion)
            if(checkVersion(version))
            {
                GrfxLogger.log('info', 'Engine is up-to-date');
                //MusicBeatState.switchState(new TitleState());
            }    
            else
            {
                GrfxLogger.log('warning', 'Player should update the engine');
                txts.push(['Hello there,\nYou are playing the outdated version of Grafex.\nconsider updating, please:\n\n' + EngineData.githubLink + '\n\nPress ENTER to open the page', EngineData.githubLink]);
            } 
        }

        if (connectionFailed)
        {
            txts.push(["Couldn't connect to the server", '']);
        }
        #end
        if(alreadySeen)
        MusicBeatState.switchState(new TitleState());

        txts.push(["Thanks for using our engine! <3\n- with love\n    Grafex Team", '']);

        txt = new FlxText(0, 300, FlxG.width, '', 32);
        txt.borderColor = FlxColor.BLACK;
        txt.borderSize = 3;
        txt.borderStyle = FlxTextBorderStyle.OUTLINE;
        txt.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
        txt.screenCenter(X);
        add(txt);

        arrowTxt = new FlxText(txt.x + 300, txt.y + 300, FlxG.width, '', 32);
        arrowTxt.borderColor = FlxColor.BLACK;
        arrowTxt.borderSize = 3;
        arrowTxt.borderStyle = FlxTextBorderStyle.OUTLINE;
        arrowTxt.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
        add(arrowTxt);       
        
        changeSelection();
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if(!leftState)
        {
            arrowSine += 270 * elapsed;
            arrowTxt.alpha = 1 - Math.sin((Math.PI * arrowSine) / 180);
        }   

        if(controls.UI_LEFT_P)
            changeSelection(-1);

        if(controls.UI_RIGHT_P)
            changeSelection(1);

        if(!leftState && (FlxG.keys.justPressed.ESCAPE || controls.BACK))
            makeCoolTransition();

        if(controls.ACCEPT)
            if(!leftState && txts[curSelected][1] != null && txts[curSelected][1] != '') Utils.browserLoad(txts[curSelected][1]);
    }

	function changeSelection(?pos:Int)
    {
        if(leftState)
            return;

        curSelected += pos;
    
        if (curSelected <= 0)
			curSelected = 0;
		if (curSelected >= txts.length + 1)
			curSelected = txts.length - 1;    

        if(txts != null && curSelected < txts.length)
            {
                txt.text = txts[curSelected][0];
                if(txts.length != 1)
                    {
                        if(curSelected > 0 && curSelected < txts.length)
                            arrowTxt.text = "< - >";
                        if(curSelected == 0)
                            arrowTxt.text = ">";
                        if(curSelected == txts.length - 1)
                            arrowTxt.text = "<";
                    }
            }

        if(curSelected == txts.length)
            makeCoolTransition();
            
        FlxG.sound.play(Paths.sound('scrollMenu'));
    }

   function requestVersion():Array<Int>
       {
            // More flexible thing for those, whose Ethernet is DEAD :skull: - Xale
            GrfxLogger.log('info', 'Current engine version is ' + EngineData.grafexEngineVersion);

            !connectionFailed ? try {
                var returnArray:Array<Int> = [];
                GrfxLogger.log('info', 'Current GitHub version is ' + Http.requestUrl(link));

                for(i in 0...Http.requestUrl(link).trim().split('\n')[0].split('.').length)
                {
                    trace(Std.parseInt(Http.requestUrl(link).trim().split('\n')[0].split('.')[i]));
                    returnArray.push(Std.parseInt(Http.requestUrl(link).trim().split('\n')[0].split('.')[i]));
                }

                return returnArray;
                //return Std.parseInt(Http.requestUrl(link).trim().split('\n')[0].split('.'));
            } catch(e) {
                connectionFailed = true;
                GrfxLogger.log('warning', e.message == 'EOF' ? 'Connection timed out' : e.message);
                requestVersion();
            } : {
                GrfxLogger.log('warning', "Couldn't connect to GitHub; Checking by local file");

                if(FileSystem.exists('./localVersion.txt'))
                { // Trying to check for the local txt version - Xale
                    var returnArray:Array<Int> = [];

                    GrfxLogger.log('info', "Local version is " + File.getContent('localVersion.txt').trim().split('\n')[0]);

                    for(i in 0...File.getContent('localVersion.txt').trim().split('\n')[0].split('.').length)
                    {
                        trace(Std.parseInt(File.getContent('localVersion.txt').trim().split('\n')[0].split('.')[i]));
                        returnArray.push(Std.parseInt(File.getContent('localVersion.txt').trim().split('\n')[0].split('.')[i]));
                    }
                    return returnArray;
                    //return File.getContent('localVersion.txt').trim().split('\n')[0].split('.');      
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

    function checkVersion(version:Array<Int>):Bool
    {
        for(i in 0...version.length)
        {
            trace(version[i] <= EngineData.notParsedVersion[i]);
        }

		if(version[0] <= EngineData.notParsedVersion[0] && version[1] < EngineData.notParsedVersion[1])
            return true;
        else if(version[2] <= EngineData.notParsedVersion[2])
            return false;
        return false;

	}

    function makeCoolTransition()
    {
        arrowTxt.alpha = 1;
        leftState = true;
        alreadySeen = true;
        //FlxG.camera.fade(FlxColor.BLACK, 3, true);
        FlxTween.tween(txt, {alpha: 0}, 3);
        FlxTween.tween(arrowTxt, {alpha: 0}, 3);
        FlxG.sound.play(Paths.sound('titleShoot')).fadeOut(4, 0);
        FlxG.camera.flash(FlxColor.WHITE, 3, function() {
            FlxTransitionableState.skipNextTransIn = false;
            FlxTransitionableState.skipNextTransOut = false;

            MusicBeatState.switchState(new TitleState());
        });
    }
}