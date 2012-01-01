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
		
		//public var range:int;

		//public var commands:Array;
		public function ExternalMapObject() {
			graphic = "None";
			dir = 2;
			conditions = new Array();
			speed = 0;
			wait = 0;
			xTile = 0;
			yTile = 0;
			moveWait = 0;
			aTrigger = "None";
			range = 0;
			commands = new Array();
			movement="None";
		}
	}
}