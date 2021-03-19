package game.char;

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

	public function new(x:Float, y:Float, path:Array<FlxPoint>,
			monsterData:MonsterData) {
		super(x, y, monsterData);
		walkPath = path;
		points = monsterData.points;
		elementalAi.currentState = elementalIdle;
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

	public static function createEnemy(x:Float, y:Float, player,
			bulletGrp:FlxTypedGroup<Bullet>, path:Array<FlxPoint>,
			enemyName:String):Enemy {
		var enemy = switch (enemyName) {
			case EnemyType.FIRE_TURRET:
				new Turret(x, y, cast DepotData.Enemies_Fire_Turret, bulletGrp);
			case EnemyType.WATER_TURRET:
				return new Turret(x, y, cast DepotData.Enemies_Water_Turret,
					bulletGrp);
			case _:
				null;
		}
		if (enemy != null) {
			enemy.player = player;
		}
		return enemy;
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

	public function takeDamage(damage:Int) {
		health -= damage;
		isHit = true;
		this.flicker(HIT_TIME, 0.04, true, true, (_) -> {
			isHit = false;
		});
		if (health <= 0) {
			this.kill();
		}
	}
}