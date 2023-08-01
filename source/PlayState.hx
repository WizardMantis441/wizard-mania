package;

import input.*;
import backend.*;
import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.system.FlxSound;
import openfl.utils.Assets;

class PlayState extends FlxState {
	public static var self:PlayState;

	public var song:String = "fill up";
	public var difficulty:String = "hard";
	
	public var CHART:ChartFormat;

	public var inst:FlxSound;
	public var voices:FlxSound;

	public var songStarted:Bool = false;

	public var cpuStrums:StrumLine;
	public var playerStrums:StrumLine;
	
	public var debugText:FlxText;

	override function create() {
		super.create();
		self = this;
		CHART = ChartParser.parse(song, difficulty);

		Conductor.mapBPMChanges(CHART);
		Conductor.bpm = CHART.bpm;

		Conductor.onStepHit.add(stepHit);
		Conductor.onBeatHit.add(beatHit);
		Conductor.onMeasureHit.add(measureHit); 
		
		cpuStrums = new StrumLine(FlxG.width * 0.25, 50, true);
		add(cpuStrums);
		
		playerStrums = new StrumLine(FlxG.width * 0.75, 50, false);
		add(playerStrums);

		for (note in CHART.notes) {
			if (note.mustPress)
				playerStrums.queuedNotes.push(Reflect.copy(note));
			else
				cpuStrums.queuedNotes.push(Reflect.copy(note));
		}

		for (strumLine in [cpuStrums, playerStrums]) {
			strumLine.queuedNotes.sort((a, b) -> Std.int(a.time - b.time));
		}
		
		debugText = new FlxText(3, 3, 0, "", 20);
		debugText.alpha /= 3;
		add(debugText);

		inst = new FlxSound();
		inst.loadEmbedded(Paths.songInst(song));
		FlxG.sound.list.add(inst);

		if (Assets.exists(Paths.songVoices(song))) {
			voices = new FlxSound();
			voices.loadEmbedded(Paths.songVoices(song));
			FlxG.sound.list.add(voices);
		}
	}
	
	override function update(elapsed:Float) {
		super.update(elapsed);
		Conductor.update(elapsed);

		if (!songStarted && Conductor.songPosition >= 0) {
			Conductor.songPosition = 0;
			songStarted = true;
			inst.play();
			if (voices != null)
				voices.play();
		}

		// code theft from psych enginr!!!
		if (Math.abs(inst.time - Conductor.songPosition) > 20
			|| (voices != null && Math.abs(voices.time - Conductor.songPosition) > 20)) {
			voices.pause();

			FlxG.sound.music.play();
			Conductor.songPosition = inst.time;
			if (Conductor.songPosition <= voices.length) {
				voices.time = Conductor.songPosition;
			}
			voices.play();
        }

		debugText.text = "Position: " + Math.round(Conductor.songPosition) / 1000;
		debugText.text += "\nStep: " + Conductor.curStep;
		debugText.text += "\nBeat: " + Conductor.curBeat;
		debugText.text += "\nMeasure: " + Conductor.curMeasure;
	}

	public function stepHit(curStep:Int) {}
	public function beatHit(curBeat:Int) {}
	public function measureHit(curMeasure:Int) {}
	
	override function destroy() {
		super.destroy();
		Conductor.onStepHit.remove(stepHit);
		Conductor.onBeatHit.remove(stepHit);
		Conductor.onMeasureHit.remove(stepHit);
	}
}
