package grafex.effects.flixel;

import flixel.system.FlxAssets.FlxShader;

using StringTools;

class Effect
{
	public function setValue(shader:FlxShader, variable:String, value:Float)
	{
		Reflect.setProperty(Reflect.getProperty(shader, 'variable'), 'value', [value]);
	}
}