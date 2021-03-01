package game.char;

class Player extends Actor {
	public function new(x:Float, y:Float, actorData:ActorData) {
		super(x, y, actorData);
	}

	override public function assignStats() {
		super.assignStats();
	}

	override public function update(elapsed:Float) {}
}