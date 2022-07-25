package grafex.states;

import grafex.states.options.OptionsDirect;
import grafex.systems.Paths;
import grafex.systems.statesystem.MusicBeatState;
#if desktop
import utils.Discord.DiscordClient;
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
import grafex.data.WeekData;
import flixel.system.FlxAssets.FlxShader;
import lime.app.Application;
import grafex.states.editors.MasterEditorMenu;
import flixel.input.keyboard.FlxKey;
import flixel.util.FlxTimer;
import flixel.addons.display.FlxBackdrop;
import grafex.data.EngineData;
import grafex.systems.Conductor;

using StringTools;

class MainMenuState extends MusicBeatState
{
	public static var curSelected:Int = 0;

	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;
	
	var menuItems:FlxTypedGroup<FlxSprite>;
	public var movingBG:FlxBackdrop;
	public var menuBox:FlxSprite;

        public static var firstStart:Bool = true;

	var boxMain:FlxSprite;
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

    public static var finishedFunnyMove:Bool = false;
        
    override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menu", null);
		#end
        WeekData.loadTheFirstEnabledMod();
        FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);

        if(FlxG.sound.music != null)
			if (!FlxG.sound.music.playing)
			{	
				FlxG.sound.playMusic(Paths.music('freakyMenu'), 0.7);
        		FlxG.sound.music.time = 9400;
				Conductor.changeBPM(102);
			}

        FlxG.mouse.visible = false;
        //FlxG.mouse.useSystemCursor = true;

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
		//FlxG.cameras.setDefaultDrawTarget(camGame, true);
		
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
        movingBG.velocity.x = -90;
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
		boxMain.animation.addByPrefix('idle', 'beat', 13, false);
		//boxMain.animation.play('idle');
		boxMain.antialiasing = ClientPrefs.globalAntialiasing;
		boxMain.scrollFactor.set();
		boxMain.scale.set(0.55, 0.55);
		add(boxMain);

		var scale:Float = 1;

		for (i in 0...optionShit.length)
			{
				var offset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
				var menuItem:FlxSprite = new FlxSprite(FlxG.width * -1.5, (i * 140)  + offset);
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
                if (firstStart)
				FlxTween.tween(menuItem, {x: 50}, 1 + (i * 0.25), {
					ease: FlxEase.expoInOut,
					onComplete: function(flxTween:FlxTween)
					{
						finishedFunnyMove = true;
						changeItem();
					}
				});
			else
				menuItem.x= 50;
			}
            firstStart = false;

		FlxG.camera.follow(camFollowPos, null, 1);
		
		var versionShit:FlxText = new FlxText(12, FlxG.height - 44, 0, "Grafex Engine v" + EngineData.grafexEngineVersion #if debug + " Debug" #end, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		var versionShit:FlxText = new FlxText(12, FlxG.height - 24, 0, "Friday Night Funkin' v0.2.8", 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		changeItem();

		super.create();
	}

	var selectedSomethin:Bool = false;
	var clickCount:Int = 0;
	var colorEntry:FlxColor;
	
	override function update(elapsed:Float)
	{		
		if (FlxG.sound.music != null)
            Conductor.songPosition = FlxG.sound.music.time;

		//Conductor.songPosition = FlxG.sound.music.time; // this is such a bullshit, we messed with this around 2 hours - Xale

		var lerpVal:Float = Utils.boundTo(elapsed * 9, 0, 1);

        if(FlxG.keys.justPressed.F11)
    		FlxG.fullscreen = !FlxG.fullscreen;
		if(selectedSomethin)
			new FlxTimer().start(0.1, function(tmr:FlxTimer)
				{
					FlxG.mouse.visible = false;
                    movingBG.velocity.x -= (40 / ClientPrefs.framerate * 60);
				});

		camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

		if (!selectedSomethin)
		{
			if(FlxG.mouse.wheel != 0)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
					changeItem(-FlxG.mouse.wheel);
				}
			
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
                FlxG.mouse.visible = false;
                TitleState.fromMainMenu = true;
			}

			if (controls.ACCEPT || FlxG.mouse.justPressed)
			{
				select();
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

		super.update(elapsed);

            var elapsedTime:Float = elapsed*6;
        menuItems.forEach(function(spr:FlxSprite)
        {
            if (spr.ID == curSelected)
            {
                var scaledX = FlxMath.remapToRange((spr.ID * 30) + 40, 0,1,0,1.3);
                var xPosition:Float = (scaledX * 1.5) + (FlxG.height * 0.48);
                spr.x = FlxMath.lerp(spr.x, (xPosition * Math.cos(0.7)), elapsedTime);
                FlxTween.tween(spr.scale, {x: 0.8, y: 0.8}, 0.1, {
						startDelay: 0.1,
						ease: FlxEase.linear
					}); 
            }
            else
            {
                var scaledX = FlxMath.remapToRange((spr.ID * 30) + 20, 0,1,0,1.3);
                var xPosition:Float = (scaledX * 1) + (FlxG.height * 0.48);
                spr.x = FlxMath.lerp(spr.x, (xPosition * Math.cos(1.5)), elapsedTime);
                FlxTween.tween(spr.scale, {x: 0.5, y: 0.5}, 0.1, {
						ease: FlxEase.linear
				});
            }
        });

	}

	override function stepHit()
		{
			super.stepHit();
		}

	override function beatHit()
		{
			super.beatHit();
            boxMain.animation.play('idle');
            if(curBeat % 2 == 0)
			bgClick();		
		} // no Epilepsy - PurSnake

    function changeItem(huh:Int = 0)
	{
		if (finishedFunnyMove)
		{
			curSelected += huh;

			if (curSelected >= menuItems.length)
				curSelected = 0;
			if (curSelected < 0)
				curSelected = menuItems.length - 1;
		}

		menuItems.forEach(function(spr:FlxSprite)
			{
				if (spr.ID == curSelected && finishedFunnyMove)
				{
					spr.animation.play('selected');
					camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
					FlxG.log.add(spr.frameWidth);
				}
	
				if (spr.ID != curSelected)
				{
					spr.animation.play('idle');			
				} 
			}); 
	}

	function bgClick()
		{
			if(clickCount > 1)
				clickCount = 0;
			
			switch(clickCount)
			{
				case 0:
					colorEntry = 0xFF8971f9;
				case 1:
					colorEntry = 0xFFdf7098;
			}

			FlxTween.color(movingBG, 0.7, colorEntry, 0xfffde871, {ease: FlxEase.quadOut});
			clickCount++;	
		}


        function select()
		{
                if (optionShit[curSelected] == 'donate')
				{
					Utils.browserLoad('https://ninja-muffin24.itch.io/funkin');
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));
                    FlxTween.tween(menuBox, {x:  -700}, 0.45, {ease: FlxEase.cubeInOut, type: ONESHOT, startDelay: 0});
					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected == spr.ID)
							{
								FlxTween.tween(spr, {x : 700}, 1.5, {
									ease: FlxEase.quadOut,
								});					
							}
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
										//MusicBeatState.switchState(new options.OptionsState());
										MusicBeatState.switchState(new OptionsDirect());

                                        FreeplayState.destroyFreeplayVocals();
                                        FlxG.sound.music.stop();
                                        FlxG.sound.music == null;                      
								}
							});
						}
					});
				}
        }	

}