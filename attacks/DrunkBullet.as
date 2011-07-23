package attacks{

	import actors.*;
	import enemies.*;
	
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.ui.*;
	public class DrunkBullet extends Attack {



		function DrunkBullet(xs, ys, d, r,a) {
			super(xs, ys, d, r, a);
			this.rotate=30;
		}

	}
}