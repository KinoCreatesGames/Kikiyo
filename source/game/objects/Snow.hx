package game.objects;

import flixel.effects.particles.FlxEmitter;

class Snow extends FlxEmitter {
	public static inline var BASE_SNOW:Int = 2500;

	public function new(x:Float, y:Float, intensity:Float = 1.0) {
		super(x, y);
		makeParticles(2, 2, KColor.WHITE, Math.floor(BASE_SNOW * intensity));

		solid = true;
		setSize(FlxG.width, height);
		lifespan.set(0.85, 3);
		launchAngle.set(90, 105);
		speed.set(150, 200, 100, 250);
		scale.set(0.5, 0.5, 1, 1);
	}
}