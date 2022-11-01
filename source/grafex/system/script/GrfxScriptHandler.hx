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
		// trace('Loading Module $path');
		var modulePath:String = Paths.hxModule(path);
		return new GrfxModule(parser.parseString(File.getContent(modulePath), modulePath), extraParams);
	}
}

class GrfxModule
{
	public var interp:Interp;
	public var assetGroup:String;

	public var alive:Bool = true;

	public function new(?contents:Expr, ?extraParams:StringMap<Dynamic>) {
		interp = new Interp();
		
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
