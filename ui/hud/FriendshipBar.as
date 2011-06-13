package ui.hud{
	
	import flash.text.TextField;
	import actors.*;
	import util.*;

	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.*;
	import flash.ui.*;

	public class FriendshipBar extends MovieClip {
		var maxFPHeight;
		public static var percentage;
		var out;

		function FriendshipBar() {
			percentage=0;
			out=true;
			maxFPHeight=fp.height;
			addEventListener(Event.ENTER_FRAME, gameHandler);
		}

		public function gameHandler(e) {
			collide();
			updateFP();
			animate();
		}
		public function updateFP() {
			for (var i = 0; i < 10; i++) {
				if (percentage<Unit.FP) {
					percentage+=10;
				}
			}

			if (percentage>Unit.FP) {
				percentage-=500;
			}

			if (percentage>10000) {
				percentage=10000;
			}
			fp.y = 1 + 198*(10000-percentage)/10000;
			fp.height=maxFPHeight*percentage/10000;
			//191.3 + 7.3
			FPCount.y = 191.3 - 198*(percentage)/10000;
			fpArrow.y = 195.7 - 198*(percentage)/10000;
			if (percentage<=0) {
				FPCount.text="00.0%";
			} else if (percentage<1000) {
				FPCount.text="0"+Math.floor(percentage/100)+"."+(percentage%100)/10+"%";
			} else if (percentage < 10000) {
				FPCount.text=Math.floor(percentage/100)+"."+(percentage%100)/10+"%";
			} else {
				FPCount.text="100.00%";
			}
		}
		public function collide() {
			var u1;
			var u2;
			if (Unit.currentUnit!=null) {
				u1=Unit.currentUnit;
			}
			if (Unit.partnerUnit!=null) {
				u2=Unit.partnerUnit;
			}

			if (this.hitTestObject(u1)||this.hitTestObject(u2)) {
				if (alpha>0.5) {
					alpha-=0.1;
				}
			} else {
				if (alpha<1) {
					alpha+=0.1;
				}
			}

		}
		public function animate() {
			if (percentage>=10000) {
				if (fp.currentFrame==6) {
					out=false;
				} else if (fp.currentFrame == 1) {
					out=true;
				}
				if (out) {
					fp.gotoAndStop(fp.currentFrame+1);
				} else {
					fp.gotoAndStop(fp.currentFrame-1);
				}
			} else {
				fp.gotoAndStop(1);
			}
		}
	}


}