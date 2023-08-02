package utils;

import flixel.system.macros.FlxMacroUtil;

class CoolUtil {
	public static var limeKeyCodeFromStringMap(default, null):Map<String, lime.ui.KeyCode> = FlxMacroUtil.buildMap("lime.ui.KeyCode");
	public static var limeKeyCodeToStringMap(default, null):Map<lime.ui.KeyCode, String> = FlxMacroUtil.buildMap("lime.ui.KeyCode", true);


	/**
	 * Converts an `FlxKey` to a string representation.
	 * 
	 * @param key The key to convert.
	 */
	public inline static function keyToString(key:Null<lime.ui.KeyCode>):String {
		return switch (key) {
			case null, UNKNOWN: "---";
			case LEFT: "←";
			case DOWN: "↓";
			case UP: "↑";
			case RIGHT: "→";
			case ESCAPE: "ESC";
			case BACKSPACE: "[←]";
			case NUMPAD_0: "#0";
			case NUMPAD_1: "#1";
			case NUMPAD_2: "#2";
			case NUMPAD_3: "#3";
			case NUMPAD_4: "#4";
			case NUMPAD_5: "#5";
			case NUMPAD_6: "#6";
			case NUMPAD_7: "#7";
			case NUMPAD_8: "#8";
			case NUMPAD_9: "#9";
			case NUMPAD_PLUS: "#+";
			case NUMPAD_MINUS: "#-";
			case NUMPAD_PERIOD: "#.";
			case NUMPAD_MULTIPLY: "#*";
			case GRAVE: "`";
			case LEFT_BRACKET: "[";
			case RIGHT_BRACKET: "]";
			case PRINT_SCREEN: "PrtScrn";
			case QUOTE: "'";
			case NUMBER_0: "0";
			case NUMBER_1: "1";
			case NUMBER_2: "2";
			case NUMBER_3: "3";
			case NUMBER_4: "4";
			case NUMBER_5: "5";
			case NUMBER_6: "6";
			case NUMBER_7: "7";
			case NUMBER_8: "8";
			case NUMBER_9: "9";
			case COMMA: ",";
			case PERIOD: ".";
			case SEMICOLON: ";";
			case BACKSLASH: "\\";
			case SLASH: "/";
			case PAGE_UP: "PgUp";
			case PAGE_DOWN: "PgDown";
			case PLUS: "+";
			case MINUS: "-";
			default: limeKeyCodeToStringMap.get(key);
		}
	}
}
