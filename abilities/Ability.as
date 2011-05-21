/*
Units are the general heroes.
*/
package abilities{

	import flash.events.*;
	import flash.display.MovieClip;
	import flash.ui.Keyboard;

	import actors.*;

	public class Ability extends MovieClip {

		static public var FPS:int=24;
		/**
		 * Name - Name of the Ability
		 * Description - Description of the Ability
		 * index - Frame index of the display Icon
		 */
		public var Name;
		public var description;
		public var index;

		private var hpPercChange:int;
		private var hpLumpChange:int;
		private var atkSpeedPerc:int;
		private var mvSpeedPerc:int;
		private var atkDmgPerc:int;
		private var atkDmgLump:int;
		private var cdPercChange:int;
		
		/**
		 * Info
		 */

		public var cooldown:int;//cooldown time measured in seconds
		public var maxCooldown:int;
		public var uses:int;
		public var maxUses:int;//number of uses before cooldown
		public var canHotkey:Boolean;//whether or not the ability/command can be equipped to a hotkey or passive
		public var delay:int; //wait time before using again immediately
		static public var tileMap;
		
		/**
		 * What kind of ability it is
		 */
		public var bomber:Boolean;
		public var dasher:Boolean;
		public var ranger:Boolean;
		public var targeter:Boolean;
		public var other:Boolean;
		public var passive:Boolean;
		
		/**
		 * Targets
		 */
		 public var targets:Array;

		public function Ability(id:int) {
			Name	=	AbilityDatabase.getName(id);
			description = AbilityDatabase.getDescription(id);
			index	= AbilityDatabase.getIndex(id);
			
			hpPercChange= AbilityDatabase.getHPPercChange(id);
			hpLumpChange= AbilityDatabase.getHPLumpChange(id);
			atkSpeedPerc= AbilityDatabase.getAtkSpeedPerc(id);
			mvSpeedPerc	= AbilityDatabase.getMvSpeedPerc(id);
			atkDmgPerc	= AbilityDatabase.getAtkDmgPerc(id);
			atkDmgLump	= AbilityDatabase.getAtkDmgLump(id);
			cdPercChange= AbilityDatabase.getCDPercChange(id);
			
			maxCooldown = cooldown = AbilityDatabase.getCooldown(id);
			uses	= 0;
			maxUses	= 0;
			canHotkey=false;
			delay	= 10;
			bomber	= dasher = ranger = targeter = other = passive = false;
		}
		public function activate(xpos, ypos) {
		}
		public function cancel() {
		}
		public function enable(switchOn){
		}
		public function cooldownHandler(e) {
			cooldown--;
			if (cooldown<=0) {
				removeEventListener(Event.ENTER_FRAME, cooldownHandler);
				cooldown=0;
				uses=maxUses;
			}
		}
	}
}