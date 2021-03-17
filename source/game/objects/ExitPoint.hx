package game.objects;

class ExitPoint extends FlxSprite {
	public function new(x:Float, y:Float) {
		super(x, y);
		setSprite();
	}

	public function setSprite() {
		makeGraphic(16, 16, KColor.ORANGE);
	}
}