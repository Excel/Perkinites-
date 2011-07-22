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
	import util.*;

	public class Ability extends MovieClip {

		static public var FPS:int=24;
		/**
		 * Name - Name of the Ability
		 * Description - Description of the Ability
		 * index - Frame index of the display Icon
		 * id - ID in the database or something
		 * amount - Number of copies of the same ability given in a Prize Drop
		 */
		public var Name;
		public var description;
		public var index;

		public var id;
		public var amount;
		public var spec;

		public var hpPercChange:int;
		public var hpLumpChange:int;
		public var atkSpeed:int;
		public var mvSpeedPerc:int;
		public var atkDmgPerc:int;
		public var atkDmgLump:int;
		public var cdPercChange:int;

		public var targetX:Number;
		public var targetY:Number;

		/**
		 * Info
		 */

		public var aoe:String;
		public var range:int;
		public var cooldown:int;//cooldown time measured in seconds
		public var maxCooldown:int;
		public var activation:String;//change into int later
		public var uses:int;
		public var maxUses:int;//number of uses before cooldown
		public var active:Boolean;//whether or not the ability can be equipped to a hotkey or passive
		public var delay:int;//wait time before using again immediately

		public var min:int;
		public var max:int;

		public var damage;

		public var moveToTarget:int;
		static public var tileMap;

		/**
		 * What kind of ability it is
		 */
		public var bomber:Boolean;
		public var dasher:Boolean;
		public var ranger:Boolean;
		public var targeter:Boolean;
		public var other:Boolean;

		/**
		 * Targets
		 */
		public var targets:Array;

		public function Ability(id:int, a:int) {
			Name=AbilityDatabase.getName(id);
			description=AbilityDatabase.getDescription(id);
			index=AbilityDatabase.getIndex(id);
			this.id=id;
			spec=AbilityDatabase.getSpec(id);

			damage=AbilityDatabase.getDamage(id);
			hpPercChange=AbilityDatabase.getHPPercChange(id);
			hpLumpChange=AbilityDatabase.getHPLumpChange(id);
			atkSpeed=AbilityDatabase.getAtkSpeed(id);
			mvSpeedPerc=AbilityDatabase.getMvSpeedPerc(id);
			atkDmgPerc=AbilityDatabase.getAtkDmgPerc(id);
			atkDmgLump=AbilityDatabase.getAtkDmgLump(id);
			cdPercChange=AbilityDatabase.getCDPercChange(id);

			aoe=AbilityDatabase.getAOE(id);
			range=AbilityDatabase.getRange(id);
			maxCooldown=cooldown=AbilityDatabase.getCooldown(id);
			activation=AbilityDatabase.getActivation(id);
			amount=a;
			uses=AbilityDatabase.getUses(id);
			maxUses=AbilityDatabase.getUses(id);
			active=false;
			delay=10;
			min=AbilityDatabase.getMin(id);
			max=AbilityDatabase.getMax(id);

			moveToTarget=AbilityDatabase.getMoveToTarget(id);
			bomber=dasher=ranger=targeter=other=false;
		}

		public function updateStats() {
			if (min==0) {
				damage=AbilityDatabase.getDamage(id);
				range=AbilityDatabase.getRange(id);
				maxCooldown=cooldown=AbilityDatabase.getCooldown(id);
			} else {
				damage = AbilityDatabase.getDamage(id) + (min-1)*AbilityDatabase.getDamageChange(id);
				range = AbilityDatabase.getRange(id) + (min-1)*50;
				maxCooldown = cooldown = AbilityDatabase.getCooldown(id) - (min-1)*2;
			}
		}
		public function activate(xpos, ypos, unit) {
			if (uses>0&&min>0) {
				switch (activation) {
					case "Hotkey" :
						targetX=mouseX+ScreenRect.getX();
						targetY=mouseY+ScreenRect.getY();
						unit.addEventListener(Event.ENTER_FRAME, moveAbilityHandler);
						break;
					default :
						unit.addEventListener(Event.ENTER_FRAME, moveAbilityHandler);
						//unit.parent.parent.addEventListener(MouseEvent.MOUSE_DOWN, moveAbilityHandler);
						break;
					case "Hotkey -> Select Unit" :
						targetX=mouseX+ScreenRect.getX();
						targetY=mouseY+ScreenRect.getY();
						break;
				}

			}
		}

		public function moveAbilityHandler(e) {
			var obj=e.target;
			
			obj.removeEventListener(Event.ENTER_FRAME, finishAbilityHandler);
			
			targetX=mouseX+ScreenRect.getX();
			targetY=mouseY+ScreenRect.getY();
			switch (moveToTarget) {
				case 1 :
					var ax=mouseX+ScreenRect.getX();
					var ay=mouseY+ScreenRect.getY();

					obj.mxpos=ax;
					obj.mypos=ay;

					obj.path = TileMap.findPath(TileMap.map, new Point(Math.floor(Unit.currentUnit.x/32), Math.floor(Unit.currentUnit.y/32)),
					  new Point(Math.floor(Unit.currentUnit.mxpos/32), Math.floor(Unit.currentUnit.mypos/32)), 
					  true, true);
					obj.range=range;

					obj.addEventListener(Event.ENTER_FRAME, finishAbilityHandler);
					break;
				case 2 :
					Unit.currentUnit.mxpos=mouseX+ScreenRect.getX();
					Unit.currentUnit.mypos=mouseY+ScreenRect.getY();

					Unit.partnerUnit.mxpos=mouseX+ScreenRect.getX();
					Unit.partnerUnit.mypos=mouseY+ScreenRect.getY();

					Unit.currentUnit.teleportToCoord(Unit.currentUnit.mxpos, Unit.currentUnit.mypos);
					Unit.partnerUnit.teleportToCoord(Unit.partnerUnit.mxpos,Unit.partnerUnit.mypos)+Math.floor(Math.random()*64-32);
					break;
			}

			obj.removeEventListener(Event.ENTER_FRAME, moveAbilityHandler);
			obj.parent.parent.removeEventListener(MouseEvent.MOUSE_DOWN, moveAbilityHandler);

		}
		public function finishAbilityHandler(e) {
			var obj=e.target;
			//trace(Math.sqrt(Math.pow(obj.y-targetY,2)+Math.pow(obj.x-targetX,2)));
			if (Math.sqrt(Math.pow(obj.y-targetY,2)+Math.pow(obj.x-targetX,2))<=range) {
				obj.mxpos=obj.x;
				obj.mypos=obj.y;
				obj.path=[];
				obj.range=0;

				sendAttacks(obj);
				
				uses-=1;
				if (uses<=0) {
					addEventListener(Event.ENTER_FRAME, cooldownHandler);
				}				
				obj.removeEventListener(Event.ENTER_FRAME, finishAbilityHandler);


			}
		}

		public function cancel() {
		}
		public function enable(switchOn) {
		}
		public function cooldownHandler(e) {
			if (! GameUnit.menuPause&&! GameUnit.superPause) {
				cooldown--;
				if (cooldown<=0) {
					removeEventListener(Event.ENTER_FRAME, cooldownHandler);
					updateStats();
					uses=maxUses;
				}
			}
		}


		public function getSpecInfo():String {
			var spec2=spec;
			if (spec=="Damage") {
				spec2="Damage = "+damage;
			} else if (spec == "Set Damage") {
				spec2="Set Damage = "+damage;
			} else if (spec=="Siphon") {
				spec2="Siphon + "+damage;
			} else if (spec == "Healing+") {
				spec2="Healing + "+hpLumpChange;
			} else if (spec == "Healing%") {
				spec2="Healing % "+hpPercChange+"%";
			}
			spec2=spec2+"\n"+activation;
			return spec2;
		}
		private function sendAttacks(obj) {
			var a;//the attack to send out
			var i;//the iterative variable

			var ax=targetX;
			var ay=targetY;

			var radian=Math.atan2(ay-obj.y,ax-obj.x);
			var degree = (radian*180/Math.PI);

			var aspeed=32;

			//variables to incorporate into main Ability code
			var numBullets=8;
			var radius = 50;
			
			switch (aoe) {
				case "Line" :
					a=new Attack(aspeed*Math.cos(radian),aspeed*Math.sin(radian),damage,"PC");
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

						a = new Attack(aspeed*Math.cos(radian), aspeed*Math.sin(radian), damage, "PC");
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

						a = new Attack(aspeed*Math.cos(radian), aspeed*Math.sin(radian), damage, "PC");
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
					a=new Attack(aspeed/2, aspeed/2,damage,"PC", true, radius);
					a.x=ax;
					a.y=ay;
					
					obj.parent.addChild(a);
					//obj.parent.setChildIndex(a, 0);				
					break;
				case "Aura" :
					a=new Attack(aspeed/2,aspeed/2,damage,"PC", true, radius);
					a.x=obj.x;
					a.y=obj.y;

					obj.parent.addChild(a);
					//obj.parent.setChildIndex(a, 0);				
					break;
				default :
					break;
			}
		}

	}
}