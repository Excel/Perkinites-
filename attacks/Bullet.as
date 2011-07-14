package attacks{

	import actors.*;
	import enemies.*;
	import levels.*;
	import tileMapper.*;
	import util.*;

	import flash.display.MovieClip;
	import flash.events.*;
	import flash.ui.*;
	public class Bullet extends MovieClip {

		static public var list:Array=[];
		var xspeed:Number;
		var yspeed:Number;
		var damage:int;
		var attacker:String;//attacker can only be "PC" or "Enemy"
		var tileMap;
		var exist:int;
		var hit=false;
		var rotate:int;

		public var pauseMovement:Boolean;

		function Bullet(xs, ys, d, a, tm = null) {

			xspeed=xs;
			yspeed=ys;
			damage=d;
			attacker=a;
			//tileMap=tm;
			exist=150;
			rotate=0;
			pauseMovement=false;
			this.addEventListener(Event.ENTER_FRAME, gameHandler);

		}

		function gameHandler(e) {
			if (! pauseMovement) {
				//Update position
				update();
				//Did it collide?
				checkExplode();
				//Did it hit?
				checkHit();

			}
		}

		function update() {
			if (! pauseMovement) {
				x+=xspeed;
				y+=yspeed;
				exist--;
				rotation+=rotate;
			}
		}

		function checkExplode() {
			if (! pauseMovement) {
				if(TileMap.hitWall(x, y)){
					kill();
					return;
				}
				/*if (! tileMap["t_"+pytile+"_"+pxtile].walkable) {
					kill();
					return;
				}
*/
				if (exist<0) {
					kill();
					return;
				}
			}
		}
		function checkHit() {
			if (! pauseMovement) {
				var list=[];
				if (attacker=="PC") {
					list=Enemy.list;
					for (var i = 0; i < list.length; i++) {
						if (this.hitTestObject(list[i].collision)) {
							list[i].updateHP(damage);
							kill();
							return;
						}
					}

				} else if (attacker=="Enemy") {
					if (this.hitTestObject(Unit.currentUnit)&&hit==false) {
						Unit.currentUnit.updateHP(damage);
						//hit = true;
						kill();
						return;
					}
					if (this.hitTestObject(Unit.partnerUnit)&&hit==false) {
						Unit.partnerUnit.updateHP(damage);
						//hit = true;
						kill();
						return;
					}
				}
			}
		}
		function kill() {
			removeEventListener(Event.ENTER_FRAME, gameHandler);
			if (this.parent!=null) {
				this.parent.removeChild(this);
			}
		}
	}
}