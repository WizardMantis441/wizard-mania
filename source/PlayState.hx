package;

import input.StrumLine;
import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import backend.Conductor;

class PlayState extends FlxState {
	var cpuStrums:StrumLine;
	var playerStrums:StrumLine;
	
	var debugText:FlxText;

	override function create() {
		super.create();
		Conductor.onStepHit.add(stepHit);
		Conductor.onBeatHit.add(beatHit);
		Conductor.onMeasureHit.add(measureHit); 
		
		cpuStrums = new StrumLine(FlxG.width * 0.25, 50, true);
		cpuStrums.x -= (cpuStrums.width) * 0.5;
		add(cpuStrums);
		
		playerStrums = new StrumLine(FlxG.width * 0.75, 50, false);
		playerStrums.x -= (playerStrums.width) * 0.5;
		add(playerStrums);
		
		debugText = new FlxText(3, 3, 0, "", 20);
		debugText.alpha = 0.5;
		add(debugText);
	}
	
	override function update(elapsed:Float) {
		super.update(elapsed);
		Conductor.update(elapsed);

		debugText.text = "Position: " + Math.round(Conductor.songPosition) / 1000;
		debugText.text += "\nStep: " + Conductor.curStep;
		debugText.text += "\nBeat: " + Conductor.curBeat;
		debugText.text += "\nMeasure: " + Conductor.curMeasure;
	}

	public function stepHit(curStep:Int) {
		trace("step works!");
	}
	
	public function beatHit(curBeat:Int) {
		trace("beat works!");
	}
	
	public function measureHit(curMeasure:Int) {
		trace("measure works!");
	}
	
	// for later..? lols!
	override function destroy() {
		super.destroy();
		Conductor.onStepHit.remove(stepHit);
		Conductor.onBeatHit.remove(stepHit);
		Conductor.onMeasureHit.remove(stepHit);
	}
}
