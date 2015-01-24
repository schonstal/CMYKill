package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
  var menuGraphic:FlxSprite;

  override public function create():Void {
    menuGraphic = new FlxSprite();
    menuGraphic.makeGraphic(FlxG.width, FlxG.height, 0xff33ff33);
    add(menuGraphic);
    super.create();
  }
  
  override public function destroy():Void {
    super.destroy();
  }

  override public function update(elapsed:Float):Void {
    super.update(elapsed);
  }
}
