package;

import game.GameTypes.ActorData;
import haxe.DynamicAccess;

using Lambda;

// Path to your own depot file
@:build(macros.DepotMacros.buildDepotFile('assets/data/database.dpo'))
class DepotData {}