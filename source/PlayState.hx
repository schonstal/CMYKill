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
import flixel.math.FlxMath;
import flixel.math.FlxPoint;

using flixel.util.FlxSpriteUtil;

class PlayState extends FlxState
{
  var rooms:Dynamic = {};
  var playerLight:FlxSprite;
  var players:Array<Player> = [];
  var playerGroup:FlxGroup = new FlxGroup();
  var playerBulletGroup:FlxGroup = new FlxGroup();
  var playerFlashGroup:FlxGroup = new FlxGroup();
  var playerHealthGroup:FlxGroup = new FlxGroup();
  var playerLightGroup:FlxGroup = new FlxGroup();
  var activeRoom:Room;

  var bulletGroup:BulletGroup;
  
  var frame:Int = 0;

  override public function create():Void {
    super.create();
    for(fileName in Reg.rooms) {
      Reflect.setField(rooms,
                       fileName,
                       new Room("assets/tilemaps/" + fileName + ".tmx"));
    }

    for(i in (0...3)) {
      players[i] = new Player(0,0,i);
      players[i].init();
      playerGroup.add(players[i]);
      playerBulletGroup.add(players[i].bulletGroup);
      playerHealthGroup.add(players[i].healthBar);
      playerFlashGroup.add(players[i].muzzleFlash);
      playerLightGroup.add(players[i].playerLight);
    }

    switchRoom("main");

    FlxG.camera.scroll.x = 16;
    FlxG.camera.scroll.y = 22;
    FlxG.debugger.drawDebug = true;

    //bulletGroup = new BulletGroup();
    //add(bulletGroup);
  }
  
  override public function destroy():Void {
    super.destroy();
  }

  override public function update(elapsed:Float):Void {
    if(FlxG.keys.justPressed.Q) players[1].hurt(10);
    super.update(elapsed);

    for(i in (0...3)) {
      players[i].resetFlags();
    }
    touchWalls();
    calculateUpgrades();
  }

  private function calculateUpgrades():Void {
    for(i in (0...3)) {
      if(FlxMath.getDistance(FlxPoint.get(players[i].x, players[i].y),
                             FlxPoint.get(players[0].x, players[0].y)) < PlayerLight.RADIUS[0]) {
        players[i].autoFire = true;
      } else {
        players[i].autoFire = false;
      }
      if(FlxMath.getDistance(FlxPoint.get(players[i].x, players[i].y),
                             FlxPoint.get(players[1].x, players[1].y)) < PlayerLight.RADIUS[1]) {
        players[i].healsPerSecond = 5;
      } else {
        players[i].healsPerSecond = 0;
      }
      if(FlxMath.getDistance(FlxPoint.get(players[i].x, players[i].y),
                             FlxPoint.get(players[2].x, players[2].y)) < PlayerLight.RADIUS[2]) {
        players[i].bulletScale = 2;
      } else {
        players[i].bulletScale = 1;
      }
    }
  }

  private function touchWalls():Void {
    FlxG.collide(activeRoom.foregroundTiles, playerGroup, function(tile:FlxObject, player:Player):Void {
      if((player.touching & FlxObject.FLOOR) > 0) {
        player.setCollidesWith(Player.WALL_UP);
      }
    });
  }

  public function switchRoom(roomName:String):Void {
    activeRoom = Reflect.field(rooms, roomName);
    add(activeRoom.backgroundTiles);
    add(playerBulletGroup);
    add(playerGroup);
    add(playerFlashGroup);
    add(activeRoom.foregroundTiles);
    add(playerLightGroup);
    add(playerHealthGroup);

    //add(new PlayerLight(player, 1));
    //add(new PlayerLight(player, 2));
  }
}
