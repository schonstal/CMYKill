package;

import flixel.util.FlxSave;

/**
 * Handy, pre-built Registry class that can be used to store 
 * references to objects and other things for quick-access. Feel
 * free to simply ignore it or change it in any way you like.
 */
class Reg
{
  public static var rooms:Array<String> = [
    "quarters"
  ];
  public static var level:Int = 1;
  public static var saves:Array<FlxSave> = [];
}
