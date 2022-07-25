package grafex.states.options.substates;
#if FEATURE_FILESYSTEM
import sys.FileSystem;
import sys.io.File;
#end
import openfl.display.BitmapData;
import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.FlxG;

using StringTools;

class OptionsHelpers
{
	public static var noteskinArray = ["Default", "Chip", "Future", "Grafex"];
    public static var IconsBopArray = ['Grafex', 'Classic', 'Modern'];
    public static var TimeBarArray = ['Time Left', 'Time Elapsed', 'Disabled'];
    public static var ColorBlindArray = ['None', 'Deuteranopia', 'Protanopia', 'Tritanopia'];
    public static var AccuracyTypeArray = ['Grafex', 'Kade', 'Mania', 'Andromeda', 'Forever', 'Psych'];
    
	public static function getNoteskinByID(id:Int)
	{
		return noteskinArray[id];
	}

    static public function ChangeNoteSkin(id:Int)
    {
        ClientPrefs.noteSkin = getNoteskinByID(id);
    }

    public static function getIconBopByID(id:Int)
	{
	    return IconsBopArray[id];
	}

    static public function ChangeIconBop(id:Int)
    {
        ClientPrefs.hliconbop = getIconBopByID(id);
    }

    public static function getTimeBarByID(id:Int)
	{
	    return TimeBarArray[id];
	}

    static public function ChangeTimeBar(id:Int)
    {
        ClientPrefs.timeBarType = getTimeBarByID(id);
    }

    public static function getColorBlindByID(id:Int)
    {
        return ColorBlindArray[id];
    }

    static public function ChangeColorBlind(id:Int)
    {
        ClientPrefs.ColorBlindType = getColorBlindByID(id);
    }

    public static function getAccTypeID(id:Int)
    {
        return AccuracyTypeArray[id];
    }

    static public function ChangeAccType(id:Int)
    {
        ClientPrefs.ratingSystem = getAccTypeID(id);
    }
}