function onCreate()
	camY = 'camFollow.y';
	camX = 'camFollow.x';
	nevada = true;
	
	setPropertyFromClass('GameOverSubstate', 'deathSoundName', 'bfded'); --put in mods/sounds/
	
    makeLuaSprite('city', 'nevada/nevada_city', -600, -100) --the background
		addLuaSprite('city', false);
			setProperty('city.scale.x', getProperty('city.scale.x') + 0.6);
			setProperty('city.scale.y', getProperty('city.scale.y') + 0.2);
		
	if not lowQuality then
		makeAnimatedLuaSprite('heli', 'nevada/choppalol', -1680, 10) --the heli that deimos and sanford ride.
			addLuaSprite('heli', false); --Added offscreen before it starts moving.
				addAnimationByPrefix('heli', 'Move', 'choppa xD', 24, true);
	
		makeLuaSprite('hill', 'nevada/nevada_hill', -200, 100) --the hill that deimos and sanford occupy.
			addLuaSprite('hill', false);
				setProperty('hill.scale.x', getProperty('hill.scale.x') + 0.8);
				setProperty('hill.scale.y', getProperty('hill.scale.y') + 0.6);
	
		makeAnimatedLuaSprite('sanford', 'nevada/stanford', 1370, 100) --sanford's sprites. bool statement means if the animation should loop or not.
			addAnimationByPrefix('sanford', 'enter', 'stanford land', 12, false);
			addAnimationByPrefix('sanford', 'idle', 'stanford dance', 14, false);
			addAnimationByPrefix('sanford', 'shoot', 'stanford shoot', 20, false);
				setProperty('sanford.scale.x', getProperty('sanford.scale.x') + 0.26);
				setProperty('sanford.scale.y', getProperty('sanford.scale.y') + 0.26);
	
		makeAnimatedLuaSprite('deimos', 'nevada/deimous', -790, 100); --deimos's sprites
			addAnimationByPrefix('deimos', 'enter', 'deimous land', 12, false);
			addAnimationByPrefix('deimos', 'idle', 'deimous dance', 14, true);
			addAnimationByPrefix('deimos', 'shoot', 'deimous shoot', 20, false);
				setProperty('deimos.scale.x', getProperty('deimos.scale.x') + 0.26);
				setProperty('deimos.scale.y', getProperty('deimos.scale.y') + 0.26);
		
		--makeAnimatedLuaSprite('shotflashDeimos', nil, -790, 0);
			--doTweenColor('shotflashDeimosColorTween', 'shotflashDeimos', 'cccccc', 0.01, 'linear');			addAnimationByPrefix('deimos', 'shoot', 'deimous shoot', 20, false);
			--makeGraphic('shotflashDeimos', 400, 300, 'cccccc');
			--setBlendMode('shotflashDeimos', 'screen');
		
		--makeLuaSprite('shotflashSanford', nil, 1370, 0);
			--doTweenColor('shotflashDeimosColorTween', 'shotflashSanford', 'cccccc', 0.01, 'linear');			addAnimationByPrefix('sanford', 'shoot', 'stanford shoot', 20, false);
			--makeGraphic('shotflashSanford', 400, 300, 'cccccc');
			--setBlendMode('shotflashSanford', 'screen');
	end
			
	makeAnimatedLuaSprite('tiky', 'nevada/tikyfall', 340, -50); -- tricky falling off the speaker
		addAnimationByPrefix('tiky', 'skidaddle', 'fall', 24, true); --the animation
	
    makeLuaSprite('stage', 'nevada/nevada_stage', -400, -220); --the stage where everybody sings!
		addLuaSprite('stage', false);
			setProperty('stage.scale.x', getProperty('stage.scale.x') + 0.6);
			setProperty('stage.scale.y', getProperty('stage.scale.y') + 0.8);
			
	makeAnimatedLuaSprite('speaker', 'nevada/speakers', 185, 460); --the speakers that tricky sings on, and later falls off of
		addAnimationByPrefix('speaker', 'idle', 'GF Dancing Beat', 24, true);
			setLuaSpriteScrollFactor('speaker', 1, 1);
	
	makeAnimatedLuaSprite('hotdog', 'nevada/gfhotdog', 2000, 500); --creating gf walking in with a hotdog
		addAnimationByPrefix('hotdog', 'enter', 'girlfriend walk', 8, true);
		addAnimationByPrefix('hotdog', 'idle', 'girlfriend dance idle', 24, true);
			setProperty('hotdog.scale.x', getProperty('hotdog.scale.x') + 0.56);
			setProperty('hotdog.scale.y', getProperty('hotdog.scale.y') + 0.56);
			setLuaSpriteScrollFactor('hotdog', 1, 1);
	
	makeLuaSprite('yeet', 'nevada/cya', 220, 220); --creating the gf sprite that flies away
		setProperty('yeet.scale.x', getProperty('yeet.scale.x') + 0.5);
		setProperty('yeet.scale.y', getProperty('yeet.scale.y') + 0.5);
			
	makeLuaSprite('shot', 'nevada/tracer', 2000, 640); --da Bullet
		addLuaSprite('shot', true); --creating the bullet offscreen for later
		
	if not lowQuality then
		makeLuaSprite('foreground', 'nevada/nevada_foreground', -970, -215); --the foreground, aka tent with the word MADNESS on it
			addLuaSprite('foreground', true);
				setProperty('foreground.scale.x', getProperty('foreground.scale.x') + 0.75);
				setProperty('foreground.scale.y', getProperty('foreground.scale.y') + 0.8);
	
		makeAnimatedLuaSprite('laserdot', 'nevada/laser', 520, 210); --x 520 y 210
			addAnimationByPrefix('laserdot', 'enter', 'laser idle', 24, false);
			addAnimationByPrefix('laserdot', 'bop', 'laser bop', 24, true);
			setProperty('laserdot.scale.x', getProperty('laserdot.scale.x') + 0.6);
			setProperty('laserdot.scale.y', getProperty('laserdot.scale.y') + 0.6);
	end	
			
	if difficulty == 2 then --don't need hellclown if the difficulty isn't "fucked"
		if not lowQuality then
			makeAnimatedLuaSprite('hellclown', 'nevada/hellclown', 180, 1500); --hellclown,
			makeAnimatedLuaSprite('lefthand', 'nevada/hand', -300, 2050); --his left hand,
			makeAnimatedLuaSprite('righthand', 'nevada/hand', 1000, 2050); --and his right hand.
			
				addAnimationByPrefix('hellclown', 'idle', 'hellclown idle', 12, true);
				addAnimationByPrefix('lefthand', 'idle', 'hand idle', 14, true);
				addAnimationByPrefix('righthand', 'idle', 'hand idle', 14, true);
				
				setProperty('hellclown.scale.x', getProperty('hellclown.scale.x') + 0.7);
				setProperty('hellclown.scale.y', getProperty('hellclown.scale.y') + 0.7);
				setLuaSpriteScrollFactor('hellclown', 1, 1);
				
				setProperty('lefthand.scale.x', getProperty('lefthand.scale.x') + 0.9);
				setProperty('lefthand.scale.y', getProperty('lefthand.scale.y') + 0.9);
				setLuaSpriteScrollFactor('lefthand', 1, 1);
				
				setProperty('righthand.scale.x', getProperty('righthand.scale.x') + 0.9);
				setProperty('righthand.scale.y', getProperty('righthand.scale.y') + 0.9);
				setLuaSpriteScrollFactor('righthand', 1, 1);
		end				
		if not hideHud then
			if downscroll then
				makeAnimatedLuaSprite('lever', 'nevada/gremlin', 390, 40); --the health draining lever
				setProperty('lever.flipY', true);
			else
				makeAnimatedLuaSprite('lever', 'nevada/gremlin', 390, 410);
			end
			setProperty('lever.scale.x', getProperty('lever.scale.x') - 0.3);
			setProperty('lever.scale.y', getProperty('lever.scale.y') - 0.3);
			setObjectCamera('lever', 'hud');
			addAnimationByPrefix('lever', 'enter', 'enter', 21, false);
			addAnimationByPrefix('lever', 'idle', 'idle', 18, true);
			addAnimationByIndices('lever', 'exit', 'enter', '16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0', 18);
			
			setLuaSpriteScrollFactor('lever', 0, 0);
		end
	elseif difficulty == 1 then --adds the climbing enemies for "hard" difficulty
		makeAnimatedLuaSprite('agent', 'nevada/agent', 370, 1000);
			addAnimationByPrefix('agent', 'agentdie', 'poo poo agent', 12, false);
			setProperty('agent.scale.x', getProperty('agent.scale.x') + 0.2);
			setProperty('agent.scale.y', getProperty('agent.scale.y') + 0.2);
		
		makeAnimatedLuaSprite('engineer', 'nevada/engineer', 910, 1000);
			addAnimationByPrefix('engineer', 'engineerdie', 'engineer idle', 12, false);
			setProperty('engineer.scale.x', getProperty('engineer.scale.x') + 0.2);
			setProperty('engineer.scale.y', getProperty('engineer.scale.y') + 0.2);
		
		makeAnimatedLuaSprite('grunt', 'nevada/grunt', -150, 1000);
			addAnimationByPrefix('grunt', 'gruntdie', 'grunt is dead :)', 12, false);
			setProperty('grunt.scale.x', getProperty('grunt.scale.x') + 0.2);
			setProperty('grunt.scale.y', getProperty('grunt.scale.y') + 0.2);
	end
	--a bunch of precaching to brace for lag
	
	if difficulty == 2 then
		precacheImage('nevada/notes/EX Note');
		precacheImage('nevada/gremlin');
		if not lowQuality then
			precacheImage('nevada/hellclown');
			precacheImage('nevada/hand');
		end
	elseif difficulty == 1 then
		if not lowQuality then
			precacheImage('nevada/grunt');
			precacheImage('nevada/engineer');
			precacheImage('nevada/agent');
		end
		precacheImage('nevada/notes/Hell Note');
	end
	
	if not lowQuality then
		precacheImage('nevada/cya');
		precacheImage('nevada/laser');
		precacheImage('nevada/stanford');
		precacheImage('nevada/deimous');
		precacheImage('nevada/tiky');
		precacheImage('nevada/speakers');
	end
	precacheImage('nevada/notes/Bullet_Note');
	addCharacterToList('hank-scared', 'dad'); 
	addCharacterToList('acceleranttricky', 'gf');
	addCharacterToList('gf-handsup', 'gf');
	precacheSound('hankshoot');
	precacheSound('hankreadyupsound');
	precacheSound('Screamfade');
	if difficulty == 2 then
		precacheSound('hellclown');
	end
end

function onStartCountdown()
	setProperty(camX, 350);
				
	addLuaSprite('hellclown', false); --hellclown appears
	addLuaSprite('lefthand', false);
	addLuaSprite('righthand', false);
	setProperty('hellclown.visible', false);
	setProperty('lefthand.visible', false);
	setProperty('righthand.visible', false);
	-- countdown started, duh
	-- return Function_Stop if you want to stop the countdown from happening (Can be used to trigger dialogues and stuff! You can trigger the countdown with startCountdown())
	return Function_Continue;
end