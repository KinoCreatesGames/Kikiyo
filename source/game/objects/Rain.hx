package game.objects;

import flixel.effects.particles.FlxEmitter;

class Rain extends FlxEmitter {
	public static inline var BASE_RAIN:Int = 2500;

	/**
	 * Creates rain on the in game screen.
	 * @param x 
	 * @param y 
	 * @param intensitiy 
	 */
	public function new(x:Float, y:Float, intensitiy:Float = 1.0) {
		super(x, y);

		makeParticles(2, 8, KColor.WHITE, Math.floor(BASE_RAIN * intensitiy));
		setSize(400, height);
		solid = true;
		lifespan.set(0.85, 1.25);
		launchAngle.set(90, 90);
		var rainAccl = 400;
		speed.set(rainAccl);
		// acceleration.set(0, rainAccl, 0, rainAccl, 0, rainAccl, 0, rainAccl);
		// color.set(KColor.WHITE, KColor.WINTER_SKY, KColor.WINTER_SKY,
		// KColor.WHITE);
		alpha.set(1, 1);
		scale.set(1, 0.25, 1, 1.25);
	}
}