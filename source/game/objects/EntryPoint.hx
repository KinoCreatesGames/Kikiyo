package game.objects;

class EntryPoint extends FlxSprite {
	public function new(x:Float, y:Float) {
		super(x, y);
		setSprite();
	}

	public function setSprite() {
		makeGraphic(16, 16, KColor.PURPLE);
	}
}