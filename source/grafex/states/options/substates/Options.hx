package grafex.states.options.substates;

import grafex.systems.song.Song;
import grafex.states.substates.LoadingState;
import grafex.systems.Paths;
import utils.FPSMem;
import lime.app.Application;
import lime.system.DisplayMode;
import flixel.util.FlxColor;
import Controls.KeyboardScheme;
import flixel.FlxG;
import openfl.display.FPS;
import flixel.graphics.FlxGraphic;
import openfl.Lib;

class Option
{
	public function new()
	{
		display = updateDisplay();
	}

	private var description:String = "";
	private var display:String;
	private var acceptValues:Bool = false;

	public var acceptType:Bool = false;

	public var waitingType:Bool = false;

	public final function getDisplay():String
	{
		return display;
	}

	public final function getAccept():Bool
	{
		return acceptValues;
	}

	public final function getDescription():String
	{
		return description;
	}

	public function getValue():String
	{
		return updateDisplay();
	};

	public function onType(text:String)
	{
	}

	// Returns whether the label is to be updated.
	public function press():Bool
	{
		return true;
	}

	private function updateDisplay():String
	{
		return "";
	}

	public function left():Bool
	{
		return false;
	}

	public function right():Bool
	{
		return false;
	}
}

class DFJKOption extends Option
{
	public function new()
	{
		super();
                if (OptionsMenu.isInPause)
			description = "This option cannot be toggled in the pause menu.";
		else
		description = "Edit your keybindings";
	}

	public override function press():Bool
	{
		//OptionsMenu.instance.selectedCatIndex = 4;
		//OptionsMenu.instance.switchCat(OptionsMenu.instance.options[4], false);

                if (OptionsMenu.isInPause)
			return false;
		OptionsMenu.openControllsState();
             		return true;
	}

	private override function updateDisplay():String
	{
		return "Edit Keybindings";
	}
}

class NotesOption extends Option
{
	public function new()
	{
		super();
                if (OptionsMenu.isInPause)
			description = "This option cannot be toggled in the pause menu.";
		else
		description = "Edit notes colors";
	}

	public override function press():Bool
	{
		//OptionsMenu.instance.selectedCatIndex = 4;
		//OptionsMenu.instance.switchCat(OptionsMenu.instance.options[4], false);

                if (OptionsMenu.isInPause)
			return false;
		OptionsMenu.openNotesState();
             		return true;
	}

	private override function updateDisplay():String
	{
		return "Edit Notes Colors";
	}
}

class Customizeption extends Option
{
	public function new()
	{
		super();
                 if (OptionsMenu.isInPause)
			description = "This option cannot be toggled in the pause menu.";
		else
		description = "Edit elements positions / beat offset";
	}

	public override function press():Bool
	{
		//OptionsMenu.instance.selectedCatIndex = 4;
		//OptionsMenu.instance.switchCat(OptionsMenu.instance.options[4], false);


         if (OptionsMenu.isInPause)
			return false;
		OptionsMenu.openAjustState();
	          		return true;
	}

	private override function updateDisplay():String
	{
		return "Edit elements positions and beat offset";
	}
}

class SickMSOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc + " (Press R to reset)";
		acceptType = true;
	}

	public override function left():Bool
	{
		ClientPrefs.sickWindow--;
		if (ClientPrefs.sickWindow < 0)
			ClientPrefs.sickWindow = 0;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		ClientPrefs.sickWindow++;
		display = updateDisplay();
		return true;
	}

	public override function onType(char:String)
	{
		if (char.toLowerCase() == "r")
			ClientPrefs.sickWindow = 45;
	}

	private override function updateDisplay():String
	{
		return "SICK: < " + ClientPrefs.sickWindow + " ms >";
	}
}

class GoodMsOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc + " (Press R to reset)";
		acceptType = true;
	}

	public override function left():Bool
	{
		ClientPrefs.goodWindow--;
		if (ClientPrefs.goodWindow < 0)
			ClientPrefs.goodWindow = 0;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		ClientPrefs.goodWindow++;
		display = updateDisplay();
		return true;
	}

	public override function onType(char:String)
	{
		if (char.toLowerCase() == "r")
			ClientPrefs.goodWindow = 90;
	}

	private override function updateDisplay():String
	{
		return "GOOD: < " + ClientPrefs.goodWindow + " ms >";
	}
}

class BadMsOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc + " (Press R to reset)";
		acceptType = true;
	}

	public override function left():Bool
	{
		ClientPrefs.badWindow--;
		if (ClientPrefs.badWindow < 0)
			ClientPrefs.badWindow = 0;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		ClientPrefs.badWindow++;
		display = updateDisplay();
		return true;
	}

	public override function onType(char:String)
	{
		if (char.toLowerCase() == "r")
			ClientPrefs.badWindow = 135;
	}

	private override function updateDisplay():String
	{
		return "BAD: < " + ClientPrefs.badWindow + " ms >";
	}
}

/*class ShitMsOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc + " (Press R to reset)";
		acceptType = true;
	}

	public override function left():Bool
	{
		FlxG.save.data.shitMs--;
		if (FlxG.save.data.shitMs < 0)
			FlxG.save.data.shitMs = 0;
		display = updateDisplay();
		return true;
	}

	public override function onType(char:String)
	{
		if (char.toLowerCase() == "r")
			FlxG.save.data.shitMs = 160;
	}

	public override function right():Bool
	{
		FlxG.save.data.shitMs++;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "SHIT: < " + FlxG.save.data.shitMs + " ms >";
	}
}*/

class DownscrollOption extends Option
{
	public function new(desc:String)
	{
		super();
		if (OptionsMenu.isInPause)
			description = "This option cannot be toggled in the pause menu.";
		else
			description = desc;
	}

	public override function left():Bool
	{
		if (OptionsMenu.isInPause)
			return false;
		ClientPrefs.downScroll = !ClientPrefs.downScroll;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		left();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Downscroll: < " + (ClientPrefs.downScroll ? "Enabled" : "Disabled") + " >";
	}
}

class GhostTapOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function left():Bool
	{
		ClientPrefs.ghostTapping = !ClientPrefs.ghostTapping;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		left();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Ghost Tapping: < " + (ClientPrefs.ghostTapping ? "Enabled" : "Disabled") + " >";
	}
}

class SkipTitleOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function left():Bool
	{
		ClientPrefs.skipTitleState = !ClientPrefs.skipTitleState;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		left();
		return true;
	}

	private override function updateDisplay():String
	{
		return "TitleState Skipping: < " + (ClientPrefs.skipTitleState ? "Enabled" : "Disabled") + " >";
	}
}

class KESustainsOption extends Option
{
	public function new(desc:String)
	{
		super();
         if (OptionsMenu.isInPause)
			description = "This option cannot be toggled in the pause menu.";
		else
		description = desc;
	}

	public override function left():Bool
	{
                if (OptionsMenu.isInPause)
			return false;
		ClientPrefs.keSustains = !ClientPrefs.keSustains;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		left();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Kade Engine Sustains System: < " + (ClientPrefs.keSustains ? "Enabled" : "Disabled") + " >";
	}
}



class ScoreZoom extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function left():Bool
	{
		ClientPrefs.scoreZoom = !ClientPrefs.scoreZoom;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		left();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Score zomming in beats: < " + (ClientPrefs.scoreZoom ? "Enabled" : "Disabled") + " >";
	}
}

class HideHud extends Option
{
	public function new(desc:String)
	{
		super();
              if (OptionsMenu.isInPause)
			description = "This option cannot be toggled in the pause menu.";
		else
			description = desc;

	}

	public override function left():Bool
	{
              	if (OptionsMenu.isInPause)
			return false;
		ClientPrefs.hideHud = !ClientPrefs.hideHud;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		left();
		return true;
	}

	private override function updateDisplay():String
	{
		return "HUD: < " + (!ClientPrefs.hideHud ? "Enabled" : "Disabled") + " >";
	}
}

class MicedUpSusOption extends Option
{
	public function new(desc:String)
	{
		super();
              if (OptionsMenu.isInPause)
			description = "This option cannot be toggled in the pause menu.";
		else
			description = desc;

	}

	public override function left():Bool
	{
              	if (OptionsMenu.isInPause)
			return false;
		ClientPrefs.micedUpSus = !ClientPrefs.micedUpSus;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		left();
		return true;
	}

	private override function updateDisplay():String
	{
		return "MicedUp Sustains Filter: < " + (ClientPrefs.micedUpSus ? "Enabled" : "Disabled") + " >";
	}
}

class ShowCombo extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function left():Bool
	{
		ClientPrefs.showCombo = !ClientPrefs.showCombo;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		left();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Combo Sprite: < " + (ClientPrefs.showCombo ? "Enabled" : "Disabled") + " >";
	}
}

class BlurNotes extends Option
{
	public function new(desc:String)
	{
		super();
              if (OptionsMenu.isInPause)
			description = "This option cannot be toggled in the pause menu.";
		else
			description = desc;
	}

	public override function left():Bool
	{
           	if (OptionsMenu.isInPause)
			return false;
		ClientPrefs.blurNotes = !ClientPrefs.blurNotes;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		left();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Blured Notes: < " + (ClientPrefs.blurNotes ? "Enabled" : "Disabled") + " >";
	}
}

class AutoSave extends Option
{
	public function new(desc:String)
	{
		super();

			description = desc;
	}

	public override function left():Bool
	{

		ClientPrefs.chartautosave = !ClientPrefs.chartautosave;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		left();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Chart AutoSave: < " + (ClientPrefs.chartautosave ? "Enabled" : "Disabled") + " >";
	}
}

class AutoSaveInt extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function left():Bool
	{
		ClientPrefs.chartautosaveInterval--;
		if (ClientPrefs.chartautosaveInterval < 1)
		ClientPrefs.chartautosaveInterval = 1;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		ClientPrefs.chartautosaveInterval++;
		if (ClientPrefs.chartautosaveInterval > 15)
			ClientPrefs.chartautosaveInterval = 15;
		display = updateDisplay();
		return true;
	}

	public override function getValue():String
	{
		return "Chart AutoSave Interval: < " + ClientPrefs.chartautosaveInterval + " Minutes >";
	}
}


class NoReset extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function left():Bool
	{
		ClientPrefs.noReset = !ClientPrefs.noReset;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		left();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Reset Button: < " + (!ClientPrefs.noReset ? "Enabled" : "Disabled") + " >";
	}
}

class DistractionsAndEffectsOption extends Option
{
	public function new(desc:String)
	{
		super();
		if (OptionsMenu.isInPause)
			description = "This option cannot be toggled in the pause menu.";
		else
			description = desc;
	}

	public override function left():Bool
	{
		if (OptionsMenu.isInPause)
			return false;
		FlxG.save.data.distractions = !FlxG.save.data.distractions;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		left();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Distractions: < " + (!FlxG.save.data.distractions ? "off" : "on") + " >";
	}
}

class Shouldcameramove extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		ClientPrefs.shouldcameramove= !ClientPrefs.shouldcameramove;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Dynamic Camera: < " + (ClientPrefs.shouldcameramove ? "Enabled" : "Disabled") + " >";
	}
}

class InstantRespawn extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		ClientPrefs.instantRespawn = !ClientPrefs.instantRespawn;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Instant Respawn: < " + (ClientPrefs.instantRespawn ? "Enabled" : "Disabled") + " >";
	}
}

class FlashingLightsOption extends Option
{
	public function new(desc:String)
	{
		super();
		if (OptionsMenu.isInPause)
			description = "This option cannot be toggled in the pause menu.";
		else
			description = desc;
	}

	public override function left():Bool
	{
		if (OptionsMenu.isInPause)
			return false;
		ClientPrefs.flashing = !ClientPrefs.flashing;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		left();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Flashing Lights: < " + (ClientPrefs.flashing ? "Enabled" : "Disabled") + " >";
	}
}

class AntialiasingOption extends Option
{
	public function new(desc:String)
	{
		super();
		if (OptionsMenu.isInPause)
			description = "This option cannot be toggled in the pause menu.";
		else
			description = desc;
	}

	public override function left():Bool
	{
		if (OptionsMenu.isInPause)
			return false;
		ClientPrefs.globalAntialiasing = !ClientPrefs.globalAntialiasing;
               // onChangeAntiAliasing();
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		left();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Antialiasing: < " + (ClientPrefs.globalAntialiasing ? "Enabled" : "Disabled") + " >";
	}

       /* function onChangeAntiAliasing()
	{
		for (sprite in members)
		{
			var sprite:Dynamic = sprite; //Make it check for FlxSprite instead of FlxBasic
			var sprite:FlxSprite = sprite; //Don't judge me ok
			if(sprite != null && (sprite is FlxSprite) && !(sprite is FlxText)) {
				sprite.antialiasing = ClientPrefs.globalAntialiasing;
			}
		}
	} */
}

class MissSoundsOption extends Option
{
	public function new(desc:String)
	{
		super();
			description = desc;
	}

	public override function left():Bool
	{
		ClientPrefs.playmisssounds = !ClientPrefs.playmisssounds;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		left();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Miss Sounds: < " + (ClientPrefs.playmisssounds ? "Enabled" : "Disabled") + " >";
	}
}

class MissAnimsOption extends Option
{
	public function new(desc:String)
	{
		super();
			description = desc;
	}

	public override function left():Bool
	{
		ClientPrefs.playmissanims = !ClientPrefs.playmissanims;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		left();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Miss Animations: < " + (ClientPrefs.playmissanims ? "Enabled" : "Disabled") + " >";
	}
}

class PauseCountDownOption extends Option
{
	public function new(desc:String)
	{
		super();
			description = desc;
	}

	public override function left():Bool
	{
		ClientPrefs.countdownpause = !ClientPrefs.countdownpause;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		left();
		return true;
	}

	private override function updateDisplay():String
	{
		return "AfterPause CountDown: < " + (ClientPrefs.countdownpause ? "Enabled" : "Disabled") + " >";
	}
}

class GreenScreenMode extends Option
{
	public function new(desc:String)
	{
		super();
		if (OptionsMenu.isInPause)
			description = "This option cannot be toggled in the pause menu.";
		else
			description = desc;
	}

	public override function left():Bool
	{
		if (OptionsMenu.isInPause)
			return false;
		ClientPrefs.greenscreenmode = !ClientPrefs.greenscreenmode;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		left();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Green Screen mode: < " + (ClientPrefs.greenscreenmode ? "Enabled" : "Disabled") + " >";
	}
}

class Judgement extends Option
{
	public function new(desc:String)
	{
		super();
		if (OptionsMenu.isInPause)
			description = "This option cannot be toggled in the pause menu.";
		else
			description = desc;
		acceptValues = true;
	}

	public override function press():Bool
	{
		if (OptionsMenu.isInPause)
			return false;
		OptionsMenu.instance.selectedCatIndex = 5;
		OptionsMenu.instance.switchCat(OptionsMenu.instance.options[5], false);
		return true;
	}

	private override function updateDisplay():String
	{
		return "Edit Judgements";
	}
}

class FPSOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function left():Bool
	{	
		ClientPrefs.showFPS = !ClientPrefs.showFPS;
		FPSMem.showFPS = ClientPrefs.showFPS;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		left();
		return true;
	}

	private override function updateDisplay():String
	{
		return "FPS Counter: < " + (FPSMem.showFPS ? "Enabled" : "Disabled") + " >";
	} 
}

class MEMOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function left():Bool
	{
	    ClientPrefs.showMEM = !ClientPrefs.showMEM;
        FPSMem.showMem =  ClientPrefs.showMEM;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		left();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Memory Counter: < " + (FPSMem.showMem ? "Enabled" : "Disabled") + " >";
	} 
}

class AutoPause extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function left():Bool
	{
		ClientPrefs.autoPause = !ClientPrefs.autoPause;
                FlxG.autoPause = ClientPrefs.autoPause;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		left();
		return true;
	}

	private override function updateDisplay():String
	{
		return "AutoPause: < " + (ClientPrefs.autoPause ? "Enabled" : "Disabled") + " >";
	} 
}

class ShowSplashes extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function left():Bool
	{
        ClientPrefs.noteSplashes = !ClientPrefs.noteSplashes;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		left();
		return true;
	}

	private override function updateDisplay():String
	{
		return "NoteSplashes: < " + (ClientPrefs.noteSplashes ? "Enabled" : "Disabled") + " >";
	} 
}
class QualityLow extends Option
{
	public function new(desc:String)
	{
		super();
              if (OptionsMenu.isInPause)
			description = "This option cannot be toggled in the pause menu.";
		else
			description = desc;
	}

	public override function left():Bool
	{
             		if (OptionsMenu.isInPause)
			return false;
        ClientPrefs.lowQuality = !ClientPrefs.lowQuality;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		left();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Low Quality: < " + (ClientPrefs.lowQuality ? "Enabled" : "Disabled") + " >";
	} 
}

class FPSCapOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
		acceptValues = true;
	}

	public override function press():Bool
	{
		return false;
	}

	private override function updateDisplay():String
	{
		return "FPS Cap: < " + ClientPrefs.framerate + " >";
	}

	override function right():Bool
	{
		if (ClientPrefs.framerate >= 290)
		{
			ClientPrefs.framerate = 290;
                        onChangeFramerate();
		}
		else
			ClientPrefs.framerate = ClientPrefs.framerate + 5;
		    onChangeFramerate();

		return true;
	}

	override function left():Bool
	{
		if (ClientPrefs.framerate > 290)
			ClientPrefs.framerate = 290;
		else if (ClientPrefs.framerate <= 60)
			ClientPrefs.framerate = Application.current.window.displayMode.refreshRate;
		else
			ClientPrefs.framerate = ClientPrefs.framerate - 5;
			onChangeFramerate();
		return true;
	}

    function onChangeFramerate()
	{
		if(ClientPrefs.framerate > FlxG.drawFramerate)
		{
			FlxG.updateFramerate = ClientPrefs.framerate;
			FlxG.drawFramerate = ClientPrefs.framerate;
		}
		else
		{
			FlxG.drawFramerate = ClientPrefs.framerate;
			FlxG.updateFramerate = ClientPrefs.framerate;
		}
	}

	override function getValue():String
	{
		return updateDisplay();
	}
}

class HideOppStrumsOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function left():Bool
	{
		ClientPrefs.hideOpponenStrums = !ClientPrefs.hideOpponenStrums;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		left();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Opponent Strums: < " + (!ClientPrefs.hideOpponenStrums ? "Enabled" : "Disabled") + " >";
	}
}

class OffsetMenu extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		trace("switch");

		PlayState.SONG = Song.loadFromJson('tutorial', '');
		PlayState.isStoryMode = false;
		PlayState.storyDifficulty = 0;
		PlayState.storyWeek = 0;
		//PlayState.offsetTesting = true;
		trace('CUR WEEK' + PlayState.storyWeek);
		LoadingState.loadAndSwitchState(new PlayState());
		return false;
	}

	private override function updateDisplay():String
	{
		return "Time your offset";
	}
}
class OffsetThing extends Option
{
	public function new(desc:String)
	{
		super();
		if (OptionsMenu.isInPause)
			description = "This option cannot be toggled in the pause menu.";
		else
			description = desc;
	}

	public override function left():Bool
	{
		if (OptionsMenu.isInPause)
			return false;
		ClientPrefs.noteOffset--;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		if (OptionsMenu.isInPause)
			return false;
		ClientPrefs.noteOffset++;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Note offset: < " + Utils.truncateFloat(ClientPrefs.noteOffset, 0) + " >";
	}

	public override function getValue():String
	{
		return "Note offset: < " + Utils.truncateFloat(ClientPrefs.noteOffset, 0) + " >";
	}
} 

class CamZoomOption extends Option
{
	public function new(desc:String)
	{
		super();
		if (OptionsMenu.isInPause)
			description = "This option cannot be toggled in the pause menu.";
		else
			description = desc;
	}

	public override function left():Bool
	{
		if (OptionsMenu.isInPause)
			return false;
		ClientPrefs.camZooms = !ClientPrefs.camZooms;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		left();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Camera Zooming: < " + (ClientPrefs.camZooms ? "Enabled" : "Disabled") + " >";
	}
}

class JudgementCounter extends Option
{
	public function new(desc:String)
	{
		super();
		if (OptionsMenu.isInPause)
			description = "This option cannot be toggled in the pause menu.";
		else
			description = desc;
	}

	public override function left():Bool
	{
		if (OptionsMenu.isInPause)
			return false;
		ClientPrefs.showjud = !ClientPrefs.showjud;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		left();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Judgement Counter: < " + (ClientPrefs.showjud ? "Enabled" : "Disabled") + " >";
	}
}

class Imagepersist extends Option
{
	public function new(desc:String)
	{
		super();
			description = desc;
	}

	public override function left():Bool
	{
		ClientPrefs.imagesPersist = !ClientPrefs.imagesPersist;
                FlxGraphic.defaultPersist = ClientPrefs.imagesPersist;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		left();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Persistent Cached Data: < " + (ClientPrefs.imagesPersist ? "Enabled" : "Disabled") + " >";
	}
}

class ControllerMode extends Option
{
	public function new(desc:String)
	{
		super();
		if (OptionsMenu.isInPause)
			description = "This option cannot be toggled in the pause menu.";
		else
			description = desc;
	}

	public override function left():Bool
	{
		if (OptionsMenu.isInPause)
			return false;
		ClientPrefs.controllerMode = !ClientPrefs.controllerMode;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		left();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Controller Mode: < " + (ClientPrefs.controllerMode ? "Enabled" : "Disabled") + " >";
	}
}

class MiddleScrollOption extends Option
{
	public function new(desc:String)
	{
		super();
		if (OptionsMenu.isInPause)
			description = "This option cannot be toggled in the pause menu.";
		else
			description = desc;
	}

	public override function left():Bool
	{
		if (OptionsMenu.isInPause)
			return false;
		ClientPrefs.middleScroll = !ClientPrefs.middleScroll;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		left();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Middle Scroll: < " + (ClientPrefs.middleScroll ? "Enabled" : "Disabled") + " >";
	}
}


class NoteskinOption extends Option
{
	public function new(desc:String)
	{
		super();
		if (OptionsMenu.isInPause)
			description = "This option cannot be toggled in the pause menu.";
		else
			description = desc;
	}

	public override function left():Bool
	{
		if (OptionsMenu.isInPause)
			return false;
		ClientPrefs.noteSkinNum--;
		if (ClientPrefs.noteSkinNum < 0)
			ClientPrefs.noteSkinNum = OptionsHelpers.noteskinArray.length - 4;
     	OptionsHelpers.ChangeNoteSkin(ClientPrefs.noteSkinNum);
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		if (OptionsMenu.isInPause)
			return false;
		ClientPrefs.noteSkinNum++;
		if (ClientPrefs.noteSkinNum > OptionsHelpers.noteskinArray.length - 1)
			ClientPrefs.noteSkinNum = OptionsHelpers.noteskinArray.length - 1;
        OptionsHelpers.ChangeNoteSkin(ClientPrefs.noteSkinNum);
		display = updateDisplay();
		return true;
	}

	public override function getValue():String
	{
		return "Current Noteskin: < " + OptionsHelpers.getNoteskinByID(ClientPrefs.noteSkinNum) + " >";
	}
}

class AccTypeOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function left():Bool
	{
		ClientPrefs.ratingSystemNum--;
		if (ClientPrefs.ratingSystemNum < 0)
			ClientPrefs.ratingSystemNum = OptionsHelpers.AccuracyTypeArray.length - 6;
     	OptionsHelpers.ChangeAccType(ClientPrefs.ratingSystemNum);
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		ClientPrefs.ratingSystemNum++;
		if (ClientPrefs.ratingSystemNum > OptionsHelpers.AccuracyTypeArray.length - 1)
			ClientPrefs.ratingSystemNum = OptionsHelpers.AccuracyTypeArray.length - 1;
        OptionsHelpers.ChangeAccType(ClientPrefs.ratingSystemNum);
		display = updateDisplay();
		return true;
	}

	public override function getValue():String
	{
		return "Current Accuracy Type: < " + OptionsHelpers.getAccTypeID(ClientPrefs.ratingSystemNum) + " >";
	}
}

class ColorBlindOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function left():Bool
	{
		ClientPrefs.ColorBlindTypeNum--;
		if (ClientPrefs.ColorBlindTypeNum < 0)
			ClientPrefs.ColorBlindTypeNum = OptionsHelpers.ColorBlindArray.length - 1;
        OptionsHelpers.ChangeColorBlind(ClientPrefs.ColorBlindTypeNum);
		ColorblindFilters.applyFiltersOnGame();
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		ClientPrefs.ColorBlindTypeNum++;
		if (ClientPrefs.ColorBlindTypeNum > OptionsHelpers.ColorBlindArray.length - 1)
			ClientPrefs.ColorBlindTypeNum = OptionsHelpers.ColorBlindArray.length - 4;
                  OptionsHelpers.ChangeColorBlind(ClientPrefs.ColorBlindTypeNum);
				  ColorblindFilters.applyFiltersOnGame();
		display = updateDisplay();
		return true;
	}

	public override function getValue():String
	{
		return "Color Blindness Type: < " + OptionsHelpers.getColorBlindByID(ClientPrefs.ColorBlindTypeNum) + " >";
	}
}

class IconBop extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function left():Bool
	{
		ClientPrefs.hliconbopNum--;
		if (ClientPrefs.hliconbopNum < 0)
		ClientPrefs.hliconbopNum = OptionsHelpers.IconsBopArray.length - 3;
     OptionsHelpers.ChangeIconBop(ClientPrefs.hliconbopNum);
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		ClientPrefs.hliconbopNum++;
		if (ClientPrefs.hliconbopNum > OptionsHelpers.IconsBopArray.length - 1)
			ClientPrefs.hliconbopNum = OptionsHelpers.IconsBopArray.length - 1;
        OptionsHelpers.ChangeIconBop(ClientPrefs.hliconbopNum);
		display = updateDisplay();
		return true;
	}

	public override function getValue():String
	{
		return "Icon bopping type: < " + OptionsHelpers.getIconBopByID(ClientPrefs.hliconbopNum) + " >";
	}
}

class TimeBarType extends Option
{
	public function new(desc:String)
	{
		super();
		if (OptionsMenu.isInPause)
			description = "This option cannot be toggled in the pause menu.";
		else
			description = desc;
	}

	public override function left():Bool
	{
		if (OptionsMenu.isInPause)
			return false;
		ClientPrefs.timeBarTypeNum--;
		if (ClientPrefs.timeBarTypeNum < 0)
			ClientPrefs.timeBarTypeNum = OptionsHelpers.TimeBarArray.length - 3;
     	OptionsHelpers.ChangeTimeBar(ClientPrefs.timeBarTypeNum);
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		if (OptionsMenu.isInPause)
			return false;
		ClientPrefs.timeBarTypeNum++;
		if (ClientPrefs.timeBarTypeNum > OptionsHelpers.TimeBarArray.length - 1)
			ClientPrefs.timeBarTypeNum = OptionsHelpers.TimeBarArray.length - 1;
        OptionsHelpers.ChangeTimeBar(ClientPrefs.timeBarTypeNum);
		display = updateDisplay();
		return true;
	}

	public override function getValue():String
	{
		return "Time bar type: < " + OptionsHelpers.getTimeBarByID(ClientPrefs.timeBarTypeNum) + " >";
	}
}

class HealthBarOption extends Option
{
	public function new(desc:String)
	{
		super();
		if (OptionsMenu.isInPause)
			description = "This option cannot be toggled in the pause menu.";
		else
			description = desc;
	}

	public override function left():Bool
	{
		if (OptionsMenu.isInPause)
			return false;
		ClientPrefs.visibleHealthbar = !ClientPrefs.visibleHealthbar;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		left();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Health Bar: < " + (ClientPrefs.visibleHealthbar ? "Enabled" : "Disabled") + " >";
	}
}

class HealthBarAlpha extends Option
{
	public function new(desc:String)
	{
		super();
		if (OptionsMenu.isInPause)
			description = "This option cannot be toggled in the pause menu.";
		else
			description = desc;
		acceptValues = true;
	}

	override function right():Bool
	{
		if (OptionsMenu.isInPause)
			return false;
		ClientPrefs.healthBarAlpha += 0.1;
		if (ClientPrefs.healthBarAlpha > 1)
			ClientPrefs.healthBarAlpha = 1;
		return true;
	}

	override function left():Bool
	{
		if (OptionsMenu.isInPause)
			return false;
		ClientPrefs.healthBarAlpha -= 0.1;

		if (ClientPrefs.healthBarAlpha < 0)
			ClientPrefs.healthBarAlpha = 0;

		return true;
	}

	private override function updateDisplay():String
		{
			return "Healthbar Transparceny: < " + Utils.truncateFloat(ClientPrefs.healthBarAlpha, 1) + " >";
		}
	
}

class SustainsAlpha extends Option
{
	public function new(desc:String)
	{
		super();
		if (OptionsMenu.isInPause)
			description = "This option cannot be toggled in the pause menu.";
		else
			description = desc;
		acceptValues = true;
	}

	override function right():Bool
	{
		if (OptionsMenu.isInPause)
			return false;
		ClientPrefs.susTransper += 0.1;

		if (ClientPrefs.susTransper > 1)
			ClientPrefs.susTransper = 1;
		return true;
	}

	override function left():Bool
	{
		if (OptionsMenu.isInPause)
			return false;
		ClientPrefs.susTransper -= 0.1;

		if (ClientPrefs.susTransper < 0)
			ClientPrefs.susTransper = 0;

		return true;
	}

	private override function updateDisplay():String
		{
			return "Sustain Notes Transparceny: < " + Utils.truncateFloat(ClientPrefs.susTransper, 1) + " >";
		}
	
}

class HitSoundOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
		acceptValues = true;
	}

	private override function updateDisplay():String
	{
		return "HitSound volume: < " + Utils.truncateFloat(ClientPrefs.hsvol, 1) + " >";
	}

	override function right():Bool
	{
		ClientPrefs.hsvol += 0.1;
		if (ClientPrefs.hsvol > 1)
			ClientPrefs.hsvol = 1;
                FlxG.sound.play(Paths.sound('note_click'), ClientPrefs.hsvol);
		return true;

	}

	override function left():Bool
	{
		ClientPrefs.hsvol -= 0.1;
		if (ClientPrefs.hsvol < 0)
			ClientPrefs.hsvol = 0;
                FlxG.sound.play(Paths.sound('note_click'), ClientPrefs.hsvol);
		return true;
	}
}

class LaneUnderlayOption extends Option
{
	public function new(desc:String)
	{
		super();
		if (OptionsMenu.isInPause)
			description = "This option cannot be toggled in the pause menu.";
		else
			description = desc;
		acceptValues = true;
	}

	private override function updateDisplay():String
	{
		return "Lane Transparceny: < " + Utils.truncateFloat(ClientPrefs.underdelayalpha, 1) + " >";
	}

	override function right():Bool
	{
		if (OptionsMenu.isInPause)
			return false;
		ClientPrefs.underdelayalpha += 0.1;

		if (ClientPrefs.underdelayalpha > 1)
			ClientPrefs.underdelayalpha = 1;
		return true;
	}

	override function left():Bool
	{
		if (OptionsMenu.isInPause)
			return false;
		ClientPrefs.underdelayalpha -= 0.1;

		if (ClientPrefs.underdelayalpha < 0)
			ClientPrefs.underdelayalpha = 0;

		return true;
	}
}

class SongNameOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function left():Bool
	{
		ClientPrefs.songNameDisplay = !ClientPrefs.songNameDisplay;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		left();
		return true;
	}

	private override function updateDisplay():String
	{
		return "SongName Displayed: < " + (ClientPrefs.songNameDisplay ? "Enabled" : "Disabled") + " >";
	}
}

class VintageOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function left():Bool
	{
		ClientPrefs.vintageOnGame = !ClientPrefs.vintageOnGame;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		left();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Vintage: < " + (ClientPrefs.vintageOnGame ? "Enabled" : "Disabled") + " >";
	}
}
