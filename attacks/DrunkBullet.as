package attacks{

	import actors.*;
	import enemies.*;
	import levels.*;
	
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.ui.*;
	public class DrunkBullet extends Bullet {



		function DrunkBullet(xs, ys, d, a, tm) {
			super(xs, ys, d, a, tm);
			this.rotate=30;
		}

	}
}