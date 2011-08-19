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
	import game.*;
	import tileMapper.*;
	import ui.*;
	import util.*;

	public class Ability extends MovieClip {

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
		public var range:int;
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
		
		/**
		 * onActivation - general gameHandler of Ability when first activated
		 * onCast - apply this gameHandler as well once bullets form
		 * onMove - the movement gameHandler of the bullet
		 * onDefend - what happens if attacked by another bullet
		 * onHit - apply the effects when the bullet hits a target
		 * onRemove - what happens when hotkey is moved from battle to inventory
		 */		
		public var onActivation:Array = new Array();
		public var onCast:Array = new Array();
		public var onMove:Array = new Array();
		public var onDefend:Array = new Array();
		public var onHit:Array = new Array();
		public var onRemove:Array = new Array();
		
		public static var sd = new SelectDisplay();

		/**
		 * Targets
		 */
		public var targets:Array;

		public function Ability(id:int = -1, a:int = 1) {
			if (id != -1) {
				AbilityDatabase.getAbilityStats(this, id);
			}
			this.amount = a;
		}
		
		public function updateAbility() {
			var minAbility = AbilityDatabase.getMinAbility(ID);
			if (min > 1) {
				this.range = minAbility.range + rangeMod * (min - 1);
				this.maxCooldown = this.cooldown = minAbility.cooldown + cooldownMod * (min - 1);
				this.power = minAbility.power + powerMod * (min - 1);
				this.power2 = minAbility.power2 + power2Mod * (min - 1);
				this.power3 = minAbility.power3 + power3Mod * (min - 1);
			} else {
				this.range = minAbility.range;
				this.maxCooldown = this.cooldown = minAbility.cooldown;
				this.power = minAbility.power;
				this.power2 = minAbility.power2;
				this.power3 = minAbility.power3;
			}
		}
		/**
		 * Figure out what kind of activation it is.
		 * 0 = You don't activate it. 
		 * 1 = Start activating and get the target X/Y.
		 * 2 = Let the user click first and then activate.
		 * 3 = Bring up the Select Unit Display.
		 * 4 = Hold Down. Essentially No. 1
		 **/

		public function activate(xpos, ypos, unit) {
/*			if (! activating) {
				activating=true;

				if (uses>0&&min>0) {
					switch (activation) {
						case 1 :
							targetX=mouseX+ScreenRect.getX();
							targetY=mouseY+ScreenRect.getY();
							unit.addEventListener(Event.ENTER_FRAME, moveAbilityHandler);
							break;
						case 2 :
							break;
						case 3 :
							if (sd.parent==null) {
								GameVariables.stageRef.addChild(sd);
							}
							GameVariables.stageRef.addEventListener(KeyboardEvent.KEY_DOWN, selectUnitHandler);
							Unit.disableHotkeys=true;
							finish=false;			
							unit.addEventListener(Event.ENTER_FRAME, finishAbilityHandler);
							break;
						default :
							targetX=mouseX+ScreenRect.getX();
							targetY=mouseY+ScreenRect.getY();
							unit.addEventListener(Event.ENTER_FRAME, moveAbilityHandler);
							//unit.parent.parent.addEventListener(MouseEvent.MOUSE_DOWN, moveAbilityHandler);
							break;

					}

				}
			}*/
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
			/*var ax;
			var ay;
			var obj=e.target;

			obj.removeEventListener(Event.ENTER_FRAME, finishAbilityHandler);

			targetX=mouseX+ScreenRect.getX();
			targetY=mouseY+ScreenRect.getY();
			switch (moveToTarget) {
				case 1 :
					ax=mouseX+ScreenRect.getX();
					ay=mouseY+ScreenRect.getY();

					obj.mxpos=ax;
					obj.mypos=ay;

					obj.path = TileMap.findPath(TileMap.map, new Point(Math.floor(obj.x/32), Math.floor(obj.y/32)),
					  new Point(Math.floor(obj.mxpos/32), Math.floor(obj.mypos/32)), 
					  true, true);
					obj.range=range;
					break;
				case 2:	
					ax=mouseX+ScreenRect.getX();
					ay=mouseY+ScreenRect.getY();

					obj.mxpos=ax;
					obj.mypos=ay;

					obj.path = TileMap.findPath(TileMap.map, new Point(Math.floor(obj.x/32), Math.floor(obj.y/32)),
					  new Point(Math.floor(obj.mxpos/32), Math.floor(obj.mypos/32)), 
					  true, true);
					obj.range=range;
					break;				
				case 3 :
					Unit.currentUnit.mxpos=mouseX+ScreenRect.getX();
					Unit.currentUnit.mypos=mouseY+ScreenRect.getY();

					Unit.partnerUnit.mxpos=mouseX+ScreenRect.getX();
					Unit.partnerUnit.mypos=mouseY+ScreenRect.getY();

					Unit.currentUnit.teleportToCoord(Unit.currentUnit.mxpos, Unit.currentUnit.mypos);
					Unit.partnerUnit.teleportToCoord(Unit.partnerUnit.mxpos,Unit.partnerUnit.mypos)+Math.floor(Math.random()*64-32);
					break;
			}

			obj.addEventListener(Event.ENTER_FRAME, finishAbilityHandler);
			obj.removeEventListener(Event.ENTER_FRAME, moveAbilityHandler);
*/
		}
		public function finishAbilityHandler(e) {
/*			var obj=e.target;
			if (Math.sqrt(Math.pow(obj.y-targetY,2)+Math.pow(obj.x-targetX,2))<=range || finish) {
				obj.mxpos=obj.x;
				obj.mypos=obj.y;
				obj.path=[];
				obj.range=0;

				//sprite++;

				if (delay==0) {
					sendAttacks(obj);
					sendMod(obj, target);
					uses-=1;
					if (uses<=0) {
						addEventListener(Event.ENTER_FRAME, cooldownHandler);
					}
				}
				if (stand<=0) {
					obj.removeEventListener(Event.ENTER_FRAME, finishAbilityHandler);
					activating=false;
					finish = false;
					stand=AbilityDatabase.getStand(id);
					delay=AbilityDatabase.getDelay(id);

				} else {
					stand--;
					delay--;
				}

			}*/
		}

		public function cancel() {
		}


		public function cooldownHandler(e) {
/*			if (! GameUnit.menuPause&&! GameUnit.superPause) {
				cooldown--;
				if (cooldown<=0) {
					removeEventListener(Event.ENTER_FRAME, cooldownHandler);
					updateStats();
					uses=maxUses;
				}
			}*/
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
		public function getDescription():String {
			var newDescription = description;
			var pattern:RegExp = /POWER/g; 
			newDescription = newDescription.replace(pattern, power);
			pattern = /POWER2/g; 
			newDescription = newDescription.replace(pattern, power2);
			pattern = /POWER3/g; 
			newDescription = newDescription.replace(pattern, power3);		
			return newDescription;
		}
		public function getSpecInfo():String {
			var spec2 = spec;			
/*			if (spec=="Damage") {
				spec2="Damage = "+damage;
			} else if (spec == "S-Damage") {
				spec2="S-Damage = "+damage;
			} else if (spec=="Siphon") {
				spec2="Siphon + "+damage;
			} else if (spec == "Healing+") {
				spec2="Healing + "+hpLump;
			} else if (spec == "Healing%") {
				spec2="Healing % "+hpPerc+"%";
			}
			spec2=spec2+"\n"+activationLabel;*/
			return spec2;
		}
	}
}