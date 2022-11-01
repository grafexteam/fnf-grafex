package grafex.system.loader;

import flixel.FlxBasic;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import haxe.ds.StringMap;
import grafex.system.script.GrfxScriptHandler;
import grafex.states.playstate.PlayState;
import grafex.util.ClientPrefs;

import sys.io.File;
import sys.FileSystem;

class GrfxStage extends FlxTypedGroup<FlxSprite> {
	var stageBuild:GrfxModule;
	public var foreground:FlxSpriteGroup;

	public var curStage:String;	
        public var exist:Bool = true;
	public var customModFolder:Int = 0;

    public function new(?stage:String = 'stage') {
        super();

		this.curStage = stage;

		foreground = new FlxSpriteGroup();

		var exposure:StringMap<Dynamic> = new StringMap<Dynamic>();
		exposure.set('this', PlayState.instance);
		exposure.set('add', add);
		exposure.set('foreground', foreground);
		exposure.set('stage', this);
        exposure.set('curStage', this.curStage);
		exposure.set('boyfriend', PlayState.instance.boyfriend);
        exposure.set('gf', PlayState.instance.gf);
		exposure.set('dad', PlayState.instance.dad);
		exposure.set('dadOpponent', PlayState.instance.dad);

		if(FileSystem.exists('assets/stages/$stage/$stage.hx')) {
		        stageBuild = GrfxScriptHandler.loadModule('stages/$stage/$stage', exposure);
			Paths.doStageFuckinShitOH('assets/stages/$stage');
			if (stageBuild.exists("onCreate"))
				stageBuild.get("onCreate")();
			Paths.doStageFuckinShitOH();
			exist = true;
			trace('$stage.hx has loaded successfully ' + exist);
		} else {
            //this = null; Really? - PurSnake
			exist = false;
			trace('$stage.hx not exitst in our universe ' + exist);
		}
    }

	public function stageCreatePost() {
		stageBuild.set('this', PlayState.instance);
		stageBuild.set('add', PlayState.instance.add);
		stageBuild.set('boyfriend', PlayState.instance.boyfriend);
		stageBuild.set('dad', PlayState.instance.dad);
        stageBuild.set('gf', PlayState.instance.gf);
		stageBuild.set('dadOpponent', PlayState.instance.dad);
		if (stageBuild.exists("onCreatePost"))
			stageBuild.get("onCreatePost")();
	}

	public function stageUpdateSection(curSection:Int) {
		if (stageBuild.exists("onSection"))
			stageBuild.get("onSection")(curSection);
    }

	public function stageUpdate(curBeat:Int) {
		if (stageBuild.exists("onBeat"))
			stageBuild.get("onBeat")(curBeat);
    }

	public function stageUpdateStep(curStep:Int) {
		if (stageBuild.exists("onStep"))
			stageBuild.get("onStep")(curStep);
    }

	public function stageUpdateConstant(elapsed:Float)
	{
		if (stageBuild.exists("onUpdate"))
			stageBuild.get("onUpdate")(elapsed);
	}

	public function dispatchEvent(eventName:String, val1:String, val2:String, ?val3:String)
	{
		if (stageBuild.exists("onEvent"))
			stageBuild.get("onEvent")(eventName, val1, val2, val3);
	}

	public function stageStartCountDown() {
		if (stageBuild.exists("onStartCountdown"))
			stageBuild.get("onStartCountdown")();
	}
	public function stageCountDownStarted() {
		if (stageBuild.exists("onCountdownStarted"))
			stageBuild.get("onCountdownStarted")();
	}

	public function stageSongStart() {
		if (stageBuild.exists("onSongStart"))
			stageBuild.get("onSongStart")();
	}

	override function add(Object:FlxSprite):FlxSprite
	{
		if (!ClientPrefs.globalAntialiasing)
			cast(Object, FlxSprite).antialiasing = false;
		return super.add(Object);
	}
}

