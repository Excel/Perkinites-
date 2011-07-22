
package collects{

	import actors.*;
	import ui.*;

	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.ui.Keyboard;


	public class HappyOrb extends MovieClip {


		static public var list:Array=[];
		public var exist;
		public function HappyOrb() {

			exist=24*5;
			scaleX=0.05;
			scaleY=0.05;
			addEventListener(Event.ENTER_FRAME, startHandler);
			list.push(this);
		}

		public function startHandler(e) {
			rotation+=20;
			collide();
			scaleX+=0.05;
			scaleY+=0.05;
			if (Math.floor(scaleX*1.5)==1&&Math.floor(scaleY*1.5)==1) {
				removeEventListener(Event.ENTER_FRAME, startHandler);
				addEventListener(Event.ENTER_FRAME, gameHandler);
			}
		}
		public function endHandler(e) {
			rotation+=20;
			if (! collide()) {
				scaleX-=0.05;
				scaleY-=0.05;
				if (scaleX<=0.10&&scaleY<=0.10) {
					this.removeEventListener(Event.ENTER_FRAME, startHandler);
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
			rotation+=20;
			collide();
			exist--;
			if (exist<=0) {
				removeEventListener(Event.ENTER_FRAME, gameHandler);
				addEventListener(Event.ENTER_FRAME, endHandler);
			}
		}
		public function collide() {
			if (this.parent != null &&
			(this.hitTestObject(Unit.currentUnit)||this.hitTestObject(Unit.partnerUnit))) {
				Unit.FP+=050;
				Unit.score+=500;
				this.removeEventListener(Event.ENTER_FRAME, startHandler);
				this.removeEventListener(Event.ENTER_FRAME, gameHandler);
				this.removeEventListener(Event.ENTER_FRAME, endHandler);
				var rand=Math.floor(Math.random()*10+10);
				/*for (var i = 0; i < Math.floor(Math.random()*5+5); i++) {
					var radian = (Math.floor(Math.random()*10) * Math.floor(360/rand)*i)*Math.PI/180;
					var xs=8*Math.cos(radian);
					var ys=8*Math.sin(radian);
					var exfrag=new ExFrag1(xs,ys,Unit.tileMap);
					exfrag.x=x;
					exfrag.y=y;
					this.parent.addChild(exfrag);
				}*/

				list.splice(list.indexOf(this),1);
				this.parent.removeChild(this);


				return true;
			}
			return false;
		}
	}
}