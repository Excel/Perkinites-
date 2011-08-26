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
		public var power:int;
		public var powerMod:Number;
		public var power2:int;
		public var power2Mod:Number;
		public var power3:int;
		public var power3Mod:Number;
		
		public var correct:int;
		
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
			if (min > 1) {
				this.range = Math.floor(minAbility.range + rangeMod * (min - 1));
				this.maxCooldown = this.cooldown = Math.floor(this.cooldown = minAbility.cooldown + cooldownMod * (min - 1));
				this.power = Math.floor(minAbility.power + powerMod * (min - 1));
				this.power2 = Math.floor(minAbility.power2 + power2Mod * (min - 1));
				this.power3 = Math.floor(minAbility.power3 + power3Mod * (min - 1));
				this.uses = minAbility.uses;
				//trace(minAbility.power2 + power2Mod * (min - 1) + " " + power2Mod);
			} else {
				this.range = minAbility.range;
				this.maxCooldown = this.cooldown = minAbility.cooldown;
				this.power = minAbility.power;
				this.power2 = minAbility.power2;
				this.power3 = minAbility.power3;
				this.uses = minAbility.uses;
			}
/*			if (this.castingUnit != null) {
				var unit = this.castingUnit;
				cancel();
				startAbility(unit);
			}*/
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
			obj.mxpos=targetX;
			obj.mypos=targetY;
			obj.path = TileMap.findPath(TileMap.map, new Point(Math.floor(obj.x/32), Math.floor(obj.y/32)),
				new Point(Math.floor(obj.mxpos/32), Math.floor(obj.mypos/32)), 
					  false, true);
			obj.path = obj.smoothPath();
			//obj.range = range;	
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
			
						radian=Math.atan2(targetY-castingUnit.y,targetX-castingUnit.x);		
						castingUnit.faceDirection(radian);
						activate();
						castingUnit.removeEventListener(Event.ENTER_FRAME, moveAbilityHandler);						
					} else if (Math.abs(txTile - xTile) < Math.abs(tyTile - yTile) && !TileMap.hitNonpass(txTile*32+16, yTile*32+16)) {
						obj.path = TileMap.findPath(TileMap.map, new Point(xTile, yTile), new Point(txTile, yTile), false, true);
						obj.mxpos=txTile*32+16;
						obj.mypos=yTile*32+16;						
						obj.path = obj.smoothPath();
						castingUnit.removeEventListener(Event.ENTER_FRAME, moveAbilityHandler);			
						castingUnit.addEventListener(Event.ENTER_FRAME, correctMovementHandler);
					} else if(!TileMap.hitNonpass(xTile*32+16, tyTile*32+16)){
						obj.path = TileMap.findPath(TileMap.map, new Point(xTile, yTile), new Point(xTile, tyTile), false, true);						
						obj.mxpos=xTile*32+16;
						obj.mypos = tyTile * 32 + 16;
						obj.path = obj.smoothPath();
						castingUnit.removeEventListener(Event.ENTER_FRAME, moveAbilityHandler);			
						castingUnit.addEventListener(Event.ENTER_FRAME, correctMovementHandler);
					} else if (!TileMap.hitNonpass(txTile * 32 + 16, yTile * 32 + 16)) {
						obj.path = TileMap.findPath(TileMap.map, new Point(xTile, yTile), new Point(txTile, yTile), false, true);
						obj.mxpos=txTile*32+16;
						obj.mypos=yTile*32+16;						
						obj.path = obj.smoothPath();
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
				castingUnit.faceDirection(radian);							
				activate();
				castingUnit.removeEventListener(Event.ENTER_FRAME, correctMovementHandler);
				castingUnit.removeEventListener(Event.ENTER_FRAME, moveAbilityHandler);
			}
		}

		public function activate() {
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
			this.castingUnit = null;
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
			if (prevMoveCount!=moveCount) {
				prevMoveCount = moveCount;
				var newStat;
				if (stat == "POWER") {
					newStat = power;
				} else if (stat == "POWER2") {
					newStat = power2;
				} else if (stat == "POWER3") {
					newStat = power3;
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
		public function cast(attackNum:String, distance:String, AOE:String, speed:String, width:String, height:String, attackGraphic:String, origin:String = null) {
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
						for (i = -(newAttackNum - 1) / 2; i < Math.ceil(newAttackNum / 2); i++) { //FIX THIS
							a = new Attack(newSpeed * Math.cos(radian), newSpeed * Math.sin(radian), this, castingUnit);
							
							if (origin == null) { //Unit
								a.x=castingUnit.x+this.width*Math.cos(radian)/2 + Math.sin(radian)*newDistance * i;
								a.y=castingUnit.y+this.height*Math.sin(radian)/2 + Math.cos(radian)*newDistance * i;								
							} else if (origin == "Cursor") {
								a.x=mouseX+ScreenRect.getX();
								a.y=mouseY+ScreenRect.getY();
							} else if (origin == "Target") {
								a.x = targetX;
								a.y = targetY;
							}
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
							if (origin == null) { //Unit
								a.x=castingUnit.x+this.width*Math.cos(radian)/2;
								a.y=castingUnit.y+this.height*Math.sin(radian)/2;							
							} else if (origin == "Cursor") {
								a.x=mouseX+ScreenRect.getX();
								a.y=mouseY+ScreenRect.getY();
							} else if (origin == "Target") {
								a.x=targetX;
								a.y = targetY;
							}							
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


		private function sendAttacks(obj) {
/*			var a;//the attack to send out
			var i;//the iterative variable

			var ax=targetX;
			var ay=targetY;

			var radian=Math.atan2(ay-obj.y,ax-obj.x);
			var degree = (radian*180/Math.PI);

			var aspeed=15;

			//variables to incorporate into main Ability code
			var numBullets=8;
			var radius=50;

			switch (aoe) {
				case "Line" :
					//a=new Attack(aspeed*Math.cos(radian),aspeed*Math.sin(radian),damage,range,obj);
					a = new Attack(aspeed*Math.cos(radian), aspeed*Math.sin(radian), this, obj);
					a.x=obj.x+width*Math.cos(radian)/2;
					a.y=obj.y+height*Math.sin(radian)/2;
					a.rotation=degree;
					obj.parent.addChild(a);
					//obj.parent.setChildIndex(a, 0);
					break;
					case "Circle" :
					radian=Math.atan2(ay-obj.y,ax-obj.x);
					degree = (radian*180/Math.PI);
					for (i = 0; i < 360; i+=360/numBullets) {
					degree+=i;
					radian=degree*Math.PI/180;
					
					a = new Attack(aspeed*Math.cos(radian), aspeed*Math.sin(radian), damage, range,"PC");
					a.x=obj.x+width*Math.cos(radian)/2;
					a.y=obj.y+height*Math.sin(radian)/2;
					
					a.rotation=degree;
					obj.parent.addChild(a);
					//obj.parent.setChildIndex(a, 0);
					
					radian=Math.atan2(ay-obj.y,ax-obj.x);
					degree = (radian*180/Math.PI);
					
					}
					break;
					case "Cone" :
					radian=Math.atan2(ay-obj.y,ax-obj.x);
					degree = (radian*180/Math.PI);
					for (i = -numBullets/2; i < Math.ceil(numBullets/2); i++) {
					degree+=5*i;
					radian=degree*Math.PI/180;
					
					a=new Attack(aspeed*Math.cos(radian),aspeed*Math.sin(radian),damage,range,obj);
					a.setMods(this);
					a.x=obj.x+width*Math.cos(radian)/2;
					a.y=obj.y+height*Math.sin(radian)/2;
					
					a.rotation=degree;
					obj.parent.addChild(a);
					//obj.parent.setChildIndex(a, 0);
					
					radian=Math.atan2(ay-obj.y,ax-obj.x);
					degree = (radian*180/Math.PI);
					
					}
					break;
					case "Point" :
					a=new Attack(aspeed/2, aspeed/2,damage,radius,"Unit", true);
					a.x=ax;
					a.y=ay;
					
					obj.parent.addChild(a);
					//obj.parent.setChildIndex(a, 0);
					break;
					case "Aura" :
					a=new Attack(aspeed/2,aspeed/2,damage,radius,"Unit", true);
					a.x=obj.x;
					a.y=obj.y;
					
					obj.parent.addChild(a);
					//obj.parent.setChildIndex(a, 0);
					break;
				default :
					break;
			}*/
		}

		private function sendMod(obj, target) {
/*			switch (target) {
				case "Current" :
					Unit.currentUnit.updateHP(1);
					break;
				case "Partner" :
					Unit.partnerUnit.updateHP(10);
					break;
				case "Team" :
					Unit.currentUnit.updateHP(1);
					break;
					Unit.partnerUnit.updateHP(10);
					break;

			}*/
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
					moveCount++;
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
			pattern = /POWER3/g; 
			newDescription = newDescription.replace(pattern, power3);		
			pattern = /POWER2/g; 
			newDescription = newDescription.replace(pattern, power2);			
			var pattern:RegExp = /POWER/g; 
			newDescription = newDescription.replace(pattern, power);
			return newDescription;
		}
		public function getSpecInfo():String {
			var spec2 = spec;			
			if (spec=="Damage") {
				spec2="Damage = "+power;
			} else if (spec == "S-Damage") {
				spec2="S-Damage = "+power;
			} else if (spec=="Siphon") {
				spec2="Siphon + "+power;
			} else if (spec == "Healing +") {
				spec2 = "Healing + " + power;
			} else if (spec == "Healing %") {
				spec2="Healing "+power+"%";
			}
			//spec2=spec2+"\n"+activationLabel;*/
			return spec2;
		}
	}
}