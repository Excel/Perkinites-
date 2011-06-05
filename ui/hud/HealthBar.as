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
		public var holder:GameUnit;
		public var setWidth:int;
		public var setHeight:int;
		public var HUD:Boolean;

		public var xOffset:Number=0.75;
		public var yOffset:Number=1;

		public function HealthBar(HP:int, maxHP:int, holder:GameUnit = null, setWidth:int = 64, HUD:Boolean = false) {


			this.HP=HP;
			this.maxHP=maxHP;
			if (holder!=null&&! HUD) {
				holder.addChild(this);
				x=holder.x-setWidth/2;
				y=holder.y-holder.height/2-20;
			}

			this.setWidth=setWidth;
			if (HUD) {
				this.setHeight=8;
			} else {
				this.setHeight=4;
			}
			this.HUD=HUD;

			back = new Sprite();
			addChild(back);
			if (HUD) {
				back.graphics.lineStyle(2,0x000000);
			} else {
				back.graphics.lineStyle(1,0x000000);
			}
			back.graphics.lineStyle(2,0x000000);
			back.graphics.beginFill(0x404040);
			back.graphics.drawRect(0,0,setWidth+2,setHeight+2);
			back.graphics.endFill();

			damage = new Sprite();
			addChild(damage);
			damage.graphics.beginFill(0x880000);
			damage.graphics.drawRect(xOffset, yOffset,setWidth,setHeight);
			damage.graphics.endFill();

			health= new Sprite();
			addChild(health);
			if (holder is Enemy) {
				if (this.HUD) {
					health.graphics.beginFill(0xFF6F6F);
				} else {
					health.graphics.beginFill(0xFF0000);
				}
			} else if (holder is Unit) {
				if (HUD) {
				} else {
					health.graphics.beginFill(0x0066FF);
				}
			}
			health.graphics.drawRect(xOffset, yOffset,setWidth,setHeight);
			health.graphics.endFill();
			
			damage.scaleX=health.scaleX;

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

			repositionBars();

		}
		public function redrawBars() {
			damage.graphics.beginFill(0x880000);
			damage.graphics.drawRect(xOffset, yOffset,setWidth,setHeight);
			damage.graphics.endFill();


			if (holder is Enemy) {
				if (HUD) {
					health.graphics.beginFill(0xFF6F6F);
				} else {
					health.graphics.beginFill(0xFF0000);
				}
			} else if (holder is Unit) {
				if (HUD) {
				} else {
					health.graphics.beginFill(0x0066FF);
				}
			}

			health.graphics.drawRect(xOffset, yOffset,setWidth,setHeight);
			health.graphics.endFill();
		}

		public function repositionBars() {
			if (HUD) {
				damage.x=setWidth-damage.width+xOffset+0.5;
				health.x=setWidth-health.width+xOffset+0.5;
			}
		}

		public function delayTimerHandler(e:TimerEvent):void {
			damage.addEventListener(Event.ENTER_FRAME, decreaseHandler);
			delayTimer.stop();
		}
		public function decreaseHandler(e:Event):void {
			if (! GameUnit.menuPause) {
				damage.scaleX-=0.05;
				if (health.scaleX>damage.scaleX) {
					damage.scaleX=health.scaleX;
					damage.removeEventListener(Event.ENTER_FRAME, decreaseHandler);
				}
				repositionBars();
			}
		}

	}


}