package game.states;

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
	}

	override function processLevel(elapsed) {}

	override public function tilesetPath():String {
		return AssetPaths.floor_tileset__png;
	}
}