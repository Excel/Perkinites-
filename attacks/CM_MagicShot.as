package attacks{

	import actors.*;
	import enemies.*;
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.ui.*;
	public class CM_MagicShot extends Bullet {

		var maxSpeed;
		var dir;
		var lr;
		var ud;
		var shot;
		var count=0;

		function CM_MagicShot(xs, ys, damage, d, tm) {
			super(xs, ys, damage, "PC", tm);
			//Assign values to variables
			maxSpeed=8;
			dir=d;
			switch (dir) {
				case 2 :
					lr=-1;
					ud=0;
					rotation=0;
					break;//left from our perspective
				case 4 :
					lr=0;
					ud=-1;
					rotation=270;
					break;
				case 6 :
					lr=0;
					ud=1;
					rotation=90;
					break;
				case 8 :
					lr=1;
					ud=0;
					rotation=180;
					break;//right from our perspective
			}
			shot=true;

			//Play shooting sound
		}

		override function update() {
			//Move in a wave pattern
			//count++;
			//if (count%12==0) {
			//Update
			x+=xspeed;
			y+=yspeed;
			switch (dir) {
				case 2 :
					rotation-=5*lr;
					break;
				case 4 :
					rotation-=5*ud;
					break;
				case 6 :
					rotation+=5*ud;
					break;
				case 8 :
					rotation+=5*lr;
					break;
			}


			//exist--;
			if (lr==1) {
				if (xspeed==maxSpeed) {
					lr=-1;
					shot=false;
				}
			}
			if (lr==-1) {
				if (xspeed==-1*maxSpeed) {
					lr=1;
					shot=false;
				}
			}
			if (ud==1) {
				if (yspeed==maxSpeed) {
					ud=-1;
					shot=false;
				}
			}
			if (ud==-1) {
				if (yspeed==-1*maxSpeed) {
					ud=1;
					shot=false;
				}
			}

			xspeed+=lr;
			yspeed+=ud;

			if (! shot) {
				maxSpeed=12;
			}


		}
		override function checkExplode() {

		}
		override function checkHit() {
			//Hit
			var list=[];
			list=Enemy.list;
			for (var i = 0; i < list.length; i++) {
				if (this.hitTestObject(list[i])) {
					list[i].updateHP(damage);
				}
			}
		}
	}
}