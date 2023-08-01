package backend;

typedef ChartNote = {
    var time:Float;
    var id:Int;
    var length:Float;
    var mustPress:Bool;
}

typedef ChartEvent = {
    var time:Float;
    var name:String;
    var parameters:Array<String>;
}

typedef ChartFormat = {
    var bpm:Float;
    var scrollSpeed:Float;
    var notes:Array<ChartNote>;
    var events:Array<ChartEvent>;
}