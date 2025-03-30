function create() {
	enableCameraHacks = false;
	playCutscenes = true;
}

function postCreate() {
	for(i in 0...6) {
		var name = "tank" + Std.string(i);
		stage.getSprite(name).visible = false;
	}
}

function postUpdate(elapsed) {
	for(s in strumLines) {
		for(i in 0...4) {
			var n = s.members[i];
			n.angle = Math.sin(curBeatFloat + (i * 0.45)) * 15;
		}
	}


	// for(s in strumLines) {
	// 	for(i in 0...4) {
	// 		var n = s.members[i];
	// 		n.y = FlxG.height - 200;
	// 		n.angle = 180;
	// 	}
	// }

	// if (curSection != null)
	//     defaultCamZoom = curSection.mustHitSection ? 0.9 : 0.5;
}