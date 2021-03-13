package game.char;

import flixel.math.FlxVelocity;

/**
 * Shaders will be applied to replicate certain status effects
 * on enemies and players.
 */
class Enemy extends game.char.Actor {
	public var walkPath:Array<FlxPoint>;
	public var points:Int;

	public function new(x:Float, y:Float, path:Array<FlxPoint>,
			monsterData:MonsterData) {
		super(x, y, monsterData);
		walkPath = path;
		points = monsterData.points;
		elementalAi.currentState = elementalIdle;
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

	public static function createEnemy(x:Float, y:Float, path:Array<FlxPoint>,
			enemyName:String):Enemy {
		switch (enemyName) {
			case EnemyType.FIRE_TURRET:
				return new Turret(x, y, cast DepotData.Enemies_Fire_Turret,
					null);
			case EnemyType.WATER_TURRET:
				return new Turret(x, y, cast DepotData.Enemies_Water_Turret,
					null);
			case _:
				return null;
		}
	}
}