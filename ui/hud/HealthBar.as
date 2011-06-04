package ui.hud{

	import actors.*;
	import enemies.*;
	import game.*;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.*;
	import flash.ui.*;
	import flash.utils.Timer;

	public class HealthBar extends MovieClip {
		public var back;
		public var damage;
		public var health;
		public var delayTimer:Timer;
		public var HP:int;
		public var maxHP:int;
		public var setWidth:int;

		public function HealthBar(holder:GameUnit, HP:int, maxHP:int, setWidth:int = 64) {

			holder.addChild(this);
			this.HP=HP;
			this.maxHP=maxHP;
			this.setWidth=setWidth;


			x=holder.x-setWidth/2;
			y=holder.y-holder.height/2-20;

			back = new Sprite();
			addChild(back);
			back.graphics.lineStyle(1,0x000000);
			back.graphics.beginFill(0x404040);
			back.graphics.drawRect(0,0,setWidth,4);
			back.graphics.endFill();

			damage = new Sprite();
			addChild(damage);
			damage.graphics.beginFill(0x880000);
			damage.graphics.drawRect(0,0,setWidth,4);
			damage.graphics.endFill();

			health= new Sprite();
			addChild(health);
			if (holder is Enemy) {
				health.graphics.beginFill(0xFF0000);
			} else if (holder is Unit) {
				health.graphics.beginFill(0x0066FF);
			}
			health.graphics.drawRect(0,0,setWidth,4);
			health.graphics.endFill();

			delayTimer=new Timer(500,1);
			delayTimer.addEventListener(TimerEvent.TIMER, delayTimerHandler);
		}

		public function update(nHP:int, nMaxHP:int) {
			delayTimer.stop();
			var oRatio=this.HP/this.maxHP;
			var nRatio=nHP/nMaxHP;

			redrawBars();
			health.scaleX=nRatio;
			if (nRatio>oRatio) {
				damage.scaleX=nRatio;
			} else {
				delayTimer.start();
			}
		}
		public function redrawBars() {
			damage.graphics.beginFill(0x880000);
			damage.graphics.drawRect(0,0,setWidth,4);
			damage.graphics.endFill();


			if (parent is Enemy) {
				health.graphics.beginFill(0xFF0000);
			} else if (parent is Unit) {
				health.graphics.beginFill(0x0066FF);
			}
			health.graphics.drawRect(0,0,setWidth,4);
			health.graphics.endFill();
		}

		public function delayTimerHandler(e:TimerEvent):void {
			damage.addEventListener(Event.ENTER_FRAME, decreaseHandler);
			delayTimer.stop();
		}
		public function decreaseHandler(e:Event):void {
			damage.scaleX-=0.05;
			if (health.scaleX>damage.scaleX) {
				damage.scaleX=health.scaleX;
				damage.removeEventListener(Event.ENTER_FRAME, decreaseHandler);
			}
		}

	}


}