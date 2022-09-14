package grafex.sprites.background;

import flixel.FlxSprite;
import grafex.system.Paths;
import grafex.util.ClientPrefs;

class BGSprite extends FlxSprite
{
	private var idleAnim:String;
	public function new(image:String, ?library:String, x:Float = 0, y:Float = 0, ?scrollX:Float = 1, ?scrollY:Float = 1, ?animArray:Array<String> = null, ?loop:Bool = false, ?fps:Int = 24) {
		super(x, y);

		if (animArray != null) {
			frames = Paths.getSparrowAtlas(image, library);
			for (i in 0...animArray.length) {
				var anim:String = animArray[i];
				animation.addByPrefix(anim, anim, fps, loop);
				if(idleAnim == null) {
					idleAnim = anim;
					animation.play(anim);
				}
			}
		} else {
			if(image != null) {
				loadGraphic(Paths.image(image, library));
			}
			active = false;
		}
		scrollFactor.set(scrollX, scrollY);
		antialiasing = ClientPrefs.globalAntialiasing;
	}

	public function dance(?forceplay:Bool = false) {
		if(idleAnim != null) {
			animation.play(idleAnim, forceplay);
		}
	}
}