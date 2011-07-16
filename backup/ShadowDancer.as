package attacks{

	import actors.*;
	import enemies.*;
	import levels.*;
	
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.ui.*;
	public class ShadowDancer extends Bullet {

		public var maxspeed;
		public var dir;
		public var count;

		function ShadowDancer(d, dire, tm) {

			maxspeed=16;
			var xs=0;
			var ys=0;
			dir=dire;
			switch (dir) {
				case 2 :
					gotoAndStop(1);
					ys=1;
					break;
				case 4 :
					gotoAndStop(2);
					xs=-1;
					break;
				case 6 :
					gotoAndStop(3);
					xs=1;
					break;
				case 8 :
					gotoAndStop(4);
					ys=-1;
					break;
			}
			count=0;
			super(xs, ys, d, "Enemy", tm);
		}

		override function gameHandler(e) {
			count++;
			if (count==6) {
				var sound = new se_charge00();
				sound.play();
				switch (dir) {
					case 2 :
						gotoAndStop(1);
						yspeed=maxspeed;
						break;
					case 4 :
						gotoAndStop(2);
						xspeed=-1*maxspeed;
						break;
					case 6 :
						gotoAndStop(3);
						xspeed=maxspeed;
						break;
					case 8 :
						gotoAndStop(4);
						yspeed=-1*maxspeed;
						maxspeed;
						break;
				}
			}
			x+=xspeed;
			y+=yspeed;
			if (count==15) {
				kill();
				return;
			}

			var list=[];
			if (this.hitTestObject(Unit.currentUnit)&& hit == false) {

				//Unit.health-=damage;
				hit = true;


			}


		}
	}

}