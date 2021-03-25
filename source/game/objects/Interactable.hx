package game.objects;

class Interactable extends FlxTypedGroup<FlxSprite> {
	/**
	 * ID of the Interaction, this would be an Int
	 		* This would be in the LDTk map data.
	 */
	public var id:Int;

	/**
	 * Name of the Interactable; this would be in camel case
	 		* This would be in the LDTk map.
	 */
	public var name:String;

	/**
	 * Description of what the interaction is about
	 		* This would also be in the LDTk map data.
	 */
	public var description:String;

	public var activation:InteractableActivation;
	public var priority:InteractablePriority;

	public var sprite:InteractableSprite;
	public var interactionCollider:InteractableSprite;
	public var position:FlxPoint;

	public function new(x:Float, y:Float, activation:InteractableActivation,
			priority:InteractablePriority) {
		super();
		this.priority = priority;
		this.activation = activation;
		trace(this.priority);
		position = new FlxPoint(x, y);
		setupInteraction();
	}

	/**
	 * Sets up an interaction with additional information
	 * using the Event ID and picking it
	 * from the database.
	 * This would add information such as the sprite and commands.
	 */
	public function setupInteraction() {
		var width = 16;
		var height = 16;
		var interactionSpace = 3;
		sprite = new InteractableSprite(position.x, position.y, this);
		sprite.immovable = true;
		sprite.makeGraphic(width + interactionSpace,
			height + interactionSpace, KColor.TRANSPARENT);
		sprite.isTrigger = true;
		interactionCollider = new InteractableSprite(sprite.x, sprite.y, this);
		interactionCollider.makeGraphic(width, height, KColor.PRETTY_PINK);
		interactionCollider.immovable = true;
		add(sprite);
		add(interactionCollider);
	}

	/**
	 * Overridden method for triggering interactions 
	 * depending on the type of class.
	 */
	public function triggerInteraction() {
		trace('Triggered Interaction');
	}
}