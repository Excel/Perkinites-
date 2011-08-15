package ui{

	import flash.text.TextField;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.*;
	import flash.filters.GlowFilter;
	import flash.ui.Keyboard;

	import abilities.*;
	import actors.*;
	import game.*;
	import maps.*;
	import util.FunctionUtils;
	
	public class DecisionDisplay extends MovieClip {

		public var stageRef:Stage;
		public var commandsArray:Array;
		public var gameObject:GameUnit;
		
		public var optionsArray:Array;
		
		public var commands:Array;
		public var prevMoveCount:int;
		public var moveCount:int;
		
		function DecisionDisplay(stageRef:Stage, answersArray:Array, commandsArray:Array, gameObject:GameUnit) {
			this.stageRef = stageRef;
			this.commandsArray = commandsArray;
			this.gameObject = gameObject;
			
			this.optionsArray = new Array(choice1, choice2, choice3, choice4);
			x = 320-150;
			y = 186;
			for (var i = 0; i < answersArray.length; i++) {
				optionsArray[i].visible = true;
				optionsArray[i].choice.text = answersArray[i];
				optionsArray[i].mouseChildren = false;
				optionsArray[i].addEventListener(MouseEvent.MOUSE_OVER, overHandler);
				optionsArray[i].addEventListener(MouseEvent.MOUSE_OUT, outHandler);
				optionsArray[i].addEventListener(MouseEvent.CLICK, clickHandler);
			}
			for (i = i; i < optionsArray.length; i++) {
				optionsArray[i].visible = false;
			}
			
			stageRef.addChild(this);
			
		}
		
		function overHandler(e) {
			var gf1=new GlowFilter(0xFFFFFF,100,10,10,1,10,false,false);
			e.target.filters=[gf1];
		}
		function outHandler(e) {
			e.target.filters=[];
		}		
		function clickHandler(e) {
			parent.removeChild(this);
			var message = gameObject.messagebox;
			if (message.parent != null) {
				message.parent.removeChild(message);
			}
			prevMoveCount = gameObject.prevMoveCount;
			moveCount = gameObject.moveCount+1;
			commands = gameObject.commands;
			gameObject.swapActions(-1, 0, commandsArray[optionsArray.indexOf(e.target)]);
			var func = FunctionUtils.thunkify(gameObject.swapActions, prevMoveCount, moveCount, commands);
			gameObject.commands.push(func);
		}
	}
}