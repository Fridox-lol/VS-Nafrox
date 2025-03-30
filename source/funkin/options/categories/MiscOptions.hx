package funkin.options.categories;
import funkin.backend.scripting.events.*;
import flixel.tweens.FlxTween;
import funkin.editors.ui.*;
import funkin.menus.ModSwitchMenu;
import funkin.backend.scripting.ModState;

class MiscOptions extends OptionsScreen {
	public override function new() {
		super("Miscellaneous", "Use this menu to reset save data or engine settings.");
		#if UPDATE_CHECKING
		add(new Checkbox(
			"Enable Nightly Updates",
			"If checked, will also include nightly builds in the update checking.",
			"betaUpdates"));,
		add(new TextOption(
			"Check for Updates",
			"Select this option to check for new engine updates.",
			function() {
				var report = funkin.backend.system.updating.UpdateUtil.checkForUpdates();
				if (report.newUpdate) {
					FlxG.switchState(new funkin.backend.system.updating.UpdateAvailableScreen(report));
				} else {
					CoolUtil.playMenuSFX(CANCEL);
					updateDescText("No update found.");
				}
		}));,
		#end
		add(new TextOption("Reset Save Data", "WARNING: THIS DELETES EVERY SAVE FILE IN EVERY CODENAME MOD. USE IT WISELY.", function() {
			FlxG.switchState(new ModState('cutelyEatsYourSaveDataState'));
		}));
	}
}
