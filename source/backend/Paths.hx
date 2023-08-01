package backend;

import flixel.graphics.frames.FlxAtlasFrames;

class Paths {
    public static inline function image(path:String) {
        return 'assets/images/$path.png';
    }

    public static inline function json(path:String) {
        return 'assets/$path.json';
    }

    public static inline function xml(path:String) {
        return 'assets/$path.xml';
    }

    public static inline function songInst(song:String) {
        return 'assets/songs/$song/Inst.ogg';
    }

    public static inline function songVoices(song:String) {
        return 'assets/songs/$song/Voices.ogg';
    }

    public static inline function getSparrowAtlas(path:String, ?folder:String = "images") {
        return FlxAtlasFrames.fromSparrow('assets/$folder/$path.png', 'assets/$folder/$path.xml');
    }
}