package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flash.geom.Point;
import flixel.system.FlxSound;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.PS4ButtonID;
import flash.display.BlendMode;
import flixel.util.FlxTimer;

class MuzzleFlash extends FlxSprite
{
  public function new(X:Float=0,Y:Float=0,playerIndex:Int=0) {
    super(X,Y);
    loadGraphic("assets/images/muzzleFlash.png", 13, 13);
    animation.add("flash", [1]);
    animation.play("flash");
    blend = BlendMode.ADD;
    setFacingFlip(FlxObject.LEFT, true, false);
    setFacingFlip(FlxObject.RIGHT, false, false);
    color = Player.COLORS[playerIndex];
    visible = false;
  }

  public function flash():Void {
    visible = true;
    new FlxTimer().start(0.01, function(t:FlxTimer):Void {
      visible = false;
    });
  }
}
