package game.states;

import game.objects.Snow;
import game.objects.Rain;
import game.objects.Fire;
import game.objects.Grass;
import flixel.FlxObject;
import flixel.tile.FlxBaseTilemap.FlxTilemapAutoTiling;
import flixel.tile.FlxTilemap;
import flixel.addons.editors.tiled.TiledTileSet;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.addons.editors.tiled.TiledMap;

class LevelState extends BaseTileState {
	public var player:Player;
	public var systemicEntitiesGrp:FlxTypedGroup<SystemicEntity>;
	// Could be generic later if necessary
	public var fireGrp:Fire;
	public var rainGrp:Rain;
	public var snowGrp:Snow;

	public static inline var REGION_TILESET_NAME = 'Regions';
	public static inline var GRASS_TILE = 26;

	override public function createLevelInfo() {
		var tileLayer:TiledTileLayer = cast(map.getLayer('Level'));
		player = new Player(60, 60, cast DepotData.Actors_Kikiyo);
		createLevelMap(tileLayer);
		createRegionEntities();
	}

	/**
	 * Creates grass and other system entities 
	 		* using regions in LDTk from Integer Grid.
	 */
	public function createRegionEntities() {
		var tileset:TiledTileSet = cast(map.getTileSet(REGION_TILESET_NAME));
		var tileLayer:TiledTileLayer = cast(map.getLayer('Regions'));
		var regionLevel = new FlxTilemap();
		regionLevel.loadMapFromArray(tileLayer.tileArray, map.width,
			map.height, AssetPaths.Regions__intgrid__png, map.tileWidth,
			map.tileHeight, FlxTilemapAutoTiling.OFF, tileset.firstGID, 1);

		for (index in 0...regionLevel.getData().length) {
			var coords = regionLevel.getTileCoordsByIndex(index, false);
			var tile = regionLevel.getTileByIndex(index);
			// Grass = 26 from Data
			if (tile == GRASS_TILE) {
				systemicEntitiesGrp.add(new Grass(coords.x, coords.y));
			}
		}
	}

	override public function createGroups() {
		super.createGroups();
		systemicEntitiesGrp = new FlxTypedGroup<SystemicEntity>();
	}

	override public function addGroups() {
		super.addGroups();
		add(systemicEntitiesGrp);
		add(player);
	}

	override public function createUI() {}

	override function processCollision() {
		super.processCollision();
		processPlayerCollisions();
	}

	public function processPlayerCollisions() {
		FlxG.overlap(enemyGrp, player, enemyTouchPlayer);
		// Weather Handling for game
		FlxG.overlap(player, fireGrp, playerTouchFire);
		FlxG.overlap(player, rainGrp, playerTouchRain);
		FlxG.overlap(player, snowGrp, playerTouchSnow);
	}

	public function enemyTouchPlayer(enemy:Enemy, player:Player) {
		FlxG.camera.shake(0.1, 0.1);
		if (enemy.health <= 0) {
			enemy.kill();
		}

		if (player.health <= 0) {
			player.kill();
		}
	}

	public function playerTouchFire(player:Player, fireGrp:Fire) {
		FlxG.camera.shake(0.1, 0.1);
		player.handleElement(FireAtk(0));
		// Do Fire Attack on player
	}

	public function playerTouchRain(player:Player, rainGrp:Rain) {
		player.handleElement(WaterAtk(0));
	}

	public function playerTouchSnow(player:Player, snowGrp:Snow) {
		player.handleElement(IceAtk(0));
	}

	override function processLevel(elapsed) {}

	override public function tilesetPath():String {
		return AssetPaths.floor_tileset__png;
	}
}