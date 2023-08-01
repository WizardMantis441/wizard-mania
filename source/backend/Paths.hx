package backend;

import flixel.graphics.frames.FlxAtlasFrames;

class Paths {
    public static inline function image(path:String) {
        return 'assets/images/$path.png';
    }

    public static inline function getSparrowAtlas(path:String, ?folder:String = "images") {
        return FlxAtlasFrames.fromSparrow('assets/$folder/$path.png', 'assets/$folder/$path.xml');
    }
}