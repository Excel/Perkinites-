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

		static public var list:Array = new Array();
		var xspeed:Number;
		var yspeed:Number;
		var ability:Ability;
		var caster:GameUnit;//attacker can only be Unit or Enemy
		var totalRange:Number;

		var rotate:int;

		public var pauseMovement:Boolean;
		public var defendCommands:Array;
		public var hitCommands:Array;
		
		public var targetedEnemies;
		public var hitEnemies;
		public var hitWall:Boolean = false; 
		
		public var hitMode:Boolean = false; // true - hit enemies and activate
		public var wallMode:Boolean = false; //true - hit walls and activate

		function Attack(xs:Number, ys:Number, a:Ability, c:GameUnit) {

			xspeed=xs;
			yspeed=ys;
			ability=a;
			caster=c;
 
			totalRange = 0;
			rotate = 0;
			
			defendCommands = new Array();
			hitCommands = new Array();
			targetedEnemies = new Array();
			hitEnemies = new Array();
			list.push(this);
			this.addEventListener(Event.ENTER_FRAME, gameHandler);
			//this.addEventListener(Event.ENTER_FRAME, defendHandler);
			

		}
		
		override public function gameHandler(e) {
			if (! pauseAction && ! superPause && ! menuPause) {		
				if (commands.length != 0 && moveCount < commands.length) {
					commands[moveCount]();					
				}
				if (hitMode) {
					checkHit();
				}
				if (wallMode) {
					if (TileMap.hitWall(x, y)) {
						hitWall = true;
						for (var oh = 0; oh < hitCommands.length; oh++) {
							hitCommands[oh]();
						}	
						return;
					}					
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

		public function bounce() {	
			if (prevMoveCount != moveCount) {
				prevMoveCount = moveCount;			
				trace("bounce");
				hitWall = false;
				eraseObject();
				moveCount++;
				if (moveCount < commands.length) {
					commands[moveCount]();
				}					
			}
		}
		public function moveForward(threshold:Number) {
			if (prevMoveCount != moveCount) {
				prevMoveCount = moveCount;
				x += xspeed;
				y += yspeed;
				totalRange += Math.sqrt(Math.pow(xspeed, 2) + Math.pow(yspeed, 2));	
				if (totalRange >= range*threshold) {
					moveCount++;		
					totalRange = 0;
				} else {
					prevMoveCount--;
				}
			}
		}
		public function toggleHitMode(toggle:String) {
			if (prevMoveCount != moveCount) {
				prevMoveCount = moveCount;			
				if (toggle == "ON") {
					hitMode = true;
				} else if (toggle == "OFF") {
					hitMode = false;
				}
				moveCount++;
				if (moveCount < commands.length) {
					commands[moveCount]();
				}				
			}
		}
		public function toggleWallMode(toggle:String) {
			if (prevMoveCount != moveCount) {
				prevMoveCount = moveCount;			
				if (toggle == "ON") {
					wallMode = true;
				} else if (toggle == "OFF") {
					wallMode = false;
				}
				moveCount++;
				if (moveCount < commands.length) {
					commands[moveCount]();
				}				
			}
		}		

		function defendHandler(e:Event):void {
			if (defendCommands.length > 0) {
				for (var d = 0; d < list.length; d++) {
					if (this.hitTestObject(list[d]) && this != list[d]) {
						for (var d2 = 0; d2 < defendCommands.length; d2++) {
							defendCommands[d2];
						}
					}
				}
			}
		}
		
		public function playAnimation(animationGraphic:String, mode:String) {		
		}

		public function separate(statChange) {
			var s = new Array();
			var sep=statChange.indexOf("+");
			if (sep==-1) {
				sep=statChange.toString().indexOf('-');
			}

			if (sep!=-1) {
				s.push(parseFloat(statChange.substring(0,sep)));
				s.push(parseFloat(statChange.substring(sep, statChange.toString().length)));
			} else {
				s.push(parseFloat(statChange));
				s.push(0);
			}
			return s;
		}
		
		override public function changeStat(unitType:String, statType:String, stat:String, popup:String) {
			var newStat;
			var i;
			if (stat == "POWER") {
				newStat = ability.power;
			} else if (stat == "POWER2") {
				newStat = ability.power2;
			} else if (stat == "POWER3") {
				newStat = ability.power3;
			} else{
				var ns = separate(stat);
				newStat = ns[0] + ns[1] * (ability.min - 1);
			}
			
			if (statType=="Health") {
			} else if (statType=="Health+") {
			} 	else if (statType=="Health-") {
					for (i = 0; i < targetedEnemies.length; i++) {
						if (hitEnemies.indexOf(targetedEnemies[i]) == -1) {
							targetedEnemies[i].updateHP(newStat);
							hitEnemies.push(targetedEnemies[i]);
						}
					}
			} else if (statType == "MaxHealth") {
				
			} else if (statType == "Attack") {
				
			} else if (statType == "Defense") {
				
			} else if (statType == "Defense+") {
				
			} else if (statType == "Defense-") {
				
			} else if (statType == "Speed") {
			} if (popup == "Yes") {
				
			}			
		}				
		
		function checkExplode() {
			if (! pauseAction&&! superPause&&! menuPause) {
				if (TileMap.hitWall(x,y)) {
					kill();
					return;
				}
			}
		}
		function checkHit() {
			if (! pauseAction&&! superPause&&! menuPause) {
				var list=[];
				if (caster is Unit) {
					list = Enemy.list;					
					for (var i = 0; i < list.length; i++) {		
						if (this.hitTestObject(list[i]) && targetedEnemies.indexOf(list[i]) == -1) {
							targetedEnemies.push(list[i]);
							for (var oh = 0; oh < hitCommands.length; oh++) {
								hitCommands[oh]();
							}
						}
					}

				} else if (caster is Enemy) {
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
			hitMode = false;
			wallMode = false;
			removeEventListener(Event.ENTER_FRAME, defendHandler);	
			list.splice(list.indexOf(this),1);			
		}		
		
	}
}