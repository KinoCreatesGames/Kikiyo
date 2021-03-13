package game.char;

/**
 * Base object for things in the game world to be affected by
 * different elements and react to them in different ways.
 * This will control them switching between different
 * status effects when touched.
 * 
 * This will not handle their personal state management to
 * each effect.
 * 
 * For example grass will be inflicted by burning, but
 * grass the class will handle removing the burning
 * and showcasing the change in their state.
 */
class SystemicEntity extends FlxSprite {
	public var envStatusEffect:StatusEffects;
	public var fireRes:Float = 0.5;
	public var waterRes:Float = 0.5;
	public var iceRes:Float = 0.5;
	public var windRes:Float = 0.5;
	public var magneticRes:Float = 0.5;
	public var lightningRes:Float = 0.5;
	public var physRes:Float = 0.5;

	public var burningTimer:Float = 0;
	public var wetTimer:Float = 0;
	public var iceyTimer:Float = 0;
	public var freezeTimer:Float = 0;
	public var chargedTimer:Float = 0;

	public static inline var BURN_TIME = 6;
	public static inline var WET_TIME = 6;
	public static inline var ICE_TIME = 6;
	public static inline var FREEZE_TIME = 3;
	public static inline var CHARGE_TIME = 6;

	public var elementalAi:State;
	public var ai:State;

	public function new(x:Float, y:Float) {
		super(x, y);
		envStatusEffect = None;
		elementalAi = new State(elementalIdle);
		ai = new State(idle);
		assignRes();
	}

	/**
	 * Assigns the resistances of the Systemic Entity;
	 * By Default all resistances are set to 50/100 0.5
	 		* Override this function to update resistances on an systemic object.
	 */
	public function assignRes() {}

	/**
	 * Allows you to set the resistance of an element by passing
	 		* in the enum/ADT value.
	 * @param res  ElementalResistance
	 */
	public function setRes(res:ElementalResistances) {
		switch (res) {
			case FireRes(res):
				fireRes = res;
			case WaterRes(res):
				waterRes = res;
			case IceRes(res):
				iceRes = res;
			case WindRes(res):
				windRes = res;
			case MagneticRes(res):
				magneticRes = res;
			case LightningRes(res):
				lightningRes = res;
			case PhysRes(res):
				physRes = res;
		}
	}

	/**
	 * Idle function for enemies and actors.
	 * @param elapsed 
	 */
	public function idle(elapsed:Float) {}

	/**
	 * Handles Elemental Infliction for each element.
	 		* Also handles element status effect being inflicted
	 		* on an individual.
	 * @param elementAtk 
	 */
	public function handleElement(elementAtk:ElementalAtk) {
		var inflictEl = (resistance:Float) -> resistance < 1;
		// Inflicts the handler if the resistance of the element is
		// less than one.
		var inflictAction = (canExecute:Bool, dmg:Int, res:Float,
			fn:(Int, Float) -> Void) -> fn(dmg, res);
		switch (elementAtk) {
			case FireAtk(dmg):
				inflictAction(inflictEl(fireRes), dmg, fireRes, handleFireAtk);
			case WaterAtk(dmg):
				inflictAction(inflictEl(waterRes), dmg, waterRes,
					handleWaterAtk);

			case LightningAtk(dmg):
				inflictAction(inflictEl(lightningRes), dmg, lightningRes,
					handleLightningAtk);

			case MagnetoAtk(dmg):
				inflictAction(inflictEl(magneticRes), dmg, magneticRes,
					handleMagnetoAtk);

			case IceAtk(dmg):
				inflictAction(inflictEl(iceRes), dmg, iceRes, handleIceAtk);

			case WindAtk(dmg):
				inflictAction(inflictEl(windRes), dmg, windRes, handleWindAtk);

			case PhysAtk(dmg):
				inflictAction(inflictEl(physRes), dmg, physRes, handlePhysAtk);
		}
	}

	/**
	 * Handles for fire atk, can be overridden
	 		* to add extra logic for fire atks.
	 * @param dmg 
	 * @param res 
	 */
	public function handleFireAtk(dmg:Int, res:Float) {
		if (envStatusEffect == Wet) {
			// Do nothing
		} else {
			envStatusEffect = Burning;
			if (burningTimer <= 0) {
				burningTimer = BURN_TIME;
			}
		}
		this.health -= calculateElementalDamage(dmg, res);
	}

	/**
	 * Handler for water atks; can be overridden
	 		* to add extra logic for water atks.
	 * @param dmg 
	 * @param res 
	 */
	public function handleWaterAtk(dmg:Int, res:Float) {
		if (envStatusEffect == Icy) {
			envStatusEffect = Frozen;
			freezeTimer = FREEZE_TIME;
		} else {
			envStatusEffect = Wet;
			wetTimer = WET_TIME;
		}
		this.health -= calculateElementalDamage(dmg, res);
	}

	/**
	 * Handler for lightning atks; can be overriden 
	 		* to add extra logic for lightning atks.
	 * @param dmg 
	 * @param res 
	 */
	public function handleLightningAtk(dmg:Int, res:Float) {
		envStatusEffect = Charged;
		this.health -= calculateElementalDamage(dmg, res);
		chargedTimer = CHARGE_TIME;
	}

	/**
	 * Handlers for magnetized/magneto attacks; can be overidden
	 		* to add extra logic for magneto atks.
	 * @param dmg 
	 * @param res 
	 */
	public function handleMagnetoAtk(dmg:Int, res:Float) {
		envStatusEffect = Magnetized;
		this.health -= calculateElementalDamage(dmg, res);
	}

	/**
	 * Handles the dmg based on the resistance and adds the
	 		* status effect.
	 * @param dmg 
	 * @param res 
	 */
	public function handleIceAtk(dmg:Int, res:Float) {
		if (envStatusEffect == Wet) {
			envStatusEffect = Frozen;
			freezeTimer = FREEZE_TIME;
		} else if (envStatusEffect == Burning) {
			// Do nothing
		} else {
			envStatusEffect = Icy;
			iceyTimer = ICE_TIME;
		}
		this.health -= calculateElementalDamage(dmg, res);
	}

	/**
	 * Handles the dmg based on the resistance adds the
	 		* status effect.
	 * @param dmg 
	 * @param res 
	 */
	public function handleWindAtk(dmg:Int, res:Float) {
		envStatusEffect = Windy;
		this.health -= calculateElementalDamage(dmg, res);
	}

	/**
	 * Handles the dmg based on the resistance and doesn't have any
	 		* particular status effect.
	 * @param dmg 
	 * @param res 
	 */
	public function handlePhysAtk(dmg:Int, res:Float) {
		this.health -= calculateElementalDamage(dmg, res);
	}

	/**
	 * Used to calculate the damage. Should be used in the 
	 		* handlers for creating the final damage number based on your
	 		* systemic entity. Meaning grass shouldn't take damage, the same way
	 		* enemies will.
	 * @param dmg 
	 * @param res 
	 * @return Int
	 */
	public function calculateElementalDamage(dmg:Int, res:Float):Int {
		var resLeft = 1 - res;
		return Math.floor(dmg * resLeft);
	}

	// Elemental States

	public function elementalIdle(elapsed:Float) {
		switch (envStatusEffect) {
			case Burning:
				elementalAi.currentState = burning;
			case Wet:
				elementalAi.currentState = wet;
			case Frozen:
				elementalAi.currentState = frozen;
			case Icy:
				elementalAi.currentState = icey;
			case Charged:
				elementalAi.currentState = charged;
			case _:
				// Do nothing
		}
	}

	public function burning(elapsed:Float) {
		// Drains fixed amount of hp every second
		if (burningTimer >= 0) {
			burningTimer -= elapsed;
		}
		if (burningTimer % 1 == 0) {
			health -= 1;
		}

		if (burningTimer <= 0) {
			envStatusEffect = None;
			elementalAi.currentState = elementalIdle;
		}
	}

	public function wet(elapsed:Float) {
		if (wetTimer >= 0) {
			wetTimer -= elapsed;
		}
		if (wetTimer <= 0) {
			envStatusEffect = None;
			elementalAi.currentState = elementalIdle;
		}
	}

	public function charged(elapsed:Float) {
		if (chargedTimer >= 0) {
			chargedTimer -= elapsed;
		}

		if (chargedTimer <= 0) {
			envStatusEffect = None;
			elementalAi.currentState = elementalIdle;
		}
	}

	public function icey(elapsed:Float) {
		if (iceyTimer >= 0) {
			iceyTimer -= elapsed;
		}
		if (iceyTimer <= 0) {
			elementalAi.currentState = elementalIdle;
			envStatusEffect = None;
		}
	}

	public function frozen(elapsed:Float) {
		if (freezeTimer >= 0) {
			freezeTimer -= elapsed;
		}

		if (freezeTimer <= 0) {
			envStatusEffect = None;
			elementalAi.currentState = elementalIdle;
		}
	}
}