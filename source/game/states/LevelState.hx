package game.states;

class LevelState extends BaseTileState {
	override public function createLevelInfo() {
		trace(DepotData.Actors.lines);
	}

	override public function createUI() {}
}