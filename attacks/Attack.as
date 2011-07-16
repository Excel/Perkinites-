package attacks{

	import actors.*;
	import enemies.*;
	import levels.*;
	import tileMapper.*;
	import util.*;

	import flash.display.MovieClip;
	import flash.events.*;
	import flash.ui.*;
	public class Attack extends MovieClip {

		static public var list:Array=[];
		var xspeed:Number;
		var yspeed:Number;
		var damage:int;
		var attacker:String;//attacker can only be "PC" or "Enemy"
		var expand:Boolean;
		var radius:int;
		var exist:int;

		var hit=false;
		var rotate:int;

		public var pauseMovement:Boolean;

		function Attack(xs, ys, d, a, e:Boolean = false, r:int = 0) {

			xspeed=xs;
			yspeed=ys;
			damage=d;
			attacker=a;
			expand=e;
			radius=r;
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
				if (expand) {
					if (width<radius*2&&height<radius*2) {
						width+=xspeed;
						height+=yspeed;
					} else {
						width=radius*2;
						height=radius*2;
					}
				} else {
					x+=xspeed;
					y+=yspeed;
				}
				exist--;
				rotation+=rotate;
			}
		}

		function checkExplode() {
			if (! pauseMovement) {
				if (TileMap.hitWall(x,y) && !expand) {
					kill();
					return;
				}
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