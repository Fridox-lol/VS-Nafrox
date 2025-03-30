//i genuinely have no idea what i'm doing

package funkin.menus;

import funkin.savedata.FunkinSave;
import haxe.io.Path;
import funkin.backend.scripting.events.*;
import flixel.util.FlxTimer;
import flixel.math.FlxPoint;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import funkin.backend.FunkinText;
import haxe.xml.Access;
import flixel.text.FlxText;

class StoryMenuState extends MusicBeatState {
	//da stuff
	public var characters:Map<String, MenuCharacter> = [];
	public var weeks:Array<WeekData> = [];

	//the important things
	public var scoreText:FlxText;
	public var tracklist:FlxText;
	public var weekTitle:FlxText;
	public var weekn:FlxSprite;
	public var tweeny:FlxTween;

	public var curDifficulty:Int = 0;
	public var curWeek:Int = 0;

	//menu shit
	public var difficultySprites:Map<String, FlxSprite> = [];
	public var weekBG:FlxSprite;
	public var leftArrow:FlxSprite;
	public var rightArrow:FlxSprite;
	public var blackBar:FlxSprite;
	public var weekBgButForReal:FlxSprite;
	public var nafroxShitLol:FlxSprite;
	public var diffSprite:FlxSprite;
	public var scarystatic:FlxSprite;
	public var blackboxatthebottom:FlxSprite;

	//tweens for selection
	public var tweenbitch1:FlxTween;
	public var tweenbitch2:FlxTween;
	public var tweenbitch3:FlxTween;
	public var tweenbitch4:FlxTween;
	public var tweenbitch5:FlxTween;
	public var tweenbitch6:FlxTween;
	public var tweenbitch7:FlxTween;
	public var tweenbitch8:FlxTween;

	//other misc stuff
	public var lerpScore:Float = 0;
	public var intendedScore:Int = 0;

	public var canSelect:Bool = true;

	public var weekSprites:FlxTypedGroup<MenuItem>;
	public var characterSprites:FlxTypedGroup<MenuCharacterSprite>;

	//public var charFrames:Map<String, FlxFramesCollection> = [];

	public override function create() {
		super.create();
		loadXMLs();
		persistentUpdate = persistentDraw = true;


		FlxG.mouse.visible = false;
		
		// WEEK INFO
		blackBar = new FlxSprite(0, 0).makeSolid(FlxG.width, 56, 0xFFFFFFFF);
		blackBar.color = 0xFF000000;
		blackBar.updateHitbox();
		blackBar.alpha = 0; //cant remove this or game crashes

		nafroxShitLol = new FlxSprite(-370, -30);
		nafroxShitLol.frames = Paths.getFrames('menus/nafroxmenu/story/nafrox_week');
		nafroxShitLol.animation.addByPrefix('idle', 'nafroxmenu_normal', 24);
		nafroxShitLol.animation.addByPrefix('select', 'nafroxmenu_select', 24);
		nafroxShitLol.animation.play('idle');
		nafroxShitLol.antialiasing = true;
		add(nafroxShitLol);

		weekBgButForReal = new FlxSprite(470, -50).loadGraphic(Paths.image('menus/nafroxmenu/story/storyselect')); //uhhhhhhhhhhhh
		weekBgButForReal.antialiasing = true;
		add(weekBgButForReal);

		scoreText = new FunkinText(950, 100, 0, "SCORE: -", 36);
		scoreText.setFormat(Paths.font("vcr.ttf"), 32);

		weekTitle = new FlxText(-250, 670, FlxG.width - 20, "", 232);
		weekTitle.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);
		weekTitle.color = 0xFFFF0000;
		weekTitle.alpha = 0.7;

		weekn = new FlxSprite(790, 0).loadGraphic(Paths.image('menus/nafroxmenu/story/weekn')); //no it's not that type of n, you morons :D
		weekn.screenCenter(Y); //we do indeed love screen centering
		tweeny = FlxTween.tween(weekn, {y: 340}, 3.1, {ease: FlxEase.quadInOut, type: PINGPONG});
		weekn.antialiasing = true;
		add(weekn);

		weekBG = new FlxSprite(0, 56).makeSolid(FlxG.width, 400, 0xFFFFFFFF);
		weekBG.color = 0xFF000000;
		weekBG.updateHitbox();
		weekBG.alpha = 0; //deleting it causes the game to crash so whoopty freekin doo

		weekSprites = new FlxTypedGroup<MenuItem>();

		// DUMBASS ARROWS
		var assets = Paths.getFrames('menus/storymenu/assets');
		var directions = ["left", "right"];

		leftArrow = new FlxSprite((FlxG.width + 400) / 2, weekBG.y + weekBG.height - 470 + 10);
		rightArrow = new FlxSprite(FlxG.width - 10, weekBG.y + weekBG.height - 470 + 10);
		for(k=>arrow in [leftArrow, rightArrow]) {
			var dir = directions[k];

			arrow.frames = assets;
			arrow.animation.addByPrefix('idle', 'arrow $dir');
			arrow.animation.addByPrefix('press', 'arrow push $dir', 24, false);
			arrow.animation.play('idle');
			arrow.antialiasing = true;
			add(arrow);
		}
		rightArrow.x -= rightArrow.width;

		tracklist = new FunkinText(866, weekBG.y + weekBG.height + 44, Std.int(((FlxG.width - 400) / 2) - 80), "TRACKS", 32);
		tracklist.alignment = CENTER;
		tracklist.color = 0xFF7F0000;

		add(weekSprites);
		for(e in [blackBar, scoreText, weekTitle, weekBG, tracklist]) {
			e.scrollFactor.set();
			add(e);
		}

		characterSprites = new FlxTypedGroup<MenuCharacterSprite>();
		for(i in 0...3) {
			characterSprites.add(new MenuCharacterSprite(i));
		}
		add(characterSprites);

		for(i=>week in weeks) {
			var spr:MenuItem = new MenuItem(-100, (i * 120) + 440, 'menus/storymenu/weeks/${week.sprite}');
			weekSprites.add(spr);
			spr.alpha = 0;

			for(e in week.difficulties) {
				var le = e.toLowerCase();
				if (difficultySprites[le] == null) {
					var diffSprite = new FlxSprite(leftArrow.x + leftArrow.width, leftArrow.y);
					diffSprite.loadAnimatedGraphic(Paths.image('menus/storymenu/difficulties/${le}'));
					diffSprite.setUnstretchedGraphicSize(Std.int(rightArrow.x - leftArrow.x - leftArrow.width), Std.int(leftArrow.height), false, 1);
					diffSprite.antialiasing = true;
					diffSprite.scrollFactor.set();
					add(diffSprite);

					difficultySprites[le] = diffSprite;
				}
			}
		}

		//spooky static so you don't see the animation looping xd
		scarystatic = new FlxSprite(0,0);
		scarystatic.frames = Paths.getFrames('menus/nafroxmenu/story/scaryredstatic');
		scarystatic.animation.addByPrefix('idle', 'scaryredstatic' , 24);
		scarystatic.animation.play('idle');
		add(scarystatic);
		scarystatic.alpha = 0;

		//black screen that kind of overlays the static
		blackboxatthebottom = new FlxSprite(0,0);
		blackboxatthebottom.makeGraphic(2763, 2763, FlxColor.BLACK); //happy fridox
		add(blackboxatthebottom);
		blackboxatthebottom.alpha = 0;


		changeWeek(0, true);

		DiscordUtil.call("onMenuLoaded", ["null"]);

		if (FlxG.save.data.lastSongPlayed == 'death')
		{
		FlxG.sound.playMusic(Paths.music('freakyMenuBadEnding'), 0.7);
		}
		else
		{
		CoolUtil.playMenuSong();
		}
	}

	var __lastDifficultyTween:FlxTween;
	public override function update(elapsed:Float) {
		super.update(elapsed);

		lerpScore = lerp(lerpScore, intendedScore, 0.5);
		scoreText.text = 'WEEK SCORE:${Math.round(lerpScore)}';

		FlxG.camera.zoom = FlxMath.lerp(1, FlxG.camera.zoom, FlxMath.bound(1 - (elapsed * 3.125), 0, 1));


		if (canSelect) {
			if (leftArrow != null && leftArrow.exists) leftArrow.animation.play(controls.LEFT ? 'press' : 'idle');
			if (rightArrow != null && rightArrow.exists) rightArrow.animation.play(controls.RIGHT ? 'press' : 'idle');

			if (controls.BACK) {
				goBack();
			}

			changeDifficulty((controls.LEFT_P ? -1 : 0) + (controls.RIGHT_P ? 1 : 0));
			changeWeek((controls.UP_P ? -1 : 0) + (controls.DOWN_P ? 1 : 0));

			if (controls.ACCEPT)
				selectWeek();
		} else {
			for(e in [leftArrow, rightArrow])
				if (e != null && e.exists)
					e.animation.play('idle');
		}
	}

	public function goBack() {
		var event = event("onGoBack", new CancellableEvent());
		if (!event.cancelled)
			FlxG.switchState(new MainMenuState());
	}

	public function changeWeek(change:Int, force:Bool = false) {
		if (change == 0 && !force) return;

		var event = event("onChangeWeek", EventManager.get(MenuChangeEvent).recycle(curWeek, FlxMath.wrap(curWeek + change, 0, weeks.length-1), change));
		if (event.cancelled) return;
		curWeek = event.value;

		//if (!force) CoolUtil.playMenuSFX();
		for(k=>e in weekSprites.members) {
			e.targetY = k - curWeek;
		}
		tracklist.text = 'TRACKS\n\n${[for(e in weeks[curWeek].songs) if (!e.hide) e.name.toUpperCase()].join('\n')}';
		weekTitle.text = weeks[curWeek].name.getDefault("");

		for(i in 0...3)
			characterSprites.members[i].changeCharacter(characters[weeks[curWeek].chars[i]]);

		changeDifficulty(0, true);

		MemoryUtil.clearMinor();
	}

	var __oldDiffName = null;
	public function changeDifficulty(change:Int, force:Bool = false) {
		if (change == 0 && !force) return;

		var event = event("onChangeDifficulty", EventManager.get(MenuChangeEvent).recycle(curDifficulty, FlxMath.wrap(curDifficulty + change, 0, weeks[curWeek].difficulties.length-1), change));
		if (event.cancelled) return;
		curDifficulty = event.value;

		if (__oldDiffName != (__oldDiffName = weeks[curWeek].difficulties[curDifficulty].toLowerCase())) {
			for(e in difficultySprites) e.visible = false;
			FlxG.sound.play(Paths.sound('menu/difficultySelect'));

			var diffSprite = difficultySprites[__oldDiffName];
			if (diffSprite != null) {
				diffSprite.visible = true;

				if (__lastDifficultyTween != null)
					__lastDifficultyTween.cancel();
				diffSprite.alpha = 0;
				diffSprite.y = leftArrow.y - 15;

				__lastDifficultyTween = FlxTween.tween(diffSprite, {y: leftArrow.y, alpha: 1}, 0.01);
			}
		}

		intendedScore = FunkinSave.getWeekHighscore(weeks[curWeek].id, weeks[curWeek].difficulties[curDifficulty]).score;
	}

	public function loadXMLs() {
		// CoolUtil.coolTextFile(Paths.txt('freeplaySonglist'));
		var weeks:Array<String> = [];
		if (getWeeksFromSource(weeks, MODS))
			getWeeksFromSource(weeks, SOURCE);

		for(k=>weekName in weeks) {
			var week:Access = null;
			try {
				week = new Access(Xml.parse(Assets.getText(Paths.xml('weeks/weeks/$weekName'))).firstElement());
			} catch(e) {
				Logs.trace('Cannot parse week "$weekName.xml": ${Std.string(e)}`', ERROR);
			}

			if (week == null) continue;

			if (!week.has.name) {
				Logs.trace('Story Menu: Week at index ${k} has no name. Skipping...', WARNING);
				continue;
			}
			var weekObj:WeekData = {
				name: week.att.name,
				id: weekName,
				sprite: week.getAtt('sprite').getDefault(weekName),
				chars: [null, null, null],
				songs: [],
				difficulties: ['easy', 'normal', 'hard']
			};

			var diffNodes = week.nodes.difficulty;
			if (diffNodes.length > 0) {
				var diffs:Array<String> = [];
				for(e in diffNodes) {
					if (e.has.name) diffs.push(e.att.name);
				}
				if (diffs.length > 0)
					weekObj.difficulties = diffs;
			}

			if (week.has.chars) {
				for(k=>e in week.att.chars.split(",")) {
					if (e.trim() == "" || e == "none" || e == "null")
						weekObj.chars[k] = null;
					else {
						addCharacter(weekObj.chars[k] = e.trim());
					}
				}
			}
			for(k2=>song in week.nodes.song) {
				if (song == null) continue;
				try {
					var name = song.innerData.trim();
					if (name == "") {
						Logs.trace('Story Menu: Song at index ${k2} in week ${weekObj.name} has no name. Skipping...', WARNING);
						continue;
					}
					weekObj.songs.push({
						name: name,
						hide: song.getAtt('hide').getDefault('false') == "true"
					});
				} catch(e) {
					Logs.trace('Story Menu: Song at index ${k2} in week ${weekObj.name} cannot contain any other XML nodes in its name.', WARNING);
					continue;
				}
			}
			if (weekObj.songs.length <= 0) {
				Logs.trace('Story Menu: Week ${weekObj.name} has no songs. Skipping...', WARNING);
				continue;
			}
			this.weeks.push(weekObj);
		}
	}

	public function addCharacter(charName:String) {
		var char:Access = null;
		try {
			char = new Access(Xml.parse(Assets.getText(Paths.xml('weeks/characters/$charName'))).firstElement());
		} catch(e) {
			Logs.trace('Story Menu: Cannot parse character "$charName.xml": ${Std.string(e)}`', ERROR);
		}
		if (char == null) return;

		if (characters[charName] != null) return;
		var charObj:MenuCharacter = {
			spritePath: Paths.image(char.getAtt('sprite').getDefault('menus/storymenu/characters/${charName}')),
			scale: Std.parseFloat(char.getAtt('scale')).getDefault(1),
			xml: char,
			offset: FlxPoint.get(
				Std.parseFloat(char.getAtt('x')).getDefault(0),
				Std.parseFloat(char.getAtt('y')).getDefault(0)
			)
		};
		characters[charName] = charObj;
	}

	public function getWeeksFromSource(weeks:Array<String>, source:funkin.backend.assets.AssetsLibraryList.AssetSource) {
		var path:String = Paths.txt('freeplaySonglist');
		var weeksFound:Array<String> = [];
		if (Paths.assetsTree.existsSpecific(path, "TEXT", source)) {
			var trim = "";
			weeksFound = CoolUtil.coolTextFile(Paths.txt('weeks/weeks'));
		} else {
			weeksFound = [for(c in Paths.getFolderContent('data/weeks/weeks/', false, source)) if (Path.extension(c).toLowerCase() == "xml") Path.withoutExtension(c)];
		}

		if (weeksFound.length > 0) {
			for(s in weeksFound)
				weeks.push(s);
			return false;
		}
		return true;
	}

	public override function destroy() {
		super.destroy();

		for(e in characters)
			if (e != null && e.offset != null)
				e.offset.put();
	}

	public function selectWeek() {
		var event = event("onWeekSelect", EventManager.get(WeekSelectEvent).recycle(weeks[curWeek], weeks[curWeek].difficulties[curDifficulty], curWeek, curDifficulty));
		if (event.cancelled) return;

		canSelect = false;
		FlxG.sound.play(Paths.sound('menu/storyStart'));
		nafroxShitLol.animation.play('select');
		FlxG.sound.music.stop();
		tweenbitch1 = FlxTween.tween(weekTitle, {y: 1250}, 0.6, {ease: FlxEase.sineIn});
		tweenbitch2 = FlxTween.tween(scoreText, {x: 1950}, 0.6, {ease: FlxEase.sineIn});
		tweenbitch3 = FlxTween.tween(tracklist, {y: 1250}, 0.7, {ease: FlxEase.sineIn});
		tweenbitch4 = FlxTween.tween(scarystatic, {alpha: 1}, 1.1, {ease: FlxEase.sineIn});
		tweenbitch5 = FlxTween.tween(blackboxatthebottom, {alpha: 1}, 1.5, {ease: FlxEase.sineIn});
		tweenbitch6 = FlxTween.tween(weekn, {x: 449}, 0.9, {ease: FlxEase.quadInOut});

		FlxG.camera.zoom += 0.065;
		FlxG.camera.shake(0.001, 99, null, true);
		//bopDone = true;
		
		new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				FlxTween.tween(FlxG.camera, {zoom: 1.8, angle: 4}, 1.2, {ease: FlxEase.quadInOut});
				tweenbitch7 = FlxTween.tween(weekBgButForReal, {alpha: 0}, 1.8, {ease: FlxEase.quadInOut});
				tweenbitch8 = FlxTween.tween(nafroxShitLol, {alpha: 0}, 1.8, {ease: FlxEase.quadInOut});
			});

		MusicBeatState.skipTransIn = MusicBeatState.skipTransOut = true;

		//if you tell me there's a more efficient way to do these tweens, shut up im not changing it this is my first time using source

		for(char in characterSprites)
			if (char.animation.exists("confirm"))
				char.animation.play("confirm");

		PlayState.loadWeek(weeks[curWeek], weeks[curWeek].difficulties[curDifficulty]);

		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			FlxG.switchState(new PlayState());
		});
		weekSprites.members[curWeek].startFlashing();
		//weekn.startFlashing();
	}
}

typedef WeekData = {
	var name:String;  // name SHOULD NOT be used for loading week highscores, its just the name on the right side of the week, remember that next time!!  - Nex
	var id:String;  // id IS instead for saving and loading!!  - Nex
	var sprite:String;
	var chars:Array<String>;
	var songs:Array<WeekSong>;
	var difficulties:Array<String>;
}

typedef WeekSong = {
	var name:String;
	var hide:Bool;
}

typedef MenuCharacter = {
	var spritePath:String;
	var xml:Access;
	var scale:Float;
	var offset:FlxPoint;
	// var frames:FlxFramesCollection;
}

class MenuCharacterSprite extends FlxSprite
{
	public var character:String;

	var pos:Int;

	public function new(pos:Int) {
		super(0, 70);
		this.pos = pos;
		visible = false;
		antialiasing = true;
	}

	public var oldChar:MenuCharacter = null;

	public function changeCharacter(data:MenuCharacter) {
		visible = (data != null);
		if (!visible)
			return;

		if (oldChar != (oldChar = data)) {
			CoolUtil.loadAnimatedGraphic(this, data.spritePath);
			for(e in data.xml.nodes.anim) {
				if (e.getAtt("name") == "idle")
					animation.remove("idle");

				XMLUtil.addXMLAnimation(this, e);
			}
			animation.play("idle");
			scale.set(data.scale, data.scale);
			updateHitbox();
			offset.x += data.offset.x;
			offset.y += data.offset.y;

			x = (FlxG.width * 0.25) * (1 + pos) - 150;
		}
	}
}
class MenuItem extends FlxSprite
{
	public var targetY:Float = 0;

	public function new(x:Float, y:Float, path:String)
	{
		super(x, y);
		CoolUtil.loadAnimatedGraphic(this, Paths.image(path, null, true));
		screenCenter(X);
		antialiasing = true;
	}

	private var isFlashing:Bool = false;

	public function startFlashing():Void
	{
		isFlashing = true;
	}

	// if it runs at 60fps, fake framerate will be 6
	// if it runs at 144 fps, fake framerate will be like 14, and will update the graphic every 0.016666 * 3 seconds still???
	// so it runs basically every so many seconds, not dependant on framerate??
	// I'm still learning how math works thanks whoever is reading this lol
	// var fakeFramerate:Int = Math.round((1 / FlxG.elapsed) / 10);

	// hi ninja muffin
	// i have found a more efficient way
	// dw, judging by how week 7 looked you prob know how to do maths
	// goodbye
	var time:Float = 0;

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		time += elapsed;
		y = CoolUtil.fpsLerp(y, (targetY * 120) + 480, 0.17);

		if (isFlashing)
			color = (time % 0.1 > 0.05) ? FlxColor.WHITE : 0xFF6D0000;
	}
}
