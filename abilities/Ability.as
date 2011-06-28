/*
Abilities are the special commands Perkinites can use. :)
*/
package abilities{

	import flash.events.*;
	import flash.display.MovieClip;
	import flash.ui.Keyboard;

	import actors.*;
	import attacks.*;
	import game.*;
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

			hpPercChange=AbilityDatabase.getHPPercChange(id);
			hpLumpChange=AbilityDatabase.getHPLumpChange(id);
			atkSpeed=AbilityDatabase.getAtkSpeed(id);
			mvSpeedPerc=AbilityDatabase.getMvSpeedPerc(id);
			atkDmgPerc=AbilityDatabase.getAtkDmgPerc(id);
			atkDmgLump=AbilityDatabase.getAtkDmgLump(id);
			cdPercChange=AbilityDatabase.getCDPercChange(id);

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

		public function activate(xpos, ypos) {
			if (uses>0) {
				switch (activation) {
					case "Hotkey" :
						targetX=mouseX+ScreenRect.getX();
						targetY=mouseY+ScreenRect.getY();
						Unit.currentUnit.addEventListener(Event.ENTER_FRAME, moveAbilityHandler);
						break;
					default:
						Unit.currentUnit.parent.parent.addEventListener(MouseEvent.MOUSE_DOWN, moveAbilityHandler);
						break;
					case "Hotkey -> Select Unit" :
						targetX=mouseX+ScreenRect.getX();
						targetY=mouseY+ScreenRect.getY();
						break;
				}

			}
		}

		public function moveAbilityHandler(e) {
			targetX=mouseX+ScreenRect.getX();
			targetY=mouseY+ScreenRect.getY();
			switch (moveToTarget) {
				case 1 :
					var ax=mouseX+ScreenRect.getX();
					var ay=mouseY+ScreenRect.getY();
					var radian=Math.atan2(ay-Unit.currentUnit.y,ax-Unit.currentUnit.x);

					var degree = (radian*180/Math.PI);

					Unit.currentUnit.mxpos=Math.floor(ax-32*Math.cos(radian));
					Unit.currentUnit.mypos=Math.floor(ay-32*Math.sin(radian));

					Unit.currentUnit.moveTo(Unit.currentUnit.mxpos, Unit.currentUnit.mypos);
					Unit.currentUnit.addEventListener(Event.ENTER_FRAME, finishAbilityHandler);
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
			uses-=1;
			Unit.currentUnit.removeEventListener(Event.ENTER_FRAME, moveAbilityHandler);
			Unit.currentUnit.parent.parent.removeEventListener(MouseEvent.MOUSE_DOWN, moveAbilityHandler);			
			if (uses<=0) {
				addEventListener(Event.ENTER_FRAME, cooldownHandler);
			}
		}
		public function finishAbilityHandler(e) {
			//these Unit.currentUnit's should be replaced eventually but I have to overwrite a lot of activate
			if (Unit.currentUnit.x==Unit.currentUnit.mxpos&&Unit.currentUnit.y==Unit.currentUnit.mypos) {
				var ax=targetX;
				var ay=targetY;

				for (var i = -1; i < 2; i++) {
					var radian=Math.atan2(ay-Unit.currentUnit.y,ax-Unit.currentUnit.x);

					var degree = (radian*180/Math.PI);
					degree+=5*i;
					radian=degree*Math.PI/180;
					var bxspeed=20;
					var byspeed=20;

					var b1=new CM_BasicShot(bxspeed*Math.cos(radian),byspeed*Math.sin(radian),5,"PC",Unit.tileMap);
					b1.x=Unit.currentUnit.x+width*Math.cos(radian)/2;
					b1.y=Unit.currentUnit.y+height*Math.sin(radian)/2;

					b1.scaleX=0.40;
					b1.rotation=90+degree;
					Unit.currentUnit.parent.addChild(b1);
					Unit.currentUnit.parent.setChildIndex(b1, 0);

					Unit.currentUnit.removeEventListener(Event.ENTER_FRAME, finishAbilityHandler);
				}


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
					maxCooldown=cooldown=AbilityDatabase.getCooldown(id);
					uses=maxUses;
				}
			}
		}
	}
}