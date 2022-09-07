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
	}

	private var iconOffsets:Array<Float> = [0, 0];
	var spriteType = "dual";
	public function changeIcon(char:String)
	{
		if(this.char != char)
		{
        	switch(char) 
			{     
        		default:
					var name:String = 'icons/' + char;
					if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/icon-' + char; //Older versions of psych engine's support
					if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/icon-noone'; //Prevents crash from missing icon
					var file:Dynamic = Paths.image(name);
			
					loadGraphic(file); //Load stupidly first for getting the file size
					var widths = width;
					if (width == 450) {
						loadGraphic(file, true, Math.floor(width / 3), Math.floor(height)); // 
						iconOffsets[0] = (width - 150) / 3;
						iconOffsets[1] = (width - 150) / 3;
						iconOffsets[2] = (width - 150) / 3;
					} else {
						loadGraphic(file, true, Math.floor(width / 2), Math.floor(height)); 
						iconOffsets[0] = (width - 150) / 2;
						iconOffsets[1] = (width - 150) / 2;
					}
				
			        updateHitbox();
					if (widths == 450) {
						spriteType = "trio";
						animation.add(char, [0, 1, 2], 0, false, isPlayer);
					} else {
						animation.add(char, [0, 1], 0, false, isPlayer);
						spriteType = "dual";
					}
					animation.play(char);
					this.char = char;
				
					antialiasing = ClientPrefs.globalAntialiasing;
					if(char.endsWith('-pixel')) {
						antialiasing = false;
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
	    }
	}

	public function doIconWork() {
		switch(ClientPrefs.healthIconBop)
			{
				case 'Modern':
					scale.set(1.2, 1.2);
					updateHitbox();
				case 'Grafex':
					scale.x = 1;
					scale.y = 1;
					FlxTween.tween(this.scale, {x: 1.15, y: 1.15}, Conductor.crochet / 2000, {ease: FlxEase.quadOut, type: BACKWARD});
				case 'Classic':
					setGraphicSize(Std.int(this.width + 30));
			}
	}

	var iconOffset:Int = 26;
	public function doIconPos(elapsed:Float) {
		switch(ClientPrefs.healthIconBop)
		{
			case 'Grafex':	

				this.isPlayer ? {
					x = PlayState.instance.healthBar.x + (PlayState.instance.healthBar.width * (FlxMath.remapToRange(PlayState.instance.healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
				} : {
					x = PlayState.instance.healthBar.x + (PlayState.instance.healthBar.width * (FlxMath.remapToRange(PlayState.instance.healthBar.percent, 0, 100, 100, 0) * 0.01)) - (width - iconOffset);
				}

			 case 'Modern':	

				var mult:Float = FlxMath.lerp(1, scale.x, Utils.boundTo(1 - (elapsed * 9), 0, 1));
				scale.set(mult, mult);
				updateHitbox();

				this.isPlayer ? {
						x = PlayState.instance.healthBar.x + (PlayState.instance.healthBar.width * (FlxMath.remapToRange(PlayState.instance.healthBar.percent, 0, 100, 100, 0) * 0.01)) + (150 * scale.x - 150) / 2 - iconOffset;
					} : {
						x = PlayState.instance.healthBar.x + (PlayState.instance.healthBar.width * (FlxMath.remapToRange(PlayState.instance.healthBar.percent, 0, 100, 100, 0) * 0.01)) - (150 * scale.x) / 2 - iconOffset * 2;
					}
   
			case 'Classic':    
				scale.set(1, 1);

				updateHitbox();
				this.isPlayer ? {
					x = PlayState.instance.healthBar.x + (PlayState.instance.healthBar.width * (FlxMath.remapToRange(PlayState.instance.healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
				} : {
					x = PlayState.instance.healthBar.x + (PlayState.instance.healthBar.width * (FlxMath.remapToRange(PlayState.instance.healthBar.percent, 0, 100, 100, 0) * 0.01)) - (width - iconOffset);
				}
		}
	}

	public function doIconPosFreePlayBoyezz(elapsed:Float) {
		switch(ClientPrefs.healthIconBop)
		{
			case 'Grafex':	
                //nothing dumbass

			case 'Modern':	

				var mult:Float = FlxMath.lerp(1, this.scale.x, Utils.boundTo(1 - (elapsed * 9), 0, 1));
				scale.set(mult, mult);
   
			case 'Classic':    
				scale.set(1, 1);
		}
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
