package;

import flixel.addons.transition.FlxTransitionableState;
import grafex.util.PlayerSettings;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;
import flixel.tweens.FlxTween;
import openfl.Lib;
import openfl.display.Sprite;
import openfl.events.Event;
import grafex.system.log.GrfxLogger;
import grafex.util.ClientPrefs;

import grafex.system.script.GrfxScriptHandler;

// for crashing shit - Xale
import lime.app.Application;
import openfl.events.UncaughtErrorEvent;
import grafex.states.substates.PrelaunchingState;
import external.FPSMem;
#if debug
import grafex.states.TitleState;
#end

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

	final normalFps:Int = ClientPrefs.framerate; // it's gonna get removed by DCE anyways, so I'm not gonna comment it out
	// final lowFps:Int = 10;

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
			stage.color = 0x00ff0000;
			init();	
		}
		else
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}

		Application.current.window.onFocusOut.add(onWindowFocusOut);
		Application.current.window.onFocusIn.add(onWindowFocusIn);
		Application.current.window.onClose.add(onWindowClose);

		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onCrash);
	}

	function onWindowClose()
	{
		GrfxLogger.close();
		GrfxLogger.log('info', 'Application closed by Player');
	}

	function onWindowFocusOut()
	{
		GrfxLogger.log('info', "Game unfocused");

		if(!ClientPrefs.autoPause /*&& Type.getClass(FlxG.state) != PlayState || !PlayState.instance.paused*/)
		{
			// Conserve power by lowering draw framerate when unfocuced
			FlxG.drawFramerate = 10;
		}
	}
	
	function onWindowFocusIn()
	{
		GrfxLogger.log('info', "Game focused");

		if(!ClientPrefs.autoPause /*&& Type.getClass(FlxG.state) != PlayState || !PlayState.instance.paused*/)
		{
			FlxG.drawFramerate = ClientPrefs.framerate;
			FlxG.updateFramerate = ClientPrefs.framerate;
		}
	}

	function onCrash(e:UncaughtErrorEvent):Void
	{
		if(e != null)
		{
			GrfxLogger.log('error', e.error);
			@:privateAccess GrfxLogger.crash(e.error);
		}
	}


	private function init(?E:Event):Void
	{
		FlxTransitionableState.skipNextTransIn = true;
        FlxTransitionableState.skipNextTransOut = true;

		Application.current.window.focus();
		
		@:privateAccess GrfxLogger.init();
		GrfxLogger.log('INFO', 'Game launched');

		//PlayerSettings.init();

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
			final ratioX:Float = stageWidth / gameWidth; // change it back if needed
			final ratioY:Float = stageHeight / gameHeight;
			zoom = Math.min(ratioX, ratioY);
			gameWidth = Math.ceil(stageWidth / zoom);
			gameHeight = Math.ceil(stageHeight / zoom);
		}

		ClientPrefs.loadDefaultKeys();
		trace('fuck it');
		GrfxScriptHandler.initialize();
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
