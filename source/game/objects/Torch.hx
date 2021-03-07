package game.objects;

import flixel.FlxBasic;
import flixel.effects.particles.FlxEmitter.FlxTypedEmitter;

/**
 * Torch created using a FlxBasic Typed Group
 * Used to emit particles from the torch light source.
 */
class Torch extends FlxTypedGroup<FlxBasic> {
	public var torchBase:FlxSprite;
	public var torchLight:Fire; // TODO: Turn this into fire
	public var position:FlxPoint;

	public function new(x:Float, y:Float, size:Int) {
		super(size);
		position = new FlxPoint(x, y);
		torchBase = new FlxSprite(x, y + 8);
		torchBase.makeGraphic(8, 8, KColor.RICH_BLACK, true);
		torchLight = new Fire(torchBase.x + torchBase.width / 2, torchBase.y,
			200);
		add(torchLight);
		add(torchBase);
		torchLight.start(false, 0.1, 0);
	}
}