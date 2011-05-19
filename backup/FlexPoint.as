package util{

	import actors.*;

	import flash.display.MovieClip;
	import flash.events.*;
	import flash.ui.*;

	public class FlexPoint extends MovieClip {

		var val:int;
		var xspeed:int;
		var yspeed:int;
		var maxspeed:int;
		function FlexPoint(v) {
			val=v;
			xspeed=0;
			yspeed=0;
			
			/*
			Generally speaking...
			Yellow = 0.01
			Green = 0.10
			Blue = 0.25
			Red = 0.50
			Meal Credit = 6.15
			*/
			if (val<10) {
				gotoAndStop(1);
				maxspeed=20;
			} else if (val < 25) {
				gotoAndStop(2);
				maxspeed=17;
			} else if (val < 50) {
				gotoAndStop(3);
				maxspeed=14;
			} else if (val < 615) {
				gotoAndStop(4);
				maxspeed=11;
			} else {
				gotoAndStop(5);
				maxspeed=10;
			}

			addEventListener(Event.ENTER_FRAME, gameHandler);
		}
		function gameHandler(e) {

			if (x>Unit.xpos) {
				xspeed--;
			}
			if (Unit.xpos>x) {
				xspeed++;
			}
			if (y>Unit.ypos) {
				yspeed--;
			}
			if (Unit.ypos>y) {
				yspeed++;
			}
			if (-1*maxspeed>xspeed) {
				xspeed=-1*maxspeed;
			}
			if (-1*maxspeed>yspeed) {
				yspeed=-1*maxspeed;
			}
			if (xspeed>maxspeed) {
				xspeed=maxspeed;
			}
			if (yspeed>maxspeed) {
				yspeed=maxspeed;
			}

			x+=xspeed;
			y+=yspeed;


			if (this.hitTestObject(Unit.list[0])) {
				kill();
			}




		}

		public function kill() {
			Unit.flexPoints++;
			removeEventListener(Event.ENTER_FRAME, gameHandler);
			if (stage!=null) {
			stage.removeChild(this);
			}
		}
	}
}