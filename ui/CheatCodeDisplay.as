package ui{


	import flash.display.MovieClip;
	import flash.events.*;
	import flash.ui.*;
	public class CheatCodeDisplay extends MovieClip {

		public var frame:int;
		function CheatCodeDisplay(ccName) {

			x = 0;
			y = 182;
			frame = 0;
			cheatCodeName.text = ccName;
			cheatCodeActivate.alpha = 0;
			unlocked.alpha = 0;
			cheatCodeName.alpha = 0;
			addEventListener(Event.ENTER_FRAME, gameHandler);

		}
		function gameHandler(e) {
			if(frame == 0){
				var sound = new se_cheatcode();
				sound.play();
			}
			if(frame < 8){
				cheatCodeActivate.alpha += 1/8;
			}
			else if (frame >= 8 && frame < 16){
				
			}
			else if (frame < 24 && frame >= 16){
				unlocked.alpha+=1/8;
				cheatCodeName.alpha+=1/8;
			}
			else if(frame < 48 && frame >= 24){
				
			}
			else if (frame < 64 &&frame >= 48){
				this.alpha -=1/16;
			}
			else{
				removeEventListener(Event.ENTER_FRAME, gameHandler);
				this.parent.removeChild(this);
			}
			frame++;
			

		}
	}
}