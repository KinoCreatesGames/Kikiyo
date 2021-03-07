package game.states;

import game.objects.Fire;
import game.objects.Torch;

class LevelOneState extends LevelState {
	public var torch:Torch;

	override public function create() {
		super.create();
		createLevel(AssetPaths.LevelOne__tmx);
		torch = new Torch(300, 200, 4);
		add(torch);
	}

	override function processCollision() {
		super.processCollision();

		FlxG.overlap(player, torch.torchLight, playerTouchFire);
		FlxG.overlap(systemicEntitiesGrp, torch.torchLight,
			systemEntityTouchFire);
	}

	public function playerTouchFire(player:Player, fireGrp:Fire) {
		FlxG.camera.shake(0.1, 0.1);
		player.handleElement(FireAtk(0));
		// Do Fire Attack on player
	}

	public function systemEntityTouchFire(entity:SystemicEntity, fire:Fire) {
		entity.handleElement(FireAtk(0));
	}
}