package game.objects;

class Grass extends SystemicEntity {
	public var burningTimer:Float = 0;
	public var ai:State;

	public static inline var BURN_TIME = 6;

	public var burnt:Bool;

	public function new(x:Float, y:Float) {
		super(x, y);
		ai = new State(idle);
		burnt = false;
		loadGraphic(AssetPaths.grass_out__png, true, 16, 16, true);
		animation.add('idle', [0]);
		animation.add('burning', [1]);
		animation.add('burnt', [2]);
	}

	override public function assignRes() {
		setRes(LightningRes(1.0));
		setRes(MagneticRes(1.0));
		setRes(IceRes(1.0));
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		ai.update(elapsed);
	}

	public function idle(elapsed:Float) {
		if (!burnt && envStatusEffect == Burning) {
			ai.currentState = burning;
		}
	}

	public function burning(elapsed:Float) {
		if (burningTimer >= 0) {
			burningTimer -= elapsed;
			// Change the Sprite Frame with each
			if (burningTimer.withinRangef(1, 4)) {
				animation.play('burning');
			} else if (burningTimer.withinRangef(-1, 1)) {
				animation.play('burnt');
				burnt = true;
			} else {
				animation.play('idle');
			}
		}
	}

	override public function handleFireAtk(dmg:Int, res:Float) {
		super.handleFireAtk(dmg, res);
		if (burningTimer <= 0 && !burnt) {
			burningTimer = BURN_TIME;
		}
	}
}