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

		/**
		 * Numerical Stats of the Unit
		 * EP - Effect Points
		 * SP - Speed Points
		 */
		public var EP:int;
		public var SP:int;
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
		public var bomber;
		public var dasher;
		public var ranger;
		public var targeter;
		public var other;
		public var passive;
		
		/**
		 * Targets
		 */
		 public var targets:Array;

		public function Ability() {
			Name=":]";
			description=":O";
			index = 1;
			EP=0;
			SP = 0;
			cooldown=0;
			maxCooldown=0;
			uses=0;
			maxUses=0;
			canHotkey=false;
			delay = 10;
			bomber = dasher = ranger = targeter = other = passive = 0;
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