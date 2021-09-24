package;

#if desktop
import Discord.DiscordClient;
import sys.thread.Thread;
#end
// This used for working all-in-one script ":) - Xale
import GameMenuState;
// ---
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.input.keyboard.FlxKey;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.system.ui.FlxSoundTray;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;
import openfl.Assets;
import Data;

using StringTools;

class TitleState extends MusicBeatState
{
	public static var muteKeys:Array<FlxKey> = [FlxKey.ZERO];
	public static var volumeDownKeys:Array<FlxKey> = [FlxKey.NUMPADMINUS, FlxKey.MINUS];
	public static var volumeUpKeys:Array<FlxKey> = [FlxKey.NUMPADPLUS, FlxKey.PLUS];

	static var initialized:Bool = false;

	var blackScreen:FlxSprite;
	var credGroup:FlxGroup;
	var credTextShit:Alphabet;
	var textGroup:FlxGroup;
	var logoSpr:FlxSprite;

	public static var isLogoLoaded:Bool = false;

	var curWacky:Array<String> = [];

	var wackyImage:FlxSprite;

	override public function create():Void
	{
		#if (polymod && !html5)
		if (sys.FileSystem.exists('mods/'))
		{
			var folders:Array<String> = [];
			for (file in sys.FileSystem.readDirectory('mods/'))
			{
				var path = haxe.io.Path.join(['mods/', file]);
				if (sys.FileSystem.isDirectory(path))
				{
					folders.push(file);
				}
			}
			if(folders.length > 0)
			{
				polymod.Polymod.init({modRoot: "mods", dirs: folders});
			}
		}
		#end
		FlxG.game.focusLostFramerate = 60;
		FlxG.sound.muteKeys = muteKeys;
		FlxG.sound.volumeDownKeys = volumeDownKeys;
		FlxG.sound.volumeUpKeys = volumeUpKeys;

		PlayerSettings.init();

		curWacky = FlxG.random.getObject(getIntroTextShit());
		swagShader = new ColorSwap();
		super.create();

		FlxG.save.bind('grafex', 'xale');
		ClientPrefs.loadPrefs();

		Highscore.load();

		if (FlxG.save.data.weekUnlocked != null)
		{
			if (StoryMenuState.weekUnlocked.length < 4)
				StoryMenuState.weekUnlocked.insert(0, true);

			if (!StoryMenuState.weekUnlocked[0])
				StoryMenuState.weekUnlocked[0] = true;
		}

		FlxG.mouse.visible = false;
		if(FlxG.save.data.flashing == null && !FlashingState.leftState)
		{
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
			MusicBeatState.switchState(new FlashingState());
		}
		else
		{
			#if desktop
			DiscordClient.initialize();
			Application.current.onExit.add (function (exitCode)
			{
				DiscordClient.shutdown();
			});
			#end
			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				startIntro();
			});
		}
	}

	var logoBl:FlxSprite;
	var gfDance:FlxSprite;
	var danceLeft:Bool = false;
	var titleText:FlxSprite;
	var swagShader:ColorSwap = null;

	function startIntro()
	{
		if (!initialized)
		{
			if(FlxG.sound.music == null)
			{
				FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);

				FlxG.sound.music.fadeIn(4, 0, 0.7);
			}
		}

		Conductor.changeBPM(102);
		persistentUpdate = true;

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		logoBl = new FlxSprite(-150, -100);
		logoBl.frames = Paths.getSparrowAtlas('logoBumpin');
		logoBl.antialiasing = ClientPrefs.globalAntialiasing;
		logoBl.animation.addByPrefix('bump', 'logo bumpin', 24);
		logoBl.animation.play('bump');
		logoBl.updateHitbox();
		isLogoLoaded = true;

		swagShader = new ColorSwap();
		gfDance = new FlxSprite(FlxG.width * 0.4, FlxG.height * 0.07);
		gfDance.frames = Paths.getSparrowAtlas('gfDanceTitle');
		gfDance.animation.addByIndices('danceLeft', 'gfDance', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
		gfDance.animation.addByIndices('danceRight', 'gfDance', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
		gfDance.antialiasing = ClientPrefs.globalAntialiasing;
		add(gfDance);
		gfDance.shader = swagShader.shader;
		add(logoBl);
		logoBl.shader = swagShader.shader;

		titleText = new FlxSprite(100, FlxG.height * 0.8);
		titleText.frames = Paths.getSparrowAtlas('titleEnter');
		titleText.animation.addByPrefix('idle', "Press Enter to Begin", 24);
		titleText.animation.addByPrefix('press', "ENTER PRESSED", 24);
		titleText.antialiasing = ClientPrefs.globalAntialiasing;
		titleText.animation.play('idle');
		titleText.updateHitbox();
		add(titleText);

		credGroup = new FlxGroup();
		add(credGroup);
		textGroup = new FlxGroup();

		blackScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		credGroup.add(blackScreen);

		credTextShit = new Alphabet(0, 0, "", true);
		credTextShit.screenCenter();

		credTextShit.visible = false;

		logoSpr = new FlxSprite(0, FlxG.height * 0.4).loadGraphic(Paths.image('titlelogo'));
		add(logoSpr);
		logoSpr.visible = false;
		logoSpr.setGraphicSize(Std.int(logoSpr.width * 0.55));
		logoSpr.updateHitbox();
		logoSpr.screenCenter(X);
		logoSpr.antialiasing = ClientPrefs.globalAntialiasing;

		FlxTween.tween(credTextShit, {y: credTextShit.y + 20}, 2.9, {ease: FlxEase.quadInOut, type: PINGPONG});

		if (initialized)
			skipIntro();
		else
			initialized = true;
	}

	function getIntroTextShit():Array<Array<String>>
	{
		var fullText:String = Assets.getText(Paths.txt('introText'));

		var firstArray:Array<String> = fullText.split('\n');
		var swagGoodArray:Array<Array<String>> = [];

		for (i in firstArray)
		{
			swagGoodArray.push(i.split('--'));
		}

		return swagGoodArray;
	}

	var transitioning:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;

		if (FlxG.keys.justPressed.F)
		{
			FlxG.fullscreen = !FlxG.fullscreen;
		}

		var pressedEnter:Bool = FlxG.keys.justPressed.ENTER;

		#if mobile
		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed)
			{
				pressedEnter = true;
			}
		}
		#end

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (gamepad != null)
		{
			if (gamepad.justPressed.START)
				pressedEnter = true;

			#if switch
			if (gamepad.justPressed.B)
				pressedEnter = true;
			#end
		}

		if (pressedEnter && !transitioning && skippedIntro)
		{
			if(titleText != null) titleText.animation.play('press');

			FlxG.camera.flash(FlxColor.WHITE, 0.4);
			FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

                        FlxTween.tween(FlxG.camera, {y: FlxG.height}, 2, {ease: FlxEase.expoIn, startDelay: -0.1});
			
                        transitioning = true;

			new FlxTimer().start(1.5, function(tmr:FlxTimer)
			{
				MusicBeatState.switchState(new GameMenuState.MainMenuState());
				closedState = true;
			});
		}

		if (pressedEnter && !skippedIntro)
		{
			skipIntro();
		}

		if(swagShader != null)
		{
			if(controls.UI_LEFT) swagShader.hue -= elapsed * 0.1;
			if(controls.UI_RIGHT) swagShader.hue += elapsed * 0.1;
		}

		super.update(elapsed);
	}

	function createCoolText(textArray:Array<String>, ?offset:Float = 0)
	{
		for (i in 0...textArray.length)
		{
			var money:Alphabet = new Alphabet(0, 0, textArray[i], true, false);
			money.screenCenter(X);
			money.y += (i * 60) + 200 + offset;
			credGroup.add(money);
			textGroup.add(money);
		}
	}

	function addMoreText(text:String, ?offset:Float = 0)
	{
		if(textGroup != null) {
			var coolText:Alphabet = new Alphabet(0, 0, text, true, false);
			coolText.screenCenter(X);
			coolText.y += (textGroup.length * 60) + 200 + offset;
			credGroup.add(coolText);
			textGroup.add(coolText);
		}
	}

	function deleteCoolText()
	{
		while (textGroup.members.length > 0)
		{
			credGroup.remove(textGroup.members[0], true);
			textGroup.remove(textGroup.members[0], true);
		}
	}

	private static var closedState:Bool = false;
	override function beatHit()
	{
		super.beatHit();

		if(isLogoLoaded)
		{
			logoBl.animation.play('bump', true);

			danceLeft = !danceLeft;

			if (danceLeft)
				gfDance.animation.play('danceRight');
			else
				gfDance.animation.play('danceLeft');
		}
		
		FlxG.log.add(curBeat);
 
		if(!closedState) {
			switch (curBeat)
			{
				case 1:
					createCoolText(['Graphex Engine by'], 45);
				case 3:
					addMoreText('XaleTheCat', 45);
					addMoreText('PurpleSnake', 45); 
				case 4:
					deleteCoolText();
				case 5:
					createCoolText(['This is a mod to'], -60);
				case 7:
					addMoreText('This game right below lol', -60);
					logoSpr.visible = true;
				case 8:
					deleteCoolText();
					logoSpr.visible = false;
				case 9:
					createCoolText([curWacky[0]]);
				case 11:
					addMoreText(curWacky[1]);
				case 12:
					deleteCoolText();
				case 13:
					addMoreText('Friday');
				case 14:
					addMoreText('Night');
				case 15:
					addMoreText('Funkin');

				case 16:
					skipIntro();
			}
		}
	}

	var skippedIntro:Bool = false;

	function skipIntro():Void
	{
		if (!skippedIntro)
		{
			remove(logoSpr);

			FlxG.camera.flash(FlxColor.WHITE, 1);
			remove(credGroup);
			skippedIntro = true;
		}
	}
}
