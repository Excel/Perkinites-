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
		var totalRange:Number;

		var rotate:int;

		public var pauseMovement:Boolean;
		public var defendCommands:Array;
		public var hitCommands:Array;

		function Attack(xs:Number, ys:Number, a:Ability, c:GameUnit) {

			xspeed=xs;
			yspeed=ys;
			ability=a;
			caster=c;
 
			totalRange = 0;
			rotate = 0;
			
			defendCommands = new Array();
			hitCommands = new Array();
			list.push(this);
			this.addEventListener(Event.ENTER_FRAME, gameHandler);
			this.addEventListener(Event.ENTER_FRAME, defendHandler);

		}
		
		override public function gameHandler(e) {
			if (! pauseAction && ! superPause && ! menuPause) {
				if (commands.length!=0&&moveCount<commands.length) {
					commands[moveCount]();
				}
				if (moveCount>=commands.length) {
					prevMoveCount=-1;
					moveCount = 0;
					if (aTrigger == "Click" || aTrigger == "Collide" || aTrigger == "None") {
						GameUnit.objectPause=false;
						removeEventListener(Event.ENTER_FRAME, detectHandler);
						removeEventListener(Event.ENTER_FRAME, gameHandler);
						Unit.currentUnit.range = 0;
						Unit.partnerUnit.range = 0;
					}
				}
			}
		}		

		public function moveForward() {
			if (prevMoveCount != moveCount) {
				prevMoveCount = moveCount;
				x += xspeed;
				y += yspeed;
				totalRange += Math.sqrt(Math.pow(xspeed,2) + Math.pow(yspeed,2));				
				if (totalRange >= range) {
				moveCount++;		
				} else {
					prevMoveCount--;
				}
			}
		}
		public function toggleHitMode(toggle:String) {
			if (toggle == "ON") {
				addEventListener(Event.ENTER_FRAME, hitHandler);
			} else if (toggle == "OFF") {
				removeEventListener(Event.ENTER_FRAME, hitHandler);				
			}
		}
		
		function defendHandler(e:Event):void {
			if (defendCommands.length > 0) {
				for (var i = 0; i < list.length; i++) {
					if (this.hitTestObject(list[i])) {
						for (var j = 0; j < defendCommands.length; j++) {
							defendCommands[j];
						}
					}
				}
			}
		}
		function hitHandler(e:Event):void {
			checkHit();
		}
		function update() {
			if (! pauseAction&&! superPause&&! menuPause) {
				x+=xspeed;
				y+=yspeed;
				totalRange += Math.sqrt(Math.pow(xspeed,2) + Math.pow(yspeed,2));
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
							list[i].updateHP(ability.power);
							kill();
							return;
						}
					}

				} else if (caster is Enemy) {
					if (this.hitTestObject(Unit.currentUnit)) {
						Unit.currentUnit.updateHP(ability.power);
						kill();
						return;
					}
					if (this.hitTestObject(Unit.partnerUnit)) {
						Unit.partnerUnit.updateHP(ability.power);
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
		override public function eraseObject() {
			kill();
			removeEventListener(Event.ENTER_FRAME, hitHandler);
			removeEventListener(Event.ENTER_FRAME, defendHandler);			
		}		
		
	}
}