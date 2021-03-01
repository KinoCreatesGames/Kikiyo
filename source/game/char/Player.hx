package game.char;

import flixel.math.FlxVector;

class Player extends Actor {
	public function new(x:Float, y:Float, actorData:ActorData) {
		super(x, y, actorData);
		create();
	}

	public function create() {
		makeGraphic(16, 16, KColor.WHITE);
		drag.x = drag.y = 1600;
		maxVelocity.set(300, 300);
	}

	override public function assignStats() {
		super.assignStats();
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		updateMovement(elapsed);
	}

	public function updateMovement(elapsed) {
		var down = FlxG.keys.anyPressed([DOWN, S]);
		var up = FlxG.keys.anyPressed([UP, W]);
		var left = FlxG.keys.anyPressed([LEFT, A]);
		var right = FlxG.keys.anyPressed([RIGHT, D]);
		var direction = new FlxVector(0, 0);
		if (up) {
			direction.y = -1;
		} else if (down) {
			direction.y = 1;
		}

		if (left) {
			direction.x = -1;
		} else if (right) {
			direction.x = 1;
		}
		velocity.set(this.spd * direction.x, this.spd * direction.y);
		trace(velocity);
	}
}