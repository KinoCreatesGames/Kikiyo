package game;

import haxe.ds.Map;

class GameVariables {
	public static var switchMap:Map<String, Any> = [];

	public static function setValue(name:String, val:Any) {
		switchMap.set(name, val);
	}

	public static function getValue(name:String):Any {
		return switchMap.get(name);
	}
}