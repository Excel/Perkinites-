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
			updateFP();
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
		
		
	}


}