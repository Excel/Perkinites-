/*
Abilities are the special commands Perkinites can use. :)
*/
package abilities{

	import flash.events.*;
	import flash.display.MovieClip;
	import flash.ui.Keyboard;
	import flash.geom.Point;

	import actors.*;
	import attacks.*;
	import collects.Gem;
	import game.*;
	import maps.*;
	import tileMapper.*;
	import ui.*;
	import util.*;

	public class Ability extends GameUnit{

		/**
		 * Name - Name of the Ability
		 * Description - Description of the Ability
		 * index - Frame index of the display Icon
		 * id - ID in the database or something
		 * amount - Number of copies of the same ability given in a Prize Drop
		 */
		public var Name:String;
		public var description:String;
		public var ID:int;
		
		public var index:int;
		public var amount:int;
		
		public var availability:String;
		public var spec:String;
		public var aoe:String;
		public var uses:int;
		public var activation:int;
		public var active:Boolean;
		public var value:Number;
		public var stand:int;
		public var exist:int;
		public var min:int;
		public var max:int;
		//public var range:int;
		public var rangeMod:Number;
		public var cooldown:int;
		public var cooldownMod:Number;
		public var maxCooldown:int;
		public var correct:int;

		public var allowCustom:String;
		public var wait:int;
		public var cast:String;
		public var moveForward:Number;
		
		public var damage:int;
		public var damageMod:Number;
		public var damageRatio:int;
		public var equipStatBuff:String;
		public var bonusDuration:int;
		public var bonusDurationMod;
		public var healthLump;
		public var healthPerc;
		public var healthLumpMod;
		public var healthPercMod;
		public var attackLump;
		public var attackPerc;
		public var attackLumpMod;
		public var attackPercMod;		
		public var defenseLump;
		public var defensePerc;
		public var defenseLumpMod;
		public var defensePercMod;		
		public var speedLump;
		public var speedPerc;
		public var speedLumpMod;
		public var speedPercMod;		
		public var rangeLump;
		public var rangePerc;
		public var rangeLumpMod;
		public var rangePercMod;		
		public var cooldownLump;
		public var cooldownPerc;	
		public var cooldownLumpMod;
		public var cooldownPercMod;
		
		public var equipDebuff;
		public var stunDuration;
		public var slowDuration;
		public var slowPerc;
		public var sickDuration;
		public var sickPerc;
		public var sickTime;
		public var exhaustDuration;
		public var regenDuration;
		public var regenLump;
		public var regenPerc;
		public var regenTime;

		public var stunDurationMod;
		public var slowDurationMod;
		public var slowPercMod;
		public var sickDurationMod;
		public var sickPercMod;
		public var sickTimeMod;
		public var exhaustDurationMod;
		public var regenDurationMod;
		public var regenLumpMod;
		public var regenPercMod;
		public var regenTimeMod;
		/**
		 * onActivation - general gameHandler of Ability when first activated
		 * onMove - the movement gameHandler of the bullet
		 * onDefend - what happens if attacked by another bullet
		 * onHit - apply the effects when the bullet hits a target
		 * onRemove - what happens when hotkey is moved from battle to inventory
		 */		
		public var onActivation:Array = new Array();
		public var onMove:Array = new Array();
		public var onDefend:Array = new Array();
		public var onHit:Array = new Array();
		public var onRemove:Array = new Array();
		
		public static var sd = new SelectDisplay();
		public var activating:Boolean = false;
		
		public var castingUnit:Unit;
		public var castCount = 0;

		/**
		 * Targets
		 */
		public var targets:Array;
		public var targetX;
		public var targetY;

		public function Ability(id:int = -1, a:int = 1) {
			if (id != -1) {
				AbilityDatabase.getAbilityStats(this, id);
			}
			this.amount = a;
		}
		
		public function updateAbility() {
			var minAbility = AbilityDatabase.getMinAbility(ID);
			var minMod;
			if (min > 1) {
				minMod = min;
			} else {
				minMod = 1;
			}
			this.range = Math.floor(minAbility.range + rangeMod * (minMod - 1));
			this.maxCooldown = this.cooldown = Math.floor(this.cooldown = minAbility.cooldown + cooldownMod * (minMod - 1));
			this.uses = minAbility.uses;
			this.damage = Math.floor(minAbility.damage + damageMod * (minMod - 1));	
			this.bonusDuration = Math.floor(minAbility.bonusDuration + bonusDurationMod * (minMod - 1));				
			this.healthLump = Math.floor(minAbility.healthLump + healthLumpMod * (minMod - 1));
			this.healthPerc = Math.floor(minAbility.healthPerc + healthPercMod * (minMod - 1));
			this.attackLump = Math.floor(minAbility.attackLump + attackLumpMod * (minMod - 1));
			this.attackPerc = Math.floor(minAbility.attackPerc + attackPercMod * (minMod - 1));
			this.defenseLump = Math.floor(minAbility.defenseLump + defenseLumpMod * (minMod - 1));
			this.defensePerc = Math.floor(minAbility.defensePerc + defensePercMod * (minMod - 1));
			this.speedLump = Math.floor(minAbility.speedLump + speedLumpMod * (minMod - 1));
			this.speedPerc = Math.floor(minAbility.speedPerc + speedPercMod * (minMod - 1));
			this.rangeLump = Math.floor(minAbility.rangeLump + rangeLumpMod * (minMod - 1));
			this.rangePerc = Math.floor(minAbility.rangePerc + rangePercMod * (minMod - 1));
			this.cooldownLump = Math.floor(minAbility.cooldownLump + cooldownLumpMod * (minMod - 1));
			this.cooldownPerc = Math.floor(minAbility.cooldownPerc + cooldownPercMod * (minMod - 1));
			this.stunDuration = Math.floor(minAbility.stunDuration + stunDurationMod * (minMod - 1));
			this.slowDuration = Math.floor(minAbility.slowDuration + slowDurationMod * (minMod - 1));
			this.slowPerc = Math.floor(minAbility.slowPerc + slowPercMod * (minMod - 1));
			this.sickDuration = Math.floor(minAbility.sickDuration + sickDurationMod * (minMod - 1));
			this.sickPerc = Math.floor(minAbility.sickPerc + sickPercMod * (minMod - 1));
			this.sickTime = Math.floor(minAbility.sickTime + sickTimeMod * (minMod - 1));
			this.exhaustDuration = Math.floor(minAbility.exhaustDuration + exhaustDurationMod * (minMod - 1));
			this.regenDuration = Math.floor(minAbility.regenDuration + regenDurationMod * (minMod - 1));
			this.regenLump = Math.floor(minAbility.regenLump + regenLumpMod * (minMod - 1));			
			this.regenPerc = Math.floor(minAbility.regenPerc + regenPercMod * (minMod - 1));
			this.regenTime = Math.floor(minAbility.regenTime + regenTimeMod * (minMod - 1));

		}
		/**
		 * Figure out what kind of correction it is.
		 * 0 = It's fine.
		 * 1 = Make sure unit aligns horizontally/vertically with target.
		 * 2 = Make sure unit to target is walkable.
		 * 3 = Ignore the target.
		 * 4 = Make sure unit aligns so that unit can shoot at target. All ranged attacks will use this.
		 * 5 = Make sure unit aligns so that unit can walk to target. Charge/tank attacks will use this.
		 */

		/**
		 * Figure out what kind of activation it is.
		 * 0 = You don't activate it. 
		 * 1 = Start activating and get the target X/Y.
		 * 2 = Let the user click first and then activate.
		 * 3 = Bring up the Select Unit Display.
		 * 4 = Hold Down. Essentially No. 1
		 */
		public function startAbility(unit) {
			if (activation > 0) {
				if (!unit.activating && cooldown == maxCooldown && uses > 0) {
					unit.activating = true;
					castingUnit = unit;
					if (correct != 3 && GameVariables.attackTarget.enemyRef != null) {
						targetX = GameVariables.attackTarget.enemyRef.x;
						targetY = GameVariables.attackTarget.enemyRef.y;
					}
					else {
						targetX=mouseX+ScreenRect.getX();
						targetY=mouseY+ScreenRect.getY();
					}
					unit.addEventListener(Event.ENTER_FRAME, moveAbilityHandler);	
				}												
			} else {
				castingUnit = unit;				
				activate();
			}			

		}

		public function selectUnitHandler(e) {
/*			if (e.keyCode=="X".charCodeAt(0)) {
				target="Team";
				finishSelection();
			} else if (e.keyCode == "A".charCodeAt(0) || e.keyCode == "S".charCodeAt(0)) {
				target="Current";
				finishSelection();
			} else if (e.keyCode == "D".charCodeAt(0) || e.keyCode == "F".charCodeAt(0)) {
				target="Partner";
				finishSelection();
			}*/
		}
		function finishSelection() {
/*			GameVariables.stageRef.removeEventListener(KeyboardEvent.KEY_DOWN, selectUnitHandler);
			GameVariables.stageRef.removeChild(sd);
			finish=true;
			Unit.disableHotkeys=false;*/

		}
		public function clickTargetHandler(e) {
/*			targetX=mouseX+ScreenRect.getX();
			targetY=mouseY+ScreenRect.getY();*/
		}



		public function moveAbilityHandler(e) {
			var obj = e.target;
			var radian;
			var xTile;
			var yTile;
			
			var txTile;
			var tyTile;
			if (true && GameVariables.attackTarget.enemyRef != null) {
					targetX = GameVariables.attackTarget.enemyRef.x;
					targetY = GameVariables.attackTarget.enemyRef.y;
			}
			obj.moveTo(targetX, targetY);

			if (Math.sqrt(Math.pow(obj.y - targetY, 2) + Math.pow(obj.x - targetX, 2)) <= range
					&& ((correct != 4) || (correct == 4 && TileMap.shootable(new Point(Math.floor(obj.x / 32), Math.floor(obj.y / 32)), 
															new Point(Math.floor(targetX / 32), Math.floor(targetY / 32))))) 
					&& ((correct != 5) || (correct == 5 && TileMap.walkable(new Point(Math.floor(obj.x / 32), Math.floor(obj.y / 32)), 
															new Point(Math.floor(targetX/32), Math.floor(targetY/32)))))															
															
															) {
				if (correct == 1) {
					xTile = Math.floor(obj.x / 32);
					yTile = Math.floor(obj.y / 32);
					
					txTile = Math.floor(targetX / 32);
					tyTile = Math.floor(targetY / 32);
					if (txTile - xTile == 0 || tyTile - yTile == 0) {
						obj.mxpos=obj.x;
						obj.mypos=obj.y;
						obj.path=[];
						obj.range = 0;	
						obj.stopAnimation();
						
						radian=Math.atan2(targetY-castingUnit.y,targetX-castingUnit.x);		
						castingUnit.faceDirection(radian);
						activate();
						castingUnit.removeEventListener(Event.ENTER_FRAME, moveAbilityHandler);						
					} else if (Math.abs(txTile - xTile) < Math.abs(tyTile - yTile) && !TileMap.hitNonpass(txTile*32+16, yTile*32+16)) {
						obj.moveTo(txTile*32+16, yTile*32+16);
						castingUnit.removeEventListener(Event.ENTER_FRAME, moveAbilityHandler);			
						castingUnit.addEventListener(Event.ENTER_FRAME, correctMovementHandler);
					} else if (!TileMap.hitNonpass(xTile * 32 + 16, tyTile * 32 + 16)) {
						obj.moveTo(xTile*32+16, tyTile*32+16);     			
						castingUnit.removeEventListener(Event.ENTER_FRAME, moveAbilityHandler);			
						castingUnit.addEventListener(Event.ENTER_FRAME, correctMovementHandler);
					} else if (!TileMap.hitNonpass(txTile * 32 + 16, yTile * 32 + 16)) {
						obj.moveTo(txTile*32+16, yTile*32+16);							
						castingUnit.removeEventListener(Event.ENTER_FRAME, moveAbilityHandler);			
						castingUnit.addEventListener(Event.ENTER_FRAME, correctMovementHandler);
					}
					else {
						cancel();
					}
				} else if (correct == 2) {
					xTile = Math.floor(obj.x / 32);
					yTile = Math.floor(obj.y / 32);
					
					txTile = Math.floor(targetX / 32);
					tyTile = Math.floor(targetY / 32);					
					if (TileMap.walkable(new Point(xTile, yTile), new Point(txTile, tyTile))) {
						obj.mxpos=obj.x;
						obj.mypos=obj.y;
						obj.path=[];
						obj.range = 0;	
						obj.stopAnimation();
						
						radian=Math.atan2(targetY-castingUnit.y,targetX-castingUnit.x);					
						castingUnit.faceDirection(radian);
						activate();
						castingUnit.removeEventListener(Event.ENTER_FRAME, moveAbilityHandler);							
					}
					else {
						cancel();
					}
				} else{
					obj.mxpos=obj.x;
					obj.mypos=obj.y;
					obj.path=[];
					obj.range = 0;	
					obj.stopAnimation();
					
					radian=Math.atan2(targetY-castingUnit.y,targetX-castingUnit.x);					
					castingUnit.faceDirection(radian);
					activate();
					castingUnit.removeEventListener(Event.ENTER_FRAME, moveAbilityHandler);
				}			
			}
		}
		
		public function correctMovementHandler(e) {
			var obj = e.target;
			if (true && GameVariables.attackTarget.enemyRef != null) {
					targetX = GameVariables.attackTarget.enemyRef.x;
					targetY = GameVariables.attackTarget.enemyRef.y;
			}			
			var radian=Math.atan2(targetY-castingUnit.y,targetX-castingUnit.x);
			var degree = (radian * 180 / Math.PI);
			var tol = 20;
			if (Math.abs(degree) < tol || Math.abs(degree - 90) < tol || Math.abs(degree - 180) < tol 
				|| Math.abs(degree + 90) < tol || Math.abs(degree + 180) < tol) {
				obj.mxpos=obj.x;
				obj.mypos=obj.y;
				obj.path=[];
				obj.range = 0;	
				obj.stopAnimation();
				castingUnit.faceDirection(radian);							
				activate();
				castingUnit.removeEventListener(Event.ENTER_FRAME, correctMovementHandler);
				castingUnit.removeEventListener(Event.ENTER_FRAME, moveAbilityHandler);
			}
		}

		public function activate() {
			castingUnit.stopAnimation();
			if (activation > 0) {
				uses--;
			}
			if (uses >= 0) {
				this.activating = true;
				this.addEventListener(Event.ENTER_FRAME, gameHandler); //onactivation	
			}
		}
		
		public function cancel() {
			if (activation > 0) {
				if (uses <= 0) {
				this.addEventListener(Event.ENTER_FRAME, cooldownHandler);					
				}
				castingUnit.activating = false;		
				castingUnit.mxpos=castingUnit.x;
				castingUnit.mypos=castingUnit.y;
				castingUnit.path=[];
				castingUnit.range = 0;							
				castingUnit.removeEventListener(Event.ENTER_FRAME, moveAbilityHandler);	
			}
			stand = AbilityDatabase.getMinAbility(ID).stand;			
			this.removeEventListener(Event.ENTER_FRAME, gameHandler);
			this.removeEventListener(Event.ENTER_FRAME, waitHandler);			
			this.activating = false;
		}

		override public function gameHandler(e) {
			if (! pauseAction && ! superPause && ! menuPause) {		
				if (onActivation.length != 0 && moveCount < onActivation.length) {
					onActivation[moveCount]();
				}
				stand--;				
				if ((stand <=0 && moveCount >= onActivation.length) || (stand <=0 && uses < 0)) {
					prevMoveCount=-1;
					moveCount = 0;
					cancel();
				}
			}
		}

		public function separate(statChange) {
			var s = new Array();
			if (statChange != null) {
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
			}
			else {
				s = new Array(0, 0);
			}
			return s;
		}
		
		override public function changeStat(unitType:String, statType:String, stat:String, popup:String) {
			if (prevMoveCount!=moveCount) {
				prevMoveCount = moveCount;
				var newStat;
				if (stat == "POWER") {
					newStat = damage;
				} else{
					var ns = separate(stat);
					newStat = ns[0] + ns[1] * (min - 1);
				}
				if (statType=="Health") {
					if (unitType=="Current") {
						Unit.currentUnit.updateHP(newStat-Unit.currentUnit.HP, popup);
					} else if (unitType == "Partner") {
						Unit.partnerUnit.updateHP(newStat-Unit.partnerUnit.HP, popup);
					}
				} else if (statType=="Health+") {
					if (unitType=="Current") {
						Unit.currentUnit.updateHP(-1*newStat, popup);
					} else if (unitType == "Partner") {
						Unit.partnerUnit.updateHP(-1*newStat, popup);
					}
				} 	else if (statType=="Health-") {
					if (unitType=="Current") {
						Unit.currentUnit.updateHP(newStat, popup);
					} else if (unitType == "Partner") {
						Unit.partnerUnit.updateHP(newStat, popup);
					}
				} else if (statType == "MaxHealth") {
					if (unitType=="Current") {
						Unit.currentUnit.maxHP=newStat;
						Unit.currentUnit.updateHP(0, "No");
					} else if (unitType == "Partner") {
						Unit.partnerUnit.maxHP=newStat;
						Unit.partnerUnit.updateHP(0, "No");
					}
				} else if (statType == "Attack") {
					if (unitType=="Current") {
						Unit.currentUnit.AP=newStat;
					} else if (unitType == "Partner") {
						Unit.partnerUnit.AP=newStat;
					}
				} else if (statType == "Defense") {
					if (unitType=="Current") {
						Unit.currentUnit.DP=newStat;
					} else if (unitType == "Partner") {
						Unit.partnerUnit.DP=newStat;
					}
				} else if (statType == "Defense+") {
					if (unitType=="Current") {
						Unit.currentUnit.DP+=newStat;
					} else if (unitType == "Partner") {
						Unit.partnerUnit.DP+=newStat;
					}
				} else if (statType == "Defense-") {
					if (unitType=="Current") {
						Unit.currentUnit.DP-=newStat;
					} else if (unitType == "Partner") {
						Unit.partnerUnit.DP-=newStat;
					}
				} else if (statType == "Speed") {
					if (unitType=="Current") {
						Unit.currentUnit.speed=newStat;
					} else if (unitType == "Partner") {
						Unit.partnerUnit.speed=newStat;
					}
				}
				moveCount++;
				if (moveCount < onActivation.length) {
					onActivation[moveCount]();
				}				
			}
		}		
		
		public function teleportPlayers() {
			if (prevMoveCount != moveCount) {
				prevMoveCount = moveCount;
				Unit.currentUnit.x = Unit.currentUnit.mxpos = targetX;
				Unit.currentUnit.y = Unit.currentUnit.mypos = targetY;
				Unit.partnerUnit.x = Unit.partnerUnit.mxpos = targetX;
				Unit.partnerUnit.y = Unit.partnerUnit.mypos = targetY;			
				
				moveCount++;
				if (moveCount < onActivation.length) {
					onActivation[moveCount]();
				}
			}
		}
		public function cast(attackNum:String, distance:String, AOE:String, speed:String, width:String, height:String, attackGraphic:String) {
			if (prevMoveCount != moveCount) {
				prevMoveCount = moveCount;
				
				var i;
				var a;
				var om;
				var od;
				var oh;
				var an = separate(attackNum);
				var d = separate(distance);
				var s = separate(speed);
				var w = separate(width);
				var h = separate(height);
				
				var newAttackNum = an[0] + an[1] * (min - 1);
				var newDistance = d[0] + d[1] * (min - 1);
				var newSpeed = s[0] + s[1] * (min - 1);
				var newWidth = w[0] + w[1] * (min - 1);
				var newHeight = h[0] + h[1] * (min - 1);
				
				var radian=Math.atan2(targetY-castingUnit.y,targetX-castingUnit.x);
				var degree = (radian*180/Math.PI);
				
				switch(AOE) {
					case "Line": 
						for (i = -(newAttackNum - 1) / 2; i < Math.ceil(newAttackNum / 2); i++) {
							a = new Attack(newSpeed * Math.cos(radian), newSpeed * Math.sin(radian), this, castingUnit);
							a.x=castingUnit.x+this.width*Math.cos(radian)/2 + Math.sin(radian)*newDistance * i;
							a.y=castingUnit.y+this.height*Math.sin(radian)/2 + Math.cos(radian)*newDistance * i;								
							a.width = newWidth;
							a.height = newHeight;
							a.rotation = degree + 90;
							a.range = this.range;
							castingUnit.parent.addChild(a);	
							
							for (om = 0; om < onMove.length; om++) {
								a.commands.push(MapObjectParser.parseCommand(a, onMove[om]));
							}
							for (od = 0; od < onDefend.length; od++) {
								a.defendCommands.push(MapObjectParser.parseCommand(a, onDefend[od]));
							}
							for (oh = 0; oh < onHit.length; oh++) {
								a.hitCommands.push(MapObjectParser.parseCommand(a, onHit[oh]));
							}
							a.addEventListener(Event.ENTER_FRAME, a.gameHandler);
						}							
						break;
					
					case "Circle": 
						for (i = degree; i < 360+degree; i += 360 / newAttackNum) {
							radian = (i*Math.PI/180);
							a = new Attack(newSpeed*Math.cos(radian), newSpeed*Math.sin(radian), this, castingUnit);
							a.x=castingUnit.x+this.width*Math.cos(radian)/2;
							a.y=castingUnit.y+this.height*Math.sin(radian)/2;													
							a.width = newWidth;
							a.height = newHeight;
							a.rotation = i + 90;
							a.range = newDistance;
							castingUnit.parent.addChild(a);	
							
							for (om = 0; om < onMove.length; om++) {
								a.commands.push(MapObjectParser.parseCommand(a, onMove[om]));
							}
							for (od = 0; od < onDefend.length; od++) {
								a.defendCommands.push(MapObjectParser.parseCommand(a, onDefend[od]));
							}
							for (oh = 0; oh < onHit.length; oh++) {
								a.hitCommands.push(MapObjectParser.parseCommand(a, onHit[oh]));
							}
							a.addEventListener(Event.ENTER_FRAME, a.gameHandler);
						}								
					break;
					case "Cone":
						degree = (radian*180/Math.PI);
						for (i = -(newAttackNum - 1) / 2; i < Math.ceil(newAttackNum / 2); i++){
							degree += (newDistance / newAttackNum) * (i*2);
							radian = degree * Math.PI / 180;
							
							a = new Attack(newSpeed*Math.cos(radian), newSpeed*Math.sin(radian), this, castingUnit);
							a.x = castingUnit.x + this.width * Math.cos(radian) / 2;
							a.y = castingUnit.y + this.height * Math.sin(radian) / 2;	
							a.width = newWidth;
							a.height = newHeight;							
							a.rotation = degree + 90;							
							a.range = this.range;						
							
							castingUnit.parent.addChild(a);	
							
							for (om = 0; om < onMove.length; om++) {
								a.commands.push(MapObjectParser.parseCommand(a, onMove[om]));
							}
							for (od = 0; od < onDefend.length; od++) {
								a.defendCommands.push(MapObjectParser.parseCommand(a, onDefend[od]));
							}
							for (oh = 0; oh < onHit.length; oh++) {
								a.hitCommands.push(MapObjectParser.parseCommand(a, onHit[oh]));
							}
							a.addEventListener(Event.ENTER_FRAME, a.gameHandler);
							radian = Math.atan2(targetY - castingUnit.y, targetX - castingUnit.x);
							degree = (radian * 180 / Math.PI);
						}					
					break;
					case "Point":
						for (i = degree; i < 360+degree; i += 360 / newAttackNum) {
							radian = (i*Math.PI/180);
							a = new Attack(newSpeed*Math.cos(radian), newSpeed*Math.sin(radian), this, castingUnit);
							a.x=mouseX+ScreenRect.getX();
							a.y=mouseY+ScreenRect.getY();													
							a.width = newWidth;
							a.height = newHeight;
							a.rotation = i + 90;
							a.range = this.range;
							castingUnit.parent.addChild(a);	
							
							for (om = 0; om < onMove.length; om++) {
								a.commands.push(MapObjectParser.parseCommand(a, onMove[om]));
							}
							for (od = 0; od < onDefend.length; od++) {
								a.defendCommands.push(MapObjectParser.parseCommand(a, onDefend[od]));
							}
							for (oh = 0; oh < onHit.length; oh++) {
								a.hitCommands.push(MapObjectParser.parseCommand(a, onHit[oh]));
							}
							a.addEventListener(Event.ENTER_FRAME, a.gameHandler);
						}									
					break;
				}
				moveCount++;
				if (moveCount < onActivation.length) {
					onActivation[moveCount]();
				}
			}
		}
		
		public function cooldownHandler(e) {
			if (! GameUnit.menuPause&&! GameUnit.superPause) {
				cooldown--;
				if (cooldown<=0) {
					removeEventListener(Event.ENTER_FRAME, cooldownHandler);
					updateAbility();
				}
			}
		}
		
		public function heal(target:String) {
			if (prevMoveCount != moveCount) {
				prevMoveCount = moveCount;
				
				var healthBonus;
				var unit;
				
				if (target == "Self") {
					unit = this.castingUnit;
				} else if (target == "Partner") {
					if (this.castingUnit == Unit.currentUnit) {
						unit = Unit.partnerUnit;
					}
					else if (this.castingUnit == Unit.partnerUnit) {
						unit = Unit.currentUnit;
					}
				}
				healthBonus = unit.maxHP * (this.healthPerc / 100) + this.healthLump;
				unit.updateHP( -1 * healthBonus, "Yes");							
				
				advanceMove();
			}

		}		
		
		/**
		 * Creates gems that pop up for JT's D4X attack.
		 */
		
		public function D4X() {
			if (prevMoveCount != moveCount) {
				prevMoveCount = moveCount;
				
				var openTiles = new Array();
				for (var a = Math.floor(ScreenRect.getX()/32)+2; a < Math.floor((ScreenRect.getX()+640)/32)-2; a++) {
					for (var b = Math.floor(ScreenRect.getY()/32)+2; b < Math.floor((ScreenRect.getY()+480)/32)-2; b++) {
						if (TileMap.getTile(a*32 + 16, b*32+16)== "p") {
							openTiles.push(new Point(a * 32+4, b * 32+4));
						}
					}
				}
				
				if(GameVariables.attackTarget.enemyRef != null){
					var gem;
					var openTile;
					for (var i = 0; i < 4; i++) {
						gem = new Gem(1);
						castingUnit.parent.addChild(gem);
						openTile = openTiles[Math.floor(Math.random() * openTiles.length)];
						gem.x = openTile.x;
						gem.y = openTile.y;
					}
					gem = new Gem(10);
					castingUnit.parent.addChild(gem);
					openTile = openTiles[Math.floor(Math.random() * openTiles.length)];				
					gem.x = openTile.x;
					gem.y = openTile.y;
				}
				advanceMove();			
			}
		}
		
		/**
		 * Allows for abilities to be held down to shoot repeatedly.
		 * THE CONDITIONAL + JUMPTO DO NOT WORK SO THIS HAD TO BE MADE ARGHHHHHHHHHHHHHHHHH
		 * THAT WILL PROBABLY HAVE TO BE REWRITTEN LATER
		 */
		public function rapidFire(commandIndex:int) {
			if (prevMoveCount != moveCount) {
				prevMoveCount = moveCount;			
				var key = checkHotkey();
				if (uses > 0  && KeyDown.keyIsDown(key)) {
					moveCount=commandIndex;
					prevMoveCount = moveCount - 1;
					activate();
					if (GameVariables.attackTarget.enemyRef == null) {
						targetX=mouseX+ScreenRect.getX();
						targetY=mouseY+ScreenRect.getY();
					}
				}
				else {
					advanceMove();
				}
			}
		}
		
		public function checkHotkey() {
			if (this == Unit.hk1) {
				return Unit.hotKey1;
			} else if (this == Unit.hk2) {
				return Unit.hotKey2;
			} else if (this == Unit.hk3) {
				return Unit.hotKey3;
			} else if (this == Unit.hk4) {
				return Unit.hotKey4;
			} else if (this == Unit.hk5) {
				return Unit.hotKey5;
			} else if (this == Unit.hk6) {
				return Unit.hotKey6;
			} else if (this == Unit.hk7) {
				return Unit.hotKey7;
			}
			return Unit.hotKey1;
		}
		override public function advanceMove() {
			moveCount++;
			if (moveCount < onActivation.length) {
				onActivation[moveCount]();
			}		
		}
		
		override public function useConditional(conditionsArray:Array, passArray:Array, failArray:Array) {
			var check = AbilityConditionChecker.checkCondition(this, conditionsArray);
			var tempPrevMoveCount = prevMoveCount;
			var tempMoveCount = moveCount+1;
			var tempCommands = onActivation;
			
			if (check) {
				swapActions( -1, 0, passArray);
			}
			else {
				swapActions( -1, 0, failArray);
			}
			var func = FunctionUtils.thunkify(swapActions, tempPrevMoveCount, tempMoveCount, tempCommands);
			onActivation.push(func);
		}
	
		override public function swapActions(prevMoveCount:int, moveCount:int, commands:Array) {
			this.prevMoveCount = prevMoveCount;
			this.moveCount = moveCount;
			this.onActivation = commands;
			addEventListener(Event.ENTER_FRAME, gameHandler);
			
		}
		
		public function getDescription():String {
			var newDescription = description;		
			var pattern:RegExp = /DAMAGE/g; 
			newDescription = newDescription.replace(pattern, this.damage);
			pattern= /APLUMP/g; 
			newDescription = newDescription.replace(pattern, this.attackLump);
			pattern = /APPERC/g; 
			newDescription = newDescription.replace(pattern, this.attackPerc);
			pattern = /REGENDURATION/g; 
			newDescription = newDescription.replace(pattern, this.regenDuration);			
			pattern = /REGENLUMP/g; 
			newDescription = newDescription.replace(pattern, this.regenLump);
			pattern = /REGENPERC/g; 
			newDescription = newDescription.replace(pattern, this.regenPerc);
			pattern = /REGENTIME/g; 
			newDescription = newDescription.replace(pattern, (this.regenTime/24).toFixed(1));		
			return newDescription;
		}
		public function getSpecInfo():String {
			var spec2 = spec;			
			if (spec=="Damage") {
				spec2="Damage = "+damage;
			} else if (spec == "S-Damage") {
				spec2="S-Damage = "+damage;
			} else if (spec=="Siphon") {
				spec2="Siphon + "+damage;
			} else if (spec == "Healing +") {
				spec2 = "Healing + " + this.healthLump;
			} else if (spec == "Healing %") {
				spec2="Healing "+this.healthPerc+"%";
			}
			//spec2=spec2+"\n"+activationLabel;*/
			return spec2;
		}
	}
}