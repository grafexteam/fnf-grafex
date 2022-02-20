package;

import flixel.FlxState;
import flixel.FlxG;

import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;
import flixel.system.FlxSound;
import openfl.utils.Assets;
import openfl.utils.AssetType;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import webm.*;
import openfl.events.AsyncErrorEvent;
import openfl.events.MouseEvent;
import openfl.events.NetStatusEvent;
import openfl.media.Video;
import openfl.net.NetConnection;
import openfl.net.NetStream;
import vlc.VlcBitmap;
import openfl.events.Event;
import StoryMenuState;
import PlayState;

import openfl.Lib;

#if cpp
import webm.WebmPlayer;
#end

using StringTools;

class VideoState extends MusicBeatState
{
	public var leSource:String = "";
	public var transClass:FlxState;
	public var txt:FlxText;
	public var fuckingVolume:Float = 1;
	public var notDone:Bool = true;
	public var vidSound:FlxSound;
	public var useSound:Bool = false;
	public var soundMultiplier:Float = 1;
	public var prevSoundMultiplier:Float = 1;
	public var videoFrames:Int = 0;
	public var defaultText:String = "";
	public var doShit:Bool = false;
	public var pauseText:String = "Press P To Pause/Unpause";
	public var autoPause:Bool = false;
	public var musicPaused:Bool = false;
	var sexMode:Bool = false;
	public static var sexed:Bool = false;
	var holdTimer:Int = 0;
	var crashMoment:Int = 0;
	var itsTooLate:Bool = false;
	var skipTxt:FlxText;
	var doneSomeShit:Bool = false;
	public function new(source:String, toTrans:FlxState, frameSkipLimit:Int = -1, autopause:Bool = false)
	{
		super();
		
		autoPause = autopause;
		
		leSource = source;
		transClass = toTrans;
	}
	
	override function create()
	{
		
		super.create();
		FlxG.autoPause = false;
		FlxTransitionableState.skipNextTransIn = false;
		FlxTransitionableState.skipNextTransOut = false;
		doShit = false;

		if (GlobalVideo.isWebm)
		{
		videoFrames = Std.parseInt(Assets.getText(leSource.replace(".webm", ".txt")));
		}
		
		fuckingVolume = FlxG.sound.music.volume;
		FlxG.sound.music.volume = 0;
		var isHTML:Bool = false;
		#if web
		isHTML = true;
		#end
		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);
		var html5Text:String = "You Are Not Using HTML5...\nThe Video Didnt Load!";
		if (isHTML)
		{
			html5Text = "You Are Using HTML5!";
		}
		defaultText = "If Your On HTML5\nTap Anything...\nThe Bottom Text Indicates If You\nAre Using HTML5...\n\n" + html5Text;
		txt = new FlxText(0, 0, FlxG.width,
			defaultText,
			32);
		txt.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		txt.screenCenter();
		add(txt);

		skipTxt = new FlxText(FlxG.width / 1.5, FlxG.height - 50, FlxG.width, 'hold ANY KEY to skip', 32);
		skipTxt.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, LEFT);
		
		if (GlobalVideo.isWebm)
		{
			if (Assets.exists(leSource.replace(".webm", ".ogg"), MUSIC) || Assets.exists(leSource.replace(".webm", ".ogg"), SOUND))
			{
				useSound = true;
				vidSound = FlxG.sound.play(leSource.replace(".webm", ".ogg"));
			}
		}
		GlobalVideo.get().source(leSource);
		GlobalVideo.get().clearPause();
		if (GlobalVideo.isWebm)
		{	
			GlobalVideo.get().updatePlayer();
		}
		GlobalVideo.get().show();
		if (GlobalVideo.isWebm)
		{
			GlobalVideo.get().restart();
		} else {
			GlobalVideo.get().play();
		}

		vidSound.time = vidSound.length * soundMultiplier;
		doShit = true;
		
		if (autoPause && FlxG.sound.music != null && FlxG.sound.music.playing)
		{
			musicPaused = true;
			FlxG.sound.music.pause();
		}
	
		add(skipTxt);
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if(FlxG.keys.justPressed.F11)
                {
                FlxG.fullscreen = !FlxG.fullscreen;
                }

                if (useSound)
		{
			var wasFuckingHit = GlobalVideo.get().webm.wasHitOnce;
			soundMultiplier = GlobalVideo.get().webm.renderedCount / videoFrames;
			
			if (soundMultiplier > 1)
			{
				soundMultiplier = 1;
			}
			if (soundMultiplier < 0)
			{
				soundMultiplier = 0;
			}
			if (doShit)
			{
				var compareShit:Float = 100;
				if (vidSound.time >= (vidSound.length * soundMultiplier) + compareShit || vidSound.time <= (vidSound.length * soundMultiplier) - compareShit)
					vidSound.time = vidSound.length * soundMultiplier;
			}
			if (wasFuckingHit)
			{
			if (soundMultiplier == 0)
			{
				if (prevSoundMultiplier != 0)
				{
					vidSound.pause();
					vidSound.time = 0;
				}
			} else {
				if (prevSoundMultiplier == 0)
				{
					vidSound.resume();
					vidSound.time = vidSound.length * soundMultiplier;
				}
			}
			prevSoundMultiplier = soundMultiplier;
			}
		}
		
		if (notDone)
		{
			FlxG.sound.music.volume = 0;
		}
		GlobalVideo.get().update(elapsed);

		if (controls.RESET)
		{
			GlobalVideo.get().restart();
		}
		
		if (GlobalVideo.get().ended || GlobalVideo.get().stopped)
		{
			txt.visible = false;
			skipTxt.visible = false;
			GlobalVideo.get().hide();
			GlobalVideo.get().stop();
		}
		if (crashMoment > 0)
			crashMoment--;
		if (FlxG.keys.pressed.ANY && crashMoment <= 0 || itsTooLate && FlxG.keys.pressed.ANY) {
			holdTimer++;
			crashMoment = 16;
			itsTooLate = true;
			GlobalVideo.get().alpha();
			txt.visible = false;
			if (holdTimer > 100) {
				notDone = false;
				skipTxt.visible = false;
				FlxG.sound.music.volume = fuckingVolume;
				txt.text = pauseText;
				
				if (musicPaused)
				{
					musicPaused = false;
					FlxG.sound.music.resume();
				}
				FlxG.autoPause = true;
				GlobalVideo.get().stop();
				FlxG.switchState(transClass);
			}
		} else if (!GlobalVideo.get().paused) {
			GlobalVideo.get().unalpha();
			holdTimer = 0;
			itsTooLate = false;
		}
		if (GlobalVideo.get().ended)
		{
			notDone = false;
			FlxG.sound.music.volume = fuckingVolume;
			txt.text = pauseText;
			
			if (musicPaused)
			{
				musicPaused = false;
				FlxG.sound.music.resume();
			}
			FlxG.autoPause = true;
			
			FlxG.switchState(transClass);
		}
		
		if (GlobalVideo.get().played || GlobalVideo.get().restarted)
		{
			GlobalVideo.get().show();
		}
		
		GlobalVideo.get().restarted = false;
		GlobalVideo.get().played = false;
		GlobalVideo.get().stopped = false;
		GlobalVideo.get().ended = false;
	}
}

class VideoHandler
{
	public var netStream:NetStream;
	public var video:Video;
	public var isReady:Bool = false;
	public var addOverlay:Bool = false;
	public var vidPath:String = "";
	public var ignoreShit:Bool = false;
	
	public function new()
	{
		isReady = false;
	}
	
	public function source(?vPath:String):Void
	{
		if (vPath != null && vPath.length > 0)
		{
		vidPath = vPath;
		}
	}
	
	public function init1():Void
	{
		isReady = false;
		video = new Video();
		video.visible = false;
	}
	
	public function init2():Void
	{
		#if web
		var netConnection = new NetConnection ();
		netConnection.connect (null);
		
		netStream = new NetStream (netConnection);
		netStream.client = { onMetaData: client_onMetaData };
		netStream.addEventListener (AsyncErrorEvent.ASYNC_ERROR, netStream_onAsyncError);

		netConnection.addEventListener (NetStatusEvent.NET_STATUS, netConnection_onNetStatus);
		netConnection.addEventListener (NetStatusEvent.NET_STATUS, onPlay);
		netConnection.addEventListener (NetStatusEvent.NET_STATUS, onEnd);
		#end
	}
	
	public function client_onMetaData (metaData:Dynamic) {
		
		video.attachNetStream (netStream);
		
		video.width = FlxG.width;
		video.height = FlxG.height;
		
	}
	
	
	public function netStream_onAsyncError (event:AsyncErrorEvent):Void
	{
		// does nothing - Xale
	}
	
	
	public function netConnection_onNetStatus (event:NetStatusEvent):Void
	{
		// does nothing - Xale
	}
	
	public function play():Void
	{
		#if web
		ignoreShit = true;
		netStream.close();
		init2();
		netStream.play(vidPath);
		ignoreShit = false;
		#end
		trace(vidPath);
	}
	
	public function stop():Void
	{
		netStream.close();
		onStop();
	}
	
	public function restart():Void
	{
		play();
		onRestart();
	}
	
	public function update(elapsed:Float):Void
	{
		video.x = GlobalVideo.calc(0);
		video.y = GlobalVideo.calc(1);
		video.width = GlobalVideo.calc(2);
		video.height = GlobalVideo.calc(3);
	}
	
	public var stopped:Bool = false;
	public var restarted:Bool = false;
	public var played:Bool = false;
	public var ended:Bool = false;
	public var paused:Bool = false;
	
	public function pause():Void
	{
		netStream.pause();
		paused = true;
	}
	
	public function resume():Void
	{
		netStream.resume();
		paused = false;
	}
	
	public function togglePause():Void
	{
		if (paused)
		{
			resume();
		} else {
			pause();
		}
	}
	
	public function clearPause():Void
	{
		paused = false;
	}
	
	public function onStop():Void
	{
		if (!ignoreShit)
		{
			stopped = true;
		}
	}
	
	public function onRestart():Void
	{
		restarted = true;
	}
	
	public function onPlay(event:NetStatusEvent):Void
	{
		if (event.info.code == "NetStream.Play.Start")
		{
			played = true;
		}
	}
	
	public function onEnd(event:NetStatusEvent):Void
	{
		if (event.info.code == "NetStream.Play.Complete")
		{
			ended = true;
		}
	}
	
	public function alpha():Void
	{
		video.alpha = GlobalVideo.daAlpha1;
	}
	
	public function unalpha():Void
	{
		video.alpha = GlobalVideo.daAlpha2;
	}
	
	public function hide():Void
	{
		video.visible = false;
	}
	
	public function show():Void
	{
		video.visible = true;
	}
}

class WebmHandler
{
	#if desktop
	public var webm:WebmPlayer;
	public var vidPath:String = "";
	public var io:WebmIo;
	public var initialized:Bool = false;
	
	public function new()
	{
	}
	
	public function source(?vPath:String):Void
	{
		if (vPath != null && vPath.length > 0)
		{
		vidPath = vPath;
		}
	}
	
	public function makePlayer():Void
	{
		io = new WebmIoFile(vidPath);
		webm = new WebmPlayer();
		webm.fuck(io, false);
		webm.addEventListener(WebmEvent.PLAY, function(e) {
			onPlay();
			FlxG.log.add('started');
		});
		webm.addEventListener(WebmEvent.COMPLETE, function(e) {
			onEnd();
			FlxG.log.add('completed');
		});
		webm.addEventListener(WebmEvent.STOP, function(e) {
			onStop();
			FlxG.log.add('stopped');
		});
		webm.addEventListener(WebmEvent.RESTART, function(e) {
			onRestart();
			FlxG.log.add('restarted');
		});
		webm.visible = false;
		initialized = true;
	}
	
	public function updatePlayer():Void
	{
		FlxG.log.add('ate your ass');
		io = new WebmIoFile(vidPath);
		webm.fuck(io, false);
	}
	
	public function play():Void
	{
		if (initialized)
		{
			FlxG.log.add('what the fuck');
			webm.play();
		}
	}
	
	public function stop():Void
	{
		if (initialized)
		{
			webm.stop();
		}
	}
	
	public function restart():Void
	{
		if (initialized)
		{
			FlxG.log.add('what the fuck part 2');
			webm.restart();
		}
	}
	
	public function update(elapsed:Float)
	{
		webm.x = GlobalVideo.calc(0);
		webm.y = GlobalVideo.calc(1);
		webm.width = GlobalVideo.calc(2);
		webm.height = GlobalVideo.calc(3);
	}
	
	public var stopped:Bool = false;
	public var restarted:Bool = false;
	public var played:Bool = false;
	public var ended:Bool = false;
	public var paused:Bool = false;
	
	public function pause():Void
	{
		webm.changePlaying(false);
		paused = true;
	}
	
	public function resume():Void
	{
		webm.changePlaying(true);
		paused = false;
	}
	
	public function togglePause():Void
	{
		if (paused)
		{
			resume();
		} else {
			pause();
		}
	}
	
	public function clearPause():Void
	{
		paused = false;
		webm.removePause();
	}
	
	public function onStop():Void
	{
		stopped = true;
	}
	
	public function onRestart():Void
	{
		restarted = true;
	}
	
	public function onPlay():Void
	{
		played = true;
	}
	
	public function onEnd():Void
	{
		ended = true;
	}
	
	public function alpha():Void
	{
		webm.alpha = GlobalVideo.daAlpha1;
	}
	
	public function unalpha():Void
	{
		webm.alpha = GlobalVideo.daAlpha2;
	}
	
	public function hide():Void
	{
		webm.visible = false;
	}
	
	public function show():Void
	{
		webm.visible = true;
	}
	#else
	public var webm:Sprite;
	public function new()
	{
		// does nothing ._ . - Xale
	}
	#end
}

class GlobalVideo
{
	private static var video:VideoHandler;
	private static var webm:WebmHandler;
	public static var isWebm:Bool = false;
	public static var isAndroid:Bool = false;
	public static var daAlpha1:Float = 0.2;
	public static var daAlpha2:Float = 1;

	public static function setVid(vid:VideoHandler):Void
	{
		video = vid;
	}
	
	public static function getVid():VideoHandler
	{
		return video;
	}
	
	public static function setWebm(vid:WebmHandler):Void
	{
		webm = vid;
		isWebm = true;
	}
	
	public static function getWebm():WebmHandler
	{
		return webm;
	}
	
	public static function get():Dynamic
	{
		if (isWebm)
		{
			return getWebm();
		} else {
			return getVid();
		}
	}
	
	public static function calc(ind:Int):Dynamic
	{
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		var width:Float = GameDimensions.width;
		var height:Float = GameDimensions.height;
		
		var ratioX:Float = height / width;
		var ratioY:Float = width / height;
		var appliedWidth:Float = stageHeight * ratioY;
		var appliedHeight:Float = stageWidth * ratioX;
		
		var remainingX:Float = stageWidth - appliedWidth;
		var remainingY:Float = stageHeight - appliedHeight;
		remainingX = remainingX / 2;
		remainingY = remainingY / 2;
		
		appliedWidth = Std.int(appliedWidth);
		appliedHeight = Std.int(appliedHeight);
		
		if (appliedHeight > stageHeight)
		{
			remainingY = 0;
			appliedHeight = stageHeight;
		}
		
		if (appliedWidth > stageWidth)
		{
			remainingX = 0;
			appliedWidth = stageWidth;
		}
		
		switch(ind)
		{
			case 0:
				return remainingX;
			case 1:
				return remainingY;
			case 2:
				return appliedWidth;
			case 3:
				return appliedHeight;
		}
		
		return null;
	}
}

class GameDimensions
{
	public static var width:Int = 1280;
	public static var height:Int = 720;
}

// Made by BrigthFyr lol

class MP4Handler
{
	public static var video:Video;
	public static var netStream:NetStream;
	public static var finishCallback:FlxState;
	public var sprite:FlxSprite;
	#if desktop
	public static var vlcBitmap:VlcBitmap;
	#end

	public function new()
	{

		FlxG.autoPause = false;

		if (FlxG.sound.music != null)
		{
			FlxG.sound.music.stop();
		}
	}

	public function playMP4(path:String, callback:FlxState, ?outputTo:FlxSprite = null, ?repeat:Bool = false, ?isWindow:Bool = false, ?isFullscreen:Bool = false):Void
	{
		#if html5
		FlxG.autoPause = false;

		if (FlxG.sound.music != null)
		{
			FlxG.sound.music.stop();
		}

		finishCallback = callback;

		video = new Video();
		video.x = 0;
		video.y = 0;

		FlxG.addChildBelowMouse(video);

		var nc = new NetConnection();
		nc.connect(null);

		netStream = new NetStream(nc);
		netStream.client = {onMetaData: client_onMetaData};

		nc.addEventListener("netStatus", netConnection_onNetStatus);

		netStream.play(path);
		#else
		finishCallback = callback;

		vlcBitmap = new VlcBitmap();
		vlcBitmap.set_height(FlxG.stage.stageHeight);
		vlcBitmap.set_width(FlxG.stage.stageHeight * (16 / 9));

		trace("Setting width to " + FlxG.stage.stageHeight * (16 / 9));
		trace("Setting height to " + FlxG.stage.stageHeight);

		vlcBitmap.onVideoReady = onVLCVideoReady;
		vlcBitmap.onComplete = onVLCComplete;
		vlcBitmap.onError = onVLCError;

		FlxG.stage.addEventListener(Event.ENTER_FRAME, update);

		if (repeat)
			vlcBitmap.repeat = -1;
		else
			vlcBitmap.repeat = 0;

		vlcBitmap.inWindow = isWindow;
		vlcBitmap.fullscreen = isFullscreen;

		FlxG.addChildBelowMouse(vlcBitmap);
		vlcBitmap.play(checkFile(path));
		
		if (outputTo != null)
		{
			// lol this is bad kek
			vlcBitmap.alpha = 0;
	
			sprite = outputTo;
		}
		#end
	}

	#if desktop
	function checkFile(fileName:String):String
	{
		var pDir = "";
		var appDir = "file:///" + Sys.getCwd() + "/";

		if (fileName.indexOf(":") == -1) // Not a path
			pDir = appDir;
		else if (fileName.indexOf("file://") == -1 || fileName.indexOf("http") == -1) // C:, D: etc? ..missing "file:///" ?
			pDir = "file:///";

		return pDir + fileName;
	}

	/////////////////////////////////////////////////////////////////////////////////////

	function onVLCVideoReady()
	{
		trace("video loaded!");
		if (sprite != null)
			sprite.loadGraphic(vlcBitmap.bitmapData);	
	}

	public function onVLCComplete()
	{
		vlcBitmap.stop();

		// Clean player, just in case! Actually no.

		FlxG.camera.fade(FlxColor.BLACK, 0, false);


		trace("Big, Big Chungus, Big Chungus!");

		new FlxTimer().start(0.3, function (tmr:FlxTimer)
		{
			if (finishCallback != null)
			{
				LoadingState.loadAndSwitchState(finishCallback);
			}
			vlcBitmap.dispose();

			if (FlxG.game.contains(vlcBitmap))
			{
				FlxG.game.removeChild(vlcBitmap);
			}	
		});
		

	}

	function onVLCError()
	{
		if (finishCallback != null)
		{
			LoadingState.loadAndSwitchState(finishCallback);
		}
	}

	function update(e:Event)
	{
		if (FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.SPACE)
		{
			if (vlcBitmap.isPlaying)
			{
				onVLCComplete();
			}
		}
		vlcBitmap.volume = FlxG.sound.volume + 0.3; // shitty volume fix. then make it louder.
		if (FlxG.sound.volume <= 0.1) vlcBitmap.volume = 0;
	}
	#end

	/////////////////////////////////////////////////////////////////////////////////////

	function client_onMetaData(path)
	{
		video.attachNetStream(netStream);

		video.width = FlxG.width;
		video.height = FlxG.height;
	}

	function netConnection_onNetStatus(path)
	{
		if (path.info.code == "NetStream.Play.Complete")
		{
			finishVideo();
		}
	}

	function finishVideo()
	{
		netStream.dispose();

		if (FlxG.game.contains(video))
		{
			FlxG.game.removeChild(video);
		}

		if (finishCallback != null)
		{
			LoadingState.loadAndSwitchState(finishCallback);
		}
		else
			LoadingState.loadAndSwitchState(new MainMenuState());
	}
}