package game.objects;

class Grass extends SystemicEntity {
	public var burnt:Bool;

	public function new(x:Float, y:Float) {
		super(x, y);
		ai = new State(idle);
		elementalAi = new State(elementalIdle);
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
		elementalAi.update(elapsed);
	}

	override public function elementalIdle(elapsed:Float) {
		if (!burnt && envStatusEffect == Burning) {
			ai.currentState = burning;
		}
	}

	override public function burning(elapsed:Float) {
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

		if (envStatusEffect == Wet) {
			ai.currentState = wet;
		}
	}

	override public function wet(elapsed:Float) {
		if (wetTimer >= 0) {
			wetTimer -= elapsed;
		}
		if (envStatusEffect == Burning && wetTimer <= 0) {
			ai.currentState = burning;
		}
	}

	override public function handleFireAtk(dmg:Int, res:Float) {
		super.handleFireAtk(dmg, res);
		if (burningTimer <= 0 && !burnt) {
			burningTimer = SystemicEntity.BURN_TIME;
		}
	}

	override public function handleWaterAtk(dmg:Int, res:Float) {
		super.handleWaterAtk(dmg, res);
		wetTimer = SystemicEntity.WET_TIME;
	}
}