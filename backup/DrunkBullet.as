package attacks{

	import actors.*;
	import enemies.*;
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.ui.*;
	public class DrunkBullet extends Bullet {


		function DrunkBullet(xs, ys, d, a) {
			super(xs, ys, d, a);
		}

		override function gameHandler(e) {
			exist--;
			x+=xspeed;
			y+=yspeed;
			if (this.damage==1) {
				rotation+=15;
			} else {
				rotation+=45;
			}
			if (x<0-15||x>640+15) {
				kill();
				return;
			} else if (y<0-15 || y > 480+15) {
				kill();
				return;
			}
			if (exist<0) {
				kill();
				return;
			}
			var list=[];
			if (attacker=="PC") {
				list=Enemy.list;
				for (var i = 0; i < list.length; i++) {
					if (this.hitTestObject(list[i])) {
						list[i].eHealth-=damage;
						list[i].updateHP();
						kill();
						return;
					}
				}

			} else if (attacker=="Enemy") {
				list=Unit.list;
				if (this.hitTestObject(list[0])&& Unit.statuses[0] != ("Dodge") && hit == false) {

					Unit.health-=damage;
					//hit = true;
					kill();

				}

			}


		}

	}
}