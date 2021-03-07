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
		updateStatusEffectResponse(elapsed);
	}

	public function updateStatusEffectResponse(elapsed:Float) {
		if (envStatusEffect == Burning) {
			// Change Color to Red
			color = KColor.RED;
		}
	}

	public function updateMovement(elapsed) {
		var down = FlxG.keys.anyPressed([DOWN, S]);
		var up = FlxG.keys.anyPressed([UP, W]);
		var left = FlxG.keys.anyPressed([LEFT, A]);
		var right = FlxG.keys.anyPressed([RIGHT, D]);
		var direction = new FlxVector(0, 0);
		var newAngle:Float = 0;
		if (up || down || left || right) {
			if (up) {
				newAngle = -90;
				if (left) {
					newAngle -= 45;
				} else if (right) {
					newAngle += 45;
				}
			} else if (down) {
				newAngle = 90;
				if (left) {
					newAngle += 45;
				} else if (right) {
					newAngle -= 45;
				}
			} else if (left) {
				newAngle = 180;
			} else if (right) {
				newAngle = 0;
			}
			velocity.set(this.spd, 0);
			velocity.rotate(FlxPoint.weak(0, 0), newAngle);
		}
	}
}