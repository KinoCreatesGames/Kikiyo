package game.states;

class LevelOneState extends LevelState {
	override public function create() {
		super.create();
		createLevel(AssetPaths.LevelOne__tmx);
	}
}