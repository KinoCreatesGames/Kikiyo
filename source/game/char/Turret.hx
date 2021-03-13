package game.char;

import flixel.math.FlxVelocity;

class Turret extends Enemy {
	public var atkSpd:Float;
	public var range:Float;
	public var bullets:FlxTypedGroup<Bullet>;
	public var player:Player;
	public var fireSound:FlxSound;
	public var fireCD:Float;

	public static inline var PROJECTILE_SPEED:Float = 600;

	public function new(x:Float, y:Float, data:MonsterData,
			bulletGrp:FlxTypedGroup<Bullet>) {
		super(x, y, null, data);
		fireCD = 0;
		fireSound = FlxG.sound.load(AssetPaths.bullet_fire__wav);
		bullets = bulletGrp;
	}

	override public function assignStats() {
		super.assignStats();
		var monData:MonsterData = cast data;
		atkSpd = monData.atkSpd;
		range = monData.range;
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
	}

	override public function idle(elapsed:Float) {
		var player = playerInRange();
		if (player != null) {
			ai.currentState = attack;
		}
		animation.play('idle');
		handleCD(elapsed);
	}

	public function attack(elapsed:Float) {
		var player = playerInRange();
		if (player != null) {
			fireAtPlayer();
			animation.play('fire');
		} else {
			ai.currentState = idle;
		}
		handleCD(elapsed);
	}

	/**
	 * Fires at the enemy using the acceleration 
	 * in their direction.
	 */
	public function fireAtPlayer() {
		var player = playerInRange();
		if (fireCD >= atkSpd) {
			fireSound.play();
			var bullet = bullets.recycle(Bullet);
			bullet.setBulletType(PhysAtk(1));
			bullet.setPosition(this.getMidpoint().x, y);
			bullet.velocity.set(0, 0);
			FlxVelocity.accelerateTowardsObject(bullet, player,
				PROJECTILE_SPEED, PROJECTILE_SPEED);
			bullets.add(bullet);
			fireCD = 0;
		}
	}

	public function playerInRange():Player {
		var currPlayer = null;
		if (player != null) {
			if (player.getMidpoint().distanceTo(this.getMidpoint()) < range
				&& player.alive) {
				currPlayer = player;
			}
		}
		return currPlayer;
	}

	public function handleCD(elapsed:Float) {
		if (fireCD >= atkSpd) {
			fireCD = atkSpd;
		}
		fireCD += elapsed;
	}
}