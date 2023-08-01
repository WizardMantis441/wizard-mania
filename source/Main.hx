package;

import flixel.FlxSprite;
import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite {
	public function new() {
		super();

		FlxSprite.defaultAntialiasing = true;
		addChild(new FlxGame(0, 0, PlayState, 240, 240, true));
	}
}
