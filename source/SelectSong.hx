package;

import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.FlxState;
import sys.FileSystem;

class SelectSong extends FlxState {

    public static var curSelected:Int = 0;

    var list:Array<String> = [];
    public static var listInfo:Array<Array<String>> = [];
    var songTxts:Array<FlxText> = [];

    override function create() {
        super.create();

        for (folders in FileSystem.readDirectory("assets/songs"))
            for (charts in FileSystem.readDirectory("assets/songs/" + folders))
                if (StringTools.endsWith(charts, ".json")) {
                    list.push(folders + "/" + charts);
                    listInfo.push([folders, charts]);
                }

        for (i in 0...list.length) {
            var item:FlxText;
            item = new FlxText(20, 20 + 28 * i, 0, list[i], 24);
            songTxts.push(item);
            add(item);
        }

        changeSelction(0);
    }

    override function update(elapsed:Float) {
        if (FlxG.keys.justPressed.UP) changeSelction(-1);
        if (FlxG.keys.justPressed.DOWN) changeSelction(1);
        if (FlxG.keys.justPressed.ENTER) FlxG.switchState(new PlayState());
    }

    function changeSelction(inc:Int) {
        curSelected = FlxMath.wrap(curSelected + inc, 0, list.length);
        for (i => txt in songTxts) txt.color = (i == curSelected) ? 0xFF00FF40 : 0xFFFFFFFF;
    }
}