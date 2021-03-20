package game;

typedef ActorData = {
	public var name:String;
	public var health:Int;
	public var atk:Int;
	public var def:Int;
	public var spd:Int;
	public var sprite:String;
}

typedef MonsterData = {
	> ActorData,
	public var ?points:Int;

	/**
	 * Used for turret enemies
	 */
	public var ?atkSpd:Float;

	/**
	 * Used for turret enemies
	 */
	public var ?range:Float;

	/**
	 * Used for armor on enemies
	 */
	public var armor:Int;

	// public var patrol:Array<FlxPoint>;
}

typedef SceneText = {
	public var text:String;
	/**
	 * Delay in seconds
	 */
	// public var delay:Int;
}

typedef GameState = {
	public var gameTime:Float;
}

/**
 * Handles the data such as player position and any active
 * game switches.
 */
typedef GameSaveState = {
	public var saveIndex:Int;
	public var days:Int;
	public var playerStats:ActorData;
	public var gameTime:Float;
	public var realTime:Float;
	public var playerAffectionLvl:Int;
	public var playerHappinessLvl:Int;
}

typedef GameSettingsSaveState = {
	public var skipMiniGames:Bool;

	/**
	 * Volume from 0 to 1 for 0 - 100%
	 */
	public var volume:Float;
}

enum abstract AnimTypes(String) from String to String {
	public var IDLE:String = 'idle';
	public var MOVE:String = 'move';
	public var DEATH:String = 'death';
}

enum Splash {
	Delay(imageName:String, seconds:Int);
	Click(imageName:String);
	ClickDelay(imageName:String, seconds:Int);
}

/**
 * Rating in Minigames
 * Good - Average Reward
 * Great - Better Reward
 * Amazing - Highest Score Reward
 */
enum Rating {
	Good;
	Great;
	Amazing;
}

enum ElementTypes {
	Fire;
	Water;
	Lightning;
	Magneto;
	Ice;
	Wind;
}

enum ElementalAtk {
	FireAtk(?dmg:Int);
	WaterAtk(?dmg:Int);
	LightningAtk(?dmg:Int);
	MagnetoAtk(?dmg:Int);
	IceAtk(?dmg:Int);
	WindAtk(?dmg:Int);
	PhysAtk(?dmg:Int);
}

/**
 * Elemental Resistances.
 * Elemental resistance of 100 means you will not be affected by the
 * status effect, thus making it impossible to be caught on fire.
 */
enum ElementalResistances {
	FireRes(res:Float);
	WaterRes(res:Float);
	IceRes(res:Float);
	MagneticRes(res:Float);
	LightningRes(res:Float);
	WindRes(res:Float);
	PhysRes(res:Float);
}

/**
 * Status effects applied when the enemy or object in the game world
 * is attacked by a specific element.
 */
enum StatusEffects {
	Burning;
	Icy;
	Frozen;
	Wet;
	Windy;
	Magnetized;
	Charged; // For when hit with electricity
	None;
}

enum ObjectTypes {
	Flammable;
	Pourus; // Affected by
	Iceable;
	Wettable;
	Magnetic;
}

/**
 * Types of enemies in the game.
 */
enum EnemyType {
	FireTurret;
	WaterTurret;
	Rusher;
	SkelArcher;
	Skeleton;
	Ghoul;
}