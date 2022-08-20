package grafex.states.substates;

import grafex.util.Utils;
import flixel.tweens.FlxEase;
import flixel.FlxSprite;
import grafex.system.Paths;
import grafex.sprites.Alphabet;
import grafex.util.ClientPrefs;
import flixel.addons.display.FlxBackdrop;
import flixel.group.FlxGroup.FlxTypedGroup;
import lime.system.System;
import sys.io.File;
import haxe.Http;
import flixel.util.FlxColor;
import flixel.FlxG;
import grafex.system.statesystem.MusicBeatState;
import flixel.text.FlxText;

class FatalErrorState extends MusicBeatState
{
    var message:Dynamic = null;
    private var txt:FlxText;
    var options:Array<String> = ['Upload report to Pastebin', 'Exit'];
    private var grpOptions:FlxTypedGroup<Alphabet>;
	private static var curSelected:Int = 0;
    public static var menuText:Alphabet;
    var selectorLeft:Alphabet;
	var selectorRight:Alphabet;

    public function new (message:Dynamic)
    {
        this.message = message;
        super();
    }

    override function create()
    {
        //GrfxLogger.log('warning', 'Player should update the engine');
        txt = new FlxText(0, 0, FlxG.width,
            'Looks like you encountered
            \na Fatal Error with message:
            \n $message
            \nyou can write about this error by link below
            \n\nhttps://github.com/JustXale/fnf-grafex/issues/new/choose',
        32);
        txt.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
        txt.borderColor = FlxColor.BLACK;
        txt.borderSize = 3;
        txt.borderStyle = FlxTextBorderStyle.OUTLINE;
        txt.screenCenter();
        add(txt);
        //Sys.command('echo your_text| clip');

        var bg:FlxBackdrop;
        bg = new FlxBackdrop(Paths.image('titleBg'), 10, 0, true, true);
	    bg.velocity.x = FlxG.random.float(-90, 90);
		bg.velocity.y = FlxG.random.float(-20, 20);
		bg.updateHitbox();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

        menuText = new Alphabet(0, 0, "Quit the game?", true, false, 0, 1);
        menuText.screenCenter();
        menuText.y -= 150;
		menuText.alpha = 1;
        add(menuText);

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		for (i in 0...options.length)
		{
			var optionText:Alphabet = new Alphabet(0, 0, options[i], true, false);
			optionText.screenCenter();
			optionText.y += (100 * (i - (options.length / 2))) + 50;
			grpOptions.add(optionText);
		}

		selectorLeft = new Alphabet(0, 0, '>', true, false);
		add(selectorLeft);
		selectorRight = new Alphabet(0, 0, '<', true, false);
		add(selectorRight);

		changeSelection();
    }

    override function update(elapsed:Float)
    {
        trace(elapsed);

        super.update(elapsed);

        if (controls.UI_UP_P) {
			changeSelection(-1);
		}
		if (controls.UI_DOWN_P) {
			changeSelection(1);
		}

		if (controls.BACK) {
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new MainMenuState());
		}

		if (controls.ACCEPT) {
			openSelectedSubstate(options[curSelected]);
		}
    }

    function openSelectedSubstate(label:String) {
		switch(label)
		{
			case 'Upload report to Pastebin':
                uploadReport(); //fuck it - PurSnake

			case 'Exit':
                FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new MainMenuState());
                Utils.cameraZoom(camera, 3, 3, FlxEase.backOut, ONESHOT);

            default:
                MusicBeatState.switchState(new MainMenuState()); //no reasons why - PurSnake
		}
	}

    function changeSelection(change:Int = 0) {
		curSelected += change;
		if (curSelected < 0)
			curSelected = options.length - 1;
		if (curSelected >= options.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpOptions.members) {
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			if (item.targetY == 0) {
				item.alpha = 1;
				selectorLeft.x = item.x - 63;
				selectorLeft.y = item.y;
				selectorRight.x = item.x + item.width + 15;
				selectorRight.y = item.y;
			}
		}
		FlxG.sound.play(Paths.sound('scrollMenu'));
	}

    function uploadReport()
    {
        var request = new Http('https://pastebin.com/api/api_post.php');
        request.addParameter('api_dev_key', '2db6612f4ca1086310d8a1964c7fb1c0');
        request.addParameter('api_paste_code', File.getContent('./logs/crash/Crash_Grafex.log'));
        request.addParameter('api_option', 'paste');
        request.addParameter('api_paste_expire_date', '1W');
        request.request(true);
        trace(request.responseData);

        System.openURL('https://github.com/JustXale/fnf-grafex/issues/new/choose', '_blank');
    }

}