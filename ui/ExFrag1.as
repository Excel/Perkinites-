package ui{

	import levels.*;
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.ui.*;
	public class ExFrag1 extends MovieClip {

		var xspeed:int;
		var yspeed:int;
		var tileMap;
		var exist:int;
		var rotate:int;

		function ExFrag1(xs, ys, tm) {

			xspeed=xs;
			yspeed=ys;
			tileMap=tm;
			exist=12;
			rotate=0;
			this.addEventListener(Event.ENTER_FRAME, gameHandler);

		}

		function gameHandler(e) {
			//Update position
			update();
			//Did it collide?
			checkExplode();



		}

		function update() {
			x+=xspeed;
			y+=yspeed;
			exist--;
			rotation+=rotate;
			alpha-=0.05;

		}

		function checkExplode() {

			var pxtile;
			var pytile;
			pxtile=Math.floor(x/SuperLevel.tileWidth);
			pytile=Math.floor(y/SuperLevel.tileHeight);

			/*if (! tileMap["t_"+pytile+"_"+pxtile].walkable) {
				kill();
				return;
			}*/

			if (exist<0) {
				kill();
				return;
			}
		}
		
		function kill() {
			removeEventListener(Event.ENTER_FRAME, gameHandler);
			if(this.parent != null){
			this.parent.removeChild(this);
		}
		}
	}
}