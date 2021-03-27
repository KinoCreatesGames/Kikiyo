package game.char;

import flixel.util.FlxPath;
import flixel.math.FlxVelocity;

/**
 * Archer type enemy that patrols a set location.
 */
class Archer extends Enemy {
	public var bullets:FlxTypedGroup<Bullet>;
	public var fireSound:FlxSound;
	public var fireCD:Float;

	public static inline var PROJECTILE_SPEED:Float = 600;

	public function new(x:Float, y:Float, data:MonsterData,
			path:Array<FlxPoint>, bulletGrp:FlxTypedGroup<Bullet>) {
		super(x, y, path, data);
		fireCD = 0;
		this.path = new FlxPath(walkPath);
		makeGraphic(16, 16, KColor.EMERALD);
		this.path.start(null, spd, FlxPath.LOOP_FORWARD);
		// fireSound = FlxG.sound
		bullets = bulletGrp;
	}

	override public function assignStats() {
		super.assignStats();
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
	}

	override public function idle(elapsed:Float) {
		if (playerInRange()) {
			ai.currentState = attack;
		} else {
			var currentPoint = this.path.nodes[this.path.nodeIndex];
			updateFacingRelationToPoint(currentPoint);
		}
		animation.play('idle');
		handleCD(elapsed);
	}

	public function attack(elapsed:Float) {
		if (playerInRange()) {
			updateFacingRelationToPoint(player.getPosition());
			fireAtPlayer();
			animation.play('fire');
		} else {
			this.path.cancel();
			ai.currentState = idle;
		}
		handleCD(elapsed);
	}

	/**
	 * Fires at the enemy using the acceleration 
	 * in their direction.
	 */
	public function fireAtPlayer() {
		if (fireCD >= atkSpd) {
			fireSound.play();
			var bullet = bullets.recycle(Bullet);
			bullet.setBulletType(bulletType());
			bullet.setPosition(this.getMidpoint().x, y);
			bullet.velocity.set(0, 0);
			FlxVelocity.accelerateTowardsObject(bullet, this.player,
				PROJECTILE_SPEED, PROJECTILE_SPEED);
			bullets.add(bullet);
			fireCD = 0;
		}
	}

	public function handleCD(elapsed:Float) {
		if (fireCD >= atkSpd) {
			fireCD = atkSpd;
		}
		fireCD += elapsed;
	}

	public function bulletType():ElementalAtk {
		switch (name) {
			// case FIRE_TURRET:
			// 	return FireAtk(atk);
			// case WATER_TURRET:
			// 	return WaterAtk(atk);

			case _:
				return PhysAtk(atk);
		}
	}
}