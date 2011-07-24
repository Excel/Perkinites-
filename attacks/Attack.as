package attacks{

	import actors.*;
	import abilities.*;
	import enemies.*;
	import game.*;
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
		var attacker:GameUnit;//attacker can only be Unit or Enemy
		var expand:Boolean;
		var range:int;
		var totalRange:int;
		var exist:int;

		var hit=false;
		var rotate:int;

		public var pauseMovement:Boolean;

		function Attack(xs, ys, d, r, a, e:Boolean = false) {

			xspeed=xs;
			yspeed=ys;
			damage=d;
			attacker=a;
			expand=e;
			range = 0;
			totalRange = r;
			exist=150;

			rotate=0;
			pauseMovement=false;
			this.addEventListener(Event.ENTER_FRAME, gameHandler);

		}

		function setMods(ability:Ability){
			
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
/*					if (width<radius*2&&height<radius*2) {
						width+=xspeed;
						height+=yspeed;
					} else {
						width=radius*2;
						height=radius*2;
					}*/
				} else {
					x+=xspeed;
					y+=yspeed;
					totalRange -= Math.sqrt(Math.pow(xspeed,2) + Math.pow(yspeed,2));
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
				if(totalRange <= 0){
					kill();
					return;
				}
			}
		}
		function checkHit() {
			if (! pauseMovement) {
				var list=[];
				if (attacker is Unit) {
					list=Enemy.list;
					for (var i = 0; i < list.length; i++) {
						if (this.hitTestObject(list[i].collision)) {
							list[i].updateHP(damage);
							kill();
							return;
						}
					}

				} else if (attacker is Enemy) {
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