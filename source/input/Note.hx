package input;

import backend.Conductor;
import flixel.FlxSprite;
import backend.Paths;

class Note extends FlxSprite {
    public static var directions:Array<String> = ["left", "down", "up", "right"];

    public var id:Int = 0;
    public var time:Float = 0;
    public var length:Float = 0;
    public var isPlayer:Bool = false;
    // not doing notetypes yet

    public function new(id:Int, time:Float, length:Float, isPlayer:Bool) {
        super(-9999, -9999); // make sure that MF IS OFF THE SCREEN WHEN IT SPAWNS!!!!
        
        this.id = id;
        this.time = time;
        this.length = length;
        this.isPlayer = isPlayer;
        
        frames = Paths.getSparrowAtlas("notes");

        var direction:String = Note.directions[id];
        animation.addByPrefix("main", direction + "0", 24);
        animation.addByPrefix("hold", direction + " hold piece0", 24, false);
        animation.addByPrefix("hold end", direction + " hold end0", 24, false);

        playAnim("main");
        scale.set(0.7, 0.7);
        updateHitbox();
    }


    override function update(elapsed:Float) {
        super.update(elapsed);
        var game = PlayState.self;
        
        var strumLine = isPlayer ? game.playerStrums : game.cpuStrums;
        var distance = (time - Conductor.songPosition) * (0.45 * game.CHART.scrollSpeed);

        x = strumLine.members[id].x;
        y = strumLine.members[id].y + distance;

        // opponent note hitting
        if (time < Conductor.songPosition && !isPlayer) {
            destroy();
            strumLine.notes.remove(this);
            strumLine.members[id].playAnim("confirm");
        }

        // goofy shit for "hey is this offscreen?!?!"
        if (time < Conductor.songPosition - (500 / game.CHART.scrollSpeed)) {
            destroy();
            strumLine.notes.remove(this);
        }
    }

    public function playAnim(name:String) {
        animation.play(name, true);
        centerOrigin();
        centerOffsets();
    }
}