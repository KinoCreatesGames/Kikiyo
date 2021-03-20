package game.char;

import flixel.util.FlxPath;
import flixel.math.FlxVelocity;

class Ghoul extends Enemy {
	public function new(x:Float, y:Float, data:MonsterData,
			path:Array<FlxPoint>) {
		super(x, y, path, data);
		this.path = new FlxPath(walkPath);
		makeGraphic(16, 16, KColor.BLACK);
		this.path.start(null, spd, FlxPath.LOOP_FORWARD);
	}

	override public function idle(elapsed:Float) {
		if (playerInRange()) {
			this.path.cancel();
			ai.currentState = attacking;
		}
	}

	public function attacking(elapsed:Float) {
		if (playerInRange()) {
			FlxVelocity.moveTowardsObject(this, player, spd);
		} else {
			this.path.start(walkPath, spd, FlxPath.LOOP_FORWARD);
			ai.currentState = idle;
		}
	}
}