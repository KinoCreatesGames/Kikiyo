package game.ui;

class PlayerHUD extends FlxTypedGroup<FlxSprite> {
	public var player:Player;
	public var position:FlxPoint;
	public var healthText:FlxText;
	public var healthBar:FlxBar;

	public function new(x:Float, y:Float, player:Player) {
		super();
		this.player = player;
		position = new FlxPoint(x, y);
		create();
	}

	public function create() {
		createHealth();
	}

	public function createHealth() {
		var pos = position;
		var padding = 12;
		healthBar = new FlxBar(pos.x + padding, pos.y + padding,
			LEFT_TO_RIGHT, 64, 16, player, 'health', 0, player.health);
		healthBar.createFilledBar(KColor.RICH_BLACK_FORGRA,
			KColor.PRETTY_PINK, true, KColor.LIGHT_ORANGE);
		healthText = new FlxText(healthBar.x, healthBar.y, -1,
			'${player.health}', Globals.FONT_N);
		healthText.x = (healthBar.x
			+ (healthBar.width / 2)
			- (healthText.width / 2));
		add(healthBar);
		add(healthText);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		updateHUD();
	}

	public function updateHUD() {
		updateHealth();
	}

	public function updateHealth() {
		healthText.text = '${player.health}';
		healthText.x = (healthBar.x
			+ (healthBar.width / 2)
			- (healthText.width / 2));
	}
}