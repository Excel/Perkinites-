
package maps{

	import game.GameUnit;
	
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.*;
	import flash.ui.*;
	import flash.display.Sprite;

	import flash.utils.Timer;
	import flash.events.TimerEvent;
	public class MapEvent extends GameUnit {

		//public var graphic;
		//public var dir:int;
		public var pos:String;
		
		public var conditions:Array;
		
		public var movement:String;
		//public var speed:Number;
		//public var wait:int;

		/**
		 * How to activate the GameUnit
		 * 0 - Click on it/press C
		 * 1 - Run over it
		 * 2 - Automatically activates
		 * 3 - Runs in parallel
		 */
		public var aTrigger:String;
		//public var range:int;
		
		//public var commands:Array;
		public function MapEvent(){
			aTrigger = "None";
			pos = "(0,0)";
			conditions = new Array();
			movement = "None";
			
		}
	}
}