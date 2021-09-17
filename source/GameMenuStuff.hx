package;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import Data;

class MenuCharacter extends FlxSprite
{
	public var character:String;

	public function new(x:Float, character:String = 'bf')
	{
		super(x);

		changeCharacter(character);
	}

	public function changeCharacter(?character:String = 'bf') {
		if(character == this.character) return;
	
		this.character = character;
		antialiasing = ClientPrefs.globalAntialiasing;

		switch(character) {
			case '':
                          
                        case 'bf':
				frames = Paths.getSparrowAtlas('menucharacters/Menu_BF');
				animation.addByPrefix('idle', "M BF Idle", 24);
				animation.addByPrefix('confirm', 'M bf HEY', 24, false);

			case 'gf':
				frames = Paths.getSparrowAtlas('menucharacters/Menu_GF');
				animation.addByPrefix('idle', "M GF Idle", 24);

			case 'dad':
				frames = Paths.getSparrowAtlas('menucharacters/Menu_Dad');
				animation.addByPrefix('idle', "M Dad Idle", 24);

			case 'spooky':
				frames = Paths.getSparrowAtlas('menucharacters/Menu_Spooky_Kids');
				animation.addByPrefix('idle', "M Spooky Kids Idle", 24);

			case 'pico':
				frames = Paths.getSparrowAtlas('menucharacters/Menu_Pico');
				animation.addByPrefix('idle', "M Pico Idle", 24);

			case 'mom':
				frames = Paths.getSparrowAtlas('menucharacters/Menu_Mom');
				animation.addByPrefix('idle', "M Mom Idle", 24);

			case 'parents-christmas':
				frames = Paths.getSparrowAtlas('menucharacters/Menu_Parents');
				animation.addByPrefix('idle', "M Parents Idle", 24);

			case 'senpai':
				frames = Paths.getSparrowAtlas('menucharacters/Menu_Senpai');
				animation.addByPrefix('idle', "M Senpai Idle", 24);
		}
		animation.play('idle');
		updateHitbox();

		switch(character) {
			case 'bf':
				offset.set(15, -40);

			case 'gf':
				offset.set(0, -25);

			case 'spooky':
				offset.set(0, -80);

			case 'pico':
				offset.set(0, -120);

			case 'mom':
				offset.set(0, 10);

			case 'parents-christmas':
				offset.set(110, 10);

			case 'senpai':
				offset.set(60, -70);
		}
	}
}

class MenuItem extends FlxSpriteGroup
{
	public var targetY:Float = 0;
	public var week:FlxSprite;
	public var flashingInt:Int = 0;

	public function new(x:Float, y:Float, weekNum:Int = 0)
	{
		super(x, y);
		week = new FlxSprite().loadGraphic(Paths.image('storymenu/week' + WeekData.getWeekNumber(weekNum)));
		//trace('Test added: ' + WeekData.getWeekNumber(weekNum) + ' (' + weekNum + ')');
		week.antialiasing = ClientPrefs.globalAntialiasing;
		add(week);
	}

	private var isFlashing:Bool = false;

	public function startFlashing():Void
	{
		isFlashing = true;
	}

	// if it runs at 60fps, fake framerate will be 6
	// if it runs at 144 fps, fake framerate will be like 14, and will update the graphic every 0.016666 * 3 seconds still???
	// so it runs basically every so many seconds, not dependant on framerate??
	// I'm still learning how math works thanks whoever is reading this lol
	var fakeFramerate:Int = Math.round((1 / FlxG.elapsed) / 10);

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		y = FlxMath.lerp(y, (targetY * 120) + 480, CoolUtil.boundTo(elapsed * 10.2, 0, 1));

		if (isFlashing)
			flashingInt += 1;

		if (flashingInt % fakeFramerate >= Math.floor(fakeFramerate / 2))
			week.color = 0xFF33ffff;
		else
			week.color = FlxColor.WHITE;
	}
}
