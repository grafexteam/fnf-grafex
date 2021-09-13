package;

import flixel.FlxSprite;
import openfl.utils.Assets as OpenFlAssets;
import Data;

using StringTools;

class HealthIcon extends FlxSprite
{
	public var sprTracker:FlxSprite;
	private var isOldIcon:Bool = false;
	private var isPlayer:Bool = false;
	private var char:String = '';

	// The following icons have antialiasing forced to be disabled
	var noAntialiasing:Array<String> = ['bf-pixel', 'senpai', 'spirit'];

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();
		this.isPlayer = isPlayer;
		changeIcon(char);
		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}

	public function changeIcon(char:String) {
		if(this.char != char) {
			var name:String = 'icons/icon-' + char;
			if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/icon-face'; //Prevents crash from missing icon
			var file:Dynamic = Paths.image(name);

			loadGraphic(file, true, 150, 150);
			animation.add(char, [0, 1, 2], 0, false, isPlayer);
			animation.play(char);
			this.char = char;

			antialiasing = ClientPrefs.globalAntialiasing;
			for (i in 0...noAntialiasing.length) {
				if(char == noAntialiasing[i]) {
					antialiasing = false;
					break;
				}
			}
		}
	}

	public function getCharacter():String {
		return char;
	}
}
