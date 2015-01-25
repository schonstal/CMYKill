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
import flixel.group.FlxSpriteGroup;
//import flixel.util.FlxSpriteUtil;
import flash.display.BlendMode;
import flixel.math.FlxRandom;

class HealthBar extends FlxSpriteGroup
{
  var bg:FlxSprite;
  var healthSprite:FlxSprite;

  public function new(X:Int, Y:Int, color:Int) {
    super();
    bg = new FlxSprite(X,Y);
    bg.loadGraphic("assets/images/healthBar.png");
    add(bg);

    health = 100;

    healthSprite = new FlxSprite(X,Y);
    healthSprite.makeGraphic(4, 44, 0xffffffff);//color);
    add(healthSprite);

    this.color = color;
  }

  public override function update(elapsed:Float):Void {
    super.update(elapsed);
    healthSprite.scale.y = health/100;
    healthSprite.offset.y = 44 * (1 - scale.y)/2;
  }
}
