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
		ai.currentState = idle;
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		ai.update(elapsed);
		updateMovement(elapsed);
	}

	public function updateMovement(elapsed:Float) {}

	override public function handleFireAtk(dmg:Int, res:Float) {
		super.handleFireAtk(dmg, res);
	}
}