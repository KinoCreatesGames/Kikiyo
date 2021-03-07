package game.objects;

import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;

class Fire extends FlxEmitter {
	public function new(x, y, size:Int) {
		super(x, y, size);
		makeParticles(8, 8, KColor.ORANGE, size);
		// Setup basic fire logic
		solid = true;
		// lifespan.set(0.5, 0.75);
		lifespan.set(0.5);
		launchAngle.set(-120, -60);
		speed.set(50, 50, 150, 150);
		// velocity.set(-30, -30, 30, -30);
		color.set(KColor.LIGHT_ORANGE, KColor.WHITE, KColor.RED, KColor.BLACK);
		angularVelocity.set(0, 150, 300, 450);
		alpha.set(1, 1, 0, 0);
		scale.set(1, 1, 1.5, 1.5, 0.5, 0.5, 0.25, 0.25);
	}
}