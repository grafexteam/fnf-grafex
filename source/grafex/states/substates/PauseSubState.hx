package grafex.states.substates;

import grafex.systems.song.Song;
import grafex.systems.statesystem.MusicBeatState;
import grafex.systems.Paths;
import grafex.systems.Conductor;
import grafex.systems.statesystem.MusicBeatSubstate;
import Controls.Control;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.FlxCamera;
import flixel.util.FlxStringUtil;
import grafex.states.PlayState;
import grafex.sprites.Alphabet;

class PauseSubState extends MusicBeatSubstate
{
	var grpMenuShit:FlxTypedGroup<Alphabet>;

	public static var goToOptions:Bool = false;
	public static var goBack:Bool = false;

    public static var playingPause:Bool = false;

	var menuItems:Array<String> = [];
	var menuItemsOG:Array<String> = ['Resume', 'Restart Song', 'Options', 'Gameplay Changers', 'Change Difficulty', 'Exit to menu'];
	var difficultyChoices = [];
	var curSelected:Int = 0;

	var pauseMusic:FlxSound;
    var pausebg:FlxSprite;
	var practiceText:FlxText;
    var skipTimeText:FlxText;
	var skipTimeTracker:Alphabet;
	var curTime:Float = Math.max(0, Conductor.songPosition);
	var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
	var levelInfo:FlxText = new FlxText(20, 15, 0, "", 32);
	var levelDifficulty:FlxText = new FlxText(20, 15 + 32, 0, "", 32);
	var blueballedTxt:FlxText = new FlxText(20, 15 + 64, 0, "", 32);
	var chartingText:FlxText = new FlxText(20, 15 + 101, 0, "CHARTING MODE", 32);

	public var countdownReady:FlxSprite;
	public var countdownSet:FlxSprite;
	public var countdownGo:FlxSprite;

	var startedCountdown:Bool = false;
	
	//var botplayText:FlxText;

	public static var transCamera:FlxCamera;

	public function new(x:Float, y:Float)
	{
		super();
		
        if(Utils.difficulties.length < 2) menuItemsOG.remove('Change Difficulty'); //No need to change difficulty if there is only one!
		if(PlayState.chartingMode)
		{
			menuItemsOG.insert(2, 'Leave Charting Mode');
			
			var num:Int = 0;
			if(!PlayState.instance.startingSong)
			{
				num = 1;
				menuItemsOG.insert(3, 'Skip Time');
			}
			menuItemsOG.insert(3 + num, 'End Song');
			menuItemsOG.insert(4 + num, 'Toggle Practice Mode');
			menuItemsOG.insert(5 + num, 'Toggle Botplay');
		}
		menuItems = menuItemsOG;

		for (i in 0...Utils.difficulties.length) {
			var diff:String = '' + Utils.difficulties[i];
			difficultyChoices.push(diff);
		}
		difficultyChoices.push('BACK');

           if (!playingPause)
		{
			playingPause = true;
			pauseMusic = new FlxSound().loadEmbedded(Paths.music('breakfast'), true, true);
			pauseMusic.volume = 0;
			pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));
			pauseMusic.ID = 9000;

			FlxG.sound.list.add(pauseMusic);
		}
		else
		{
			for (i in FlxG.sound.list)
			{
				if (i.ID == 9000) // jankiest static variable
					pauseMusic = i;
			}
		}

		bg.alpha = 0;
		bg.scrollFactor.set();
		add(bg);


                if (!ClientPrefs.lowQuality)
		{
			pausebg = new FlxSprite().loadGraphic(Paths.image('pausemenubg'));
			pausebg.color = 0xFF1E1E1E;
			pausebg.scrollFactor.set();
			pausebg.updateHitbox();
			pausebg.screenCenter();
			pausebg.antialiasing = ClientPrefs.globalAntialiasing;
			add(pausebg);
			pausebg.x += 200;
			pausebg.y -= 200;
			pausebg.alpha = 0;
			FlxTween.tween(pausebg, {
				x: 0,
				y: 0,
				alpha: 1
			}, 1, {ease: FlxEase.quadOut});
                }
		levelInfo.text += PlayState.SONG.song;
		levelInfo.scrollFactor.set();
		levelInfo.setFormat(Paths.font("vcr.ttf"), 32);
		levelInfo.updateHitbox();
		add(levelInfo);

		levelDifficulty.text += Utils.difficultyString();
		levelDifficulty.scrollFactor.set();
		levelDifficulty.setFormat(Paths.font('vcr.ttf'), 32);
		levelDifficulty.updateHitbox();
		add(levelDifficulty);

		blueballedTxt.text = "Blueballed: " + PlayState.deathCounter;
		blueballedTxt.scrollFactor.set();
		blueballedTxt.setFormat(Paths.font('vcr.ttf'), 32);
		blueballedTxt.updateHitbox();
		add(blueballedTxt);

		practiceText = new FlxText(20, 15 + 101, 0, "PRACTICE MODE", 32);
		practiceText.scrollFactor.set();
		practiceText.setFormat(Paths.font('vcr.ttf'), 32);
		practiceText.x = FlxG.width - (practiceText.width + 20);
		practiceText.updateHitbox();
		practiceText.visible = PlayState.instance.practiceMode;
		add(practiceText);

		chartingText.scrollFactor.set();
		chartingText.setFormat(Paths.font('vcr.ttf'), 32);
		chartingText.x = FlxG.width - (chartingText.width + 20);
		chartingText.y = FlxG.height - (chartingText.height + 20);
		chartingText.updateHitbox();
		chartingText.visible = PlayState.chartingMode;
		add(chartingText);

		blueballedTxt.alpha = 0;
		levelDifficulty.alpha = 0;
		levelInfo.alpha = 0;

		levelInfo.x = FlxG.width - (levelInfo.width + 20);
		levelDifficulty.x = FlxG.width - (levelDifficulty.width + 20);
		blueballedTxt.x = FlxG.width - (blueballedTxt.width + 20);

		FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(levelInfo, {alpha: 1, y: 20}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
		FlxTween.tween(levelDifficulty, {alpha: 1, y: levelDifficulty.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.5});
		FlxTween.tween(blueballedTxt, {alpha: 1, y: blueballedTxt.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.7});

		grpMenuShit = new FlxTypedGroup<Alphabet>();
		add(grpMenuShit);

        regenMenu();
		changeSelection();

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

    var holdTime:Float = 0;
	override function update(elapsed:Float)
	{
		if (pauseMusic.volume < 0.5)
			pauseMusic.volume += 0.01 * elapsed;


		super.update(elapsed);
        updateSkipTextStuff();

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;
		var accepted = controls.ACCEPT;
		var escaped = controls.BACK;
        if(FlxG.keys.justPressed.F11)
        {
        FlxG.fullscreen = !FlxG.fullscreen;
        }

		if (escaped)
			{
				curSelected = 0;
				accepted = true;
			}

		if (upP  && !startedCountdown)
		{
			changeSelection(-1);
		}
		if (downP  && !startedCountdown)
		{
			changeSelection(1);
		}
        var daSelected:String = menuItems[curSelected];
		switch (daSelected)
		{
			case 'Skip Time':
				if (controls.UI_LEFT_P)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
					curTime -= 1000;
					holdTime = 0;
				}
				if (controls.UI_RIGHT_P)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
					curTime += 1000;
					holdTime = 0;
				}

				if(controls.UI_LEFT || controls.UI_RIGHT)
				{
					holdTime += elapsed;
					if(holdTime > 0.5)
					{
						curTime += 45000 * elapsed * (controls.UI_LEFT ? -1 : 1);
					}

					if(curTime >= FlxG.sound.music.length) curTime -= FlxG.sound.music.length;
					else if(curTime < 0) curTime += FlxG.sound.music.length;
					updateSkipTimeText();
				}
		}
		if (accepted && !startedCountdown)
		{
            if (menuItems == difficultyChoices)
			{
				if(menuItems.length - 1 != curSelected && difficultyChoices.contains(daSelected)) {
					var name:String = PlayState.SONG.song;
					var poop = Highscore.formatSong(name, curSelected);
					PlayState.SONG = Song.loadFromJson(poop, name);
					PlayState.storyDifficulty = curSelected;
					MusicBeatState.resetState();
					FlxG.sound.music.volume = 0;
					PlayState.changedDifficulty = true;
					PlayState.chartingMode = false;
                    skipTimeTracker = null;

					if(skipTimeText != null)
					{
						skipTimeText.kill();
						remove(skipTimeText);
						skipTimeText.destroy();
					}
					skipTimeText = null;
					return;
				}

				menuItems = menuItemsOG;
				regenMenu();
			}
			else
			{
				menuItems = menuItemsOG;
				regenMenu();
			}	

			switch (daSelected)
			{
				case "Resume":
						if (ClientPrefs.countdownpause) 
						{
							startedCountdown = true;
							startCountdown();
						}
						else 
						{
							close();
						}

				case "Options":
					goToOptions = true;
					close();
				case 'Gameplay Changers':
					close();
					PlayState.instance.openChangersMenu();
				case 'Change Difficulty':
					menuItems = difficultyChoices;
					regenMenu();
				case 'Toggle Practice Mode':
					PlayState.instance.practiceMode = !PlayState.instance.practiceMode;
					PlayState.changedDifficulty = true;
					practiceText.visible = PlayState.instance.practiceMode;
				case "Restart Song":
					restartSong();
                                case "Leave Charting Mode":
					restartSong();
					PlayState.chartingMode = false;
				case 'Skip Time':
					if(curTime < Conductor.songPosition)
					{
						PlayState.startOnTime = curTime;
						restartSong(true);
					}
					else
					{
						if (curTime != Conductor.songPosition)
						{
							PlayState.instance.clearNotesBefore(curTime);
							PlayState.instance.setSongTime(curTime);
						}
						close();
					}
				case "End Song":
					close();
					PlayState.instance.finishSong(true);
				case 'Toggle Botplay':
					PlayState.instance.cpuControlled = !PlayState.instance.cpuControlled;
					PlayState.changedDifficulty = true;
					PlayState.instance.botplayTxt.visible = PlayState.instance.cpuControlled;
					PlayState.instance.botplayTxt.alpha = 1;
					PlayState.instance.botplaySine = 0;
				case "Exit to menu":
					PlayState.deathCounter = 0;
					PlayState.seenCutscene = false;
					if(PlayState.isStoryMode) {
						MusicBeatState.switchState(new StoryMenuState());
					} else {
						MusicBeatState.switchState(new FreeplayState());
					}
PlayState.cancelMusicFadeTween();
					FlxG.sound.playMusic(Paths.music('freakyMenu'));
                    FlxG.sound.music.time = 9400;
				     Conductor.changeBPM(102);
					PlayState.changedDifficulty = false;
					PlayState.chartingMode = false;
			}
		}
	}

	public static function restartSong(noTrans:Bool = false)
	{
		PlayState.instance.paused = true; // For lua
		FlxG.sound.music.volume = 0;
		PlayState.instance.vocals.volume = 0;

		if(noTrans)
		{
			FlxTransitionableState.skipNextTransOut = true;
			FlxG.resetState();
		}
		else
		{
			MusicBeatState.resetState();
		}
	}

	override function destroy()
	{
		if (!goToOptions)
			{
	         pauseMusic.destroy();
                 playingPause = false;
			}
		super.destroy();
	}

	function changeSelection(change:Int = 0):Void
	{
		curSelected += change;

		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpMenuShit.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
                                if(item == skipTimeTracker)
				{
					curTime = Math.max(0, Conductor.songPosition);
					updateSkipTimeText();
				}
			}
		}
	}

	function regenMenu():Void {
		for (i in 0...grpMenuShit.members.length) {
			var obj = grpMenuShit.members[0];
			obj.kill();
			grpMenuShit.remove(obj, true);
			obj.destroy();
		}
		for (i in 0...menuItems.length) {
			var item = new Alphabet(0, 70 * i + 30, menuItems[i], true, false);
			item.isMenuItem = true;
			item.targetY = i;
			grpMenuShit.add(item);
                        if(menuItems[i] == 'Skip Time')
			{
				skipTimeText = new FlxText(0, 0, 0, '', 64);
				skipTimeText.setFormat(Paths.font("vcr.ttf"), 64, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				skipTimeText.scrollFactor.set();
				skipTimeText.borderSize = 2;
				skipTimeTracker = item;
				add(skipTimeText);

				updateSkipTextStuff();
				updateSkipTimeText();
			}
		}
		curSelected = 0;
		changeSelection();
	}
        function updateSkipTextStuff()
	{
		if(skipTimeText == null || skipTimeTracker == null) return;

		skipTimeText.x = skipTimeTracker.x + skipTimeTracker.width + 60;
		skipTimeText.y = skipTimeTracker.y;
		skipTimeText.visible = (skipTimeTracker.alpha >= 1);
	}

	function updateSkipTimeText()
	{
		skipTimeText.text = FlxStringUtil.formatTime(Math.max(0, Math.floor(curTime / 1000)), false) + ' / ' + FlxStringUtil.formatTime(Math.max(0, Math.floor(FlxG.sound.music.length / 1000)), false);
	}

	function startCountdown():Void
		{
 
        var introSuffix:String = '';

        if(PlayState.isPixelStage)
        introSuffix = '-pixel'; 


			var swagCounter = 0;
			// I HAD TO DO IT HERE THE WHOLE TIME IMA KMS
					bg.visible = false;
					grpMenuShit.visible = false;
					levelInfo.visible = false;
					levelDifficulty.visible = false;
					blueballedTxt.visible = false;
					chartingText.visible = false;
					practiceText.visible = false;
					pausebg.visible = false;

					FlxG.sound.play(Paths.sound('intro3' + introSuffix), 0.6);

	var StartTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
				{

	var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
	introAssets.set('default', ['ready', 'set', 'go']);
	introAssets.set('pixel', ['pixelUI/ready-pixel', 'pixelUI/set-pixel', 'pixelUI/date-pixel']);

	var introAlts:Array<String> = introAssets.get('default');
	var antialias:Bool = ClientPrefs.globalAntialiasing;
	if(PlayState.isPixelStage) {
		introAlts = introAssets.get('pixel');
		antialias = false;
	}

					
	switch (swagCounter)
	{
		case 0:
			countdownReady = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
			countdownReady.scrollFactor.set();
			countdownReady.updateHitbox();

			if (PlayState.isPixelStage)
				countdownReady.setGraphicSize(Std.int(countdownReady.width * PlayState.daPixelZoom));

			countdownReady.screenCenter();
									//countdownReady.scale.x = 0.7;
									//countdownReady.scale.y = 0.7;
			countdownReady.antialiasing = antialias;
			add(countdownReady);
			FlxTween.tween(countdownReady, {alpha: 0}, Conductor.crochet / 1000, {
				ease: FlxEase.cubeInOut,
				onComplete: function(twn:FlxTween)
				{
					remove(countdownReady);
					countdownReady.destroy();
				}
			});
			FlxG.sound.play(Paths.sound('intro2' + introSuffix), 0.6);
		case 1:
			countdownSet = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
			countdownSet.scrollFactor.set();

			if (PlayState.isPixelStage)
				countdownSet.setGraphicSize(Std.int(countdownSet.width * PlayState.daPixelZoom));

			countdownSet.screenCenter();
									//countdownSet.scale.x = 0.7;
									//countdownSet.scale.y = 0.7;
			countdownSet.antialiasing = antialias;
			add(countdownSet);
			FlxTween.tween(countdownSet, { alpha: 0}, Conductor.crochet / 1000, {
				ease: FlxEase.cubeInOut,
				onComplete: function(twn:FlxTween)
				{
					remove(countdownSet);
					countdownSet.destroy();
				}
			});
			FlxG.sound.play(Paths.sound('intro1' + introSuffix), 0.6);
		case 2:
			countdownGo = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
			countdownGo.scrollFactor.set();

			if (PlayState.isPixelStage)
				countdownGo.setGraphicSize(Std.int(countdownGo.width * PlayState.daPixelZoom));

			countdownGo.updateHitbox();

			countdownGo.screenCenter();
									//countdownGo.scale.x = 0.7;
									//countdownGo.scale.y = 0.7;
			countdownGo.antialiasing = antialias;
			add(countdownGo);
			FlxTween.tween(countdownGo, {alpha: 0}, Conductor.crochet / 1000, {
				ease: FlxEase.cubeInOut,
				onComplete: function(twn:FlxTween)
				{
					remove(countdownGo);
					countdownGo.destroy();
				}
			});
			FlxG.sound.play(Paths.sound('introGo' + introSuffix), 0.6);
                        close();
				}
					swagCounter += 1;
				}, 4);

		}
}
