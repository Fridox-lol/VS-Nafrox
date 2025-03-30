package funkin.menus;

import funkin.editors.charter.Charter;
import funkin.backend.scripting.events.MenuChangeEvent;
import funkin.options.OptionsMenu;
import funkin.backend.scripting.events.PauseCreationEvent;
import funkin.backend.scripting.events.NameEvent;
import funkin.backend.scripting.Script;
import flixel.sound.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import funkin.options.keybinds.KeybindsOptions;
import funkin.menus.StoryMenuState;
import funkin.backend.system.Conductor;
import funkin.backend.utils.FunkinParentDisabler;
import flixel.math.FlxPoint;



class PauseSubState extends MusicBeatSubstate
{
	public static var script:String = "";

	var grpMenuShit:FlxTypedGroup<Alphabet>;

	var menuItems:Array<String> = ['Resume', 'Reset', 'Escape', "Exit to charter"];
	var curSelected:Int = 0;

	var pauseMusic:FlxSound;

	public var pauseScript:Script;

	var textThing:FlxText;
	var textThing2:FlxText;
	var textThing3:FlxText;

	//tweens
	var tween1:FlxTween;
	var tween2:FlxTween;
	var tween3:FlxTween;
	var tween4:FlxTween;
	var tween5:FlxTween;
	var tween6:FlxTween;
	var tween7:FlxTween;


	var clickable:Bool = true;
	var numTime:Int = 0;
	public var statico:FlxSprite;

	public var game:PlayState = PlayState.instance; // shortcut

	private var __cancelDefault:Bool = false;

	public function new(x:Float = 0, y:Float = 0) {
		super();
	}

	var parentDisabler:FunkinParentDisabler;
	override function create()
	{
		super.create();

		if (menuItems.contains("Exit to charter") && !PlayState.chartingMode)
			menuItems.remove("Exit to charter");

		add(parentDisabler = new FunkinParentDisabler());

		textThing = new FlxText(630, 340, 0, 'I forbid you to leave.'); //edgy
		textThing.scale.set(2.8, 2.8);
		textThing.visible = false;
		add(textThing);

		textThing2 = new FlxText(630, 340, 0, 'STOP TRYING!'); //edgy 2
		textThing2.scale.set(2.8, 2.8);
		textThing2.visible = false;
		add(textThing2);

		statico = new FlxSprite(0,0);
		statico.frames = Paths.getFrames('menus/nafroxmenu/story/scaryredstatic');
		statico.animation.addByPrefix('idle', 'scaryredstatic' , 24);
		statico.animation.play('idle');
		statico.alpha = 0.5;
		statico.visible = false;
		add(statico);


		pauseScript = Script.create(Paths.script(script));
		pauseScript.setParent(this);
		pauseScript.load();

		var event = EventManager.get(PauseCreationEvent).recycle('breakfast', menuItems);
		pauseScript.call('create', [event]);

		menuItems = event.options;


		pauseMusic = FlxG.sound.load(Paths.music(event.music), 0, true);
		pauseMusic.persist = false;
		pauseMusic.group = FlxG.sound.defaultMusicGroup;
		pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));

		if (__cancelDefault = event.cancelled) return;

		var bg:FlxSprite = new FlxSprite().makeSolid(FlxG.width + 100, FlxG.height + 100, FlxColor.BLACK);
		bg.updateHitbox();
		bg.alpha = 0;
		bg.screenCenter();
		bg.scrollFactor.set();
		add(bg);

		var levelInfo:FlxText = new FlxText(20, 15, 0, PlayState.SONG.meta.displayName, 32);
		var levelDifficulty:FlxText = new FlxText(20, 15, 0, PlayState.difficulty.toUpperCase(), 32);
		var deathCounter:FlxText = new FlxText(20, 15, 0, "Died: " + PlayState.deathCounter, 32);
		var multiplayerText:FlxText = new FlxText(20, 15, 0, PlayState.opponentMode ? 'OPPONENT MODE' : (PlayState.coopMode ? 'CO-OP MODE' : ''), 32);

		for(k=>label in [levelInfo, levelDifficulty, deathCounter, multiplayerText]) {
			label.scrollFactor.set();
			//label.setFormat(Paths.font('vcr.ttf'), 32); lmao
			label.updateHitbox();
			label.alpha = 0;
			label.x = FlxG.width - (label.width + 20);
			label.y = 15 + (32 * k);
			FlxTween.tween(label, {alpha: 1, y: label.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3 * (k+1)});
			add(label);
		}

		FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});

		grpMenuShit = new FlxTypedGroup<Alphabet>();
		add(grpMenuShit);

		for (i in 0...menuItems.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpMenuShit.add(songText);
		}

		changeSelection();

		camera = new FlxCamera();
		camera.bgColor = 0;
		FlxG.cameras.add(camera, false);

		pauseScript.call("postCreate");

		game.updateDiscordPresence();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (pauseMusic.volume < 0.5)
			pauseMusic.volume += 0.01 * elapsed;

		pauseScript.call("update", [elapsed]);

		if (__cancelDefault) return;

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;

		if (upP)
			changeSelection(-1);
		if (downP)
			changeSelection(1);
		if (accepted)
			selectOption();
	}


	function jesus() { //ALL IN ONE FUNCTION BABYYYYY
		textThing.visible = false;
		textThing.alpha = 1;
		textThing.y = 340;
		statico.visible = false;
		statico.alpha = 0.5;
		clickable = true;

		textThing2.visible = false;
		textThing2.alpha = 1;
		textThing2.y = 340;
	}
		//ctrl c ctrl v for the win baby


	public function selectOption() {
		var event = EventManager.get(NameEvent).recycle(menuItems[curSelected]);
		pauseScript.call("onSelectOption", [event]);

		if (event.cancelled) return;

		var daSelected:String = event.name;

		switch (daSelected)
		{
			case "Resume":
				close();
			case "Reset":
				parentDisabler.reset();
				game.registerSmoothTransition();
				FlxG.resetState();
			case "Exit to charter":
				FlxG.switchState(new funkin.editors.charter.Charter(PlayState.SONG.meta.name, PlayState.difficulty, false));
			case "Escape":
				if (PlayState.chartingMode && Charter.undos.unsaved)
					game.saveWarn(false);
				else {
					PlayState.resetSongInfos();
					if (Charter.instance != null) Charter.instance.__clearStatics();

					if (clickable == true && numTime <= 20)
						{
					clickable = false;
					numTime = numTime + 1;
					FlxG.camera.shake(0.001, 0.5, null, true);
					FlxG.sound.play(Paths.sound('menu/crash'));
					textThing.visible = true;
					statico.visible = true;
					tween1 = FlxTween.tween(textThing, {y: 350}, 0.3, {ease: FlxEase.quadInOut});
					tween2 = FlxTween.tween(textThing, {alpha: 0}, 0.3, {ease: FlxEase.quadInOut});
					tween3 = FlxTween.tween(statico, {alpha: 0}, 0.3, {ease: FlxEase.quadInOut});
					new FlxTimer().start(0.4, function(tmr:FlxTimer)
						{
							jesus();
						});
					}
					else if (clickable == true && numTime >= 20)
						{
							clickable = false;
							numTime = numTime + 1;
							FlxG.camera.shake(0.001, 0.5, null, true);
							FlxG.sound.play(Paths.sound('menu/crash'));
							textThing2.visible = true;
							statico.visible = true;
							tween4 = FlxTween.tween(textThing2, {y: 350}, 0.3, {ease: FlxEase.quadInOut});
							tween5 = FlxTween.tween(textThing2, {alpha: 0}, 0.3, {ease: FlxEase.quadInOut});
							tween3 = FlxTween.tween(statico, {alpha: 0}, 0.3, {ease: FlxEase.quadInOut});
							new FlxTimer().start(0.4, function(tmr:FlxTimer)
								{
									jesus();
								});
						}

					// prevents certain notes to disappear early when exiting  - Nex
					// game.strumLines.forEachAlive(function(grp) grp.notes.__forcedSongPos = Conductor.songPosition);

					// CoolUtil.playMenuSong();
					// FlxG.switchState(PlayState.isStoryMode ? new StoryMenuState() : new FreeplayState());
				}

		}
	}
	override function destroy()
	{
		if(FlxG.cameras.list.contains(camera))
			FlxG.cameras.remove(camera, true);
		pauseScript.call("destroy");
		pauseScript.destroy();

		if (pauseMusic != null)
			@:privateAccess {
				FlxG.sound.destroySound(pauseMusic);
			}

		super.destroy();
	}

	function changeSelection(change:Int = 0):Void
	{
		var event = EventManager.get(MenuChangeEvent).recycle(curSelected, FlxMath.wrap(curSelected + change, 0, menuItems.length-1), change, change != 0);
		pauseScript.call("onChangeItem", [event]);
		if (event.cancelled) return;

		curSelected = event.value;

		for (i=>item in grpMenuShit.members)
		{
			item.targetY = i - curSelected;

			if (item.targetY == 0)
				item.alpha = 1;
			else
				item.alpha = 0.6;
		}
	}
}
