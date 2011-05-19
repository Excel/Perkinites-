package attacks{

	import actors.*;
	import enemies.*;
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.ui.*;
	public class CK_ElecShot extends Bullet {


		function CK_ElecShot(xs, ys, d, a, tm) {
			super(xs, ys, d, "PC", tm);
			scaleX=0.6;
			scaleY=0.25;

		}

		override function checkHit() {

			var list=Enemy.list;
			for (var i = 0; i < list.length; i++) {
				if (this.hitTestObject(list[i].collision)) {
					list[i].updateHP(damage);
					if (Math.random()<0.1) {
						list[i].shock(2);
					}
					kill();
					return;
				}
			}
		}
	}
}