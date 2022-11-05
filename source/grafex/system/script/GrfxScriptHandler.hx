package grafex.system.script;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import grafex.sprites.characters.Boyfriend;
import grafex.sprites.characters.Character;
import grafex.sprites.HealthIcon;
import grafex.system.notes.Note;
import grafex.system.notes.StrumNote;
import haxe.ds.StringMap;
import hscript.Expr;
import hscript.Interp;
import hscript.Parser;
import grafex.sprites.background.BGSprite;
import grafex.util.RealColor;
import grafex.states.playstate.PlayState;
import sys.FileSystem;
import sys.io.File;
import grafex.util.ClientPrefs;

using StringTools;

class GrfxScriptHandler {
	public static var parser:Parser = new Parser();

	public static function initialize() {
		parser.allowTypes = true;
	}

	public static function loadModule(path:String, ?extraParams:StringMap<Dynamic>) {
		trace('Loading Module $path');
		var modulePath:String = Paths.hxModule(path);
		return new GrfxModule(parser.parseString(File.getContent(modulePath), modulePath), extraParams);
	}
	
	public static function noPathModule(path:String, ?extraParams:StringMap<Dynamic>) {
		trace('Loading Module $path');
		var modulePath:String = path;
		//return new GrfxModule(parser.parseString(File.getContent(modulePath), modulePath), extraParams, path);
        return new GrfxHxScript(parser.parseString(File.getContent(modulePath), modulePath), extraParams, path);
	}
}

class GrfxHxScript extends GrfxModule //Its bullshit - PurSnake
{
    public function onCreate() {
		if (this.exists("onCreate"))
			this.get("onCreate")();
    }
	public function createPost() {
		if (this.exists("onCreatePost"))
			this.get("onCreatePost")();
	}
	public function updateSection(curSection:Int) {
		if (this.exists("onSection"))
			this.get("onSection")(curSection);
    }
	public function beatUpdate(curBeat:Int) {
		if (this.exists("onBeat"))
			this.get("onBeat")(curBeat);
    }
	public function updateStep(curStep:Int) {
		if (this.exists("onStep"))
			this.get("onStep")(curStep);
    }
	public function updateConstant(elapsed:Float) {
		if (this.exists("onUpdate"))
			this.get("onUpdate")(elapsed);
	}
	public function onNextDialogue(dialogueCount:Int) {
		if (this.exists("onNextDialogue"))
			this.get("onNextDialogue")(dialogueCount);
	}
	public function onSkipDialogue(dialogueCount:Int) {
		if (this.exists("onSkipDialogue"))
			this.get("onSkipDialogue")(dialogueCount);
	}
	public function onCountdownTick(tick:Int) {
		if (this.exists("onCountdownTick"))
			this.get("onCountdownTick")(tick);
	}
	public function onResume() {
        if (this.exists("onResume"))
			this.get("onResume")();
	}
	public function onPause() {
        if (this.exists("onPause"))
			this.get("onPause")();
	}
	public function onSpawnNote(index, data, type, isSus, id) { //Dynamic
        if (this.exists("onSpawnNote"))
			this.get("onSpawnNote")(index, data, type, isSus, id);
	}
	public function updateConstantPost(elapsed:Float) {
		if (this.exists("onUpdatePost"))
			this.get("onUpdatePost")(elapsed);
	}
	public function dispatchEvent(eventName:String, val1:String, val2:String, ?val3:String) {
		if (this.exists("onEvent"))
			this.get("onEvent")(eventName, val1, val2, val3);
	}
	public function eventEarlyTrigger(eventName:String) {
		if (this.exists("onEventEarly"))
			this.get("onEventEarly")(eventName);
	}
	public function onMoveCamera(char:String) {
		if (this.exists("onMoveCamera"))
			this.get("onMoveCamera")(char);
	}
	public function startCountDown() {
		if (this.exists("onStartCountdown"))
			this.get("onStartCountdown")();
	}
	public function countDownStarted() {
		if (this.exists("onCountdownStarted"))
			this.get("onCountdownStarted")();
	}
	public function songStart() {
		if (this.exists("onSongStart"))
			this.get("onSongStart")();
	}
	public function onEndSong() {
		if (this.exists("onEndSong"))
			this.get("onEndSong")();
	}
	public function onGhostTap(key:Int) {
		if (this.exists("onGhostTap"))
			this.get("onGhostTap")(key);
	}
	public function noteMissPress(key:Int) {
		if (this.exists("noteMissPress"))
			this.get("noteMissPress")(key);
	}
	public function onKeyPress(key:Int) {
		if (this.exists("onKeyPress"))
			this.get("onKeyPress")(key);
	}
	public function onKeyRelease(key:Int) {
		if (this.exists("onKeyRelease"))
			this.get("onKeyRelease")(key);
	}
	public function noteMissPressDir(dir:Int) {
		if (this.exists("noteMissPressDirection"))
			this.get("noteMissPressDirection")(dir);
	}
	public function noteMiss(index, data, type, isSus, id) { //Dynamic
        if (this.exists("noteMiss"))
			this.get("noteMiss")(index, data, type, isSus, id);
	}
	public function opponentNoteHit(index, data, type, isSus, id) { //Dynamic
        if (this.exists("opponentNoteHit"))
			this.get("opponentNoteHit")(index, data, type, isSus, id);
	}
	public function goodNoteHit(index, data, type, isSus, id) { //Dynamic
        if (this.exists("goodNoteHit"))
			this.get("goodNoteHit")(index, data, type, isSus, id);
	}
	public function onRecalculateRating() {
		if (this.exists("onRecalculateRating"))
			this.get("onRecalculateRating")();
	}
}  //IT SO FUCKIN EXPEREMENTAL!! DONT BULLY ME ABOUT THIS SHIT!! I'll rewrite this shit later, maybe - PurSnake

class GrfxModule
{
	public var interp:Interp;
	public var assetGroup:String;

	public var alive:Bool = true;
	public var scriptName:String = '';

	public function new(?contents:Expr, ?extraParams:StringMap<Dynamic>, ?name:String) {
		interp = new Interp();

		scriptName = name;
		
		if (extraParams != null) {
			for (i in extraParams.keys())
				interp.variables.set(i, extraParams.get(i));
		}
		interp.variables.set('dispose', dispose);
		interp.variables.set('import', import_type); // use standart haxe import but with brackets, import(flixel.FlxSprite); - Acolyte
		interp.execute(contents);
	}

	public function dispose():Dynamic
		return this.alive = false;

	public function get(field:String):Dynamic
		return interp.variables.get(field);

	public function set(field:String, value:Dynamic)
		interp.variables.set(field, value);

	public function exists(field:String):Bool
		return interp.variables.exists(field);

	public function import_type(path:String) {
		var classPackage:Array<String> = path.split('.');
        var name:String = classPackage[classPackage.length - 1];
		interp.variables.set(name, Type.resolveClass(path));
	} 
}
