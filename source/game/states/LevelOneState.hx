package game.states;

import game.objects.Snow;
import game.objects.Rain;
import game.objects.Fire;
import game.objects.Torch;

class LevelOneState extends LevelState {
	public var torch:Torch;
	public var rain:Rain;
	public var snow:Snow;

	override public function create() {
		super.create();
		createLevel(AssetPaths.LevelOne__tmx);
		torch = new Torch(300, 200, 4);
		rain = new Rain(0, -100, 1);
		// rain.start(false, 0.0125, 0);
		snow = new Snow(0, -100, 1);
		snow.start(false, 0.035, 0);
		add(rain);
		add(torch);
		add(snow);
	}

	override function processCollision() {
		super.processCollision();
		if (FlxG.keys.anyJustPressed([Z])) {
			rain.emitting = false;
		}

		FlxG.overlap(player, torch.torchLight, playerTouchFire);
		FlxG.overlap(systemicEntitiesGrp, torch.torchLight,
			systemEntityTouchFire);
		FlxG.overlap(systemicEntitiesGrp, rain, systemEntityTouchRain);
	}

	public function playerTouchFire(player:Player, fireGrp:Fire) {
		FlxG.camera.shake(0.1, 0.1);
		player.handleElement(FireAtk(0));
		// Do Fire Attack on player
	}

	public function systemEntityTouchFire(entity:SystemicEntity, fire:Fire) {
		entity.handleElement(FireAtk(0));
	}

	public function systemEntityTouchRain(entity:SystemicEntity, rain:Rain) {
		entity.handleElement(WaterAtk(0));
	}
}