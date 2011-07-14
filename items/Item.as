
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

		//having an amount of 0 means this item is being assigned to the hotkey
		//uses are called in the ItemDatabase and not through the individual Item
		//may rewrite that particular segment to have it make more sense
		public function Item(id:int, a:int) {
			super(0, 0);
			this.id = id;
			Name=ItemDatabase.getName(id);
			description=ItemDatabase.getDescription(id);
			index=ItemDatabase.getIndex(id);

			hpPercChange=ItemDatabase.getHPPercChange(id);
			hpLumpChange=ItemDatabase.getHPLumpChange(id);
			atkSpeed=ItemDatabase.getAtkSpeedPerc(id);
			mvSpeedPerc=ItemDatabase.getMvSpeedPerc(id);
			atkDmgPerc=ItemDatabase.getAtkDmgPerc(id);
			atkDmgLump=ItemDatabase.getAtkDmgLump(id);
			cdPercChange=ItemDatabase.getCDPercChange(id);

			range = ItemDatabase.getRange(id);
			maxCooldown=cooldown=ItemDatabase.getCooldown(id);
			if (a!=0) {
				amount = a;
			}
			maxUses=9;
		}
		override public function activate(xpos, ypos, unit) {
			if (Unit.itemAmounts[id]>0) {
				Unit.itemAmounts[id]-=1;
			}
		}
	}
}
