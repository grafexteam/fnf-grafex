package grafex;

import flixel.math.FlxMath;
import grafex.systems.Paths;
import grafex.states.PlayState;
import flixel.FlxG;
import flixel.tweens.FlxTween;

#if sys
import sys.io.File;
import sys.FileSystem;
#else
import openfl.utils.Assets;
#end

using StringTools;

class Utils
{
	public static var defaultDifficulties:Array<String> = [
		'Easy',
		'Normal',
		'Hard'
	];
	public static var defaultDifficulty:String = 'Normal'; //The chart that has no suffix and starting difficulty on Freeplay/Story Mode

	public static var difficulties:Array<String> = [];


	inline public static function quantize(f:Float, interval:Float){
		return Std.int((f+interval/2)/interval)*interval;
	}

	public static function getDifficultyFilePath(num:Null<Int> = null)
	{
		if(num == null) num = PlayState.storyDifficulty;

		var fileSuffix:String = difficulties[num];
		if(fileSuffix != defaultDifficulty)
		{
			fileSuffix = '-' + fileSuffix;
		}
		else
		{
			fileSuffix = '';
		}
		return Paths.formatToSongPath(fileSuffix);
	}

	public static function difficultyString():String
	{
		return difficulties[PlayState.storyDifficulty].toUpperCase();
	}

	inline public static function boundTo(value:Float, min:Float, max:Float):Float {
		return Math.max(min, Math.min(max, value));
	}

	public static function coolTextFile(path:String):Array<String>
	{
		var daList:Array<String> = [];
		#if sys
		if(FileSystem.exists(path)) daList = File.getContent(path).trim().split('\n');
		#else
		     if(Assets.exists(path)) daList = Assets.getText(path).trim().split('\n');
		#end

		for (i in 0...daList.length)
		{
			daList[i] = daList[i].trim();
		}

		return daList;
	}
	public static function listFromString(string:String):Array<String>
	{
		var daList:Array<String> = [];
		daList = string.trim().split('\n');

		for (i in 0...daList.length)
		{
			daList[i] = daList[i].trim();
		}

		return daList;
	}
	public static function dominantColor(sprite:flixel.FlxSprite):Int
		{
			var countByColor:Map<Int, Int> = [];
			for (col in 0...sprite.frameWidth)
			{
				for (row in 0...sprite.frameHeight)
				{
					var colorOfThisPixel:Int = sprite.pixels.getPixel32(col, row);
					if (colorOfThisPixel != 0)
					{
						if (countByColor.exists(colorOfThisPixel))
						{
							countByColor[colorOfThisPixel] = countByColor[colorOfThisPixel] + 1;
						}
						else if (countByColor[colorOfThisPixel] != 13520687 - (2 * 13520687))
						{
							countByColor[colorOfThisPixel] = 1;
						}
					}
				}
			}
			var maxCount = 0;
			var maxKey:Int = 0; // after the loop this will store the max color
			countByColor[flixel.util.FlxColor.BLACK] = 0;
			for (key in countByColor.keys())
			{
				if (countByColor[key] >= maxCount)
				{
					maxCount = countByColor[key];
					maxKey = key;
				}
			}
			return maxKey;
		}

	public static function numberArray(max:Int, ?min = 0):Array<Int>
	{
		var dumbArray:Array<Int> = [];
		for (i in min...max)
		{
			dumbArray.push(i);
		}
		return dumbArray;
	}

	public static function formatString(string:String):String
		{
			var split:Array<String> = string.split('-');
			var formattedString:String = '';
			for (i in 0...split.length)
			{
				var piece:String = split[i];
				var allSplit = piece.split('');
				var firstLetterUpperCased = allSplit[0].toUpperCase();
				var substring = piece.substr(1, piece.length - 1);
				var newPiece = firstLetterUpperCased + substring;
				if (i != split.length - 1)
				{
					newPiece += " ";
				}
				formattedString += newPiece;
			}
			return formattedString;
		}

	//uhhhh does this even work at all? i'm starting to doubt
	public static function precacheSound(sound:String, ?library:String = null):Void {
		Paths.sound(sound, library);
	}

    public static function precacheMusic(sound:String, ?library:String = null):Void {
	Paths.music(sound, library);
	}
	public static function browserLoad(site:String) {
		#if linux
		Sys.command('/usr/bin/xdg-open', [site]);
		#else
		FlxG.openURL(site);
		#end
	}

	public static function getArtist(song:String) 
		{
			var artistPrefix:String = '';
			switch (song) // Write here your Composer(s)
			{
				case 'alteratrocity' | 'fluffy-revenge':
                    artistPrefix = 'JustXale';
                default:
				    artistPrefix = 'Kawai Sprite';
			}	
	
			return artistPrefix;
		}

	public static function cameraZoom(target, zoomLevel, speed, style, type)
		{
			FlxTween.tween(target, {zoom: zoomLevel}, speed, {ease: style, type: type});
		}
	
	public static function truncateFloat(number:Float, precision:Int):Float
	{
		var num = number;
		num = num * Math.pow(10, precision);
		num = Math.round(num) / Math.pow(10, precision);
		return num;
	}
	
	public static function GCD(a, b)
	{
		return b == 0 ? FlxMath.absInt(a) : GCD(b, a % b);
	}
}
