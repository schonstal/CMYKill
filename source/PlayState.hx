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

class PlayState extends FlxState
{
  var rooms:Dynamic = {};
  var playerLight:FlxSprite;
  var players:Array<Player> = [];
  var activeRoom:Room;
  
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
    }

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
    
    for(i in (0...3)) {
      players[i].resetFlags();
      touchWalls(i);
    }
  }

  private function touchWalls(i:Int):Void {
    FlxG.collide(activeRoom.foregroundTiles, players[i], function(tile:FlxObject, player:Player):Void {
      if((players[i].touching & FlxObject.FLOOR) > 0) {
        players[i].setCollidesWith(Player.WALL_UP);
      }
    });
  }

  public function switchRoom(roomName:String):Void {
    activeRoom = Reflect.field(rooms, roomName);
    add(activeRoom.backgroundTiles);
    for(i in (0...3)) {
      add(players[i]);
    }
    add(activeRoom.foregroundTiles);
    for(i in (0...3)) {
      add(new PlayerLight(players[i], i));
    }
    //add(new PlayerLight(player, 1));
    //add(new PlayerLight(player, 2));
  }
}
