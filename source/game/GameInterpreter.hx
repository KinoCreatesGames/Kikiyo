package game;

import game.ui.MsgWindow;
import flixel.FlxObject;

enum KCommand {
	SendMsg(msg:String, ?name:String, ?face:String);
	Wait(frames:Int);
	PromptChoice(choices:Array<ChoiceType>);
}

enum ChoiceType {
	Choice(choiceStr:String, action:String -> Void);
}

// class Choice {
// 	public var choiceStr:String;
// 	public var action:String -> Void;
// }

class GameInterpreter extends FlxObject {
	public var commandList:Array<KCommand> = [];
	public var currentCommand:KCommand;
	public var wait:Int = 0;
	public var paused:Bool = false;

	public var msgWindow:MsgWindow;

	public function new(x:Float, y:Float) {
		super();
	}

	override public function update(elapsed:Float) {
		if (!commandList.empty() && !paused && wait <= 0) {
			currentCommand = commandList.shift();
			processCommand(currentCommand);
		}

		if (wait >= 0) {
			wait--;
		}
	}

	public function processCommand(command:KCommand) {
		switch (command) {
			case SendMsg(msg, name, face):
				// TODO: Improve messaging system
				msgWindow.sendMessage(msg, name, () -> {
					paused = false;
				});
				paused = true;
			case Wait(frames):
				wait = frames;
			case PromptChoice(choices):
				// TODO: prompt choice
		}
	}

	public function setCommands(commands:Array<KCommand>) {
		commandList = commands;
	}

	public function addCommands(commands:Array<KCommand>) {
		commandList = commandList.concat(commands);
	}

	public function addCommand(command:KCommand) {
		commandList.push(command);
	}

	public function removeCommand(command:KCommand) {
		commandList.remove(command);
	}
}