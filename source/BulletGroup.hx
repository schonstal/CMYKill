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
import flixel.math.FlxRandom;

class BulletGroup extends FlxTypedGroup<Bullet>
{
  var color:Int;

  public function new(color:Int) {
    this.color = color;
    super();
  }

  public function fireBullet(X:Float, Y:Float, direction:Float, spread:Float, scale:Float):Void {
    var bullet:Bullet = recycle(Bullet);
    bullet.x = X;
    bullet.y = Y;
    bullet.velocity.x = 400 * direction;
    bullet.velocity.y = (new FlxRandom()).float(-spread, spread);
    bullet.color = color;
    bullet.scale.x = bullet.scale.y = scale;
    bullet.facing = direction < 0 ? FlxObject.LEFT : FlxObject.RIGHT;
  }
}
