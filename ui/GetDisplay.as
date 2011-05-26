package ui{
	
	import items.*;

	import flash.display.MovieClip;
	import flash.events.*;
	import flash.ui.*;
	public class GetDisplay extends MovieClip {

		public var frame:int;
		function GetDisplay(id:int, a:int) {
			x = -160;
			frame = 0;
			itemName.text = ItemDatabase.getName(id);
			getIcon.gotoAndStop(ItemDatabase.getIndex(id));
			getIcon.useCount.visible = false;
			amount.text = a+"X";
			this.alpha = 0;
			addEventListener(Event.ENTER_FRAME, gameHandler);

		}
		function gameHandler(e) {
			if(frame == 0){
				var sound = new se_chargeup();
				sound.play();
			}
			if(frame < 8){
				this.alpha += 1/8;
				x+=20;
			}
			else if (frame > 32){
				removeEventListener(Event.ENTER_FRAME, gameHandler);
				this.parent.removeChild(this);
			}
			frame++;
			

		}
	}
}