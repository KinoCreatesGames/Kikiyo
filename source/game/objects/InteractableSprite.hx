package game.objects;

class InteractableSprite extends FlxSprite {
	public var parent:Interactable;
	public var isTrigger:Bool = false;

	public function new(x:Float, y:Float, interactable:Interactable) {
		super(x, y);
		this.parent = interactable;
	}
}