package grafex.states.options;

import grafex.system.CustomFadeTransition;
import grafex.system.Paths;
import grafex.system.statesystem.MusicBeatState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxBackdrop;
import flixel.util.FlxTimer;

class OptionsDirect extends MusicBeatState
{
	override function create()
	{
		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = true;

        var movingBG:FlxBackdrop;
        movingBG = new FlxBackdrop(Paths.image('menuDesat'), 10, 0, true, true);
		movingBG.scrollFactor.set(0,0);
		movingBG.color = 0xFFea71fd;
        movingBG.velocity.x = FlxG.random.float(-90, 90);
		movingBG.velocity.y = FlxG.random.float(-20, 20);
		add(movingBG);

		openSubState(new CustomFadeTransition(1, true)); // WHAT'S WRONG WITH THIS SHIT, IT ISN'T WORKING
		new FlxTimer().start(0.8, function(tmr:FlxTimer)
		{
			openSubState(new OptionsMenu());
		});		
	}
}