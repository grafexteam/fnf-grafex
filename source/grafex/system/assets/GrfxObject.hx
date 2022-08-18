package grafex.system.assets;

import flixel.FlxObject;

class GrfxObject extends FlxObject
{
    public var name(default, null):String = null;

    public function new(x:Float = 0, y:Float = 0, width:Float = 0, height:Float = 0, ?name:String = 'object')
    {
        super();

        this.name = name;
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;
    }

    override public function toString():String
    {
        return name;
    }
}