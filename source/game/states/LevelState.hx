package game.states;

import game.objects.InteractableSprite;
import game.objects.Interactable;
import game.objects.ExitPoint;
import game.objects.EntryPoint;
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
	public var entranceGrp:FlxTypedGroup<EntryPoint>;
	public var exitGrp:FlxTypedGroup<ExitPoint>;
	public var hud:PlayerHUD;
	public var msgWindow:MsgWindow;
	public var interpreter:GameInterpreter;
	// Could be generic later if necessary
	public var enemyBulletGrp:FlxTypedGroup<Bullet>;
	public var playerBulletGrp:FlxTypedGroup<Bullet>;
	public var fireGrp:Fire;
	public var rainGrp:Rain;
	public var snowGrp:Snow;

	/**
	 * Checkpoint position is established when entering
	 * the level for the first time.
	 */
	public var checkPointPos:FlxPoint;

	/**
	 * Interactable Grp when overlap is called actually splits the
	 * group contents into individual FlxSprites and processes them
	 * individually. Therefore, we need to update the type of FlxSprites
	 * within our new Interactable Group.
	 */
	public var interactableGrp:FlxTypedGroup<Interactable>;

	public static inline var REGION_TILESET_NAME = 'Regions';
	public static inline var SPAWN_TILE = 25;
	public static inline var GRASS_TILE = 26;
	public static inline var ENERGY_TILE = 27;
	public static inline var HEALTHBOOSTER_TILE = 28;
	public static inline var ENTER_POINT_TITLE = 29;
	public static inline var EXIT_POINT_TILE = 30;

	override public function createLevelInfo() {
		var tileLayer:TiledTileLayer = cast(map.getLayer('Level'));
		player = new Player(60, 60, cast DepotData.Actors_Kikiyo);
		// Setup Player Camera
		FlxG.camera.follow(player, TOPDOWN, 0.5);
		createLevelMap(tileLayer);
		createRegionEntities();
		createInteractables();
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
					player.setPosition(coords.x, coords.y);
				case GRASS_TILE:
					systemicEntitiesGrp.add(new Grass(coords.x, coords.y));
				case ENERGY_TILE:
					collectiblesGrp.add(new Energy(coords.x, coords.y));
				case HEALTHBOOSTER_TILE:
					collectiblesGrp.add(new HealthBooster(coords.x, coords.y));
				case ENTER_POINT_TITLE:
					entranceGrp.add(new EntryPoint(coords.x, coords.y));
				case EXIT_POINT_TILE:
					exitGrp.add(new ExitPoint(coords.x, coords.y));
			}
		}
	}

	public function createInteractables() {
		var tileLayer:TiledObjectLayer = cast(map.getLayer('Interactables'));

		tileLayer.objects.iter((obj) -> {
			var priority = InteractablePriority.createByName(obj.properties.get('priority'));

			var activation = InteractableActivation.createByName(obj.properties.get('activation'));
			var newInteractable = new Interactable(obj.x, obj.y, activation,
				priority);
			trace(interactableGrp);
			trace(newInteractable.priority);
			interactableGrp.add(newInteractable);
		});
	}

	public function createEnemies() {
		var tileLayer:TiledObjectLayer = cast(map.getLayer('Enemy'));

		tileLayer.objects.iter((enemy) -> {
			var enemyType = enemy.properties.get('enemytype');

			var path = [];
			for (key => value in enemy.properties.keys) {
				if (key.contains('path')) {
					var xy = enemy.properties.get(key)
						.split(",")
						.map((val) -> Std.parseInt(val));
					path.push(new FlxPoint(xy[0] * map.tileWidth,
						xy[1] * map.tileHeight));
				}
			}

			var newEnemy:Enemy = Enemy.createEnemy(enemy.x, enemy.y, player,
				enemyBulletGrp, path, EnemyType.createByName(enemyType));
			enemyGrp.add(newEnemy);
		});
	}

	override public function createGroups() {
		super.createGroups();
		systemicEntitiesGrp = new FlxTypedGroup<SystemicEntity>();
		enemyBulletGrp = new FlxTypedGroup<Bullet>();
		playerBulletGrp = new FlxTypedGroup<Bullet>();
		collectiblesGrp = new FlxTypedGroup<Collectible>();
		interactableGrp = new FlxTypedGroup<Interactable>();
		exitGrp = new FlxTypedGroup<ExitPoint>();
		entranceGrp = new FlxTypedGroup<EntryPoint>();
	}

	override public function addGroups() {
		super.addGroups();
		add(systemicEntitiesGrp);
		add(collectiblesGrp);
		add(player);
		player.addWeaponHBoxes();
		player.playerBullets = playerBulletGrp;
		add(entranceGrp);
		add(exitGrp);
		add(playerBulletGrp);
		add(interactableGrp);
		add(enemyBulletGrp);
		add(msgWindow);
		add(hud);
	}

	override public function createUI() {
		createMsgWindow();
		createPlayerHUD();
		createInterpreter();
	}

	public function createMsgWindow() {
		var x = (FlxG.width / 2) - (MsgWindow.WIDTH / 2);
		var y = FlxG.height - MsgWindow.HEIGHT;
		msgWindow = new MsgWindow(x, y);
		msgWindow.hide();
	}

	public function createInterpreter() {
		interpreter = new GameInterpreter(0, 0);
		interpreter.msgWindow = msgWindow;
		interpreter.addCommand(SendMsg('Hello World', 'Kino'));
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
		FlxG.overlap(player, entranceGrp, playerTouchEntryPoint);
		FlxG.overlap(player, exitGrp, playerTouchExitPoint);
		FlxG.overlap(player.smallSword, enemyGrp, playerWeaponLightTouch);
		FlxG.overlap(player.largeSword, enemyGrp, playerWeaponLargeTouch);
		FlxG.overlap(player.playerBullets, enemyGrp, playerBulletTouchEnemy);
		FlxG.overlap(player.smallSword, systemicEntitiesGrp,
			playerSWeaponTouch);
		FlxG.overlap(player.largeSword, systemicEntitiesGrp,
			playerLWeaponTouch);
		FlxG.overlap(player, interactableGrp, playerTouchInteractable);
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

	public function playerWeaponLightTouch(playerWeapon:FlxSprite,
			enemy:Enemy) {
		if (playerWeapon.visible && !enemy.isHit && enemy.armor <= 0) {
			enemy.takeDamage(1, player.facing);
		}
	}

	public function playerWeaponLargeTouch(playerWeapon:FlxSprite,
			enemy:Enemy) {
		if (playerWeapon.visible && !enemy.isHit) {
			if (enemy.armor > 0) {
				enemy.armor = (enemy.armor - 1).clamp(0, Globals.MAX_INT_VALUE);
				enemy.takeDamage(0, player.facing);
			} else {
				enemy.takeDamage(1, player.facing);
			}
		}
	}

	public function playerLWeaponTouch(playerWeapon:FlxSprite,
			entity:SystemicEntity) {
		if (playerWeapon.visible) {
			switch (Type.getClass(entity)) {
				case Grass:
					entity.kill();
				case _:
					// Do nothing for now
			}
		}
	}

	public function playerSWeaponTouch(playerWeapon:FlxSprite,
			entity:SystemicEntity) {
		if (playerWeapon.visible) {
			switch (Type.getClass(entity)) {
				case Grass:
					entity.kill();
				case _:
					// Do nothing for now
			}
		}
	}

	public function playerTouchInteractable(player:Player,
			interactableSpr:InteractableSprite) {
		if (interactableSpr.isTrigger) {
			var interactable = interactableSpr.parent;
			switch (interactable.priority) {
				case Above:
				// Do nothing
				case Below:
				// Do nothing
				case Same:
					FlxObject.separate(player,
						interactable.interactionCollider);
			}
			switch (interactable.activation) {
				case ButtonPress:
					if (FlxG.keys.anyJustPressed([E])) {
						// Trigger Interaction
						interactable.triggerInteraction();
					}
				case Touch:
					interactable.triggerInteraction();
			}
		}
	}

	/**
	 * Made to be overridden on a level to level basis for defining exits and entrances.
	 */
	public function playerTouchEntryPoint(player:Player,
		entryPoint:EntryPoint) {}

	/**
	 * Made to be overriden on a level to level basis for defining exits and entrances
	 * during gameplay.
	 */
	public function playerTouchExitPoint(player:Player, exitPoint:ExitPoint) {}

	public function playerBulletTouchEnemy(bullet:Bullet, enemy:Enemy) {
		enemy.takeDamage(bullet.atk, player.facing);
	}

	override function processLevel(elapsed) {
		interpreter.update(elapsed);
		processLevelState(elapsed);
	}

	public function processLevelState(elapsed:Float) {
		if (!player.alive) {
			gameOver = true;
		} else {
			gameOver = false;
		}
	}

	override public function tilesetPath():String {
		return AssetPaths.floor_tileset__png;
	}
}