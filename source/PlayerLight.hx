package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.addons.effects.FlxGlitchSprite;
import flixel.system.FlxSound;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
//import flixel.util.FlxSpriteUtil;
import flash.display.BlendMode;

using flixel.util.FlxSpriteUtil;

class PlayerLight extends FlxSprite
{
  public static var RADIUS:Int = 20;
  var flickerTimer:Float = 0;
  var flickerTime:Float = 0.5;

  var player:Player;
  var radius:Int = 40;
  var big:Bool = true;
  var colorIndex:Int = 0;

  var colors = [
    [0xff600060, 0xff400040],
    [0xff006060, 0xff004040],
    [0xff606000, 0xff404000]
  ];
  
  public function new(player:Player, colorIndex) {
    this.player = player;
    this.colorIndex = colorIndex;
    super(0,0);

    makeGraphic(radius*2, radius*2, FlxColor.TRANSPARENT, true);
    blend = BlendMode.ADD;

    drawCircles();
  }

  override public function update(elapsed:Float):Void {
    super.update(elapsed);

    x = player.x - radius + player.width/2;
    y = player.y - radius + player.height/2;

    flickerTimer += elapsed;
    if(flickerTimer > 0.5) {
      flickerTimer = 0;
      big = !big;
      drawCircles();
    }
  }

  private function drawCircles():Void {
    fill(FlxColor.TRANSPARENT);
    drawCircle(-1, -1, big ? RADIUS : RADIUS - 1,
                           colors[colorIndex][1],
                           {color: 0});
    drawCircle(-1, -1, big ? RADIUS - 4 : RADIUS - 5,
                           colors[colorIndex][0],
                           {color: 0});
  }
}
