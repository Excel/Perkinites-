/*
Albert is one of Princess Clarissa's minions. He is a student who wields a sword.
*/

package enemies{
	import actors.*;
	import attacks.*;
	import effects.*;
	import hud.*;
	import util.*;

	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.*;
	import flash.ui.*;

	import flash.utils.Timer;
	import flash.events.TimerEvent;
	public class Albert extends Enemy {

		public var count;

	
		public function Albert() {
			//super
			super();

			//Enemy
			this.Name="Albert";
			this.eHealth=30;
			this.maxHealth=30;
			this.barrier=0;
			this.maxBarrier=0;

			this.AP=4;
			this.speed=4;
			this.xspeed=4;
			this.yspeed=4;
			this.eHP.text=this.eHealth;

			count=0;
			this.maxWaitCount = 24*0;

			gotoAndStop(1);
			this.moveArray = [
			  moveToClosestUnit,
			  moveToClosestUnit,
			  moveToClosestUnit,
			  dashToClosestUnit,
			  attack,
			  dashToClosestUnit,
			  spinAttack
			  //FunctionUtils.thunkify(addEventListener, Event.ENTER_FRAME, pukeAttack),
			  //FunctionUtils.thunkify(addEventListener, Event.ENTER_FRAME, burpAttack)
			  ];
		}

		override public function updateHP(damage) {
			if (barrier>0) {
				barrier-=damage;
			} else {
				eHealth-=damage;
			}
			if (0>=eHealth) {
				kill();
			}
			if (barrier>0) {
				eHP.text=barrier;
			} else {
				eHP.text=eHealth;
			}
			HUD_Enemy.updateTarget(this);
		}

		override public function begin() {
			addEventListener(Event.ENTER_FRAME, gameHandler);

		}
		override public function end() {
		}

		override public function gameHandler(e) {
			if (moveCount>=moveArray.length) {
				prevMoveCount=-1;
				moveCount=0;
			}
			moveArray[moveCount]();


		}
		public function burpAttack(e) {
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
		public function pukeAttack(e) {
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