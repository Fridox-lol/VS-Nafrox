package funkin.menus;

import haxe.Json;
import funkin.backend.FunkinText;
import funkin.menus.credits.CreditsMain;
import flixel.FlxState;
import flixel.effects.FlxFlicker;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import lime.app.Application;
import funkin.backend.scripting.events.*;
import flixel.input.keyboard.FlxKey;
import funkin.game.PlayState;
import funkin.menus.ModSwitchMenu;
import funkin.backend.scripting.ModState;

import funkin.options.OptionsMenu;

using StringTools;


class MainMenuState extends MusicBeatState
{

	var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;

	var optionShit:Array<String> = CoolUtil.coolTextFile(Paths.txt("config/menuItems"));

	var bg:FlxSprite;
	var weirdparticlelmao:FlxSprite;
	var tween0:FlxTween;
	var tween1:FlxTween;
	var tween2:FlxTween;
	var tween3:FlxTween;
	var tween4:FlxTween;
	var tween5:FlxTween;
	var tween6:FlxTween;
	var tweenJesus:FlxTween;
	var tweenJesus2:FlxTween;
	var camFollow:FlxObject;
	var versionText:FunkinText;
	var glow:FlxSprite;
	var story:FlxSprite;
	var soundplayable1:Bool = true;
	var soundplayable0:Bool = true;
	var tweenter:FlxTween;
	var freeplay:FlxSprite;
	var freeplayLocked:FlxSprite;
	var soundplayable2:Bool = true;
	var credits:FlxSprite;
	var soundplayable3:Bool = true;
	var options:FlxSprite;
	var soundplayable4:Bool = true;
	var trophy:FlxSprite;
	var cursor:FlxSprite;
	var typin:String = '';
	var codeClearTimer:Float = 5;
	var notReady:FlxText;
	var bye:FlxTimer;
	var deadboyfriend:FlxSprite;
	


	public var canAccessDebugMenus:Bool = false;

	override function create()
	{
		super.create();
		
		trace(FlxG.save.data.lastSongPlayed);

		//the custom cursor
		FlxG.mouse.visible = true;
		var cursor:FlxSprite;
		cursor = new FlxSprite();
		cursor.makeGraphic(15, 15, FlxColor.TRANSPARENT);
		cursor.loadGraphic(Paths.image('menus/cursor'));
		FlxG.mouse.load(cursor.pixels);
		//THIS DOESNT EVEN WORK LMAOOOO
		
		DiscordUtil.call("onMenuLoaded", ["Menu          1"]);
	
		CoolUtil.playMenuSong();


		glow = new FlxSprite(0, -100).loadGraphic(Paths.image('menus/nafroxmenu/glow'));

		glow.scale.set(1, 1);
		glow.screenCenter();
		add(glow);


		weirdparticlelmao = new FlxSprite(0, -200);
		weirdparticlelmao.frames = Paths.getFrames('menus/nafroxmenu/nafroxmainmenu_static');
		weirdparticlelmao.animation.addByPrefix('idle', 'staticshit', 24);
		weirdparticlelmao.animation.play('idle');
		add(weirdparticlelmao);

		bg = new FlxSprite(-80).loadAnimatedGraphic(Paths.image('menus/nafroxmenu/staticpieces'));
		bg.animation.addByPrefix('idle', 'shitmenu0', 24);
		bg.animation.play('idle');
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		for(bg in [bg]) {
			bg.scale.set(1, 1);
			bg.updateHitbox();
			bg.screenCenter();
			bg.scrollFactor.set(0.4, 0.4);
			bg.antialiasing = true;
		}

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		for (i=>option in optionShit)
		{
/* 			var menuItem:FlxSprite = new FlxSprite((i * 20), 60 + (i * 160));
			menuItem.frames = Paths.getFrames('menus/mainmenu/${option}');
			menuItem.animation.addByPrefix('idle', option + " basic", 24);
			menuItem.animation.addByPrefix('selected', option + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.screenCenter(X);
			menuItems.add(menuItem);
			menuItem.scrollFactor.set();
			menuItem.antialiasing = true;
 */
 
 			deadboyfriend = new FlxSprite(0, 0);
 			deadboyfriend.frames = Paths.getFrames('menus/nafroxmenu/bfDead');
 			deadboyfriend.animation.addByPrefix('idle', 'bfdead0', 24);
 			deadboyfriend.animation.play('idle');
			deadboyfriend.screenCenter();
 			deadboyfriend.y = deadboyfriend.y - 170;
 			deadboyfriend.angle = -4;
 			deadboyfriend.scrollFactor.set(0.3, 0.3);
 			deadboyfriend.alpha = 0.5;
 			tweenJesus = FlxTween.tween(deadboyfriend, {y: 170}, 3.5, {ease: FlxEase.quadInOut, type: PINGPONG});
 			tweenJesus2 = FlxTween.tween(deadboyfriend, {angle: 4}, 3.5, {ease: FlxEase.quadInOut, type: PINGPONG});
 			deadboyfriend.antialiasing = true;

			story = new FlxSprite(0, 0);
			story.frames = Paths.getFrames('menus/nafroxmenu/storyshit');
			story.animation.addByPrefix('idle', 'storymode', 24);
			story.animation.play('idle');
			story.screenCenter();
			story.scrollFactor.set(0.7, 0.7);
			tween1 = FlxTween.tween(story, {y: 390}, 3, {ease: FlxEase.quadInOut, type: PINGPONG});
			add(story);
			story.antialiasing = true;

			freeplay = new FlxSprite(720, 0);
			freeplay.frames = Paths.getFrames('menus/nafroxmenu/freeplay');
			freeplay.animation.addByPrefix('idle', 'freeplay', 24);
			freeplay.animation.play('idle');
			freeplay.scrollFactor.set(0.3, 0.3);
			tween2 = FlxTween.tween(freeplay, {y: 40}, 3.5, {ease: FlxEase.quadInOut, type: PINGPONG});
			add(freeplay);
			freeplay.antialiasing = true;

			freeplayLocked = new FlxSprite(720, 0);
			freeplayLocked.frames = Paths.getFrames('menus/nafroxmenu/freeplayLocked');
			freeplayLocked.animation.addByPrefix('idle', 'freeplayLocked', 24);
			freeplayLocked.animation.play('idle');
			freeplayLocked.scrollFactor.set(0.3, 0.3);
			tween0 = FlxTween.tween(freeplayLocked, {y: 40}, 3.5, {ease: FlxEase.quadInOut, type: PINGPONG});
			add(freeplayLocked);
			freeplayLocked.antialiasing = true;

			if (!FlxG.save.data.FIRSTTIMEBEATINGWEEK){
				freeplay.y = -2000;
				tween2 = FlxTween.tween(freeplay, {y: -2010}, 3.5, {ease: FlxEase.quadInOut, type: PINGPONG});
			}else{
				freeplayLocked.y = -2000;
				tween0 = FlxTween.tween(freeplayLocked, {y: -2010}, 3.5, {ease: FlxEase.quadInOut, type: PINGPONG});
			}
			

			credits = new FlxSprite(50, 500).loadGraphic(Paths.image('menus/nafroxmenu/credits'));
			tween3 = FlxTween.tween(credits, {y: 530}, 3.2, {ease: FlxEase.quadInOut, type: PINGPONG});
			credits.scrollFactor.set(0.4, 0.4);
			add(credits);
			credits.antialiasing = true;

			options = new FlxSprite(90, 100).loadGraphic(Paths.image('menus/nafroxmenu/settings'));
			tween4 = FlxTween.tween(options, {y: 130}, 2.6, {ease: FlxEase.quadInOut, type: PINGPONG});
			options.scrollFactor.set(0.4, 0.4);
			add(options);
			options.antialiasing = true;

			trophy = new FlxSprite(1000, 470);
			trophy.frames = Paths.getFrames('menus/nafroxmenu/nafrox100trophy');
			trophy.animation.addByPrefix('idle', 'trophy', 24);
			trophy.animation.play('idle');
			trophy.angle = -2;
			tween5 = FlxTween.tween(trophy, {y: 500}, 3.2, {ease: FlxEase.quadInOut, type: PINGPONG});
			tween6 = FlxTween.tween(trophy, {angle: 2}, 2.2, {ease: FlxEase.quadInOut, type: PINGPONG});
			trophy.scrollFactor.set(1, 1);
			add(trophy);
			trophy.antialiasing = true;

			if (!FlxG.save.data.REMIXBEATEN){
				trophy.alpha = 0;
			}else{
				trophy.alpha = 0.45;
			}
		}



		if (FlxG.save.data.lastSongPlayed == 'death')
		{
		add(deadboyfriend);
		}


		notReady = new FlxText(630, 340, 0, "There's unfinished business somewhere.");
		notReady.scale.set(3.2, 3.2);
		notReady.alpha = 0;
		notReady.screenCenter();
		notReady.color = FlxColor.RED;
		add(notReady);
	}

	var selectedSomethin:Bool = false;
	var forceCenterX:Bool = true;



	override function update(elapsed:Float)
	{
		FlxG.camera.scroll.x = FlxMath.lerp(FlxG.camera.scroll.x, (FlxG.mouse.screenX-(FlxG.width/2)) * 0.015, (1/30)*240*elapsed);
		FlxG.camera.scroll.y = FlxMath.lerp(FlxG.camera.scroll.y, (FlxG.mouse.screenY-6-(FlxG.height/2)) * 0.015, (1/30)*240*elapsed);

		if (FlxG.keys.firstJustPressed() != FlxKey.NONE)
			codePress(FlxG.keys.firstJustPressed());
			
	
		updateCode(elapsed);

		//the current line is for debug purposes, comment after the mod is playtested -Lori
	
/* 		if (FlxG.keys.justPressed.FOUR) {
			FlxG.switchState(new ModState('weekWonState'));
		} */

		if (FlxG.sound.music.volume < 0.8)
			FlxG.sound.music.volume += 0.5 * elapsed;

		if (!selectedSomethin)
		{
			if (canAccessDebugMenus) {
				if (FlxG.keys.justPressed.SEVEN) {
					persistentUpdate = false;
					persistentDraw = true;
					openSubState(new funkin.editors.EditorPicker());
				}

				/*
				if (FlxG.keys.justPressed.SEVEN)
					FlxG.switchState(new funkin.desktop.DesktopMain());
				if (FlxG.keys.justPressed.EIGHT) {
					CoolUtil.safeSaveFile("chart.json", Json.stringify(funkin.backend.chart.Chart.parse("dadbattle", "hard")));
				}
				*/
			}


			//fridox you are a great person thx for letting me steal ur sn code :D
			//STORY
			if (FlxG.mouse.overlaps(story))
				{
					if (soundplayable1)
						{
							soundplayable1 = false;
							FlxG.sound.play(Paths.sound('menu/scroll'));
							story.scale.set(1.1, 1.1);
						}
				}
				else
					{
						soundplayable1 = true;
						story.scale.set(1, 1);
					}
		
					if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(story))
					{
						selectedSomethin = true;
						FlxG.switchState(new StoryMenuState());
					}

			//FREEPLAY
			if (FlxG.mouse.overlaps(freeplay))
				{
					if (soundplayable2)
						{
							soundplayable2 = false;
							FlxG.sound.play(Paths.sound('menu/scroll'));
							freeplay.scale.set(1.1, 1.1);
						}
				}
				else
					{
						soundplayable2 = true;
						freeplay.scale.set(1, 1);
					}
		
					if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(freeplay))
					{
						selectedSomethin = true;
						FlxG.switchState(new FreeplayState());
					}

			//LOCKED FREEPLAY
			if (FlxG.mouse.overlaps(freeplayLocked))
					{
							if (soundplayable0)
							{
								soundplayable0 = false;
								FlxG.sound.play(Paths.sound('menu/scroll'));
								freeplayLocked.scale.set(1.1, 1.1);
							}
					}
					else
						{
							soundplayable0 = true;
							freeplayLocked.scale.set(1, 1);
						}
				
						if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(freeplayLocked))
						{
							if(FlxG.random.int(0, 50) == 50) { //fridox suggested me this :sob:
								FlxG.sound.play(Paths.sound('menu/nuhUh_1'));
							}else{
								FlxG.sound.play(Paths.sound('menu/nuhUh_0'));
							}
							FlxG.sound.play(Paths.sound('menu/crash'));
							FlxG.camera.shake(0.01, 0.1, null, true);

							notReady.alpha = 1;
							bye = new FlxTimer().start(0.3, function(tmr:FlxTimer)
								{
									FlxTween.tween(notReady, {alpha: 0}, 0.3);
								});
						}


			//CREDITS
			if (FlxG.mouse.overlaps(credits))
				{
					if (soundplayable3)
						{
							soundplayable3 = false;
							FlxG.sound.play(Paths.sound('menu/scroll'));
							credits.scale.set(1.1, 1.1);
						}
				}
				else
					{
						soundplayable3 = true;
						credits.scale.set(1, 1);
					}
		
					if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(credits))
					{
						selectedSomethin = true;
						FlxG.switchState(new CreditsMain());
					}

			//OPTIONS	
			if (FlxG.mouse.overlaps(options))
				{
					if (soundplayable4)
						{
							soundplayable4 = false;
							FlxG.sound.play(Paths.sound('menu/scroll'));
							options.scale.set(1.1, 1.1);
						}
				}
				else
					{
						soundplayable4 = true;
						options.scale.set(1, 1);
					}
		
					if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(options))
					{
						selectedSomethin = true;
						FlxG.switchState(new OptionsMenu());
					}

			if (controls.BACK)
				FlxG.switchState(new TitleState());

			#if MOD_SUPPORT
			if (controls.SWITCHMOD) {
				openSubState(new ModSwitchMenu());
				persistentUpdate = false;
				persistentDraw = true;
			}
			#end
//pressing enter wouldve fuckin loaded story mode

/* 			if (controls.ACCEPT)
			{
				selectItem();
			} */

		}
		// i kept this in but tbh i dont even know if it does anything lmfao
		super.update(elapsed);

		if (forceCenterX)
		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.screenCenter(X);
		});
	}

	public override function switchTo(nextState:FlxState):Bool {
		try {
			menuItems.forEach(function(spr:FlxSprite) {
				FlxTween.tween(spr, {alpha: 0}, 0.5, {ease: FlxEase.quintOut});
			});
		}
		return super.switchTo(nextState);
	}

	function selectItem() {
		selectedSomethin = true;
		CoolUtil.playMenuSFX(CONFIRM);

			var daChoice:String = optionShit[curSelected];

			var event = event("onSelectItem", EventManager.get(NameEvent).recycle(daChoice));
			if (event.cancelled) return;
			switch (daChoice)
			{
				case 'story mode': FlxG.switchState(new StoryMenuState());
				case 'freeplay': FlxG.switchState(new FreeplayState());
				case 'donate', 'credits': FlxG.switchState(new CreditsMain());  // kept donate for not breaking scripts, if you dont want donate to bring you to the credits menu, thats easy softcodable  - Nex
				case 'options': FlxG.switchState(new OptionsMenu());
			}
	}


	function codePress(pressedKey:FlxKey)
		{
			codeClearTimer = 2; // 1 second to press next key in the code
		
			var daKey = CoolUtil.keyToString(pressedKey);
			typin += daKey;
			//FlxG.sound.play(Paths.sound('menu/codeInput'));
		
			trace('key pressed: ' + daKey);
			trace('cur code: ' + typin);
		
			switch(typin)
			{
				case '01052009':
					PlayState.loadSong("test", "normal");
					FlxG.switchState(new PlayState());
					FlxG.sound.play(Paths.sound('menu/codeAccept'));
			}
		}

		function updateCode(idk:Float)
			{
				if(codeClearTimer > 0) codeClearTimer -= idk;
				if(codeClearTimer <= 0) typin = '';
				if(codeClearTimer < 0) codeClearTimer = 0;
			}
		
}
