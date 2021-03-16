package game.char;

import flixel.math.FlxVelocity;

/**
 * Used for boar like enemy to rush at target quickly
 */
class Rusher extends Enemy {
	public var rushWaitTime:Float = 1.5;

	public static inline var RUSH_WAIT_TIME = 1.5;
	public static inline var RUSH_SPEED:Float = 1200;
	public static inline var RUSH_DRAG = 400;

	public function new(x:Float, y:Float, path:Array<FlxPoint>,
			monsterData:MonsterData) {
		super(x, y, path, monsterData);
		//
		this.drag.x = RUSH_DRAG;
		this.drag.y = RUSH_DRAG;
	}

	override public function idle(elapsed:Float) {
		if (playerInRange()) {
			ai.currentState = rush;
		}
		// Add idle moving around in the area.
	}

	public function rush(elapsed:Float) {
		// on Complete rush
		FlxVelocity.accelerateTowardsObject(this, player, RUSH_SPEED, 600);
		ai.currentState = rushComplete;
	}

	public function rushComplete(elapsed:Float) {
		if (rushWaitTime <= 0) {
			ai.currentState = idle;
			rushWaitTime = RUSH_WAIT_TIME;
		} else {
			rushWaitTime -= elapsed;
		}
	}
}