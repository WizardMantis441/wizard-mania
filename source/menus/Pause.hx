package menus;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.FlxSubState;

class Pause extends FlxSubState {
    public function new() {
        super();
        var text:FlxText;
        text = new FlxText("paused. F5 to select a different song.");
        text.screenCenter();
        add(text);
    }

    var game = PlayState.self;
    override public function update(elapsed:Float) {
        if (FlxG.keys.justPressed.ESCAPE) {
            game.inst.play();
			game.voices.play();
            close();
        }
    }
}