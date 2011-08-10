
package maps{

	import game.GameUnit;

	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.*;
	import flash.ui.*;
	import flash.display.Sprite;

	import flash.utils.Timer;
	import flash.events.TimerEvent;
	public class MapObject extends GameUnit {

		//public var graphic;
		//public var dir:int;

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
		//public var range:int;

		//public var commands:Array;
		public function MapObject() {
			conditions = new Array();
			movement="None";
		}

		public function determineActivation():void {
			switch (aTrigger) {
				case "Click" :
					addEventListener(MouseEvent.MOUSE_DOWN, clickHandler);
					break;
				case "Collide" :
					break;
				case "Automatic" :
					break;
				case "Parallel" :
					break;
			}
		}
		public function clickHandler(e:MouseEvent):void {
			addEventListener(Event.ENTER_FRAME, gameHandler);
		}

		override public function gameHandler(e) {
			if (moveCount == 0 && (aTrigger=="Click"||aTrigger=="Collide"||aTrigger=="None")) {
				GameUnit.objectPause=true;
			}
			
			if (! pauseAction&&! superPause&&! menuPause) {
				if (commands.length!=0&&moveCount<commands.length) {
					commands[moveCount]();
				}
				if (moveCount>=commands.length) {
					prevMoveCount=-1;
					moveCount=0;
					if (aTrigger=="Click"||aTrigger=="Collide"||aTrigger=="None") {
						GameUnit.objectPause=false;
						removeEventListener(Event.ENTER_FRAME, gameHandler);
					}
				}
			}
		}
	}
}