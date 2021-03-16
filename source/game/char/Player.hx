package game.char;

import flixel.math.FlxVector;

class Player extends Actor {
	public var isInvincible:Bool;
	public var invincibilityTimer:Float;
	public var healthBoostCount:Int = 0;
	public var energy:Int = 3;
	public var energyCap:Int = 4;

	public static inline var INVINCIBLE_TIME:Float = 1.5;

	/**
	 * The amount of health boosters you have to pick up for you
	 * to get your health extended.
	 */
	public static inline var HEALTHBOOSTER_SPLIT:Int = 3;

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
		switch (envStatusEffect) {
			case Burning:
				color = KColor.RED;
			case Icy:
				color = KColor.BEAU_BLUE;
			case Wet:
				color = KColor.BLUE;
			case None:
				color = KColor.WHITE;
			case _:
				// Do nothing
				// color = KColor.WHITE;
		}
	}

	public function startInvincibility() {
		isInvincible = true;
		this.flicker(INVINCIBLE_TIME, 0.04, true, true, (_) -> {
			isInvincible = false;
		});
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

	override public function handleFireAtk(dmg:Int, res:Float) {
		super.handleFireAtk(dmg, res);
	}

	override public function handleWaterAtk(dmg:Int, res:Float) {
		super.handleWaterAtk(dmg, res);
	}

	override public function handleMagnetoAtk(dmg:Int, res:Float) {
		super.handleMagnetoAtk(dmg, res);
	}

	override public function handleIceAtk(dmg:Int, res:Float) {
		super.handleIceAtk(dmg, res);
	}

	override public function handleWindAtk(dmg:Int, res:Float) {
		super.handleWindAtk(dmg, res);
	}

	override public function handleLightningAtk(dmg:Int, res:Float) {
		super.handleLightningAtk(dmg, res);
	}
}