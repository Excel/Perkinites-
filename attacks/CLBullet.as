package attacks{

	import actors.*;
	import enemies.*;
	import levels.*;
	
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.ui.*;
	public class CLBullet extends Bullet {



		function CLBullet(xs, ys, d, a, tm) {
			super(xs, ys, d, a, tm);
			this.rotate=30;
		}

	}
}