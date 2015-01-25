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
  public function new() {
    super();
  }
}
