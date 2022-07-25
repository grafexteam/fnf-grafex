package grafex.states.substates;

import grafex.systems.Paths;
import grafex.systems.statesystem.MusicBeatState;
import sys.Http;
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
        //trace('huh');
        
        //trace(versionRequest() == data.EngineData.grafexEngineVersion);

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
        //trace(Http.requestUrl(link));
        //trace(data.EngineData.grafexEngineVersion);
        return Http.requestUrl(link);
    }
}