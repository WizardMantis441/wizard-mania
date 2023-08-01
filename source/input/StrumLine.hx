package input;

import haxe.xml.Access;

import lime.app.Application;
import lime.ui.KeyCode;

import openfl.utils.Assets;

import flixel.FlxG;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;

import input.Note;
import utils.CoolUtil;

// did sprite group so we can just call
// screenCenter(X) on the strumline easily
class StrumLine extends FlxTypedSpriteGroup<Strum> {
    //Input vars.
    public var cpu:Bool = false;
    public var keybinds:Array<Array<KeyCode>> = [];
    public var keysHeld:Array<Bool> = [false, false, false, false];
    
    public var spacing:Float = 112; // 160 * 0.7

    public function new(?x:Float = 0, ?y:Float = 0, ?cpu:Bool = false) {
        super(x, y);
        this.cpu = cpu;
        
        //should i put the queued notes and the note group in playstate or here?
        for (id in 0...4) {
            var strum = new Strum(spacing * id, 0, id);
            add(strum); 
        }

        var xmlData = new Access(Xml.parse(Assets.getText("assets/data/keybinds.xml")).firstElement());
        for(elem in xmlData.elements) {
            if (elem.name != "bind") continue;
            var keys = CoolUtil.limeKeyCodeFromStringMap;

            keybinds.push([
                keys.get(elem.att.main),
                keys.get(elem.att.alt)
            ]);
        }

        Application.current.window.onKeyDown.add(keyDown);
        Application.current.window.onKeyUp.add(keyUp);
    }

    private function keyDown(keyCode:KeyCode, keyMods:Int) {
        var strumIndex:Int = -1;
        for (i => bind in keybinds) {
            if (bind.contains(keyCode)) {
                strumIndex = i;
                break;
            }
        }
        if(strumIndex == -1 || keysHeld[strumIndex] || cpu) return;
        keysHeld[strumIndex] = true;

        var queuedAnim:String = "press";
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