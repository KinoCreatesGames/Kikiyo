package;

import game.GameTypes.ActorData;
import haxe.DynamicAccess;

using Lambda;

// Path to your own depot file
@:build(macros.DepotMacros.buildDepotFile('assets/data/database.dpo'))
class DepotData {
	public static function getActors():Map<String, ActorData> {
		var map = new Map<String, ActorData>();
		Actors.lines.iter((line) -> {
			map.set(line.name, cast line);
		});
		return map;
	}
}