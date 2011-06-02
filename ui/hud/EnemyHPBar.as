package ui.hud{
	import enemies.*;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.*;
	import flash.ui.*;
	import flash.utils.Timer;

	public class EnemyHPBar extends MovieClip {
		public var damage;
		public var health;
		public var delayTimer:Timer;
		public var HP:int;
		public var maxHP:int;

		public function EnemyHPBar(HP:int, maxHP:int) {

			this.HP = HP;
			this.maxHP = maxHP;
			
			damage = new Sprite();
			addChild(damage);
			damage.graphics.beginFill(0x880000);
			damage.graphics.drawRect(0,0,64,4);
			damage.graphics.endFill();

			health= new Sprite();
			addChild(health);
			health.graphics.beginFill(0xFF0000);
			health.graphics.drawRect(0,0,64,4);
			health.graphics.endFill();
			
			delayTimer = new Timer(500, 1);
			delayTimer.addEventListener(TimerEvent.TIMER, delayTimerHandler);
		}

		public function update(nHP:int, nMaxHP:int) {
			delayTimer.stop();
			var oRatio=this.HP/this.maxHP;
			var nRatio=nHP/nMaxHP;

			redrawBars();
			health.scaleX = nRatio;
			if(nRatio > oRatio){
				damage.scaleX = nRatio;
			}
			else{
				delayTimer.start();
			}
		}
		public function redrawBars() {
			damage.graphics.beginFill(0x880000);
			damage.graphics.drawRect(0,0,64,4);
			damage.graphics.endFill();


			health.graphics.beginFill(0xFF0000);
			health.graphics.drawRect(0,0,64,4);
			health.graphics.endFill();
		}
		
		public function delayTimerHandler(e:TimerEvent):void{
			damage.addEventListener(Event.ENTER_FRAME, decreaseHandler);
			delayTimer.stop();
		}
		public function decreaseHandler(e:Event):void{
			damage.scaleX-=0.05;
			if(health.scaleX > damage.scaleX){
				damage.scaleX = health.scaleX;
				damage.removeEventListener(Event.ENTER_FRAME, decreaseHandler);
			}
		}

	}


}