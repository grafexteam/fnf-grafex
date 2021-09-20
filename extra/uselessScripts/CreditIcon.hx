package;

import flixel.FlxSprite;

class CreditIcon extends FlxSprite
{
	/**
	 * Used for FreeplayState! If you use it elsewhere, prob gonna annoying
	 */
	public var link:String;
	public var id:String;

	public function new(xPos:Float = 0, yPos:Float = 0, icon:String = 'Xale', id:String = 'Xale')
	{
		super(xPos, yPos);
		loadGraphic(Paths.image('credits/icons/icon' + icon));
		id = icon;
	}
}
