package grafex.system.assets.manager;

import grafex.system.typedefs.GrfxAnimatedSprite;
import grafex.system.typedefs.GrfxObjectProperties;


class GrfxArgumentManager
{
	public static function generateObjectTypedef(?x:Float = 0, ?y:Float = 0, ?width:Float = 0, ?height:Float =  0, ?image:String = null, ?animation:GrfxAnimatedSprite = null):GrfxObjectProperties
    {
        var properties:GrfxObjectProperties = null;
        properties.x = x; 
        properties.y = y; 
        properties.width = width; 
        properties.height = height;
        properties.image = image;
        properties.animation = animation;

        return properties;
    }
}

