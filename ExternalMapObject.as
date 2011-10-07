package{ 
	import actors.Unit;
	import game.GameUnit;
	import game.GameVariables;
	
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.*;
	import flash.ui.*;
	import flash.display.Sprite;

	import flash.utils.Timer;
	import flash.events.TimerEvent;
	public class ExternalMapObject extends MovieClip{

		public var graphic;
		public var dir:int;

		public var conditions:Array;

		public var movement:String;
		public var speed:Number;
		public var wait:int;
		
		public var xTile;
		public var yTile;
		
		public var moveWait;
		public var aTrigger;
		public var range;
		
		public var commands;
		/**
		 * How to activate the GameUnit
		 * 0 - Click on it/press C
		 * 1 - Run over it
		 * 2 - Automatically activates
		 * 3 - Runs in parallel
		 */
		//public var range:int;

		//public var commands:Array;
		public function ExternalMapObject() {
			conditions = new Array();
			commands = new Array();
			movement="None";
		}
	}
}