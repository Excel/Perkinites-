
package collects{

	import abilities.*;
	import actors.*;
	import enemies.*;
	import game.*;
	import ui.*;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.ColorTransform;	
	import flash.ui.Keyboard;


	public class Gem extends MovieClip {


		static public var list:Array=[];
		public var exist;
		public var pointValue;
		public function Gem(pointValue:int = 1) {
			this.pointValue = pointValue;
			
			if (this.pointValue == 1) {
				exist = 24 * 10;
			} else if (this.pointValue == 10) {
				exist = 24 * 5;	
				this.transform.colorTransform = new ColorTransform(0.75,0.3,0.75,0.5,0,0,0,0);
			}
			scaleX=0.75;
			scaleY=0.75;
			addEventListener(Event.ENTER_FRAME, gameHandler);
			list.push(this);
		}

		public function endHandler(e) {
			if (! collide()) {
				scaleX-=0.05;
				scaleY-=0.05;
				if (scaleX<=0.10&&scaleY<=0.10) {
					this.removeEventListener(Event.ENTER_FRAME, gameHandler);
					this.removeEventListener(Event.ENTER_FRAME, endHandler);
					list.splice(list.indexOf(this),1);
					if (this.parent!=null) {
						this.parent.removeChild(this);
					}
				}
			}
		}
		public function gameHandler(e) {
			collide();
			exist--;
			if (exist<=0) {
				removeEventListener(Event.ENTER_FRAME, gameHandler);
				addEventListener(Event.ENTER_FRAME, endHandler);
			}
		}
		public function collide() {
			if (this.parent != null &&
			(this.hitTestObject(Unit.currentUnit) || this.hitTestObject(Unit.partnerUnit))) {
				if (GameVariables.attackTarget.enemyRef != null) {
					GameVariables.attackTarget.enemyRef.updateHP(pointValue, "Yes");
					Unit.flexPoints += pointValue / 100;					
				}
				if (pointValue == 10) {
					for (var i = Attack.list.length-1; i >= 0; i--) {
						if (Attack.list[i].castingUnit is Enemy) {
							Attack.list[i].eraseObject();
						}
					}
				}
				this.removeEventListener(Event.ENTER_FRAME, gameHandler);
				this.removeEventListener(Event.ENTER_FRAME, endHandler);

				list.splice(list.indexOf(this),1);
				this.parent.removeChild(this);
				return true;
			}
			return false;
		}
	}
}