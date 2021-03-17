package game.states;

import game.objects.HealthBooster;
import game.objects.Energy;
import game.objects.Collectible;
import game.ui.MsgWindow;
import game.ui.PlayerHUD;
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
	public var collectiblesGrp:FlxTypedGroup<Collectible>;
	public var hud:PlayerHUD;
	public var msgWindow:MsgWindow;
	// Could be generic later if necessary
	public var enemyBulletGrp:FlxTypedGroup<Bullet>;
	public var fireGrp:Fire;
	public var rainGrp:Rain;
	public var snowGrp:Snow;

	public static inline var REGION_TILESET_NAME = 'Regions';
	public static inline var SPAWN_TILE = 25;
	public static inline var GRASS_TILE = 26;
	public static inline var ENERGY_TILE = 27;
	public static inline var HEALTHBOOSTER_TILE = 28;

	override public function createLevelInfo() {
		var tileLayer:TiledTileLayer = cast(map.getLayer('Level'));
		player = new Player(60, 60, cast DepotData.Actors_Kikiyo);
		// Setup Player Camera
		FlxG.camera.follow(player, TOPDOWN, 0.5);
		createLevelMap(tileLayer);
		createRegionEntities();
		createEnemies();
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
			switch (tile) {
				case SPAWN_TILE:
					player.x = coords.x;
					player.y = coords.y;

				case GRASS_TILE:
					systemicEntitiesGrp.add(new Grass(coords.x, coords.y));
				case ENERGY_TILE:
					collectiblesGrp.add(new Energy(coords.x, coords.y));
				case HEALTHBOOSTER_TILE:
					collectiblesGrp.add(new HealthBooster(coords.x, coords.y));
			}
		}
	}

	public function createEnemies() {
		var tileLayer:TiledObjectLayer = cast(map.getLayer('Enemy'));

		tileLayer.objects.iter((enemy) -> {
			var enemyName = enemy.properties.get('name');
			// TODO: Add Pathing variable for enemies with paths
			var newEnemy:Enemy = Enemy.createEnemy(enemy.x, enemy.y, player,
				enemyBulletGrp, null, enemyName);
			enemyGrp.add(newEnemy);
		});
	}

	override public function createGroups() {
		super.createGroups();
		systemicEntitiesGrp = new FlxTypedGroup<SystemicEntity>();
		enemyBulletGrp = new FlxTypedGroup<Bullet>();
		collectiblesGrp = new FlxTypedGroup<Collectible>();
	}

	override public function addGroups() {
		super.addGroups();
		add(systemicEntitiesGrp);
		add(collectiblesGrp);
		add(player);
		add(enemyBulletGrp);
		add(msgWindow);
		add(hud);
	}

	override public function createUI() {
		createMsgWindow();
		createPlayerHUD();
	}

	public function createMsgWindow() {
		var x = (FlxG.width / 2) - (MsgWindow.WIDTH / 2);
		var y = FlxG.height - MsgWindow.HEIGHT;
		msgWindow = new MsgWindow(x, y);
	}

	public function createPlayerHUD() {
		hud = new PlayerHUD(0, 0, player);
	}

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
		FlxG.overlap(player, collectiblesGrp, playerTouchCollectible);
	}

	public function enemyTouchPlayer(enemy:Enemy, player:Player) {
		FlxG.camera.shake(0.1, 0.1);
		if (enemy.health <= 0) {
			enemy.kill();
		}
		// Touching an enemy always does 1 damage
		if (!player.isInvincible) {
			player.health -= 1;
			player.startInvincibility();
		}

		if (player.health <= 0) {
			player.kill();
		}
	}

	public function playerTouchFire(player:Player, fireGrp:Fire) {
		FlxG.camera.shake(0.1, 0.1);
		player.handleElement(FireAtk(0));
		// Do Fire Attack on player
		player.startInvincibility();
	}

	public function playerTouchRain(player:Player, rainGrp:Rain) {
		player.handleElement(WaterAtk(0));
	}

	public function playerTouchSnow(player:Player, snowGrp:Snow) {
		player.handleElement(IceAtk(0));
	}

	public function playerTouchCollectible(player:Player,
			collectible:Collectible) {
		switch (Type.getClass(collectible)) {
			case Energy:
				player.energy = (player.energy + 1).clamp(0, player.energyCap);
			case HealthBooster:
				player.healthBoostCount += 1;
		}
		collectible.kill();
		trace('Energy Count', player.energy);
		trace('HealthBoosterCount', player.healthBoostCount);
	}

	override function processLevel(elapsed) {}

	override public function tilesetPath():String {
		return AssetPaths.floor_tileset__png;
	}
}