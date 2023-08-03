package backend;

import flixel.util.FlxSignal.FlxTypedSignal;
import flixel.system.FlxSound;

typedef BPMChange = {
	var bpm:Float;
	var time:Float;
	var step:Float;
}

class Conductor {
	public static var bpm(default, set):Float = 100;
	public static var crochet:Float = (60 / bpm) * 1000;
	public static var stepCrochet:Float = crochet / 4;

	//i would be modifying this to use lime events but idk how to lime. -srt
	public static var onStepHit:FlxTypedSignal<Int->Void> = new FlxTypedSignal();
	public static var onBeatHit:FlxTypedSignal<Int->Void> = new FlxTypedSignal();
	public static var onMeasureHit:FlxTypedSignal<Int->Void> = new FlxTypedSignal();

	public static var bpmChanges:Array<BPMChange> = [];

	public static var songPosition:Float = 0;

	public static var curStep:Int = 0;
	public static var curBeat:Int = 0;
	public static var curMeasure:Int = 0;

	public static function mapBPMChanges(song:ChartFormat) {
		bpmChanges = [];

		if(song == null || song.events == null) return;

		var curBPM:Float = song.bpm;
		var time:Float = 0;
		var step:Float = 0;

		for(e in song.events) {
			if(e.name == "BPM Change" && e.parameters != null) {
				if(Std.parseFloat(e.parameters[0]) == curBPM) continue;

				var steps:Float = (e.time - time) / ((60 / curBPM) * 1000 / 4);
				step += steps;
				time = e.time;
				curBPM = Std.parseFloat(e.parameters[0]);

				bpmChanges.push({
					step: step,
					time: time,
					bpm: curBPM
				});
			}
		}
	}

	public static function update(elapsed:Float) {
		songPosition += elapsed * 1000;

		updateTime();
	}

	public static function updateTime() {
		var songPos:Float = songPosition;
		var bpmChange:BPMChange = {step: 0, time: 0, bpm: 0};
		for (event in bpmChanges) {
			if (songPos >= event.time) {
				bpmChange = event;
				break;
			}
		}

		if (bpmChange.bpm > 0 && bpm != bpmChange.bpm)
			bpm = bpmChange.bpm;

		var oldStep:Int = curStep;
		curStep = Math.floor((bpmChange.step + (songPos - bpmChange.time) / stepCrochet));

		curBeat = Math.floor(curStep / 4);
		curMeasure = Math.floor(curBeat / 4);

		if(oldStep != curStep)
			stepHit(curStep);
	}

	public static function stepHit(curStep:Int) {
		onStepHit.dispatch(curStep);
		if (curStep % 4 == 0)
			beatHit(curBeat);
	}

	public static function beatHit(curBeat:Int) {
		onBeatHit.dispatch(curBeat);
		if (curBeat % 4 == 0)
			measureHit(curMeasure);
	}

	public static function measureHit(curMeasure:Int) {
		onMeasureHit.dispatch(curMeasure);
	}

	// backend
	@:noCompletion
	private static function set_bpm(newBPM:Float) {
		crochet = (60 / newBPM) * 1000;
		stepCrochet = crochet / 4;
		return bpm = newBPM;
	}
}