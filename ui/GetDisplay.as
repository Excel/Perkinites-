﻿package ui{
	
	import flash.text.TextField;
	import abilities.*;

	import flash.display.MovieClip;
	import flash.events.*;
	import flash.ui.*;
	public class GetDisplay extends MovieClip {

		public var frame:int;
		function GetDisplay(id:int, a:int, type:String, displayMode:String) {
			x = -160;
			frame = 0;
			typeName.text = type;
			itemName.text = AbilityDatabase.getAbility(id).Name;
			getIcon.gotoAndStop(AbilityDatabase.getAbility(id).index);
			
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
			else if (frame >= 40 && frame < 48){
				this.alpha -=1/8;
			}
			else if (frame >= 48){
				removeEventListener(Event.ENTER_FRAME, gameHandler);
				this.parent.removeChild(this);
			}
			frame++;
			

		}
	}
}