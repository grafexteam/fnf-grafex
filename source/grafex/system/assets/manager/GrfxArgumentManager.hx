package grafex.system.assets.manager;

import grafex.system.assets.typedefs.GrfxAnimatedSprite;
import grafex.system.assets.typedefs.GrfxObjectProperties;


class GrfxArgumentManager
{
	public static function generateObjectTypedef(?x:Float, ?y:Float, ?width:Float, ?height:Float, ?image:String, ?animation:GrfxAnimatedSprite):GrfxObjectProperties
    {
        var properties:GrfxObjectProperties;
        properties.x = x; 
        properties.y = y; 
        properties.width = width; 
        properties.height = height;
        properties.image = image;
        properties.animation = animation;

        return properties;
    }
}

