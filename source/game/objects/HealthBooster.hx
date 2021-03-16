package game.objects;

/**
 * Health Booster.
 * When you collect 3, your health goes up by a small amount
 * 5/10 points.
 */
class HealthBooster extends Collectible {
	override public function setSprite() {
		makeGraphic(4, 4, KColor.RED);
	}
}