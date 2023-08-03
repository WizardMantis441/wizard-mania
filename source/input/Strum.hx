package input;

import backend.Paths;
import input.Note;
import flixel.FlxSprite;

class Strum extends FlxSprite {
	public var id:Int = 0;
	public var strumLine:StrumLine;

	public function new(x:Float = 0, y:Float = 0, id:Int) {
		super(x, y);
		this.id = id;

		frames = Paths.getSparrowAtlas("receptors");

		var direction:String = Note.directions[id];
		animation.addByPrefix("static", direction + " static", 24);
		animation.addByPrefix("press", direction + " press", 24, false);
		animation.addByPrefix("confirm", direction + " confirm", 24, false);

		playAnim("static");
		scale.set(0.7, 0.7);
		updateHitbox();

		animation.finishCallback = function(name) {
			if (name == "confirm" && strumLine.cpu)
				playAnim("static");
		}
	}

	public function playAnim(name:String) {
		animation.play(name, true);
		centerOrigin();
		centerOffsets();
	}
}