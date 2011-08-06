package abilities{

	import actors.*;
	import enemies.*;
	import game.*;
	import tileMapper.*;
	import util.*;

	import flash.display.MovieClip;
	import flash.events.*;
	import flash.ui.*;
	public class Attack extends GameUnit {

		static public var list:Array=[];
		var xspeed:Number;
		var yspeed:Number;
		var ability:Ability;
		var caster:GameUnit;//attacker can only be Unit or Enemy


		var rotate:int;

		public var pauseMovement:Boolean;

		function Attack(xs:Number, ys:Number, a:Ability, c:GameUnit) {

			xspeed=xs;
			yspeed=ys;
			ability=a;
			caster=c;
 

			rotate=0;
			this.addEventListener(Event.ENTER_FRAME, gameHandler);

		}

		override public function gameHandler(e) {
			if (! pauseAction&&! superPause&&! menuPause) {
				//Update position
				update();
				//Did it collide?
				checkExplode();
				//Did it hit?
				checkHit();

			}
		}

		function update() {
			if (! pauseAction&&! superPause&&! menuPause) {
				x+=xspeed;
				y+=yspeed;
				//totalRange -= Math.sqrt(Math.pow(xspeed,2) + Math.pow(yspeed,2));
				//exist--;
				rotation+=rotate;
			}
		}

		function checkExplode() {
			if (! pauseAction&&! superPause&&! menuPause) {
				if (TileMap.hitWall(x,y)) {
					kill();
					return;
				}
				/*if (exist<0) {
					kill();
					return;
				}
				if(totalRange <= 0){
					kill();
					return;
				}*/
			}
		}
		function checkHit() {
			if (! pauseAction&&! superPause&&! menuPause) {
				var list=[];
				if (caster is Unit) {
					list=Enemy.list;
					for (var i = 0; i < list.length; i++) {
						if (this.hitTestObject(list[i].collision)) {
							list[i].updateHP(ability.damage);
							kill();
							return;
						}
					}

				} else if (caster is Enemy) {
					if (this.hitTestObject(Unit.currentUnit)) {
						Unit.currentUnit.updateHP(ability.damage);
						kill();
						return;
					}
					if (this.hitTestObject(Unit.partnerUnit)) {
						Unit.partnerUnit.updateHP(ability.damage);
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