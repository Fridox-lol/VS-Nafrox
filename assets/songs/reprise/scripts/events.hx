var black:FlxSprite;
var color:FlxColor;


camHUD.alpha = 0;

scarystatic = new FlxSprite(0,0);
scarystatic.frames = Paths.getFrames('menus/nafroxmenu/story/scaryredstatic');
scarystatic.animation.addByPrefix('idle', 'scaryredstatic' , 24);
scarystatic.animation.play('idle');
scarystatic.scale.set(2.3, 2.3);
add(scarystatic);
scarystatic.alpha = 0;

var black = new FlxSprite();
black.cameras = [camGame];
black.makeGraphic(2673, 2673, FlxColor.BLACK);
black.alpha = 1;
add(black);
color = FlxColor.BLACK;



function beatHit(curBeat){
    switch(curBeat){
        case 8:
            FlxTween.tween(black, {alpha: 0}, 2);
            FlxTween.tween(camHUD, {alpha: 1}, 4);
        case 147:
            FlxG.camera.shake(0.001, 99, null, true);
        case 148:
            FlxG.camera.shake(0.01, 99, null, true);
        case 149:
            FlxG.camera.shake(0.1, 99, null, true);
            FlxTween.tween(scarystatic, {alpha: 1}, 1.5);
            FlxTween.tween(black, {alpha: 1}, 2.5);
            FlxTween.tween(camHUD, {alpha: 0}, 1.2);
    }};