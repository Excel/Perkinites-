package attacks{

	import actors.*;
	import enemies.*;
	import levels.*;

	import flash.display.MovieClip;
	import flash.events.*;
	import flash.ui.*;
	public class BurpLaser extends Bullet {



		function BurpLaser(xs, ys, d, a, tm) {
			super(xs, ys, d, a, tm);
		}

		override function update() {
			if (this.currentFrame==40) {
				this.parent.removeChild(this);
				removeEventListener(Event.ENTER_FRAME, gameHandler);
				stop();
			}
			gotoAndStop(this.currentFrame+1);
		}
		override function checkHit() {
			if (attacker=="Enemy") {
				if (this.hitTestObject(Unit.currentUnit)) {
					Unit.currentUnit.updateHP(damage);

				}
				if (this.hitTestObject(Unit.partnerUnit)) {
					Unit.partnerUnit.updateHP(damage);

				}
			}
		}

	}
}