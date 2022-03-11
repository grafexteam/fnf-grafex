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

class ExperementalSettingsSubState extends BaseOptionsMenu
{
	public function new()
	{
		title = 'Experemental Settings';
		rpcTitle = 'Experemental Settings Menu'; //for Discord Rich Presence


                var option:Option = new Option('Instant Respawn',
			"If checked, you will automatically respawn, skipping the game over animation.",
                        'instantRespawn',
			'bool',
			false);
		addOption(option);

                var option:Option = new Option('Note Skin:',
			"Funny notes dropping down, how should they look like?",
			'noteSkin',
			'string',
			'Default',
			['Default', 'Future', 'Chip', 'Grafex']);
		option.showNotes = true;
		option.onChange = onChangeNoteSkin;
		addOption(option);

                var option:Option = new Option('Green Screen Mode',
			"If checked, makes screen green.",
			'greenscreenmode',
			'bool',
			false);
		addOption(option);

		super();
	}
        function onChangeNoteSkin()
	{
		updateNotes();
	}

}