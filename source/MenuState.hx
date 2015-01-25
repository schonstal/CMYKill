package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.PS4ButtonID;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
  var menuGraphic:FlxSprite;

  override public function create():Void {
    menuGraphic = new FlxSprite();
    menuGraphic.makeGraphic(FlxG.width, FlxG.height, 0xffffffff);
    add(menuGraphic);
    super.create();
    FlxG.switchState(new PlayState());
  }
  
  override public function destroy():Void {
    super.destroy();
  }

  override public function update(elapsed:Float):Void {
    super.update(elapsed);

    if(FlxG.gamepads.lastActive == null) return;

    if(FlxG.gamepads.lastActive.pressed(PS4ButtonID.X)) {
      FlxG.switchState(new PlayState());
    }
  }
}
