package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flash.geom.Point;
import flixel.system.FlxSound;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.PS4ButtonID;
import flash.display.BlendMode;

class Player extends FlxSprite
{
  public static var START_X:Float = 60;
  public static var START_Y:Float = 60;

  public static var WALL_LEFT:Int = 1 << 1;
  public static var WALL_RIGHT:Int = 1 << 2;
  public static var WALL_UP:Int = 1 << 3;
  public static var WALL:Int = WALL_LEFT|WALL_RIGHT|WALL_UP;

  public static var COLORS = [0xff800080, 0xff008080, 0xff808000];

  public static var RUN_SPEED:Float = 200;

  private var _speed:Point;
  private var _gravity:Float = 600; 

  private var _jumpPressed:Bool = false;
  private var _grounded:Bool = false;
  private var _jumping:Bool = false;
  private var _landing:Bool = false;
  private var _justLanded:Bool = false;

  private var _groundedTimer:Float = 0;
  private var _groundedThreshold:Float = 0.07;
  
  private var collisionFlags:Int = 0;

  private var jumpTimer:Float = 0;
  private var jumpThreshold:Float = 0.1;

  public var dead:Bool = false;

  public var lockedToFlags:Int = 0;

  public var jumpAmount:Float = 300;

  private var gamepad:FlxGamepad;

  private var deadTimer:Float = 0;
  private var deadThreshold:Float = 0.4;
  private var flying = false;

  public var bulletGroup:BulletGroup;
  public var fireRate:Float = 0.05;
  public var fireTimer:Float = 0.05;
  public var autoFire:Bool = true;//false;
  public var bulletScale:Float = 2;
  private var _firePressed:Bool = false;

  var jumpSound:FlxSound;
  var shootSound:FlxSound;
  var playerIndex:Int;

  public function new(X:Float=0,Y:Float=0,playerIndex:Int=0) {
    super(X,Y);
    this.playerIndex = playerIndex;

    scale.x = scale.y = 0.5;
    gamepad = FlxG.gamepads.getByID(playerIndex);

    loadGraphic("assets/images/player.png", true, 32, 32);
    animation.add("idle", [0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 2, 2], 15, true);
    animation.add("run", [6, 7, 8, 9, 10, 11], 15, true);
    animation.add("run from landing", [10, 11, 6, 7, 8, 9], 15, true);
    animation.add("jump start", [12], 15, true);
    animation.add("jump peak", [13], 15, true);
    animation.add("jump fall", [14], 15, true);
    animation.add("jump land", [9], 15, false);
    animation.add("die", [18]);
    animation.play("idle");

    width = 12;
    height = 20;

    offset.y = 12;
    offset.x = 10;

    _speed = new Point();
    _speed.y = 215;
    _speed.x = 600;

    acceleration.y = _gravity;

    maxVelocity.y = 325;
    maxVelocity.x = RUN_SPEED;

    jumpSound = FlxG.sound.load("assets/sounds/jump.wav");
    shootSound = FlxG.sound.load("assets/sounds/shoot.wav");
    setFacingFlip(FlxObject.LEFT, true, false);
    setFacingFlip(FlxObject.RIGHT, false, false);

    color = COLORS[playerIndex];
    blend = BlendMode.ADD;

    bulletGroup = new BulletGroup(color);
  }

  public function init():Void {
    x = START_X;
    y = START_Y;

    _jumpPressed = false;
    _grounded = false;
    _jumping = false;
    _landing = false;
    _justLanded = false;

    _groundedTimer = 0;
    collisionFlags = 0;

    jumpTimer = 0;

    lockedToFlags = 0;

    velocity.x = velocity.y = 0;
    acceleration.x = 0;
    acceleration.y = _gravity;
    exists = true;

    facing = FlxObject.RIGHT;
  }

  public function playRunAnim():Void {
    if(!_jumping && !_landing) {
      if(_justLanded) animation.play("run from landing");
      else animation.play("run");
    }
  }

  override public function update(elapsed:Float):Void {
    if(!dead) {
      //Check for jump input, allow for early timing
      jumpTimer += elapsed;
      if(jumpJustPressed()) {
        _jumpPressed = true;
        jumpTimer = 0;
        _grounded = false;
      }
      if(jumpTimer > jumpThreshold) {
        _jumpPressed = false;
      }

      fireTimer += elapsed;
      if(fireJustPressed() || (autoFire && firePressed())) {
        _firePressed = true;
      }
      if(fireTimer > fireRate && _firePressed) {
        _firePressed = false;
        fireTimer = 0;
        bulletGroup.fireBullet(x, y, facing == FlxObject.RIGHT ? 1 : -1, autoFire ? 15 : 0, bulletScale);
        velocity.x += (facing == FlxObject.RIGHT ? -75 : 75) * bulletScale;
        //shootSound.play();
        FlxG.sound.play("assets/sounds/shoot" + playerIndex + ".wav", 0.3);
      }

      if(collidesWith(WALL_UP)) {
        if(!_grounded) {
          animation.play("jump land");
          _landing = true;
          _justLanded = true;
        }
        _grounded = true;
        _jumping = false;
        _groundedTimer = 0;
      } else {
        _groundedTimer += elapsed;
        if(_groundedTimer >= _groundedThreshold) {
          _grounded = false;
        }
      }

      if(_landing && animation.finished) {
        _landing = false;
      }

      if(leftPressed()) {
        acceleration.x = -_speed.x * (velocity.x > 0 ? 4 : 1);
        facing = FlxObject.LEFT;
        playRunAnim();
      } else if(rightPressed()) {
        acceleration.x = _speed.x * (velocity.x < 0 ? 4 : 1);
        facing = FlxObject.RIGHT;
        playRunAnim();
      } else if (Math.abs(velocity.x) < 50) {
        if(!_jumping && !_landing) animation.play("idle");
        velocity.x = 0;
        acceleration.x = 0;
        _justLanded = false;
      } else {
        _justLanded = false;
        var drag:Float = 3;
        if (velocity.x > 0) {
          acceleration.x = -_speed.x * drag;
        } else if (velocity.x < 0) {
          acceleration.x = _speed.x * drag;
        }
      }

      if(_jumpPressed) {
          if(_grounded) {
            jumpSound.play();
            animation.play("jump start");
            _jumping = true;
            velocity.y = -_speed.y;
            _jumpPressed = false;
          }
      }

      if(velocity.y < -1) {
        if(jumpPressed() && velocity.y > -25) {
          animation.play("jump peak");
        }
      } else if (velocity.y > 1) {
        if(velocity.y > 100) {
          animation.play("jump fall");
        }
      }


      if(FlxG.keys.pressed.LEFT) {
        jumpAmount--;
      }
      if(FlxG.keys.pressed.RIGHT) {
        jumpAmount++;
      }
          
      if(!jumpPressed() && velocity.y < 0)
        acceleration.y = _gravity * 3;
      else
        acceleration.y = _gravity;
    } else {
      deadTimer += elapsed;
      if(deadTimer >= deadThreshold && !flying) {
        velocity.y = -125;
        acceleration.y = 400;
        flying = true;
      }
    }
    super.update(elapsed);
  }

  public function jumpPressed():Bool {
    return FlxG.keys.pressed.W ||
           FlxG.keys.pressed.SPACE ||
           FlxG.keys.pressed.UP ||
           (gamepad != null && gamepad.pressed(PS4ButtonID.X));
  }

  public function jumpJustPressed():Bool {
    return FlxG.keys.justPressed.W ||
           FlxG.keys.justPressed.SPACE ||
           FlxG.keys.justPressed.UP ||
           (gamepad != null && gamepad.justPressed(PS4ButtonID.X));
  }

  public function leftPressed():Bool {
    return FlxG.keys.pressed.A ||
           FlxG.keys.pressed.LEFT ||
           (gamepad != null && gamepad.getXAxis(PS4ButtonID.LEFT_ANALOG_STICK) < 0) ||
           (gamepad != null && gamepad.hat.x < 0);
  }

  public function rightPressed():Bool {
    return FlxG.keys.pressed.D ||
           FlxG.keys.pressed.RIGHT ||
           (gamepad != null && gamepad.getXAxis(PS4ButtonID.LEFT_ANALOG_STICK) > 0) ||
           (gamepad != null && gamepad.hat.x > 0);
  }

  public function firePressed():Bool {
    return FlxG.keys.pressed.T ||
           (gamepad != null && gamepad.pressed(PS4ButtonID.SQUARE));
  }

  public function fireJustPressed():Bool {
    return FlxG.keys.justPressed.T ||
           (gamepad != null && gamepad.justPressed(PS4ButtonID.SQUARE));
  }

  public function resetFlags():Void {
    collisionFlags = 0;
  }

  public function die():Void {
    animation.play("die");
    deadTimer = 0;
    dead = true;
    acceleration.y = acceleration.x = velocity.x = velocity.y = 0;
  }

  public function setCollidesWith(bits:Int):Void {
    collisionFlags |= bits;
  }

  public function collidesWith(bits:Int):Bool {
    return (collisionFlags & bits) > 0;
  }
}
