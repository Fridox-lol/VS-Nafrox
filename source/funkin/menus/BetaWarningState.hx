package funkin.menus;

import flixel.util.FlxColor;
import flixel.text.FlxText;
import funkin.backend.FunkinText;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

class BetaWarningState extends MusicBeatState {
	var titleAlphabet:Alphabet;
	var disclaimer:FunkinText;
	var twen1:FlxTween;
	var twen2:FlxTween; //fridox says i dont need to specify them, idfk waht hes yapping about
	var twen3:FlxTween;
	var twen4:FlxTween;
	var tweening:Bool = true;
	var pingpongo1:FlxTween;
	var pingpongo2:FlxTween;
	var fire:FlxSprite;
	var tweenfireY:FlxTween;
	var tweenfireAlpha:FlxTween;

	var transitioning:Bool = false;
	var clickable:Bool = false;

	public override function create() {

		if (FlxG.save.data.warning) {
			goToTitle();
		}
		else {
		super.create();



		FlxG.sound.playMusic(Paths.music('warningMenuAmbience'), 0.7);

		FlxG.mouse.visible = false;


		titleAlphabet = new Alphabet(0, 1200, "WARNING", true);
		titleAlphabet.screenCenter(X);
		add(titleAlphabet);

		disclaimer = new FunkinText(16, titleAlphabet.y + titleAlphabet.height + 10, FlxG.width - 32, "", 32);
		disclaimer.alignment = CENTER;
		disclaimer.applyMarkup('This mod was made with Codename Engine, which is still in a *${Main.releaseCycle}* state. That means *majority of the features* are either *buggy* or *not finished*. If you find any bugs, please report them to the Codename Engine GitHub.\n\n This mod contains *flashing lights*. If you suffer from epilepsy, *STOP PLAYING*.\n\n Be sure to check the options menu, both for *normal* and *custom* mod options. \n\n Press ENTER to continue',
			[
				new FlxTextFormatMarkerPair(new FlxTextFormat(0xFFFF4444), "*")
			]
		);
		add(disclaimer);

		twen3 = FlxTween.tween(titleAlphabet, {y: 200}, 1.5, {ease: FlxEase.quadInOut});
		twen4 = FlxTween.tween(disclaimer, {y: 270}, 2, {ease: FlxEase.quadInOut});

		fire = new FlxSprite(0, 0);
		fire.frames = Paths.getFrames('menus/warning/fire');
		fire.animation.addByPrefix('idle', 'fireanimfin' , 24);
		fire.animation.play('idle');
		add(fire);
		fire.alpha = 0;


		new FlxTimer().start(2, function(tmr:FlxTimer)
			{
				tweening = false;
				tweenDone();
				clickable = true;
			});
		var off = Std.int((FlxG.height - (disclaimer.y + disclaimer.height)) / 2);
		disclaimer.y += off;
		titleAlphabet.y += off;

		DiscordUtil.call("onMenuLoaded", ["ERROR: Cannot find command DiscordUtil.call"]);
	}
}

	function tweenDone() {
		if (tweening == false) {
		pingpongo1 = FlxTween.tween(titleAlphabet, {y: 210}, 1.5, {ease: FlxEase.quadInOut, type: PINGPONG});
		pingpongo2 = FlxTween.tween(disclaimer, {y: 280}, 2, {ease: FlxEase.quadInOut, type: PINGPONG});
		}
	}

	public override function update(elapsed:Float) {

		if (FlxG.save.data.warning) {
			goToTitle();
		}
		else {
		super.update(elapsed);

		if (controls.ACCEPT && transitioning) {
			FlxG.sound.music.stop();
			FlxG.camera.stopFX(); FlxG.camera.visible = false;
			goToTitle();
		}

		if (controls.ACCEPT && !transitioning && clickable) {
			transitioning = true;
			FlxG.sound.music.stop();
			FlxG.sound.play(Paths.sound('menu/warningConfirm'));
			for (i in [pingpongo1, pingpongo2])
				i.cancel();
			tweening = true;
			twen1 = FlxTween.tween(titleAlphabet, {y: 1530}, 2.4, {ease: FlxEase.quadInOut});
			twen2 = FlxTween.tween(disclaimer, {y: 1530}, 1.7, {ease: FlxEase.quadInOut});
			tweenfireAlpha = FlxTween.tween(fire, {alpha: 0.9}, 1.1, {ease: FlxEase.quadInOut});
			FlxG.camera.flash(FlxColor.WHITE, 0.4, function() {
				FlxG.camera.fade(FlxColor.BLACK, 0.6, false, goToTitle);
			});
		}
	}
}

	private function goToTitle() {
		MusicBeatState.skipTransIn = MusicBeatState.skipTransOut = true;
		FlxG.switchState(new TitleState());
	}

}
