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

}