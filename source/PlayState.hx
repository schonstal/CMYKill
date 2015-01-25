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

using flixel.util.FlxSpriteUtil;

class PlayState extends FlxState
{
  var rooms:Dynamic = {};
  var playerLight:FlxSprite;
  var players:Array<Player> = [];
  var playerGroup:FlxGroup = new FlxGroup();
  var playerBulletGroup:FlxGroup = new FlxGroup();
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
      playerLightGroup.add(new PlayerLight(players[i], i));
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
    super.update(elapsed);

    for(i in (0...3)) {
      players[i].resetFlags();
    }
    touchWalls();
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
    add(activeRoom.foregroundTiles);
    add(playerLightGroup);
    add(playerHealthGroup);

    //add(new PlayerLight(player, 1));
    //add(new PlayerLight(player, 2));
  }
}
