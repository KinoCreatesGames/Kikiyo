package game.ui;

import flixel.addons.text.FlxTypeText;

class MsgWindow extends FlxTypedGroup<FlxSprite> {
	public var position:FlxPoint;
	public var background:FlxSprite;
	public var nextArrow:FlxSprite;
	public var text:FlxTypeText;
	public var borderSize:Float;
	public var faceSprite:FlxSprite;

	public static inline var WIDTH:Int = 400;
	public static inline var HEIGHT:Int = 200;
	public static inline var BGCOLOR:Int = KColor.RICH_BLACK;
	public static inline var FONTSIZE:Int = 12;

	public var initialTextLocation:FlxPoint;

	public function new(x:Float, y:Float) {
		super();
		position = new FlxPoint(x, y);
		borderSize = 4;
		create();
	}

	public function create() {
		createBackground(position);
		createDownArrow(position);
		createFace(position);
		createText(position);
	}

	public function createBackground(positioin:FlxPoint) {
		background = new FlxSprite(position.x, position.y);
		// Have to use make graphic first in order to actually draw Rects
		background.makeGraphic(WIDTH, HEIGHT, BGCOLOR);

		background.drawRect(0, 0, WIDTH, HEIGHT, KColor.WHITE);
		background.drawRect(borderSize, borderSize, WIDTH - borderSize * 2,
			HEIGHT - borderSize * 2, BGCOLOR);
		add(background);
	}

	public function createDownArrow(position:FlxPoint) {
		var margin = 32 + borderSize;
		var y = (position.y + HEIGHT) - margin;
		var x = (position.x + WIDTH) - margin;

		nextArrow = new FlxSprite(x, y);
		nextArrow.loadGraphic(AssetPaths.dialog_arrow__png, true, 32, 32);
		nextArrow.animation.add('spin', [0, 1, 2, 3, 4, 5, 6], 6, true);
		nextArrow.visible = false;
		add(nextArrow);
	}

	public function createFace(position:FlxPoint) {
		var padding = 12;
		var x = position.x + padding + borderSize;
		var y = position.y + padding + borderSize;
		faceSprite = new FlxSprite(x, y);
		add(faceSprite);
	}

	public function createText(position:FlxPoint) {
		var x = position.x + 12 + borderSize;
		var y = position.y + 12 + borderSize;
		text = new FlxTypeText(x, y, cast WIDTH - (12 + borderSize),
			'Test Text', FONTSIZE);
		text.wordWrap = true;
		initialTextLocation = text.getPosition().copyTo(new FlxPoint());
		add(text);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
	}

	public function sendMessage(text:String, ?speakerName:String,
			?face:String, ?callBack:Void -> Void) {
		// Adjust text if face is present otherwise move back
		if (face != null) {
			// face is the path to the face image file.
			faceSprite.loadGraphic(face);
			faceSprite.visible = true;
			this.text.x += faceSprite.width;
		} else {
			this.text.x = initialTextLocation.x;
			this.faceSprite.visible = false;
		}

		if (speakerName != null) {
			this.text.resetText('${speakerName}: ${text}');
		} else {
			this.text.resetText('${text}');
		}
		// Next arrow becomes invisible.
		nextArrow.visible = false;
		nextArrow.animation.stop();
		this.text.start(0.05, false, false, null, () -> {
			trace('Play Arrow');
			nextArrow.visible = true;
			nextArrow.animation.play('spin');
			callBack();
		});
	}

	public function show() {
		visible = true;
	}

	public function hide() {
		visible = false;
	}
}