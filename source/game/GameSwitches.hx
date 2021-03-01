package game;

import haxe.ds.Map;

class GameSwitches {
	public static var switchMap:Map<String, Bool> = [];

	public static function setValue(name:String, val:Bool) {
		switchMap.set(name, val);
	}

	public static function getValue(name:String):Bool {
		return switchMap.get(name);
	}
}