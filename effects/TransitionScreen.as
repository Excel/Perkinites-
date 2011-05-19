
package effects{

	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.ui.Keyboard;


	public class TransitionScreen extends MovieClip {
		private var FPS;
		public var seconds;
		public var alphaMax;
		public var fadeIn;
		public function TransitionScreen() {
			FPS=24;
			/*seconds=s;
			alphaMax=a;
			*/
			alpha=0;

			fadeIn=true;//fade to black, false - fade out
			addEventListener(Event.ENTER_FRAME, gameHandler);
		}

		public function gameHandler(e) {
			if (fadeIn) {
				if (alphaMax>alpha) {
					alpha+=alphaMax/(seconds*FPS);
				}
			} else {
				if (alpha>0) {
					alpha-=alphaMax/(seconds*FPS);
				} else {
					removeEventListener(Event.ENTER_FRAME, gameHandler);
					this.parent.removeChild(this);
				}
			}
		}

	}
}