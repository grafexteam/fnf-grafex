package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.system.FlxAssets;
import flixel.util.FlxColor;
import Shaders;
import flixel.system.FlxAssets.FlxShader;
import lime.app.Application;
import editors.MasterEditorMenu;
import flixel.input.keyboard.FlxKey;
import flixel.util.FlxTimer;
import flixel.addons.display.FlxBackdrop;
import data.EngineData;
import Conductor;

using StringTools;

class MainMenuState extends MusicBeatState
{
	public static var curSelected:Int = 0;

	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;
	
	var menuItems:FlxTypedGroup<FlxSprite>;
	public var movingBG:FlxBackdrop;
    public var movBGval:Float = 1;
	public var menuBox:FlxSprite;

	var boxMain:FlxSprite;
	public var tipText:FlxText;
	var tipValue:String = "";       
	var tipBackground:FlxSprite;
	var tipTextMargin:Float = 10;
	var tipTextScrolling:Bool = false;
	var optionShit:Array<String> = [
		'story_mode',
		'freeplay',
        #if MODS_ALLOWED 'mods', #end
		'credits',
		//#if !switch 'donate', #end // you can uncomment this if you want - Xale
		'options'
	];

	var camFollow:FlxObject;
	var camFollowPos:FlxObject;
	var debugKeys:Array<FlxKey>;

	var arrowLeftKeys:Array<FlxKey>;
	var arrowRightKeys:Array<FlxKey>;
        
    override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menu", null);
		#end

		Application.current.window.title = Main.appTitle + ' - Main Menu';
		camGame = new FlxCamera();

		debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));	
		arrowRightKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('ui_right'));
		arrowLeftKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('ui_left'));
		
		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement);
		FlxCamera.defaultCameras = [camGame];
		
		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		var yScroll:Float = Math.max(0.25 - (0.05 * (optionShit.length - 4)), 0.1);

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		add(camFollowPos);

		movingBG = new FlxBackdrop(Paths.image('menuDesat'), 10, 0, true, true);
		movingBG.scrollFactor.set(0,0);
		movingBG.color = 0xfffde871;
		add(movingBG);

		menuBox = new FlxSprite(-125, -100);
		menuBox.frames = Paths.getSparrowAtlas('mainmenu/menuBox');
		menuBox.animation.addByPrefix('idle', 'beat', 36, true);
		menuBox.animation.play('idle');
		menuBox.antialiasing = ClientPrefs.globalAntialiasing;
		menuBox.scrollFactor.set(0, yScroll);
		menuBox.scale.set(1.2, 1.2);
		add(menuBox);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

        boxMain = new FlxSprite(-25, 495);
		boxMain.frames = Paths.getSparrowAtlas('mainmenu/boxMain');
		boxMain.animation.addByPrefix('idle', 'beat', 15, true);
		boxMain.animation.play('idle');
		boxMain.antialiasing = ClientPrefs.globalAntialiasing;
		boxMain.scrollFactor.set();
		boxMain.scale.set(0.55, 0.55);
		add(boxMain);

		var scale:Float = 1;

		for (i in 0...optionShit.length)
			{
				var offset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
				var menuItem:FlxSprite = new FlxSprite(50, (i * 140)  + offset);
				menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + optionShit[i]);
				menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
				menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
				menuItem.animation.play('idle');
				menuItem.ID = i;
				menuItems.add(menuItem);
				var scr:Float = (optionShit.length - 4) * 0.135;
				if(optionShit.length < 6) scr = 0;
				menuItem.scrollFactor.set(0, yScroll);
				menuItem.antialiasing = ClientPrefs.globalAntialiasing;
				menuItem.updateHitbox();
			}

		FlxG.camera.follow(camFollowPos, null, 1);

		var versionShit:FlxText = new FlxText(12, FlxG.height - 44, 0, "Grafex Engine v" + data.EngineData.grafexEngineVersion #if debug + " Debug Prebuild" #end, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		var versionShit:FlxText = new FlxText(12, FlxG.height - 24, 0, "Friday Night Funkin' v" + Application.current.meta.get('version'), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		
		switch(FlxG.random.int(1, 7))
        {
        	case 1:
        	    tipValue = "Also try Terraria";
        	case 2:
        	    tipValue = "Welcome to Friday Night Funkin Grafex Engine! Thank you for playing!";
        	case 3:
        	    tipValue = "Nothing to see here -_-";
        	case 4:
        		tipValue = "Xale was here UwU";
        	case 5:
        	    tipValue = "Snake was here ._.";
        	case 6:
        	    tipValue = "Check your options)";
        	case 7:
        	    tipValue = "Are you ok?";
        	case 8:
        	    tipValue = "Week 7 not included.";
        	case 9:
        	    tipValue = "Nanomachines, son.";
        }

        tipBackground = new FlxSprite();
		tipBackground.scrollFactor.set();
		tipBackground.alpha = 0.7;
		add(tipBackground);

        tipText = new FlxText(0, 0, 0, tipValue);
		tipText.scrollFactor.set();
		tipText.setFormat("VCR OSD Mono", 24, FlxColor.WHITE, LEFT);
		tipText.updateHitbox();

        add(tipText);

		tipBackground.makeGraphic(FlxG.width, Std.int((tipTextMargin * 2) + tipText.height), FlxColor.BLACK);

		changeItem();

		super.create();
        tipTextStartScrolling();
	}

	var selectedSomethin:Bool = false;
	var clickCount:Int = 0;
	var colorEntry:FlxColor;
	
	override function update(elapsed:Float)
	{		
		if (FlxG.sound.music != null)
            Conductor.songPosition = FlxG.sound.music.time;

		Conductor.songPosition = FlxG.sound.music.time; // this is such a bullshit, we messed with this around 2 hours - Xale


		var lerpVal:Float = CoolUtil.boundTo(elapsed * 9, 0, 1);

		movingBG.x -= movBGval;

        if(FlxG.keys.justPressed.F11)
    		FlxG.fullscreen = !FlxG.fullscreen;
		
        if (tipTextScrolling)
		{
			tipText.x -= elapsed * 130;
			if (tipText.x < -tipText.width)
			{	 
                tipTextScrolling = false;
				tipTextStartScrolling();
			}
		}

		if(FlxG.keys.anyJustPressed(arrowLeftKeys) || FlxG.keys.anyJustPressed(arrowRightKeys))
			bgClick();	

		camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

		if (!selectedSomethin)
		{
			if (controls.UI_UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}
			else if (controls.UI_DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

            if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'donate')
				{
					CoolUtil.browserLoad('https://ninja-muffin24.itch.io/funkin');
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));
                    FlxTween.tween(menuBox, {x:  -650}, 0.45, {ease: FlxEase.cubeInOut, type: ONESHOT, startDelay: 0});
                    movBGval = 4;
					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
							{
								FlxTween.tween(spr, {alpha: 0}, 0.4, {
									ease: FlxEase.quadOut,
									
								});
								FlxTween.tween(spr, {x : -500}, 0.55, {
									ease: FlxEase.quadOut,
									onComplete: function(twn:FlxTween)
									{
										spr.kill();
									}
								});					
							}
						else
						{
							FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
							{
								var daChoice:String = optionShit[curSelected];

								switch (daChoice)
								{
									case 'story_mode':
										MusicBeatState.switchState(new StoryMenuState());
									case 'freeplay':
										MusicBeatState.switchState(new FreeplayState());
									#if MODS_ALLOWED
									case 'mods':
										MusicBeatState.switchState(new ModsMenuState());
									#end
									case 'credits':
										MusicBeatState.switchState(new CreditsState());
									case 'options':
										MusicBeatState.switchState(new options.OptionsState());
								}
							});
						}
					});
				}
			}
			#if desktop
			else if (FlxG.keys.anyJustPressed(debugKeys))
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end
		}

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);

		super.update(elapsed);
	}

	override function stepHit()
		{
			super.stepHit();
		}

	override function beatHit()
		{
			super.beatHit();

			bgClick();		
		} // This shit wasn't working, we idk why - Xale

    function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
			{
				if (spr.ID == curSelected)
				{
					spr.animation.play('selected');
					camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
					FlxG.log.add(spr.frameWidth);
					FlxTween.tween(spr, {x: 150}, 0.1, {
						ease: FlxEase.circInOut
					});
				
					FlxTween.tween(spr.scale, {x: 0.8, y: 0.8}, 0.1, {
						startDelay: 0.1,
						ease: FlxEase.circInOut
					});
				}
	
				if (spr.ID != curSelected)
				{
					spr.animation.play('idle');
					FlxTween.tween(spr, {x: -50}, 0.1, {
						startDelay: 0.1,
						ease: FlxEase.circInOut
					});
									
					FlxTween.tween(spr.scale, {x: 0.5, y: 0.5}, 0.1, {
						ease: FlxEase.circInOut
					});			
				}
			});
	}

	function bgClick()
		{
			if(clickCount >= 2)
				clickCount = 0;
			
			switch(clickCount)
			{
				case 0:
					colorEntry = 0xFF8971f9;
	
				case 1:
					colorEntry = 0xFFdf7098;
			}

			FlxTween.color(movingBG, 1, colorEntry, 0xfffde871, {ease: FlxEase.quadOut});
			clickCount++;	
		}

	function tipTextStartScrolling()
		{
			resetTipText();

			tipText.x = tipTextMargin;
			tipText.y = -tipText.height;
	
			new FlxTimer().start(1.0, function(timer:FlxTimer)
			{
				FlxTween.tween(tipText, {y: tipTextMargin}, 0.3);
				
				new FlxTimer().start(4.5, function(timer:FlxTimer)
				{
					tipTextScrolling = true;
				});
			});
		}

	function resetTipText()
		{
			switch(FlxG.random.int(1, 7))
        	{
        		case 1:
        		    tipValue = "Also try Terraria";
        		case 2:
        		    tipValue = "Welcome to Friday Night Funkin Grafex Engine! Thank you for playing!";
        		case 3:
        		    tipValue = "Nothing to see here -_-";
        		case 4:
        			tipValue = "Xale was here UwU";
        		case 5:
        		    tipValue = "Snake was here ._.";
        		case 6:
        		    tipValue = "Check your options)";
        		case 7:
        		    tipValue = "Are you ok?";
        		case 8:
        		    tipValue = "Week 7 not included.";
        		case 9:
        		    tipValue = "Nanomachines, son.";
        	}

			tipText.text = tipValue;
		}		

		function getCurBeat()
			{

			}
}
