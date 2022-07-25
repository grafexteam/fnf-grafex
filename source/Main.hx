package;

import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;
import flixel.tweens.FlxTween;
import openfl.Assets;
import openfl.Lib;
import openfl.display.Sprite;
import openfl.events.Event;
import lime.app.Application;
import lime.ui.WindowAttributes;
import grafex.systems.statesystem.MusicBeatState;

// for crashing shit - Xale
import lime.app.Application;
import openfl.events.UncaughtErrorEvent;
import haxe.CallStack;
import haxe.io.Path;
import utils.Discord.DiscordClient;
import sys.FileSystem;
import sys.io.File;
import sys.io.Process;
import grafex.states.substates.PrelaunchingState;
import grafex.states.TitleState;
import utils.FPSMem;

using StringTools;

class Main extends Sprite
{
	var gameWidth:Int = 1280; // Width of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var gameHeight:Int = 720; // Height of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var initialState:Class<FlxState> = PrelaunchingState; // The FlxState the game starts with.
	var zoom:Float = -1; // If -1, zoom is automatically calculated to fit the window dimensions.
	var framerate:Int = 60; // How many frames per second the game should run at.
	var skipSplash:Bool = true; // Whether to skip the flixel splash screen that appears in release mode.
	var startFullscreen:Bool = false; // Whether to start the game in fullscreen on desktop targets
	public static var appTitle:String = "Friday Night Funkin': Grafex Engine";

	final normalFps:Int = ClientPrefs.framerate;
	final lowFps:Int = 10;
	var focusMusicTween:FlxTween;

	// You can pretty much ignore everything from here on - your code should go in your states.

	public static function main():Void
	{
		Lib.current.addChild(new Main());	
	}

	public function new()
	{
		super();

		if (stage != null)
		{
			init();	
		}
		else
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}

		Application.current.window.onFocusOut.add(onWindowFocusOut);
		Application.current.window.onFocusIn.add(onWindowFocusIn);
		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onCrash);
	}


	function onWindowFocusOut()
		{
			trace("Game unfocused");
	
			if(!ClientPrefs.autoPause)
			{
			// Lower global volume when unfocused
				if (focusMusicTween != null)
					focusMusicTween.cancel();
			    focusMusicTween = FlxTween.tween(FlxG.sound, {volume: FlxG.sound.volume * 0.2}, 0.5);
	
			// Conserve power by lowering draw framerate when unfocuced
			FlxG.drawFramerate = lowFps;
			}
		}
	
	function onWindowFocusIn()
	{
		trace("Game focused");

		if(!ClientPrefs.autoPause)
		{
			// Normal global volume when focused
			if (focusMusicTween != null)
				focusMusicTween.cancel();
			focusMusicTween = FlxTween.tween(FlxG.sound, {volume: FlxG.sound.volume * 5}, 0.5);
			// Bring framerate back when focused
			FlxG.drawFramerate = ClientPrefs.framerate;
			FlxG.updateFramerate = ClientPrefs.framerate;
		}
	}
	
	function onCrash(e:UncaughtErrorEvent):Void
		{
			var errMsg:String = "";
			var path:String;
			var callStack:Array<StackItem> = CallStack.exceptionStack(true);
			var dateNow:String = Date.now().toString();
	
			dateNow = dateNow.replace(" ", "_");
			dateNow = dateNow.replace(":", "'");
	
			path = "./crash/" + "Grafex_" + dateNow + ".txt";
	
			for (stackItem in callStack)
			{
				switch (stackItem)
				{
					case FilePos(s, file, line, column):
						errMsg += file + " (line " + line + ")\n";
					default:
						Sys.println(stackItem);
				}
			}
	
			errMsg += "\nUncaught Error: " + e.error + "\nPlease report this error to the GitHub page: https://github.com/JustXale/fnf-grafex\n\n> Crash Handler written by: sqirra-rng";
	
			if (!FileSystem.exists("./crash/"))
				FileSystem.createDirectory("./crash/");
	
			File.saveContent(path, errMsg + "\n");
	
			Sys.println(errMsg);
			Sys.println("Crash dump saved in " + Path.normalize(path));
	
			Application.current.window.alert(errMsg, "Error!");
			DiscordClient.shutdown();
			Sys.exit(1);
		}

	private function init(?E:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}

		setupGame();
	}

	private function setupGame():Void
	{
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		if (zoom == -1)
		{
			var ratioX:Float = stageWidth / gameWidth;
			var ratioY:Float = stageHeight / gameHeight;
			zoom = Math.min(ratioX, ratioY);
			gameWidth = Math.ceil(stageWidth / zoom);
			gameHeight = Math.ceil(stageHeight / zoom);
		}

		#if debug
		initialState = TitleState;
		#end

		ClientPrefs.loadDefaultKeys();
		addChild(new FlxGame(gameWidth, gameHeight, initialState, zoom, framerate, framerate, skipSplash, startFullscreen));

		#if !mobile
        addChild(new FPSMem(10, 3, 0xFFFFFF));
		#end

		#if html5
		//FlxG.autoPause = false;
		FlxG.mouse.visible = false;
		#end
	}
}
