package game.char;

import flixel.FlxObject;
import flixel.math.FlxVelocity;
import flixel.util.FlxPath;

/**
 * Skeletons are enemies that are faster than Ghouls.
 * They move toward the player and attack them with sword swings similar to the player.
 * 
 */
class Skeleton extends Enemy {
	/**
	 * Attack range player needs to be in for the skeleton to attack.
	 */
	public var attackRange:Float;

	public static inline var ATTACK_CD:Float = 1.5;

	public function new(x:Float, y:Float, data:MonsterData,
			path:Array<FlxPoint>) {
		super(x, y, path, data);
		this.path = new FlxPath(walkPath);
		makeGraphic(16, 16, 0xFFAB00FF);
		this.path.start(null, spd, FlxPath.LOOP_FORWARD);
	}

	override public function idle(elapsed:Float) {
		if (playerInRange()) {
			this.path.cancel();
			ai.currentState = attacking;
		} else {
			var currentPoint = this.path.nodes[this.path.nodeIndex];
			updateFacingRelationToPoint(currentPoint);
		}
	}

	public function attacking(elapsed:Float) {
		if (!playerInRange()) {
			this.path.start(walkPath, spd, FlxPath.LOOP_FORWARD);
			ai.currentState = idle;
		} else {
			FlxVelocity.moveTowardsObject(this, player, spd);
			updateFacingRelationToPoint(player.getPosition());
		}
	}

	public function playerInAttackRange(elapsed:Float) {
		var currentPos = this.getMidpoint();
		// Player In Range to be attacked by the enemy
		if (currentPos.distanceTo(player.getMidpoint()) < attackRange) {}
	}
}