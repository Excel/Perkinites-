
package items{

	import flash.events.*;
	import flash.display.MovieClip;
	import flash.ui.Keyboard;

	import actors.*;
	import abilities.*;

	public class Item_Drink extends Item {

		public function Item_Drink(u) {
			super();
			Name	="Naked Juice";
			description="Restores 25% of the Current Unit's HP.";
			index	= 2;

			uses	= u;
			maxUses	= 9;
		}

		override public function useAbility() {
			trace(uses);
			Unit.currentUnit.updateHP(Math.round(Unit.currentUnit.maxHP*-1/4));
		}

	}
}