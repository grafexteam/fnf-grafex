package grafex.cutscenes;

import grafex.systems.Paths;
import haxe.Json;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import flixel.system.FlxSound;
import grafex.cutscenes.DialogueBoxPsych.DialogueCharacter;
import flixel.FlxG;
import flixel.FlxSprite;
#if sys
import sys.FileSystem;
import sys.io.File;
#end
import openfl.utils.Assets;
import grafex.sprites.Alphabet;

using StringTools;

typedef CutsceneFile = {
	var cutscene:Array<CutsceneLine>;
}

typedef CutsceneLine = {
	var portrait:Null<String>;
	var expression:Null<String>;
	var text:Null<String>;
	var boxState:Null<String>;
	var sound:Null<String>;
    var voiceline:Null<String>;
    var cutscenePic:Null<String>;
    var showBox:Null<Bool>;
	var speed:Null<Float>;
	var event:Null<String>;
}

class Cutscene extends FlxSpriteGroup
{
	var LEFT_CHAR_X:Float = DialogueBoxPsych.LEFT_CHAR_X;
	var RIGHT_CHAR_X:Float = DialogueBoxPsych.RIGHT_CHAR_X;
	var DEFAULT_CHAR_Y:Float = DialogueBoxPsych.DEFAULT_CHAR_Y;

    var DEFAULT_TEXT_X:Float = DialogueBoxPsych.DEFAULT_TEXT_X;
    var DEFAULT_TEXT_Y:Float = DialogueBoxPsych.DEFAULT_TEXT_Y;

    public var voiceLineEnded:Bool = false;
    var cutsceneStarted:Bool = false;
	var cutsceneEnded:Bool = false;
	var introEnded:Bool = false;

    var cutsceneList:CutsceneFile = null;

    var curVL:FlxSound = null;
    var cutsceneBG:FlxSprite = null;

	public var event:Array<String> = null;

	public var finishThing:Void->Void;
	public var nextDialogueThing:Void->Void = null;
	public var skipDialogueThing:Void->Void = null;
	public var eventChecker:(event:Array<String>)->Void = null;
	var textToType:String = '';
	var bgFade:FlxSprite;
	var box:FlxSprite;
	var arrayCharacters:Array<DialogueCharacter> = [];
	var currentText:Int = 0;
	var offsetPos:Float = -600;
	var textBoxTypes:Array<String> = ['normal', 'angry'];
	var curCharacter:String = ""; // shit shit shit

    public function new(cutsceneList:CutsceneFile, ?song:String = null)
    {
        super();

		introEnded = false;

        if(song != null && song != '') {
            FlxG.sound.playMusic(Paths.music(song), 0);
            FlxG.sound.music.fadeIn(2, 0, 1);
        }

        cutsceneBG = new FlxSprite(-300, -200);
		cutsceneBG.visible = false;
		cutsceneBG.scale.set(0.75, 0.75);
		cutsceneBG.antialiasing = true;
        add(cutsceneBG);
        
        bgFade = new FlxSprite(-500, -500).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
        bgFade.scrollFactor.set();
        bgFade.visible = true;
        bgFade.alpha = 1;
        add(bgFade);

        this.cutsceneList = cutsceneList;
        spawnCharacters();

        box = new FlxSprite(70, 370);
        box.frames = Paths.getSparrowAtlas('speech_bubble');
        box.scrollFactor.set();
        box.antialiasing = ClientPrefs.globalAntialiasing;
        box.animation.addByPrefix('normal', 'speech bubble normal', 24);
        box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
        box.animation.addByPrefix('angry', 'AHH speech bubble', 24);
        box.animation.addByPrefix('angryOpen', 'speech bubble loud open', 24, false);
        box.animation.addByPrefix('center-normal', 'speech bubble middle', 24);
        box.animation.addByPrefix('center-normalOpen', 'Speech Bubble Middle Open', 24, false);
        box.animation.addByPrefix('center-angry', 'AHH Speech Bubble middle', 24);
        box.animation.addByPrefix('center-angryOpen', 'speech bubble Middle loud open', 24, false);
        box.animation.play('normal', true);
        box.visible = false;
        box.setGraphicSize(Std.int(box.width * 0.9));
        box.updateHitbox();
        add(box);

        startNextDialog();
    }

   	function spawnCharacters() {
		#if (haxe >= "4.0.0")
		var charsMap:Map<String, Bool> = new Map();
		#else
		var charsMap:Map<String, Bool> = new Map<String, Bool>();
		#end
		for (i in 0...cutsceneList.cutscene.length) {
			if(cutsceneList.cutscene[i] != null) {
				var charToAdd:String = cutsceneList.cutscene[i].portrait;
				if(!charsMap.exists(charToAdd) || !charsMap.get(charToAdd)) {
					charsMap.set(charToAdd, true);
				}
			}
		}

		for (individualChar in charsMap.keys()) {
			var x:Float = LEFT_CHAR_X;
			var y:Float = DEFAULT_CHAR_Y;
			var char:DialogueCharacter = new DialogueCharacter(x + offsetPos, y, individualChar);
			char.setGraphicSize(Std.int(char.width * DialogueCharacter.DEFAULT_SCALE * char.jsonFile.scale));
			char.updateHitbox();
			char.scrollFactor.set();
			//char.visible = cutsceneList.showBox;
			char.alpha = 0.00001;
			add(char);

			var saveY:Bool = false;
			switch(char.jsonFile.dialogue_pos) {
				case 'center':
					char.x = FlxG.width / 2;
					char.x -= char.width / 2;
					y = char.y;
					char.y = FlxG.height + 50;
					saveY = true;
				case 'right':
					x = FlxG.width - char.width + RIGHT_CHAR_X;
					char.x = x - offsetPos;
			}
			x += char.jsonFile.position[0];
			y += char.jsonFile.position[1];
			char.x += char.jsonFile.position[0];
			char.y += char.jsonFile.position[1];
			char.startingPos = (saveY ? y : x);
			arrayCharacters.push(char);
		}
	}

	var scrollSpeed = 4500;
	var daText:Alphabet = null;
	var ignoreThisFrame:Bool = true;

	override function update(elapsed:Float)
	{
		if(ignoreThisFrame) {
			ignoreThisFrame = false;
			super.update(elapsed);
			return;
		}

		if(!cutsceneEnded) {
			bgFade.alpha -= 0.3 * elapsed;
			if(bgFade.alpha < 0) bgFade.alpha = 0;

			if(PlayerSettings.player1.controls.ACCEPT) {
				if(!daText.finishedText) {
					if(daText != null) {
						daText.killTheTimer();
						daText.kill();
						remove(daText);
						daText.destroy();
					}
					daText = new Alphabet(DEFAULT_TEXT_X, DEFAULT_TEXT_Y, textToType, false, true, 0.0, 0.7);
					add(daText);
					
					if(skipDialogueThing != null) {
						skipDialogueThing();
					}
				} else if(currentText >= cutsceneList.cutscene.length) {
					cutsceneEnded = true;
					for (i in 0...textBoxTypes.length) {
						var checkArray:Array<String> = ['', 'center-'];
						var animName:String = box.animation.curAnim.name;
						for (j in 0...checkArray.length) {
							if(animName == checkArray[j] + textBoxTypes[i] || animName == checkArray[j] + textBoxTypes[i] + 'Open') {
								box.animation.play(checkArray[j] + textBoxTypes[i] + 'Open', true);
							}
						}
					}

					box.animation.curAnim.curFrame = box.animation.curAnim.frames.length - 1;
					box.animation.curAnim.reverse();
					daText.kill();
					remove(daText);
					daText.destroy();
					daText = null;
					updateBoxOffsets(box);
					FlxG.sound.music.fadeOut(1, 0);
				} else {
					startNextDialog();
				}
				FlxG.sound.play(Paths.sound('dialogueClose'));
			} else if(daText.finishedText) {
				var char:DialogueCharacter = arrayCharacters[lastCharacter];
				if(char != null && char.animation.curAnim != null && char.animationIsLoop() && char.animation.finished) {
					char.playAnim(char.animation.curAnim.name, true);
				}
			} else {
				var char:DialogueCharacter = arrayCharacters[lastCharacter];
				if(char != null && char.animation.curAnim != null && char.animation.finished) {
					char.animation.curAnim.restart();
				}
			}

			if(box.animation.curAnim.finished) {
				for (i in 0...textBoxTypes.length) {
					var checkArray:Array<String> = ['', 'center-'];
					var animName:String = box.animation.curAnim.name;
					for (j in 0...checkArray.length) {
						if(animName == checkArray[j] + textBoxTypes[i] || animName == checkArray[j] + textBoxTypes[i] + 'Open') {
							box.animation.play(checkArray[j] + textBoxTypes[i], true);
						}
					}
				}
				DialogueBoxPsych.updateBoxOffsets(box);
			}

			if(lastCharacter != -1 && arrayCharacters.length > 0) {
				for (i in 0...arrayCharacters.length) {
					var char = arrayCharacters[i];
					if(char != null) {
						if(i != lastCharacter) {
							switch(char.jsonFile.dialogue_pos) {
								case 'left':
									char.x -= scrollSpeed * elapsed;
									if(char.x < char.startingPos + offsetPos) char.x = char.startingPos + offsetPos;
								case 'center':
									char.y += scrollSpeed * elapsed;
									if(char.y > char.startingPos + FlxG.height) char.y = char.startingPos + FlxG.height;
								case 'right':
									char.x += scrollSpeed * elapsed;
									if(char.x > char.startingPos - offsetPos) char.x = char.startingPos - offsetPos;
							}
							char.alpha -= 3 * elapsed;
							if(char.alpha < 0.00001) char.alpha = 0.00001;
						} else {
							switch(char.jsonFile.dialogue_pos) {
								case 'left':
									char.x += scrollSpeed * elapsed;
									if(char.x > char.startingPos) char.x = char.startingPos;
								case 'center':
									char.y -= scrollSpeed * elapsed;
									if(char.y < char.startingPos) char.y = char.startingPos;
								case 'right':
									char.x -= scrollSpeed * elapsed;
									if(char.x < char.startingPos) char.x = char.startingPos;
							}
							char.alpha += 3 * elapsed;
							if(char.alpha > 1) char.alpha = 1;
						}
					}
				}
			}
		} else { //Dialogue ending
			if(box != null && box.animation.curAnim.curFrame <= 0) {
				box.kill();
				remove(box);
				box.destroy();
				box = null;		
			}

			if(bgFade != null) {
				bgFade.alpha -= 0.5 * elapsed;
				if(bgFade.alpha <= 0) {
					bgFade.kill();
					remove(bgFade);
					bgFade.destroy();
					bgFade = null;
				}
			}

			if(curVL != null)
				curVL.stop();

			for (i in 0...arrayCharacters.length) {
				var leChar:DialogueCharacter = arrayCharacters[i];
				if(leChar != null) {
					switch(arrayCharacters[i].jsonFile.dialogue_pos) {
						case 'left':
							leChar.x -= scrollSpeed * elapsed;
						case 'center':
							leChar.y += scrollSpeed * elapsed;
						case 'right':
							leChar.x += scrollSpeed * elapsed;
					}
					leChar.alpha -= elapsed * 10;
				}
			}

			if(box == null && bgFade == null) {
				for (i in 0...arrayCharacters.length) {
					var leChar:DialogueCharacter = arrayCharacters[0];
					if(leChar != null) {
						arrayCharacters.remove(leChar);
						leChar.kill();
						remove(leChar);
						leChar.destroy();
					}
				}
				finishThing();
				kill();
			}
		}
		super.update(elapsed);
	}

	var lastCharacter:Int = -1;
	var lastBoxType:String = '';
	function startNextDialog():Void
	{
		var curDialogue:CutsceneLine = null;
		do {
			curDialogue = cutsceneList.cutscene[currentText];
		} while(curDialogue == null);

		curDialogue = cutsceneIfCheck(curDialogue); // A litle code optimization maybe? - Xale
		
		eventCheck(curDialogue.event);
		if(eventChecker != null)
			eventChecker(curDialogue.event.split(':'));
		
		var animName:String = curDialogue.boxState;
		var boxType:String = textBoxTypes[0];
		for (i in 0...textBoxTypes.length) {
			if(textBoxTypes[i] == animName) {
				boxType = animName;
			}
		}

		if(curDialogue.cutscenePic != '')
		{
			cutsceneBG.loadGraphic(Paths.cutscenePic(curDialogue.cutscenePic));
			cutsceneBG.visible = true;
		}
		else cutsceneBG.visible = false;
		

		if(curDialogue.voiceline != null)
			{
				if(curVL != null && (curVL.playing || curDialogue.voiceline == ''))
					curVL.stop();
				curVL = new FlxSound().loadEmbedded(Paths.voiceline(curDialogue.voiceline));
				FlxG.sound.list.add(curVL);
				curVL.play(true);
			}
		
	
		var character:Int = 0;
		box.visible = curDialogue.showBox;
		for (i in 0...arrayCharacters.length) {
			if(arrayCharacters[i].curCharacter == curDialogue.portrait) {
				character = i;
				break;
			}
		}
		var centerPrefix:String = '';
		var lePosition:String = arrayCharacters[character].jsonFile.dialogue_pos;
		if(lePosition == 'center') centerPrefix = 'center-';

		if(character != lastCharacter) {
			box.animation.play(centerPrefix + boxType + 'Open', true);
			updateBoxOffsets(box);
			box.flipX = (lePosition == 'left');
		} else if(boxType != lastBoxType) {
			box.animation.play(centerPrefix + boxType, true);
			updateBoxOffsets(box);
		}
		lastCharacter = character;
		lastBoxType = boxType;

		if(daText != null) {
			daText.killTheTimer();
			daText.kill();
			remove(daText);
			daText.destroy();
		}

		textToType = curDialogue.text;
		//Alphabet.setDialogueSound('');
		daText = new Alphabet(DEFAULT_TEXT_X, DEFAULT_TEXT_Y, textToType, false, true, curDialogue.speed, 0.7);
		add(daText);

		var char:DialogueCharacter = arrayCharacters[character];
		char.visible = curDialogue.showBox;
		if(char != null) {
			char.playAnim(curDialogue.expression, daText.finishedText);
			if(char.animation.curAnim != null) {
				var rate:Float = 24 - (((curDialogue.speed - 0.05) / 5) * 480);
				if(rate < 12) rate = 12;
				else if(rate > 48) rate = 48;
				char.animation.curAnim.frameRate = rate;
			}
		}
		currentText++;

		if(nextDialogueThing != null) {
			nextDialogueThing();
		}
	}

    function getTextSpeed(voiceline:String, text:String):Float
        {
			var voicelineSound:FlxSound = new FlxSound().loadEmbedded(Paths.voiceline(voiceline));		
            var vlInSecs:Float = voicelineSound.length/1000;
            var textCount:Array<String> = text.split('');
            return vlInSecs/textCount.length - 0.01;
        }

	function updateBoxOffsets(box:FlxSprite) { //Had to copy the whole class, maybe will optimize in future lol - Xale
		box.centerOffsets();
		box.updateHitbox();
		if(box.animation.curAnim.name.startsWith('angry')) {
			box.offset.set(50, 65);
		} else if(box.animation.curAnim.name.startsWith('center-angry')) {
			box.offset.set(50, 30);
		} else {
			box.offset.set(10, 0);
		}
		
		if(!box.flipX) box.offset.y += 10;
	}

	public static function parseCutscene(path:String):CutsceneFile {
		#if MODS_ALLOWED
		if(FileSystem.exists(path))
		{
			return cast Json.parse(File.getContent(path));
		}
		#end
		return cast Json.parse(Assets.getText(path));
	}

	function cutsceneIfCheck(file:CutsceneLine):CutsceneLine
	{
		if(file.text == null || file.text.length < 1) file.text = '';
		if(file.boxState == null) file.boxState = 'normal';
		if(file.speed == null && file.voiceline != null)
			file.speed = getTextSpeed(file.voiceline, file.text);
		else if(file.speed == null)
			file.speed = 0.05;
		if(file.voiceline == null) file.voiceline = '';
		if(file.cutscenePic == null) file.cutscenePic = '';
		if(file.event == null) file.event = '';
		/*else if (file.event != '')
			eventCheck(file.event);*/
		return file;
	}

	public function eventCheck(event:String):Array<String>
	{
		trace('working lol');
		var eventArray:Array<String> = event.split(':');
		switch(eventArray[0])
		{
			case 'changeMusic':
				if(eventArray[1] != null && eventArray[1] != '') {
					FlxG.sound.music.stop();
					FlxG.sound.playMusic(Paths.music(eventArray[1]), 0);
					FlxG.sound.music.fadeIn(2, 0, 1);
				}
			case 'autoskip':
				startNextDialog();
			default:
				return null;
		}
		return null;
	}

}
