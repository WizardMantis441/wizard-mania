package;

import backend.*;
import input.*;
import menus.*;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.system.FlxSound;
import openfl.utils.Assets;

class PlayState extends FlxState {
	public static var self:PlayState;

	public var song:String;
	public var difficulty:String;

	public var CHART:ChartFormat;

	public var inst:FlxSound;
	public var voices:FlxSound;

	public var songStarted:Bool = false;

	public var cpuStrums:StrumLine;
	public var playerStrums:StrumLine;

	public var debugText:FlxText;

	public function new(song:String, diff:String) {
		super();

		this.song = song;
		this.difficulty = diff;
	}

	override function create() {
		super.create();
		self = this;

		CHART = ChartParser.parse(song, difficulty);

		Conductor.mapBPMChanges(CHART);
		Conductor.bpm = CHART.bpm;
		Conductor.songPosition = 0;

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
		inst.onComplete = function() FlxG.switchState(new SelectSong());
		FlxG.sound.list.add(inst);

		if (Assets.exists(Paths.songVoices(song))) {
			voices = new FlxSound();
			voices.loadEmbedded(Paths.songVoices(song));
			FlxG.sound.list.add(voices);
		}
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (FlxG.keys.justPressed.ENTER) {
			inst.pause();
			voices.pause();
			openSubState(new Pause());
		}

		Conductor.songPosition = inst.time;
		Conductor.updateTime();

		if (!songStarted && Conductor.songPosition >= 0) {
			Conductor.songPosition = 0;
			songStarted = true;
			inst.play();
			if (voices != null)
				voices.play();
		}

		debugText.text = "Position: " + Math.round(Conductor.songPosition) / 1000;
		debugText.text += "\nStep: " + Conductor.curStep;
		debugText.text += "\nBeat: " + Conductor.curBeat;
		debugText.text += "\nMeasure: " + Conductor.curMeasure;
	}
}
