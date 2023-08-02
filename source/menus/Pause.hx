package menus;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.FlxSubState;

class Pause extends FlxSubState {
    public function new() {
        super();

        bgColor = 0x80000000;

        var text:FlxText = new FlxText(0, 0, 0, "paused.\nF5 to select a different song.\nESCAPE/ENTER to resume.", 36);
        text.alignment = CENTER;
        text.screenCenter();
        add(text);
    }

    var game = PlayState.self;
    override public function update(elapsed:Float) {
        if (FlxG.keys.justPressed.F5) {
            FlxG.switchState(new SelectSong());
        } else if (FlxG.keys.justPressed.ESCAPE || FlxG.keys.justPressed.ENTER) {
            game.inst.play();
			game.voices.play();
            close();
        }
    }
}