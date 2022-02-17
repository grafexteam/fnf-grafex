package options;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.FlxSubState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSave;
import haxe.Json;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import Controls;

using StringTools;

class VisualsUISubState extends BaseOptionsMenu
{
	public function new()
	{
		title = 'Visuals and UI';
		rpcTitle = 'Visuals & UI Settings Menu'; //for Discord Rich Presence
                
                var option:Option = new Option('Show Judgement',
			'If checked, shows judgement HUD.',
			'showjud',
			'bool',
			true);
		addOption(option); 

                var option:Option = new Option('Note Skin:',
			"Funny notes dropping down, how should they look like?",
			'noteSkin',
			'string',
			'Default',
			['Default', 'Future', 'Chip']);
		option.showNotes = true;
		option.onChange = onChangeNoteSkin;
		addOption(option);

		var option:Option = new Option('Note Splashes',
			"If unchecked, hitting \"Sick!\" notes won't show particles.",
			'noteSplashes',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Hide HUD',
			'If checked, hides most HUD elements.',
			'hideHud',
			'bool',
			false);
		addOption(option);
		
                var option:Option = new Option('Icon Bopping Type:',
			"How will icon bops like.",
			'hliconbop',
			'string',
			'Time Left',
			['Grafex', 'Classic', 'Modern']);
		addOption(option);

                
               var option:Option = new Option('Show Under Strums Delay',
			'If checked, shows under strums delay.',
			'underdelayonoff',
			'bool',
			true);
		addOption(option);

               var option:Option = new Option('UnderDelay Alpha',
			'How much transparent should the Under Strums Delay be.',
			'underdelayalpha',
			'percent',
			0.1);
		option.scrollSpeed = 1;
		option.minValue = 0.1;
		option.maxValue = 0.8;
		option.changeValue = 0.1;
		option.decimals = 1;
		addOption(option);

		var option:Option = new Option('Time Bar:',
			"What should the Time Bar display?",
			'timeBarType',
			'string',
			'Time Left',
			['Time Left', 'Time Elapsed', 'Disabled']);
		addOption(option);

		var option:Option = new Option('Flashing Lights',
			"Uncheck this if you're sensitive to flashing lights!",
			'flashing',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Camera Zooms',
			"If unchecked, the camera won't zoom in on a beat hit.",
			'camZooms',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Score Text Zoom on second beat',
			"If unchecked, disables the Score text zooming every 2'nd beat.",
			'scoreZoom',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Health Bar Transparency',
			'How much transparent should the health bar and icons be.',
			'healthBarAlpha',
			'percent',
			1);
		option.scrollSpeed = 1.6;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		addOption(option);
		
		#if !mobile
		var option:Option = new Option('FPS Counter',
			'If unchecked, hides FPS Counter.',
			'showFPS',
			'bool',
			true);
		addOption(option);
		option.onChange = onChangeFPSCounter;
                
                var option:Option = new Option('MEMORY Counter',
			'If unchecked, hides MEMORY Counter.',
			'showMEM',
			'bool',
			true);
		addOption(option);
		option.onChange = onChangeMEMCounter;
		#end

		super();
	}

	#if !mobile
	function onChangeNoteSkin()
	{
		updateNotes();
	}

function onChangeFPSCounter()
	{
		if(Main.fpsVar != null)
			Main.fpsVar.visible = ClientPrefs.showFPS;
	}
function onChangeMEMCounter()
	{
		if(Main.memoryCounter != null)
			Main.memoryCounter.visible = ClientPrefs.showMEM;
	}
	#end
}