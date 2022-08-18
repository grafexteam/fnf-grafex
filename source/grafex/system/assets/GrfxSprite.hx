package grafex.system.assets;

import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.graphics.FlxGraphic;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.graphics.frames.FlxTileFrames;
import grafex.system.assets.typedefs.GrfxAnimatedSprite;
import flixel.FlxG;
import grafex.system.assets.manager.GrfxAssetManager;

class GrfxSprite extends FlxSprite
{
	public var id:Int = 0;

	public var name:String = "";

	//public var height:Int = 0;

    public function new(?x:Float = 0, ?y:Float = 0, ?image:FlxGraphicAsset = null, ?animation:GrfxAnimatedSprite = null)
    {
        super(x, y);

        loadGraphic(image != null ? image : null, false, 0, 0, false, '');

		id = GrfxAssetManager.currentAssets.length + 1;
    }
	
  	override public function loadGraphic(image:FlxGraphicAsset, animated:Bool = false, width:Int = 0, height:Int = 0, unique:Bool = false, ?key:String):GrfxSprite
    {
		super.loadGraphic(image, animated, width, height, unique);

        var graph:FlxGraphic = FlxG.bitmap.add(image, unique, key);
		if (graph == null)
			return this;

		if (width == 0)
		{
			width = animated ? graph.height : graph.width;
			width = (width > graph.width) ? graph.width : width;
		}

		if (height == 0)
		{
			height = animated ? width : graph.height;
			height = (height > graph.height) ? graph.height : height;
		}

		if (animated)
			frames = FlxTileFrames.fromGraphic(graph, FlxPoint.get(width, height));
		else
			frames = graph.imageFrame;

		return this;
    }

	override function toString():String
	{
		return name;
	}

}