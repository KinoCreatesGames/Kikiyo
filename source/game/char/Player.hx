package game.char;

import flixel.math.FlxVector;

class Player extends Actor {
	public var isInvincible:Bool;
	public var invincibilityTimer:Float;
	public var healthBoostCount:Int = 0;
	public var energy:Int = 3;
	public var energyCap:Int = 4;
	public var smallSword:FlxSprite;
	public var largeSword:FlxSprite;
	public var playerBullets:FlxTypedGroup<Bullet>;
	public var lsFrameCount:Int = 0;
	public var ssFrameCount:Int = 0;

	public static inline var INVINCIBLE_TIME:Float = 1.5;
	public static inline var SMALL_SWORD_WIDTH:Int = 16;
	public static inline var LARGE_SWORD_WIDTH:Int = 48;

	public static inline var SS_ACTIVE_FRAME = 6;
	public static inline var LS_ACTIVE_FRAME = 6;

	/**
	 * The amount of health boosters you have to pick up for you
	 * to get your health extended.
	 */
	public static inline var HEALTHBOOSTER_SPLIT:Int = 3;

	public static inline var DRAG:Float = 1600;
	public static inline var MAX_VELOCITY:Float = 300;

	public function new(x:Float, y:Float, actorData:ActorData) {
		super(x, y, actorData);
		create();
	}

	public function create() {
		makeGraphic(16, 16, KColor.WHITE);
		drag.x = drag.y = DRAG;
		maxVelocity.set(MAX_VELOCITY, MAX_VELOCITY);
		createWeaponHBoxes();
	}

	override public function assignStats() {
		super.assignStats();
	}

	public function createWeaponHBoxes() {
		var x = x + (this.width / 2);
		var y = y + (this.height);

		smallSword = new FlxSprite(x, y);
		smallSword.makeGraphic(SMALL_SWORD_WIDTH, 16, KColor.YELLOW);
		largeSword = new FlxSprite(x, y);
		largeSword.makeGraphic(LARGE_SWORD_WIDTH, 16, KColor.PRETTY_PINK);

		smallSword.drag.x = smallSword.drag.y = DRAG;
		smallSword.maxVelocity.set(MAX_VELOCITY, MAX_VELOCITY);
		smallSword.visible = false;

		largeSword.drag.x = largeSword.drag.y = DRAG;
		largeSword.maxVelocity.set(MAX_VELOCITY, MAX_VELOCITY);
		largeSword.visible = false;
	}

	public function addWeaponHBoxes() {
		FlxG.state.add(smallSword);
		FlxG.state.add(largeSword);
	};

	override public function update(elapsed:Float) {
		super.update(elapsed);
		updateMovement(elapsed);
		updateStatusEffectResponse(elapsed);
		updateCombat(elapsed);
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

			smallSword.velocity.set(this.spd, 0);
			smallSword.velocity.rotate(FlxPoint.weak(0, 0), newAngle);
			largeSword.velocity.set(this.spd, 0);
			largeSword.velocity.rotate(FlxPoint.weak(0, 0), newAngle);
		}
	}

	public function updateCombat(elapsed:Float) {
		var lightHit = FlxG.keys.anyJustPressed([Z]);
		var heavyHit = FlxG.keys.anyJustPressed([X]);

		if (lightHit) {
			smallSword.visible = true;
			ssFrameCount = SS_ACTIVE_FRAME;
		}

		if (heavyHit) {
			largeSword.visible = true;
			lsFrameCount = LS_ACTIVE_FRAME;
		}

		if (ssFrameCount <= 0) {
			smallSword.visible = false;
		}

		if (ssFrameCount > 0) {
			ssFrameCount -= 1;
		}

		if (lsFrameCount <= 0) {
			largeSword.visible = false;
		}
		if (lsFrameCount >= 0) {
			lsFrameCount -= 1;
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

	override public function setPosition(x:Float = 0, y:Float = 0) {
		setWeaponPositions(x, y);
		super.setPosition(x, y);
	}

	public function setWeaponPositions(x:Float, y:Float) {
		var origPos = this.getMidpoint();
		var offX = 8;
		var offY = 8;
		origPos.x -= offX;
		origPos.y -= offY;
		var smallSwordOffset = new FlxPoint(smallSword.x - origPos.x,
			smallSword.y - origPos.y);
		smallSwordOffset.x -= offX;
		smallSword.setPosition(x + smallSwordOffset.x, y + smallSwordOffset.y);
		var largeSwordOffSet = new FlxPoint(largeSword.x - origPos.x,
			largeSword.y - origPos.y);
		largeSwordOffSet.x -= (LARGE_SWORD_WIDTH / 3) + offX;
		largeSword.setPosition(x + largeSwordOffSet.x, y + largeSwordOffSet.y);
	}
}