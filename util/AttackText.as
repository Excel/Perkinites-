
package util{

	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.ui.Keyboard;


	public class AttackText extends MovieClip {
		private var FPS;
		public var seconds;
		public var fadeIn;
		public function AttackText(s) {
			FPS=24;
			this.attackText.text = s;
			alpha=0;

			fadeIn=true;//fade to black, false - fade out
			addEventListener(Event.ENTER_FRAME, gameHandler);
		}

		public function gameHandler(e) {
			if (fadeIn) {
				if (1>alpha) {
					alpha+=1/(seconds*FPS);
				}
			} else {
				if (alpha>0) {
					alpha-=1/(seconds*FPS);
					
				}
				else{
				removeEventListener(Event.ENTER_FRAME, gameHandler);
				this.parent.removeChild(this);
			}
			}
		}

	}
}