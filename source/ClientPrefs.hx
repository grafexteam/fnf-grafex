package;

import grafex.states.TitleState;
import flixel.FlxG;
import flixel.util.FlxSave;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import Controls;
import utils.FPSMem;

class ClientPrefs {
	public static var vintageOnGame:Bool = true;
    public static var playmisssounds:Bool = true;
	public static var playmissanims:Bool = true;
	public static var countdownpause:Bool = true;
    public static var greenscreenmode:Bool = false;
    public static var hitsound:Bool = false;
    public static var shouldcameramove:Bool = true;
    public static var hsvol:Float = 0;
    public static var instantRespawn:Bool = false;
    public static var hliconbop:String = 'Grafex';
    public static var hliconbopNum:Int = 0;
    public static var underdelayalpha:Float = 0.1;
    public static var underdelayonoff:Bool = true;
    public static var noteSkin:String = 'Default';
    public static var noteSkinNum:Int = 0;
    public static var autoPause:Bool = false;
    public static var showjud:Bool = true;
    public static var showCombo:Bool = true;
    public static var blurNotes:Bool = false;
	public static var visibleHealthbar:Bool = true;
	public static var ColorBlindType:String = 'None';
	public static var ColorBlindTypeNum:Int = 0;
	public static var hideOpponenStrums:Bool = false;
	public static var chartautosaveInterval:Int = 5;
	public static var chartautosave:Bool = true;
    public static var skipTitleState:Bool = false;
    public static var micedUpSus:Bool = true;
    public static var susTransper:Float = 1;
	public static var ratingSystem:String = 'Grafex';
	public static var ratingSystemNum:Int = 0;
	public static var songNameDisplay:Bool = true;
    public static var downScroll:Bool = false;
	public static var middleScroll:Bool = false;
	public static var showFPS:Bool = true;
    public static var showMEM:Bool = true;
	public static var flashing:Bool = true;
	public static var globalAntialiasing:Bool = true;
	public static var noteSplashes:Bool = true;
	public static var lowQuality:Bool = false;
	public static var framerate:Int = 60;
	public static var cursing:Bool = true;
	public static var violence:Bool = true;
	public static var camZooms:Bool = true;
	public static var hideHud:Bool = false;
	public static var noteOffset:Int = 0;
	public static var arrowHSV:Array<Array<Int>> = [[0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0]];
	public static var imagesPersist:Bool = false;
	public static var ghostTapping:Bool = true;
	public static var timeBarType:String = 'Time Left';
    public static var timeBarTypeNum:Int = 0;
	public static var scoreZoom:Bool = true;
	public static var noReset:Bool = false;
	public static var healthBarAlpha:Float = 1;
	public static var controllerMode:Bool = false;
	public static var gameplaySettings:Map<String, Dynamic> = [
		'scrollspeed' => 1.0,
		'scrolltype' => 'multiplicative', 
		'songspeed' => 1.0,
		'healthgain' => 1.0,
		'healthloss' => 1.0,
		'instakill' => false,
		'practice' => false,
		'botplay' => false,
		'opponentplay' => false,
		'healthdrainpercent' => 0
	];
	public static var comboOffset:Array<Int> = [0, 0, 0, 0];
	public static var keSustains:Bool = false; //i was bored, okay?
	
	public static var ratingOffset:Int = 0;
	public static var sickWindow:Int = 45;
	public static var goodWindow:Int = 90;
	public static var badWindow:Int = 135;
	public static var safeFrames:Float = 10;

	//Every key has two binds, add your key bind down here and then add your control on options/ControlsSubState.hx and Controls.hx
	public static var keyBinds:Map<String, Array<FlxKey>> = [
		//Key Bind, Name for ControlsSubState
		'note_left'		=> [A, LEFT],
		'note_down'		=> [S, DOWN],
		'note_up'		=> [W, UP],
		'note_right'	=> [D, RIGHT],
		
		'ui_left'		=> [A, LEFT],
		'ui_down'		=> [S, DOWN],
		'ui_up'			=> [W, UP],
		'ui_right'		=> [D, RIGHT],
		
		'accept'		=> [SPACE, ENTER],
		'back'			=> [BACKSPACE, ESCAPE],
		'pause'			=> [ENTER, ESCAPE],
		'reset'			=> [R, NONE],
		
		'volume_mute'	=> [ZERO, NONE],
		'volume_up'		=> [NUMPADPLUS, PLUS],
		'volume_down'	=> [NUMPADMINUS, MINUS],
		
		'debug_1'		=> [SEVEN, NONE],
		'debug_2'		=> [EIGHT, NONE]
	];
	public static var defaultKeys:Map<String, Array<FlxKey>> = null;

	public static function loadDefaultKeys() {
		defaultKeys = keyBinds.copy();
		//trace(defaultKeys);
	}

	public static function saveSettings() {
        FlxG.save.data.autoPause = autoPause;
		FlxG.save.data.visibleHealthbar = visibleHealthbar;
		FlxG.save.data.showjud = showjud;
        FlxG.save.data.showCombo = showCombo;
        FlxG.save.data.blurNotes = blurNotes;
		FlxG.save.data.playmissanims = playmissanims;
        FlxG.save.data.instantRespawn = instantRespawn;
        FlxG.save.data.playmisssounds = playmisssounds;
        FlxG.save.data.greenscreenmode = greenscreenmode;
        FlxG.save.data.hitsound = hitsound;
        FlxG.save.data.shouldcameramove = shouldcameramove;
        FlxG.save.data.hliconbop = hliconbop;
        FlxG.save.data.hliconbopNum = hliconbopNum;
        FlxG.save.data.noteSkin = noteSkin;
        FlxG.save.data.noteSkinNum = noteSkinNum;
		FlxG.save.data.chartautosaveInterval = chartautosaveInterval;
        FlxG.save.data.skipTitleState = skipTitleState;
		FlxG.save.data.chartautosave = chartautosave;
        FlxG.save.data.downScroll = downScroll;
		FlxG.save.data.ratingSystem = ratingSystem;
		FlxG.save.data.ratingSystemNum = ratingSystemNum;
 		FlxG.save.data.susTransper = susTransper;
		FlxG.save.data.songNameDisplay = songNameDisplay;
		FlxG.save.data.vintageOnGame = vintageOnGame;

 		FlxG.save.data.micedUpSus = micedUpSus;
		FlxG.save.data.middleScroll = middleScroll;
		FlxG.save.data.countdownpause = countdownpause;
		FlxG.save.data.showFPS = showFPS;
        FlxG.save.data.showMEM = showMEM;
		FlxG.save.data.flashing = flashing;
		FlxG.save.data.globalAntialiasing = globalAntialiasing;
		FlxG.save.data.noteSplashes = noteSplashes;
		FlxG.save.data.lowQuality = lowQuality;
		FlxG.save.data.framerate = framerate;
		FlxG.save.data.ColorBlindType = ColorBlindType;

		FlxG.save.data.camZooms = camZooms;
		FlxG.save.data.noteOffset = noteOffset;
		FlxG.save.data.hideHud = hideHud;
		FlxG.save.data.arrowHSV = arrowHSV;
		FlxG.save.data.imagesPersist = imagesPersist;
		FlxG.save.data.ghostTapping = ghostTapping;
		FlxG.save.data.timeBarType = timeBarType;
		FlxG.save.data.timeBarTypeNum = timeBarTypeNum;
		FlxG.save.data.scoreZoom = scoreZoom;
		FlxG.save.data.noReset = noReset;
        FlxG.save.data.underdelayalpha = underdelayalpha;
        FlxG.save.data.underdelayonoff = underdelayonoff;
		FlxG.save.data.hideOpponenStrums = hideOpponenStrums;
		FlxG.save.data.healthBarAlpha = healthBarAlpha;
        FlxG.save.data.hsvol = hsvol;
		FlxG.save.data.comboOffset = comboOffset;

		FlxG.save.data.ratingOffset = ratingOffset;
		FlxG.save.data.sickWindow = sickWindow;
		FlxG.save.data.goodWindow = goodWindow;
		FlxG.save.data.badWindow = badWindow;
		FlxG.save.data.safeFrames = safeFrames;
		FlxG.save.data.gameplaySettings = gameplaySettings;
		FlxG.save.data.controllerMode = controllerMode;
	
		FlxG.save.flush();

		var save:FlxSave = new FlxSave();
		save.bind('controls_v2', 'xale'); //Placing this in a separate save so that it can be manually deleted without removing your Score and stuff
		save.data.customControls = keyBinds;
		save.flush();
		FlxG.log.add("Settings saved!");
	}

	public static function loadPrefs() {
		if(FlxG.save.data.susTransper != null) {
			susTransper = FlxG.save.data.susTransper;
		}

		if(FlxG.save.data.susTransper == null) {
			susTransper = 1;
		}

		if(FlxG.save.data.micedUpSus != null) {
			micedUpSus = FlxG.save.data.micedUpSus;
		}

		if(FlxG.save.data.micedUpSus == null) {
			micedUpSus = true;
		}

		if(FlxG.save.data.vintageOnGame != null) {
			vintageOnGame = FlxG.save.data.vintageOnGame;
		}

		if(FlxG.save.data.vintageOnGame == null) {
			vintageOnGame = true;
		}

		if(FlxG.save.data.ColorBlindType != null) {
			ColorBlindType = FlxG.save.data.ColorBlindType;
		}
		
		if(FlxG.save.data.ColorBlindType == null) {
			ColorBlindType = 'None';
		}

		if(FlxG.save.data.ColorBlindTypeNum != null) {
			ColorBlindTypeNum = FlxG.save.data.ColorBlindTypeNum;
		}
		
		if(FlxG.save.data.ColorBlindTypeNum == null) {
			ColorBlindTypeNum = 0;
		}

		if(FlxG.save.data.hideOpponenStrums != null) {
			hideOpponenStrums = FlxG.save.data.hideOpponenStrums;
		}

		if(FlxG.save.data.hideOpponenStrums == null) {
			hideOpponenStrums = false;
		}

		if(FlxG.save.data.ratingSystem != null) {
			ratingSystem = FlxG.save.data.ratingSystem;
		}

		if(FlxG.save.data.ratingSystem == null) {
			ratingSystem = "Grafex";
		}

		if(FlxG.save.data.ratingSystemNum != null) {
			ratingSystemNum = FlxG.save.data.ratingSystemNum;
		}

		if(FlxG.save.data.ratingSystemNum == null) {
			ratingSystemNum = 0;
		}

		if(FlxG.save.data.chartautosaveInterval != null) {
			chartautosaveInterval = FlxG.save.data.chartautosaveInterval;
		}

		if(FlxG.save.data.chartautosaveInterval == null) {
			chartautosaveInterval = 5;
		}

		if(FlxG.save.data.chartautosave != null) {
			chartautosave = FlxG.save.data.chartautosave;
		}

		if(FlxG.save.data.chartautosave == null) {
			chartautosave = true;
		}

        if(FlxG.save.data.skipTitleState != null) {
			skipTitleState = FlxG.save.data.skipTitleState;
		}

        if(FlxG.save.data.skipTitleState == null) {
			skipTitleState = false;
		}

		if(FlxG.save.data.playmissanims != null) {
			playmissanims = FlxG.save.data.playmissanims;
		}
		
        if(FlxG.save.data.playmissanims == null) {
	        playmissanims = true;
		}

	    if(FlxG.save.data.countdownpauses != null) {
			countdownpause = FlxG.save.data.countdownpause;
		}	

        if(FlxG.save.data.countdownpause == null) {
	        countdownpause = true;
		}

		if(FlxG.save.data.noteSkin != null) {
			noteSkin = FlxG.save.data.noteSkin;
		}

		if(FlxG.save.data.noteSkin == null) {
			noteSkin = 'Default';
		}
                 	
		if(FlxG.save.data.noteSkinNum != null) {
			noteSkinNum = FlxG.save.data.noteSkinNum;
		}

    	if(FlxG.save.data.noteSkinNum == null) {
			noteSkinNum = 0;
		}

        if(FlxG.save.data.visibleHealthbar == null) {
			visibleHealthbar = true;
		}

        if(FlxG.save.data.visibleHealthbar!= null) {
			visibleHealthbar = FlxG.save.data.visibleHealthbar;
		}

		if(FlxG.save.data.showjud == null) {
			showjud = true;
		}

        if(FlxG.save.data.showjud != null) {
			showjud = FlxG.save.data.showjud;
		}

        if(FlxG.save.data.showCombo == null) {
			showCombo = true;
		}

        if(FlxG.save.data.showCombo != null) {
			showCombo = FlxG.save.data.showCombo;
		}

        if(FlxG.save.data.blurNotes == null) {
			blurNotes = false;
		}

        if(FlxG.save.data.blurNotes != null) {
			blurNotes = FlxG.save.data.blurNotes;
		}

        if(FlxG.save.data.shouldcameramove == null) {
			shouldcameramove = true;
		}

        if(FlxG.save.data.autoPause != null) {
			autoPause = FlxG.save.data.autoPause;
			FlxG.autoPause = autoPause;
		}

 		if(FlxG.save.data.autoPause == null) {
			autoPause = false;
			FlxG.autoPause = autoPause;
		}

        if(FlxG.save.data.shouldcameramove != null) {
			shouldcameramove = FlxG.save.data.shouldcameramove;
		}

		if(FlxG.save.data.hitsound == null) {
			hitsound = false;
		}

        if(FlxG.save.data.greenscreenmode == null) {
			greenscreenmode = false;
		}

        if(FlxG.save.data.playmisssounds == null) {
			playmisssounds = true;
		}

        if(FlxG.save.data.playmisssounds != null) {
			playmisssounds = FlxG.save.data.playmisssounds;
		}

        if(FlxG.save.data.instantRespawn != null) {
			instantRespawn = FlxG.save.data.instantRespawn;
		}

        if(FlxG.save.data.hitsound != null) {
			hitsound = FlxG.save.data.hitsound;
		}

        if(FlxG.save.data.greenscreenmode != null) {
			greenscreenmode = FlxG.save.data.greenscreenmode;
		}

        if(FlxG.save.data.downScroll != null) {
			downScroll = FlxG.save.data.downScroll;
		}

		if(FlxG.save.data.downScroll == null) {
			downScroll = false;
		}

		if(FlxG.save.data.middleScroll != null) {
			middleScroll = FlxG.save.data.middleScroll;
		}

		if(FlxG.save.data.middleScroll == null) {
			middleScroll = false;
		}


		if(FlxG.save.data.showFPS != null) {
			showFPS = FlxG.save.data.showFPS;	
			FPSMem.showFPS = showFPS;
			
		}
        if(FlxG.save.data.showMEM != null) {
			showMEM = FlxG.save.data.showMEM;
			FPSMem.showMem = showMEM;		
		}

		if(FlxG.save.data.showFPS == null) {
			showFPS = true;	
			FPSMem.showFPS = showFPS;
			
		}
        if(FlxG.save.data.showMEM == null) {
			showMEM = true;
			FPSMem.showMem = showMEM;		
		}

		if(FlxG.save.data.flashing != null) {
			flashing = FlxG.save.data.flashing;
		}

		if(FlxG.save.data.flashing == null) {
			flashing = true;
		}

		if(FlxG.save.data.globalAntialiasing != null) {
			globalAntialiasing = FlxG.save.data.globalAntialiasing;
		}

		if(FlxG.save.data.globalAntialiasing == null) {
			globalAntialiasing = true;
		}

		if(FlxG.save.data.noteSplashes != null) {
			noteSplashes = FlxG.save.data.noteSplashes;
		}

		if(FlxG.save.data.noteSplashes == null) {
			noteSplashes = true;
		}

		if(FlxG.save.data.lowQuality != null) {
			lowQuality = FlxG.save.data.lowQuality;
		}

		if(FlxG.save.data.lowQuality == null) {
			lowQuality = false;
		}

		if(FlxG.save.data.framerate != null) {
			framerate = FlxG.save.data.framerate;
			if(framerate > FlxG.drawFramerate) {
				FlxG.updateFramerate = framerate;
				FlxG.drawFramerate = framerate;
			} else {
				FlxG.drawFramerate = framerate;
				FlxG.updateFramerate = framerate;
			}
		}

		if(FlxG.save.data.framerate == null) {
			framerate = 60;
			if(framerate > FlxG.drawFramerate) {
				FlxG.updateFramerate = framerate;
				FlxG.drawFramerate = framerate;
			} else {
				FlxG.drawFramerate = framerate;
				FlxG.updateFramerate = framerate;
			}
		}

		if(FlxG.save.data.camZooms != null) {
			camZooms = FlxG.save.data.camZooms;
		}

		if(FlxG.save.data.camZooms == null) {
			camZooms = true;
		}

		if(FlxG.save.data.hideHud != null) {
			hideHud = FlxG.save.data.hideHud;
		}

		if(FlxG.save.data.hideHud == null) {
			hideHud = false;
		}


		if(FlxG.save.data.noteOffset != null) {
			noteOffset = FlxG.save.data.noteOffset;
		}

		if(FlxG.save.data.arrowHSV != null) {
			arrowHSV = FlxG.save.data.arrowHSV;
		}

		if(FlxG.save.data.imagesPersist != null) {
			imagesPersist = FlxG.save.data.imagesPersist;
			FlxGraphic.defaultPersist = ClientPrefs.imagesPersist;
		}

		if(FlxG.save.data.imagesPersist == null) {
			imagesPersist = false;
			FlxGraphic.defaultPersist = ClientPrefs.imagesPersist;
		}

		if(FlxG.save.data.ghostTapping != null) {
			ghostTapping = FlxG.save.data.ghostTapping;
		}

		if(FlxG.save.data.ghostTapping == null) {
			ghostTapping = true;
		}

		if(FlxG.save.data.hliconbop != null) {
			hliconbop = FlxG.save.data.hliconbop;
		}

		if(FlxG.save.data.hliconbop == null) {
			hliconbop = 'Grafex';
		}

		if(FlxG.save.data.hliconbopNum != null) {
			hliconbopNum = FlxG.save.data.hliconbopNum;
		}

		if(FlxG.save.data.hliconbopNum == null) {
			hliconbopNum = 0;
		}

        if(FlxG.save.data.timeBarType != null) {
			timeBarType = FlxG.save.data.timeBarType;
		}

		if(FlxG.save.data.timeBarType == null) {
			timeBarType = 'Time Left';
		}

 		if(FlxG.save.data.timeBarTypeNum != null) {
			timeBarTypeNum = FlxG.save.data.timeBarTypeNum;
		}

 		if(FlxG.save.data.timeBarTypeNum == null) {
			timeBarTypeNum = 0;
		}

		if(FlxG.save.data.scoreZoom != null) {
			scoreZoom = FlxG.save.data.scoreZoom;
		}

		if(FlxG.save.data.scoreZoom == null) {
			scoreZoom = true;
		}

		if(FlxG.save.data.noReset != null) {
			noReset = FlxG.save.data.noReset;
		}

		if(FlxG.save.data.underdelayalpha != null) {
			underdelayalpha = FlxG.save.data.underdelayalpha;
		}

		if(FlxG.save.data.underdelayalpha == null) {
			underdelayalpha = 0.2;
		}

    	if(FlxG.save.data.underdelayonoff != null) {
			underdelayonoff = FlxG.save.data.underdelayonoff;
		}

        if(FlxG.save.data.healthBarAlpha != null) {
			healthBarAlpha = FlxG.save.data.healthBarAlpha;
		}

    	if(FlxG.save.data.hsvol != null) {
			hsvol = FlxG.save.data.hsvol;
		}

		if(FlxG.save.data.hsvol == null) {
			hsvol = 0;
		}

		if(FlxG.save.data.comboOffset != null) {
			comboOffset = FlxG.save.data.comboOffset;
		}
		
		if(FlxG.save.data.ratingOffset != null) {
			ratingOffset = FlxG.save.data.ratingOffset;
		}

		if(FlxG.save.data.sickWindow != null) {
			sickWindow = FlxG.save.data.sickWindow;
		}

		if(FlxG.save.data.goodWindow != null) {
			goodWindow = FlxG.save.data.goodWindow;
		}

		if(FlxG.save.data.badWindow != null) {
			badWindow = FlxG.save.data.badWindow;
		}

		if(FlxG.save.data.safeFrames != null) {
			safeFrames = FlxG.save.data.safeFrames;
		}

		if(FlxG.save.data.controllerMode != null) {
			controllerMode = FlxG.save.data.controllerMode;
		}

		if(FlxG.save.data.gameplaySettings != null)
		{
			var savedMap:Map<String, Dynamic> = FlxG.save.data.gameplaySettings;
			for (name => value in savedMap)
			{
				gameplaySettings.set(name, value);
			}
		}

		if (FlxG.save.data.songNameDisplay != null)
		{
			songNameDisplay = FlxG.save.data.songNameDisplay;
		}

		if (FlxG.save.data.songNameDisplay == null)
		{
			songNameDisplay = true;
		}
		
		if(FlxG.save.data.volume != null)
		{
			FlxG.sound.volume = FlxG.save.data.volume;
		}

		if (FlxG.save.data.mute != null)
		{
			FlxG.sound.muted = FlxG.save.data.mute; 
		}

		var save:FlxSave = new FlxSave();
		save.bind('controls_v2', 'xale');
		if(save != null && save.data.customControls != null) {
			var loadedControls:Map<String, Array<FlxKey>> = save.data.customControls;
			for (control => keys in loadedControls) {
				keyBinds.set(control, keys);
			}
			reloadControls();
		}
	}

	inline public static function getGameplaySetting(name:String, defaultValue:Dynamic):Dynamic {
		return (gameplaySettings.exists(name) ? gameplaySettings.get(name) : defaultValue);
	}

	public static function reloadControls() {
		PlayerSettings.player1.controls.setKeyboardScheme(KeyboardScheme.Solo);

		TitleState.muteKeys = copyKey(keyBinds.get('volume_mute'));
		TitleState.volumeDownKeys = copyKey(keyBinds.get('volume_down'));
		TitleState.volumeUpKeys = copyKey(keyBinds.get('volume_up'));
		FlxG.sound.muteKeys = TitleState.muteKeys;
		FlxG.sound.volumeDownKeys = TitleState.volumeDownKeys;
		FlxG.sound.volumeUpKeys = TitleState.volumeUpKeys;
	}

	public static function copyKey(arrayToCopy:Array<FlxKey>):Array<FlxKey> {
		var copiedArray:Array<FlxKey> = arrayToCopy.copy();
		var i:Int = 0;
		var len:Int = copiedArray.length;

		while (i < len) {
			if(copiedArray[i] == NONE) {
				copiedArray.remove(NONE);
				--i;
			}
			i++;
			len = copiedArray.length;
		}
		return copiedArray;
	}
}
