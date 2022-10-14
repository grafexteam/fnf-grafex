package grafex.sprites;

import grafex.states.playstate.PlayState;
import grafex.system.Paths;
import grafex.system.Conductor;
import grafex.util.ClientPrefs;
import grafex.util.Utils;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.math.FlxMath;

#if MODS_ALLOWED
import sys.io.File;
import sys.FileSystem;
#end
import openfl.utils.AssetType;
import openfl.utils.Assets;

using StringTools;

class HealthIcon extends FlxSprite
{
	public var sprTracker:FlxSprite;
	public var isPlayer:Bool = false;
	private var char:String = '';

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

		if(oldAlligment != alligment)
			onChangeAlligment();

		if(spriteType == "animated")
		{
			if(animation.curAnim.finished && animation.getByName(animation.curAnim.name + '-loop') != null)
				{
					animation.play(animation.curAnim.name + '-loop');
				}
		}
	}

	private var iconOffsets:Array<Float> = [0, 0];
	public var spriteType = "dual";
	var animatedIconStage = "normal";
	public var alligment:String = 'right';
	var oldAlligment:String = 'right';
	public function changeIcon(char:String)
	{
		if(this.char != char)
		{
        	switch(char) 
			{     
        		default:
					var name:String = 'icons/' + char;
					spriteType = "dual";
					animatedIconStage = "normal";

					#if MODS_ALLOWED
					var modXmlToFind:String = Paths.modsXml(name);
					var xmlToFind:String = Paths.getPath('images/' + name + '.xml', TEXT);
					if (FileSystem.exists(modXmlToFind) || FileSystem.exists(xmlToFind) || Assets.exists(xmlToFind))
					#else
					if (Assets.exists(Paths.getPath('images/' + name + '.xml', TEXT)))
					#end
					{
						spriteType = "animated";
					}

					if(spriteType != "animated")
					{
					    if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/icon-' + char; //Older versions of psych engine's support
					    if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/icon-noone'; //Prevents crash from missing icon
					}

					var file:Dynamic = Paths.image(name);

					if(spriteType != "animated")
					{
						loadGraphic(file); //Load stupidly first for getting the file size
					    var widths = width;

						switch(width)
						{
                            case 150:
								loadGraphic(file, true, Math.floor(width), Math.floor(height));
								iconOffsets[0] = (width - 150);

								animation.add(char, [0], 0, false, isPlayer);
					            animation.play(char);
					            this.char = char;

								spriteType = "single";

							case 300:
								loadGraphic(file, true, Math.floor(width / 2), Math.floor(height)); 
					    	    iconOffsets[0] = (width - 150) / 2;
					    	    iconOffsets[1] = (width - 150) / 2;

								animation.add(char, [0, 1], 0, false, isPlayer);
								animation.play(char);
								this.char = char;

								spriteType = "dual";
                      
							case 450:
								loadGraphic(file, true, Math.floor(width / 3), Math.floor(height)); // 
								iconOffsets[0] = (width - 150) / 3;
								iconOffsets[1] = (width - 150) / 3;
								iconOffsets[2] = (width - 150) / 3;

								animation.add(char, [0, 1, 2], 0, false, isPlayer);
								animation.play(char);
								this.char = char;

								spriteType = "trio";
							
							default:
								loadGraphic(file, true, Math.floor(width / 2), Math.floor(height)); 
					    	    iconOffsets[0] = (width - 150) / 2;
					    	    iconOffsets[1] = (width - 150) / 2;

								animation.add(char, [0, 1], 0, false, isPlayer);
								animation.play(char);
								this.char = char;

								spriteType = "dual";
						}
				
			            updateHitbox();
					    antialiasing = ClientPrefs.globalAntialiasing;
					    if(char.endsWith('-pixel')) {
					    	antialiasing = false;
        	   	       }
					}
					
					if(spriteType == "animated")
						{
							frames = Paths.getSparrowAtlas(name);
					        animation.addByPrefix('win', 'win', 24, false, isPlayer);
							animation.addByPrefix('win-loop', 'win-loop', 24, true, isPlayer);
							animation.addByPrefix('normal', 'normal', 24, false, isPlayer);
							animation.addByPrefix('normal-loop', 'normal-loop', 24, true, isPlayer);
							animation.addByPrefix('loose', 'loose', 24, false, isPlayer);
							animation.addByPrefix('loose-loop', 'loose-loop', 24, true, isPlayer);

							updateHitbox();

							animation.play('normal', true);
							this.char = char;

							antialiasing = ClientPrefs.globalAntialiasing;
							if(char.endsWith('-pixel')) {
								antialiasing = false;
							}
						}
			}
		}
	}

	public dynamic function updateAnim(health:Float){ // Dynamic to prevent having like 20 if statements
		    switch(spriteType)
		    {
		        case 'trio':
		    	    if (health < 20) {
		    	    	animation.curAnim.curFrame = 1;
		    	    } else if (health > 80) {
		    	    	animation.curAnim.curFrame = 2;
		    	    } else {
		    	    	animation.curAnim.curFrame = 0;
		    	    }
                case 'dual':
		        	if (health < 20)
		        		animation.curAnim.curFrame = 1;
		        	else
		        		animation.curAnim.curFrame = 0;
				case 'single': 
					animation.curAnim.curFrame = 0;

				case 'animated':
					if (health < 20) {
						animatedIconStage = "loose";
					} else if (health > 80) {
						animatedIconStage = "win";
					} else {
						animatedIconStage = "normal";
					}
	       }
	}

	public function doIconWork() {
		
		if(spriteType == "animated")
				animation.play(animatedIconStage, true);

		scale.set(1.2, 1.2);
		updateHitbox();

	}

	var iconOffset:Int = 26;
	public function doIconPos(elapsed:Float) {
	
		var mult:Float = FlxMath.lerp(1, scale.x, Utils.boundTo(1 - (elapsed * 9), 0, 1));
		scale.set(mult, mult);
		updateHitbox();

		switch(alligment) {
            case 'right':
				this.isPlayer ? {
		    		x = PlayState.instance.healthBar.x + (PlayState.instance.healthBar.width * (FlxMath.remapToRange(PlayState.instance.healthBar.percent, 0, 100, 100, 0) * 0.01)) + (150 * scale.x - 150) / 2 - iconOffset;
		    	} : {
		    		x = PlayState.instance.healthBar.x + (PlayState.instance.healthBar.width * (FlxMath.remapToRange(PlayState.instance.healthBar.percent, 0, 100, 100, 0) * 0.01)) - (150 * scale.x) / 2 - iconOffset * 2;
		    	}	
	    case 'left':
				this.isPlayer ? {
				x = PlayState.instance.healthBar.x + (PlayState.instance.healthBar.width * (FlxMath.remapToRange(100 - PlayState.instance.healthBar.percent, 0, 100, 100, 0) * 0.01)) - (150 * scale.x) / 2 - iconOffset * 2;
		    	} : {
		    		x = PlayState.instance.healthBar.x + (PlayState.instance.healthBar.width * (FlxMath.remapToRange(100 - PlayState.instance.healthBar.percent, 0, 100, 100, 0) * 0.01)) + (150 * scale.x - 150) / 2 - iconOffset;
		    	}

		}
	}

	public function doIconPosFreePlayBoyezz(elapsed:Float) {
	
		var mult:Float = FlxMath.lerp(1, scale.x, Utils.boundTo(1 - (elapsed * 9), 0, 1));
		scale.set(mult, mult);
   
	}

	public function onChangeAlligment()
	{
		switch(alligment) {
			case 'right':
				this.flipX = isPlayer;

			case 'left':
				this.flipX = !isPlayer;
		}

		oldAlligment = alligment;

	}

	override function updateHitbox()
	{
		super.updateHitbox();
		offset.x = iconOffsets[0];
		offset.y = iconOffsets[1];
	}

	public function getCharacter():String {
		return char;
	}
}
