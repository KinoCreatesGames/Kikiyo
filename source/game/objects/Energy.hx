package game.objects;

/**
 * Energy. This is used to restore the amount of energy
 * you have in game. 
 */
class Energy extends Collectible {
	override public function setSprite() {
		makeGraphic(4, 4, KColor.WHITE);
	}
}