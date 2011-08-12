﻿
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
			var target = new Target(this);
			Unit.currentUnit.range = range;
			Unit.partnerUnit.range = range;
			addEventListener(Event.ENTER_FRAME, rangeHandler);
		}
		
		public function rangeHandler(e:Event):void {
			if ((Unit.currentUnit.HP > 0 && Unit.currentUnit.checkDistance() <= range && Unit.currentUnit.moving) && 
			(Unit.partnerUnit.HP > 0 && Unit.partnerUnit.checkDistance() <= range && Unit.partnerUnit.moving)){
				Unit.currentUnit.moving = false;
				Unit.partnerUnit.moving = false;
				removeEventListener(Event.ENTER_FRAME, rangeHandler);
				addEventListener(Event.ENTER_FRAME, gameHandler);
			}
		}
		override public function detectHandler(e:Event):void{
			if(this.hitTestPoint(GameVariables.stageRef.mouseX, GameVariables.stageRef.mouseY)){
				GameVariables.mouseMapObject = true;
			}
			else{
				GameVariables.mouseMapObject = false;
			}
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
						removeEventListener(Event.ENTER_FRAME, detectHandler);
						removeEventListener(Event.ENTER_FRAME, gameHandler);
					}
				}
			}
		}
	}
}