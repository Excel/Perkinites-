package abilities{

	import flash.events.*;
	import flash.display.MovieClip;
	import flash.ui.Keyboard;

	public class Item extends Ability {
		//having an amount of 0 means this item is being assigned to the hotkey
		//uses are called in the ItemDatabase and not through the individual Item
		//may rewrite that particular segment to have it make more sense
		public function Item(id:int, a:int) {
			super(id, 0);
		}
	}
}
