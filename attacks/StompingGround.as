package attacks{

	import actors.*;
	import enemies.*;

	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.*;
	import flash.ui.*;

	public class StompingGround extends MovieClip {
		public var damage;
		public var count;
		function StompingGround(d) {
			alpha=0;
			damage=d;
			count=0;
			this.addEventListener(Event.ENTER_FRAME, gameHandler);
		}

		public function gameHandler(e) {
			count++;
			if (alpha<1) {
				alpha+=1/5;
			}
			if (count==4) {
				for (var i = 0; i < Enemy.list.length; i++) {
					if (this.hitTestObject(Enemy.list[i])) {
						Enemy.list[i].updateHP(damage);
						//stun for a few frames
					}
				}
			}
			if (count==12) {
				removeEventListener(Event.ENTER_FRAME, gameHandler);
				this.parent.removeChild(this);

			}

		}
	}
}