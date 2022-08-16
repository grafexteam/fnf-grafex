package grafex.states.substates;

import grafex.systems.Paths;
import grafex.systems.statesystem.MusicBeatState;
import sys.Http;
import sys.io.File;
import sys.FileSystem;
import grafex.data.EngineData;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import grafex.Utils;
import Controls;

// TODO: rewrite this, maybe? - Xale

using StringTools;

class PrelaunchingState extends MusicBeatState
{
    public static var link:String = 'https://raw.githubusercontent.com/JustXale/fnf-grafex/raw/versionCheck.txt'; // i hate github now
    var txt:FlxText = new FlxText(0, 0, FlxG.width,
        "Hello there,
        \nYou are playing
        \nthe outdated version of Grafex
        \nconsider updating
        \n\nhttps://github.com/JustXale/fnf-grafex
        \n\nPress ENTER to open the page \nor ESCAPE to ignore this",
        32);

    override function create()
    {
        #if VERSION_CHECK
        if(versionRequest() != null)
            if (versionRequest() == EngineData.grafexEngineVersion)
                MusicBeatState.switchState(new TitleState());
            else
            {
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

   
   function versionRequest():String
       {
           // More flexible thing for those, whose Ethernet is DEAD :skull: - Xale
           try {
               trace('Current version is ' + Http.requestUrl(link));
               return Http.requestUrl(link);
           } catch(e) {
               if(FileSystem.exists('localVersion.txt')) { // Trying to check for the local txt version - Xale
                   trace('Current version is ' + File.getContent('localVersion.txt').trim().split('\n')[0]);
                   return File.getContent('localVersion.txt').trim().split('\n')[0];      
               }
               else 
                   return null; // YOU DELETED THAT FILE HOW DARE YOU - Xale
           }
           return null; // NOTHING WORKS, HOW DID YOU DO THAT?! - Xale
       }

}