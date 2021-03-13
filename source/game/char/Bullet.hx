package game.char;

class Bullet extends FlxSprite {
	public var atk:Int = 1;
	public var bulletSize:Int = 4;

	public function setBulletType(elAtk:ElementalAtk) {
		switch (elAtk) {
			case FireAtk(dmg):
				atk = dmg;
				makeGraphic(bulletSize, bulletSize, KColor.RED);
			case IceAtk(dmg):
				atk = dmg;
				makeGraphic(bulletSize, bulletSize, KColor.BEAU_BLUE);
			case WaterAtk(dmg):
				atk = dmg;
				makeGraphic(bulletSize, bulletSize, KColor.BLUE);
			case LightningAtk(dmg):
				atk = dmg;
				makeGraphic(bulletSize, bulletSize, KColor.PURPLE);
			case WindAtk(dmg):
				atk = dmg;
				makeGraphic(bulletSize, bulletSize, KColor.GREEN);
			case _:
				// Do nothing
		}
	}
}