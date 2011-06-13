/*
An Enemy is something that the PC will attack. Obviously. 
*/
package enemies{
	import actors.*;
	import attacks.*;
	import effects.*;
	import ui.hud.*;
	import util.*;
	import flash.text.TextField;

	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.*;
	import flash.ui.*;

	import flash.utils.Timer;
	import flash.events.TimerEvent;
	public class DrunkGuy extends Enemy {

		public var count;

		public var pukeCount;
		public var maxPukeCount;

		public function DrunkGuy() {
			//super
			super(5);
			
	
			
			count=0;
			pukeCount=0;
			maxPukeCount=1;
			this.maxWaitCount=24*0;

			scaleX=1.25;
			scaleY=1.25;
			gotoAndStop(1);
			this.moveArray = [
			  moveLeft,
			  moveRight,
			  moveDown,
			  moveUp,
			  FunctionUtils.thunkify(addEventListener, Event.ENTER_FRAME, pukeAttack),
			  FunctionUtils.thunkify(addEventListener, Event.ENTER_FRAME, burpAttack)
			  ];
			
			HUDOn = true;
			enemyHUD.updateTarget(this);
			removeChild(eHPBar);
		}

		
		override public function begin() {
			addEventListener(Event.ENTER_FRAME, gameHandler);
			addEventListener(Event.ENTER_FRAME, collideHandler);
			addEventListener(Event.ENTER_FRAME, moveHandler);

		}
		override public function end() {
			removeEventListener(Event.ENTER_FRAME, gameHandler);
			removeEventListener(Event.ENTER_FRAME, collideHandler);
			removeEventListener(Event.ENTER_FRAME, moveHandler);
			removeEventListener(Event.ENTER_FRAME, waitHandler);
			removeEventListener(Event.ENTER_FRAME, pukeAttack);
			removeEventListener(Event.ENTER_FRAME, burpAttack);
		}

		override public function gameHandler(e) {
			if (! pauseAction && !superPause && !menuPause) {
				if (moveCount>=moveArray.length) {
					prevMoveCount=-1;
					moveCount=0;
				}
				moveArray[moveCount]();
			}

		}
		public function burpAttack(e) {
			if (! pauseAction) {
				if (count==0) {
					var b=new BurpLaser(0,0,1,"Enemy",level.tileMap);
					b.x=this.x;
					b.y=this.y+4;
					this.parent.addChild(b);
				} else if (count==40) {
					count=0;
					removeEventListener(Event.ENTER_FRAME, gameHandler);
					removeEventListener(Event.ENTER_FRAME, burpAttack);
					addEventListener(Event.ENTER_FRAME, waitHandler);
				}
				count++;
			}
		}
		public function pukeAttack(e) {
			if (! pauseAction) {
				if (count%2==0&&count<51) {
					var b=new DrunkBullet(Math.random()*8-4,10,AP,"Enemy",level.tileMap);
					b.x=this.x;
					b.y=this.y;
					this.parent.addChild(b);
				}
				if (count==60) {
					count=0;
					pukeCount++;
				} else {
					count++;
				}
				if (pukeCount==maxPukeCount) {
					pukeCount=0;
					//maxPukeCount++;
					count=0;
					removeEventListener(Event.ENTER_FRAME, gameHandler);
					removeEventListener(Event.ENTER_FRAME, pukeAttack);
					addEventListener(Event.ENTER_FRAME, waitHandler);
				}
			}
		}
	}
}