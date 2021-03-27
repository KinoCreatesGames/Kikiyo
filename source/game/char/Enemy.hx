package game.char;

import flixel.math.FlxMath;
import flixel.math.FlxAngle;
import flixel.math.FlxVector;
import flixel.FlxObject;
import flixel.math.FlxVelocity;

/**
 * Shaders will be applied to replicate certain status effects
 * on enemies and players.
 */
class Enemy extends game.char.Actor {
	public var walkPath:Array<FlxPoint>;
	public var points:Int;
	public var player:Player;
	public var range:Float;
	public var armor:Int;
	public var atkSpd:Float;
	public var isHit:Bool;

	public static inline var HIT_TIME:Float = 0.5;
	// TODO: Add Smooth dampening to knockback so it's not as jerky
	public static inline var KNOCKBACK_FORCE:Float = 1000;

	public function new(x:Float, y:Float, path:Array<FlxPoint>,
			monsterData:MonsterData) {
		super(x, y, monsterData);
		walkPath = path;
		points = monsterData.points;
	}

	override public function assignStats() {
		super.assignStats();
		var monData:MonsterData = cast data;
		atkSpd = monData.atkSpd;
		range = monData.range;
		armor = monData.armor;
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		ai.update(elapsed);
		elementalAi.update(elapsed);
		updateMovement(elapsed);
	}

	public function updateMovement(elapsed:Float) {}

	override public function handleFireAtk(dmg:Int, res:Float) {
		super.handleFireAtk(dmg, res);
	}

	public function playerInRange():Bool {
		var currPlayer = null;
		if (player != null) {
			if (player.getMidpoint().distanceTo(this.getMidpoint()) < range
				&& player.alive) {
				currPlayer = player;
			}
		}
		return currPlayer != null ? true : false;
	}

	public function takeDamage(damage:Int, attackFacing:Int) {
		// Knock Back Target
		knockback(attackFacing);
		health -= damage;
		isHit = true;
		this.flicker(HIT_TIME, 0.04, true, true, (_) -> {
			isHit = false;
		});
		if (health <= 0) {
			this.kill();
		}
	}

	public function knockback(facing:Int) {
		var angle = FlxAngle.angleFromFacing(facing);
		var vel = FlxPoint.get(FlxMath.fastCos(angle) * KNOCKBACK_FORCE,
			FlxMath.fastSin(angle) * KNOCKBACK_FORCE);
		vel.x = vel.x * -1;
		vel.y = vel.y * -1;
		switch (facing) {
			case FlxObject.LEFT:
			// var vel = FlxVelocity.velocityFromFacing(this, this.spd * 2);
			// this.velocity.subtractPoint(vel);
			case FlxObject.RIGHT:

			case FlxObject.UP:

			case FlxObject.DOWN:
		}

		this.velocity.subtractPoint(vel);
	}

	public static function createEnemy(x:Float, y:Float, player,
			bulletGrp:FlxTypedGroup<Bullet>, path:Array<FlxPoint>,
			enemyType:EnemyType):Enemy {
		// Using Return Statements in the switch case returns the whole
		// function
		var enemy = switch (enemyType) {
			case FireTurret:
				new Turret(x, y, cast DepotData.Enemies_Fire_Turret, bulletGrp);
			case WaterTurret:
				new Turret(x, y, cast DepotData.Enemies_Water_Turret,
					bulletGrp);

			case Ghoul:
				new Ghoul(x, y, cast DepotData.Enemies_Ghoul, path);
			case _:
				null;
		}
		if (enemy != null) {
			enemy.player = player;
		}
		return enemy;
	}

	public function updateFacingRelationToPoint(point:FlxPoint) {
		var copy = point.copyTo(FlxPoint.weak(0, 0));
		var heightDiff = 30;
		var diffPoint = copy.subtractPoint(this.getPosition());
		var left = diffPoint.x < 0;
		var right = diffPoint.x > 0;
		var up = diffPoint.y < heightDiff.negate();
		var down = diffPoint.y > heightDiff;
		if (up) {
			facing = FlxObject.UP;
		} else if (down) {
			facing = FlxObject.DOWN;
		} else if (left) {
			facing = FlxObject.LEFT;
		} else if (right) {
			facing = FlxObject.RIGHT;
		}
	}
}