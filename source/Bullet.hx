package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.system.FlxSound;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.group.FlxGroup;
//import flixel.util.FlxSpriteUtil;
import flash.display.BlendMode;

class Bullet extends FlxSprite
{
  public function new() {
    super();
    loadGraphic("assets/images/bullet.png");

    setFacingFlip(FlxObject.LEFT, false, false);
    setFacingFlip(FlxObject.RIGHT, true, false);
  }

  public override function update(elapsed:Float):Void {
    super.update(elapsed);
    if(velocity.x < 0) {
      facing = FlxObject.LEFT;
    } else {
      facing = FlxObject.RIGHT;
    }
  }
}
