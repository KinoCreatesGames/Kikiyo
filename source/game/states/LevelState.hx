package game.states;

import flixel.FlxObject;
import flixel.tile.FlxBaseTilemap.FlxTilemapAutoTiling;
import flixel.tile.FlxTilemap;
import flixel.addons.editors.tiled.TiledTileSet;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.addons.editors.tiled.TiledMap;

class LevelState extends BaseTileState {
	public var player:Player;

	override public function createLevelInfo() {
		var tileLayer:TiledTileLayer = cast(map.getLayer('Level'));
		player = new Player(60, 60, cast DepotData.Actors_Kikiyo);

		createLevelMap(tileLayer);
	}

	override public function addGroups() {
		super.addGroups();
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