import funkin.backend.utils.WindowUtils;
import funkin.backend.utils.DiscordUtil;
import flixel.math.FlxBasePoint;
import openfl.Lib;

static var camMoveOffset:Float = 20;
static var camAngleOffset:Float = 0.25;
static var camFollowChars:Bool = true;

var movement = new FlxBasePoint();

function create() {
    camFollowChars = true; camMoveOffset = 20; camAngleOffset = 0.25;
}

function postCreate() {
    var cameraStart = strumLines.members[curCameraTarget].characters[0].getCameraPosition();
    FlxG.camera.focusOn(cameraStart);
}

function onCameraMove(camMoveEvent) {
    if (camFollowChars) {
        if (camMoveEvent.strumLine != null && camMoveEvent.strumLine?.characters[0] != null) {
            switch (camMoveEvent.strumLine.characters[0].animation.name) {
                case "singLEFT": movement.set(-camMoveOffset, 0); camGame.angle = lerp(camGame.angle, camAngleOffset, 0.5);
                case "singDOWN": movement.set(0, camMoveOffset); camGame.angle = lerp(camGame.angle, 0, 0.5);
                case "singUP": movement.set(0, -camMoveOffset); camGame.angle = lerp(camGame.angle, 0, 0.5);
                case "singRIGHT": movement.set(camMoveOffset, 0); camGame.angle = lerp(camGame.angle, -camAngleOffset, 0.5);
                case "singLEFT-alt": movement.set(-camMoveOffset, 0); camGame.angle = lerp(camGame.angle, camAngleOffset, 0.5);
                case "singDOWN-alt": movement.set(0, camMoveOffset); camGame.angle = lerp(camGame.angle, 0, 0.5);
                case "singUP-alt": movement.set(0, -camMoveOffset); camGame.angle = lerp(camGame.angle, 0, 0.5);
                case "singRIGHT-alt": movement.set(camMoveOffset, 0); camGame.angle = lerp(camGame.angle, -camAngleOffset, 0.5);
                default: movement.set(0, 0); camGame.angle = lerp(camGame.angle, 0, 0.5);
            };
            camMoveEvent.position.x += movement.x;
			camMoveEvent.position.y += movement.y;
        }
    } else camMoveEvent.cancel();
}

function destroy() {camFollowChars = true; camMoveOffset = 20; camAngleOffset = 0.25;}