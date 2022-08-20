package grafex.system.loader;

import grafex.util.ClientPrefs;
import grafex.system.assets.manager.GrfxArgumentManager;
import grafex.system.assets.typedefs.GrfxObjectProperties;
import grafex.system.loader.typedefs.GrfxStage;
import grafex.system.script.FunkinLua;
import grafex.system.script.FunkinLua.ModchartSprite;

import grafex.states.playstate.PlayState;
import grafex.states.substates.GameOverSubstate;

import grafex.system.log.GrfxLogger.log;

import flixel.FlxSprite;
import sys.io.File;
import sys.FileSystem;
import haxe.Json;

using StringTools;

class GrfxModAssetsLoader
{
	public static function generateStage(key:String)
	{
		var stageJson:GrfxStage = parseModJson(key, 'stages/mod');
		log('info', stageJson);
	}

	static function setSpriteOptions(obj:String, props:GrfxObjectProperties)
	{	
		//props == null ? props = GrfxArgumentManager.generateObjectTypedef() : {};

		if(PlayState.instance.getModObject(obj) != null && props != null) {
			var sprite:FlxSprite = PlayState.instance.getModObject(obj);
			props.x != null ? sprite.x = props.x : {
				log('Warning', 'The object has been given an invalid X coordinate');
				sprite.x = 0;
			}

			props.y != null ? sprite.y = props.y : {
				log('Warning', 'The object has been given an invalid Y coordinate');
				sprite.y = 0;
			}

			props.scale != null ? sprite.scale.set(props.scale, props.scale) : {
				log('Warning', 'The object has been given an invalid Scale property');
				sprite.scale.set(1, 1);
			}

			props.scrollfactor != null ? sprite.scrollFactor.set(props.scrollfactor[0], props.scrollfactor[1]) : {
				log('Warning', 'The object has been given an invalid ScrollFactor property');
				sprite.scrollFactor.set(1, 1);
			}
			sprite.updateHitbox();
			makeModSprite(obj, props.image != null ? props.image : null, sprite.x, sprite.y);
			return;
		} else log('Warning', 'Invalid GrfxObjectProperties');
		return;
	}

	public static function addModSprite(tag:String, front:Bool = false)
	{
		if(PlayState.instance.modchartSprites.exists(tag)) {
			var shit:ModchartSprite = PlayState.instance.modchartSprites.get(tag);
			if(!shit.wasAdded) {
				if(front)
				{
					FunkinLua.getInstance().add(shit);
				}
				else
				{
					if(PlayState.instance.isDead)
					{
						GameOverSubstate.instance.insert(GameOverSubstate.instance.members.indexOf(GameOverSubstate.instance.boyfriend), shit);
					}
					else
					{
						var position:Int = PlayState.instance.members.indexOf(PlayState.instance.gfGroup);
						if(PlayState.instance.members.indexOf(PlayState.instance.boyfriendGroup) < position) {
							position = PlayState.instance.members.indexOf(PlayState.instance.boyfriendGroup);
						} else if(PlayState.instance.members.indexOf(PlayState.instance.dadGroup) < position) {
							position = PlayState.instance.members.indexOf(PlayState.instance.dadGroup);
						}
						PlayState.instance.insert(position, shit);
					}
				}
				shit.wasAdded = true;
			}
		}
	}

	public static function makeModSprite(tag:String, image:String, x:Float, y:Float)
	{
		tag = tag.replace('.', '');
		resetSpriteTag(tag);

		var leSprite:ModchartSprite = new ModchartSprite(x, y);

		if(image != null && image.length > 0)
		{
			leSprite.loadGraphic(Paths.image(image));
		}
		leSprite.antialiasing = ClientPrefs.globalAntialiasing;
		PlayState.instance.modchartSprites.set(tag, leSprite);
		leSprite.active = true;
	} 

    public static function parseModJson(key:String, dir:String)
    {
        var rawJson:String = null;
		var path:String = Paths.getPreloadPath('$dir/$key.json');

        #if MODS_ALLOWED
		var modPath:String = Paths.modFolders('$dir/$key.json');
		if(FileSystem.exists(modPath)) {
			rawJson = File.getContent(modPath);
		} else if(FileSystem.exists(path)) {
			rawJson = File.getContent(path);
		}
		#else
		if(Assets.exists(path)) {
			rawJson = Assets.getText(path);
		}
		#end

        return cast Json.parse(rawJson);
    }

	static function resetSpriteTag(tag:String) {
		if(!PlayState.instance.modchartSprites.exists(tag)) {
			return;
		}
		
		var pee:ModchartSprite = PlayState.instance.modchartSprites.get(tag);
		pee.kill();
		if(pee.wasAdded) {
			PlayState.instance.remove(pee, true);
		}
		pee.destroy();
		PlayState.instance.modchartSprites.remove(tag);
	}
}