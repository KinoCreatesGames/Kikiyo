package game.char;

import flixel.math.FlxVelocity;

class Grunt extends Enemy {
	override public function updateMovement(elapsed:Float) {
		if (playerInRange()) {
			FlxVelocity.accelerateTowardsObject(this, player, spd, spd);
		}
	}
}