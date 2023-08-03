package backend;

import openfl.utils.Assets;
import haxe.Json;

class ChartParser {
	public static function parse(song:String, difficulty:String):ChartFormat {
		var raw:Dynamic = Json.parse(Assets.getText(Paths.json("songs/" + song.toLowerCase() + "/" + difficulty.toLowerCase())));

		if (raw.codenameChart) {
			return parseCNE(raw);
		}

		var json:Dynamic = raw.song;
		var parsed:ChartFormat = {
			bpm: json.bpm,
			scrollSpeed: json.speed,
			notes: [],
			events: []
		};

		var curBPM:Float = parsed.bpm;
		var curTime:Float = 0;
		var curCrochet:Float = ((60 / parsed.bpm) * 1000);

		var daSections:Array<Dynamic> = json.notes;
		for (section in daSections) {
			if (section == null)
				continue;

			parsed.events.push({
				time: curTime <= 0.05 ? Math.NEGATIVE_INFINITY : curTime,
				name: "Camera Pan",
				parameters: [section.mustHitSection ? "1" : "0"]
			});

			if (section.changeBPM && section.bpm != curBPM) {
				curBPM = section.bpm;
				curCrochet = (60.0 / section.bpm) * 1000.0;

				parsed.events.push({
					time: curTime,
					name: "BPM Change",
					parameters: [Std.string(section.bpm)]
				});
			}

			var daNotes:Array<Dynamic> = section.sectionNotes;
			for (note in daNotes) {
				parsed.notes.push({
					time: note[0],
					id: Std.int(note[1]) % 4,
					length: note[2],
					mustPress: section.mustHitSection != (Std.int(note[1]) >= 4)
				});
			}

			curTime += curCrochet * 4;
		}
		parsed.notes.sort((a, b) -> Std.int(a.time - b.time));

		return parsed;
	}

	public static function parseCNE(json) {
		var parsed:ChartFormat = {
			bpm: json.bpm,
			scrollSpeed: json.speed,
			notes: [],
			events: []
		};

		return parsed;
	}
}
