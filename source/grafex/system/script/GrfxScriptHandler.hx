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

    var smthVal:Dynamic;
    public function bipis(eventName:String, args:Array<Dynamic>):Dynamic {
        smthVal = null;
            if (this.exists(eventName))
	        //smthVal = this.get(eventName)(args);
			smthVal = Reflect.callMethod(interp.variables, this.get(eventName), args);

        return smthVal;

    } //callOnHscrip("onFunction", [arg1, arg2, arg3]);
}

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
