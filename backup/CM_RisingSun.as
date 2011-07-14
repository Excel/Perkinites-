package attacks{

	import actors.*;
	import enemies.*;
	import levels.*;
	import util.*;

	import flash.display.MovieClip;
	import flash.events.*;
	import flash.ui.*;
	public class CM_RisingSun extends Bullet {

		var speed;

		var yoffset;
		var count;

		function CM_RisingSun(ys, damage) {
			super(0, ys, damage, "PC", null);

			//Assign values to variables
			this.width=300;
			this.height=300;
			speed=ys;

			yoffset=0;
			count=0;

			x=ScreenRect.getX()+ScreenRect.STAGE_WIDTH/2;
			y=ScreenRect.getY()+ScreenRect.STAGE_HEIGHT;
			alpha=0;



			/*var list=Enemy.list;
			for (var i = 0; i < list.length; i++) {
				list[i].hitSun=false;

			}*/
			//Play shooting sound
		}

		override function update() {
			//Move up
			//stay in the middle for 1 second or so
			//move up and disappear
			movingArrows.rotation-=5;
			movingArrows2.rotation-=5;
			x=ScreenRect.getX()+ScreenRect.STAGE_WIDTH/2;
			y=ScreenRect.getY()+ScreenRect.STAGE_HEIGHT+yoffset;
			if (alpha<0.5) {
				alpha+=1/30;
			} else {
				alpha=0.5;
			}
			if (yoffset>-1*ScreenRect.STAGE_HEIGHT/2) {
				yoffset-=speed;
			} else if (yoffset<=-1*ScreenRect.STAGE_HEIGHT/2) {
				count++;
				if (count>18) {
					yoffset-=speed;
					if (alpha>0) {
						alpha-=1/12;
					} else {
						alpha=0;
					}
				}
			}




		}
		override function checkExplode() {
			if (yoffset<=-1.5*ScreenRect.STAGE_HEIGHT) {
				kill();
				return;
			}
		}
		override function checkHit() {

			/*var list=Enemy.list;
			for (var i = 0; i < list.length; i++) {
				if (! list[i].hitSun) {
					list[i].updateHP(damage);
				}
				list[i].hitSun=true;
			}*/
		}
	}
	/*override function kill() {
		/*var list=Enemy.list;
		for (var i = 0; i < list.length; i++) {
			list[i].hitSun=false;
		}
		removeEventListener(Event.ENTER_FRAME, gameHandler);
		this.parent.removeChild(this);
	}*/
}