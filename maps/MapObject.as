
package maps{

	import actors.Unit;
	import game.GameUnit;
	import game.GameVariables;
	
	import ui.Target;

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
			addEventListener(Event.ENTER_FRAME, detectHandler);
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
			GameVariables.mapObject = this;			
			Unit.currentUnit.range = range;
			Unit.partnerUnit.range = range;
			addEventListener(Event.ENTER_FRAME, rangeHandler);
		}
		
		public function stopFocus():void {
			removeEventListener(Event.ENTER_FRAME, rangeHandler);
			GameVariables.mapObject = null;
		}
		
		public function forceActivation():void {
			
		}
		public function forceAppear():void {
			
		}
		
		public function rangeHandler(e:Event):void {
			if ((Unit.currentUnit.HP <= 0 || (Unit.currentUnit.HP > 0 && Unit.currentUnit.checkDistance(x, y) <= range)) && 
			(Unit.partnerUnit.HP <= 0 || (Unit.partnerUnit.HP > 0 && Unit.partnerUnit.checkDistance(x, y) <= range))) {		
				GameVariables.mapObject = null;
				removeEventListener(Event.ENTER_FRAME, rangeHandler);
				addEventListener(Event.ENTER_FRAME, gameHandler);
			}
			else{
				if (Unit.currentUnit.HP > 0 && Unit.currentUnit.checkDistance(x, y) <= range && Unit.currentUnit.moving) {
					Unit.currentUnit.moving = false;
					Unit.currentUnit.mxpos=Unit.currentUnit.x;
					Unit.currentUnit.mypos=Unit.currentUnit.y;
					Unit.currentUnit.range = 0;
					Unit.currentUnit.path = [];					
				}
				if (Unit.partnerUnit.HP > 0 && Unit.partnerUnit.checkDistance(x, y) <= range && Unit.partnerUnit.moving){
					Unit.partnerUnit.moving = false;
					Unit.partnerUnit.mxpos=Unit.partnerUnit.x;
					Unit.partnerUnit.mypos=Unit.partnerUnit.y;
					Unit.partnerUnit.range = 0;
					Unit.partnerUnit.path = [];
				}
			}
		}

		override public function detectHandler(e:Event):void {
			if(aTrigger=="Click"||aTrigger=="Collide"||aTrigger=="None"){
				if(this.hitTestPoint(GameVariables.stageRef.mouseX, GameVariables.stageRef.mouseY) && parent != null){
					GameVariables.mouseMapObject = true;
				}
				else{
					GameVariables.mouseMapObject = false;
				}
			}
		}

		override public function gameHandler(e) {
			if (moveCount == 0 && (aTrigger=="Click"||aTrigger=="Collide"||aTrigger=="None")) {
				GameUnit.objectPause = true;
				Unit.currentUnit.moving = false;
				Unit.currentUnit.range = 0;
				Unit.currentUnit.mxpos=Unit.currentUnit.x;
				Unit.currentUnit.mypos = Unit.currentUnit.y;
				Unit.currentUnit.path = [];
				
				Unit.partnerUnit.moving = false;
				Unit.partnerUnit.range = 0;
				Unit.partnerUnit.mxpos=Unit.partnerUnit.x;
				Unit.partnerUnit.mypos=Unit.partnerUnit.y;
				Unit.partnerUnit.path = [];				
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