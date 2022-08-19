package flixel;

import grafex.system.assets.typedefs.GrfxBeatTween;
import grafex.system.assets.typedefs.GrfxStageAnim;
import flixel.FlxSprite;

class FlxStageSprite extends FlxSprite {
    public var name:String = null;
    public var animType:String = "loop";
    public var type:String = "Bitmap";
    public var anim:GrfxStageAnim = null;
    public var spritePath:String = "";
    public var shaderName:String;
    public var onBeatOffset:GrfxBeatTween;
}