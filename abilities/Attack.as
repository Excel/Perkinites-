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
		
		public function damage(applyStatBuff:String, applyDebuff:String) {
			for (var i = 0; i < targetedEnemies.length; i++) {
				var buff:Buff;
				if (hitEnemies.indexOf(targetedEnemies[i]) == -1) {
					if (ability.spec == "S-Damage") {
						targetedEnemies[i].updateHP(ability.damage, "Yes");	
					} else {
						targetedEnemies[i].updateHP(ability.damage + ability.castingUnit.getAttack(), "Yes");
					}
					hitEnemies.push(targetedEnemies[i]);
					if (applyStatBuff == "Yes") {
						buff = new Buff(ability, "Ability", targetedEnemies[i]);					
						targetedEnemies[i].buffs.push(buff);
					} 
					if (applyDebuff == "Yes") {
						if (ability.stunDuration > 0) {
							buff = new Buff(ability, "Stun", targetedEnemies[i]);					
							targetedEnemies[i].buffs.push(buff);							
						}
						if (ability.slowDuration > 0) {
							buff = new Buff(ability, "Slow", targetedEnemies[i]);					
							targetedEnemies[i].buffs.push(buff);								
						}
						if (ability.sickDuration > 0) {
							buff = new Buff(ability, "Sick", targetedEnemies[i]);					
							targetedEnemies[i].buffs.push(buff);								
						}
						if (ability.exhaustDuration > 0) {
							buff = new Buff(ability, "Exhaust", targetedEnemies[i]);					
							targetedEnemies[i].buffs.push(buff);								
						}
						if (ability.regenDuration > 0) {
							buff = new Buff(ability, "Regen", targetedEnemies[i]);					
							targetedEnemies[i].buffs.push(buff);								
						}
					}
				}
			}
		}
		
		public function heal(target:String) {
			var healthBonus;
			var unit;
				
			if (target == "Self") {
				unit = ability.castingUnit;
				healthBonus = unit.maxHP * (ability.healthPerc / 100) + ability.healthLump;
				unit.updateHP( -1 * healthBonus, "Yes");													
			} else if (target == "Partner") {
				if (ability.castingUnit == Unit.currentUnit) {
					unit = Unit.partnerUnit;
				}
				else if (ability.castingUnit == Unit.partnerUnit) {
					unit = Unit.currentUnit;
				}
				healthBonus = unit.maxHP * (ability.healthPerc / 100) + ability.healthLump;
				unit.updateHP( -1 * healthBonus, "Yes");																	
			} else if (target == "Target") {
				for (var i = 0; i < targetedEnemies.length; i++) {
					if (hitEnemies.indexOf(targetedEnemies[i]) == -1) {
						healthBonus = targetedEnemies[i].maxHP * (ability.healthPerc / 100) + ability.healthLump;
						targetedEnemies[i].updateHP( -1 * healthBonus, "Yes");		
					}
				}	
			}
		}
		override public function changeStat(unitType:String, statType:String, stat:String, popup:String) {
			var newStat;
			var i;
			if (stat == "POWER") {
				newStat = ability.damage;
			} else{
				var ns = separate(stat);
				newStat = ns[0] + ns[1] * (ability.min - 1);
			}
			
			if (statType=="Health") {
			} else if (statType=="Health+") {
			} 	else if (statType=="Health-") {
					for (i = 0; i < targetedEnemies.length; i++) {
						if (hitEnemies.indexOf(targetedEnemies[i]) == -1) {
							targetedEnemies[i].updateHP(newStat, popup);
							hitEnemies.push(targetedEnemies[i]);
						}
					}
			} else if (statType == "MaxHealth") {
				
			} else if (statType == "Attack") {
				
			} else if (statType == "Defense") {
				
			} else if (statType == "Defense+") {
				
			} else if (statType == "Defense-") {
				
			} else if (statType == "Speed") {
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
		
		override public function useConditional(conditionsArray:Array, passArray:Array, failArray:Array) {
			var check = AttackConditionChecker.checkCondition(this, conditionsArray);
			var tempPrevMoveCount = prevMoveCount;
			var tempMoveCount = moveCount+1;
			var tempCommands = commands;
			
			if (check) {
				swapActions(-1, 0, passArray);
			}
			else {
				swapActions(-1, 0, failArray);
			}
			var func = FunctionUtils.thunkify(swapActions, tempPrevMoveCount, tempMoveCount, tempCommands);
			commands.push(func);
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