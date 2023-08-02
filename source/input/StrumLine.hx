package input;

import flixel.FlxCamera;
import backend.Conductor;
import haxe.xml.Access;

import lime.app.Application;
import lime.ui.KeyCode;

import openfl.utils.Assets;

import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;

import input.Note;
import backend.Paths;
import backend.ChartFormat.ChartNote;
import utils.CoolUtil;

@:access(flixel.FlxCamera)
class StrumLine extends FlxTypedSpriteGroup<Strum> {
	// Note vars.
	public var notes:FlxTypedGroup<Note>; //we might have to override draw
	public var queuedNotes:Array<ChartNote> = []; //we gon create sprites over time baby!

	// Input vars.
	public var cpu:Bool = false;
	public var keybinds:Array<Array<KeyCode>> = [];
	public var keysHeld:Array<Bool> = [false, false, false, false];
	
	public var spacing:Float = 112; // 160 * 0.7

	public function new(?x:Float = 0, ?y:Float = 0, ?cpu:Bool = false) {
		super(x, y);
		this.cpu = cpu;

		for (id in 0...4) {
			var strum = new Strum(spacing * id, 0, id);
			strum.strumLine = this;
			add(strum);
		}

		var xmlData = new Access(Xml.parse(Assets.getText(Paths.xml("data/keybinds"))).firstElement());
		for(elem in xmlData.elements) {
			if (elem.name != "bind") continue;
			var keys = CoolUtil.limeKeyCodeFromStringMap;

			keybinds.push([
				keys.get(elem.att.main),
				keys.get(elem.att.alt)
			]);
		}

		this.x -= width / 2;
		notes = new FlxTypedGroup();

		Application.current.window.onKeyDown.add(keyDown);
		Application.current.window.onKeyUp.add(keyUp);
	}

	private var curSpawnNote:Int = 0;

	override function update(elapsed:Float) {
		super.update(elapsed);

		var game = PlayState.self;

		// optimization :D
		// basically removing shit from arrays can be expensive at times
		while (curSpawnNote < queuedNotes.length && queuedNotes[curSpawnNote] != null && queuedNotes[curSpawnNote].time - Conductor.songPosition < (1500 / game.CHART.scrollSpeed)) {
			var queuedNote = queuedNotes[curSpawnNote];
			var newNote = new Note(queuedNote.id, queuedNote.time, queuedNote.length, !cpu);
			notes.add(newNote);
			//trace("note spawned!");
			curSpawnNote++;
		}
		notes.update(elapsed);
	}
	
	//bc notes is an typedGroup and spriteGroups (this) only supports sprites, imma do a scuffed.
	override function draw() {
		super.draw();

		notes.cameras = cameras;
		notes.draw();
	}

	private function keyDown(keyCode:KeyCode, keyMods:Int) {
		var strumIndex:Int = -1;
		for (i => bind in keybinds)
			if (bind.contains(keyCode)) {
				strumIndex = i;
				break;
			}

		if (strumIndex == -1 || keysHeld[strumIndex] || cpu) return;
		keysHeld[strumIndex] = true;

		var queuedAnim:String = "press";

        // LITERALLY THE ENTIRE INPUT SYSTEM WTF from @Ne_Eo
 
		var game = PlayState.self;
		var hitzone = (500 / game.CHART.scrollSpeed);

		var ppnotes = notes.members // possible press notes
		.filter((n)-> n != null) // remove null notes
		.filter((n)-> n.id == strumIndex) // check only cur strum
		.filter((n)-> Math.abs(Conductor.songPosition - n.time) < hitzone); // only in hitzone

		if (ppnotes.length > 0) { // hit note
			ppnotes.sort((a, b) -> Std.int(a.time - b.time));
		
			for (b in ppnotes.filter(v->Math.abs(ppnotes[0].time - v.time) < 5)) {
				b.destroy();
				notes.remove(b);
			}
		
			queuedAnim = "confirm";
		}

		var strum:Strum = members[strumIndex];
		strum.playAnim(queuedAnim);
	}

	private function keyUp(keyCode:KeyCode, keyMods:Int) {
		var strumIndex:Int = -1;
		for (i => bind in keybinds) {
			if (bind.contains(keyCode)) {
				strumIndex = i;
				break;
			}
		}
		if (strumIndex == -1 || !keysHeld[strumIndex] || cpu) return;
		keysHeld[strumIndex] = false;

		var strum:Strum = members[strumIndex];
		strum.playAnim("static");
	}

	override function destroy() {
		Application.current.window.onKeyDown.remove(keyDown);
		Application.current.window.onKeyUp.remove(keyUp);
		super.destroy();
	}
}