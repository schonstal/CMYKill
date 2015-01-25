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

class PlayState extends FlxState
{
  var rooms:Dynamic = {};
  var player:Player;
  var activeRoom:Room;

  override public function create():Void {
    super.create();
    for(fileName in Reg.rooms) {
      Reflect.setField(rooms,
                       fileName,
                       new Room("assets/tilemaps/" + fileName + ".tmx"));
    }

    player = new Player();
    player.init();

    switchRoom("main");

    FlxG.camera.scroll.x = 16;
    FlxG.camera.scroll.y = 22;
    FlxG.debugger.drawDebug = true;
  }
  
  override public function destroy():Void {
    super.destroy();
  }

  override public function update(elapsed:Float):Void {
    super.update(elapsed);
    
    player.resetFlags();

    touchWalls();
  }

  private function touchWalls():Void {
    FlxG.collide(activeRoom.foregroundTiles, player, function(tile:FlxObject, player:Player):Void {
      if((player.touching & FlxObject.FLOOR) > 0) {
        player.setCollidesWith(Player.WALL_UP);
      }
    });
  }

  public function switchRoom(roomName:String):Void {
    activeRoom = Reflect.field(rooms, roomName);
    add(activeRoom.backgroundTiles);
    add(player);
    add(activeRoom.foregroundTiles);
  }
}
