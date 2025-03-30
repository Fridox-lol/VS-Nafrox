var transition:FlxSprite = new FlxSprite(-100, -200);
transition.frames = Paths.getSparrowAtlas('menus/transition');
transition.animation.addByPrefix("thing", "transition wipe", 24, false);
transition.scale.set(1.3, 1.3);
transition.updateHitbox();

static var skipTransition:Bool = false;
static var whiteTransition:Bool = false;

function create() {
	transitionTween.cancel();
	transitionCamera.scroll.y = 0;
	transitionCamera.height = 720;

	remove(blackSpr);
	remove(transitionSprite);
	if (!skipTransition) add(transition);

	new FlxTimer().start(0.5, () ->
		{
			finish();
		});
 
	if (!skipTransition) transition.animation.play('thing', true, newState == null, () -> {finish();}, true);
	if (whiteTransition) transitionCamera.fade(0xFFFFFFFF, 0.4,  newState == null, () -> {finish();}, true);
}