package grafex.system.assets.manager;

import flixel.FlxObject;
import grafex.system.assets.enums.GrfxObjectType;
import grafex.system.assets.typedefs.GrfxObjectProperties;

// TODO: REWORK ALL THIS SHIT!!! (HIGH PRIORITY!!!)
class GrfxAssetManager // this is my future hell... 
{
    /*public static var currentAssets(default, null):Array<GrfxObject> = null;

    public static var defaultArgs:GrfxObjectProperties = {x: 0.0, y: 0.0, height: 0.0, width: 0.0, image: null, animation: null, scale: 0, scrollfactor:[0,0]};

    public static function createObject(?type:GrfxObjectType = OBJECT, ?args:GrfxObjectProperties = null):FlxObject
    {
        switch(type)
        {
            case OBJECT:
                return addObject(args != null ? {
                    args;
                    //throw new GrfxException('Log', 'Object was added successfully', SUCCESS);
                } : {
                    defaultArgs;
                    //throw new GrfxException('Warning', 'Invalid GrfxObjectProperties', INVALID_ARGUMENT);
                }); // idk what an object is

            case SPRITE:
                return addSprite(args != null ? {
                    args;
                    //throw new GrfxException('Log', 'Sprite was added successfully', SUCCESS);

                } : {
                    defaultArgs;
                    //throw new GrfxException('Warning', 'Invalid GrfxObjectProperties', INVALID_ARGUMENT);
                }); 
        }
    }
    
	static function addObject(args:GrfxObjectProperties):FlxObject {
		var object = new GrfxObject(args.x, args.y);
        return object;
	}

	static function addSprite(args:GrfxObjectProperties):FlxObject {
		var sprite = new GrfxSprite(args.x, args.y);
        return sprite;
	}


    static public function toString():String
    {
        return '[object GrfxAssetManager]';
    }*/
}