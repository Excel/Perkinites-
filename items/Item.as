
package items{

	import flash.events.*;
	import flash.display.MovieClip;
	import flash.ui.Keyboard;

	import actors.*;
	import abilities.*;

	public class Item extends Ability {
		/*
		static public var FPS:int=24;
		
		public var Name;
		public var description;
		
		
		public var EP:int;
		public var SP:int;
		
		
		public var cooldown:int;//cooldown time measured in seconds
		public var maxCooldown:int;
		public var uses:int;
		public var maxUses:int;//number of uses before cooldown
		public var canHotkey:Boolean;//whether or not the ability/command can be equipped to a hotkey or passive
		static public var tileMap;
		
		
		public var bomber;
		public var dasher;
		public var ranger;
		public var targeter;
		public var other;
		public var passive;
		
		
		
		public var targets:Array;
		 */
		public function Item() {
			super();
			Name=":]";
			description=":O";
			EP=0;
			SP=0;
			cooldown=0;
			maxCooldown=0;
			uses=0;
			maxUses=0;
			canHotkey=true;
			bomber=dasher=ranger=targeter=other=passive=0;
		}
		override public function activate(xpos, ypos) {
			if (uses>0) {
				useAbility();
				uses--;
			}
		}

		public function useAbility() {
		}

	}
}