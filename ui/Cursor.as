package ui{


	import flash.display.MovieClip;
	import flash.events.*;
	import flash.ui.*;
	public class Cursor extends MovieClip {


		function Cursor() {

			gotoAndStop(1);
			addEventListener(Event.ENTER_FRAME, gameHandler);

		}
		function gameHandler(e) {
			x = this.parent.mouseX;
			y = this.parent.mouseY;
			
			
			/*trace(mouseX);
			
			var xmouse=Math.round((this.parent.mouseX-16)/32);
  			var ymouse=Math.round((this.parent.mouseY-16)/32);
  			x=xmouse*32;
  			y=ymouse*32;
			trace(x);*/
		}
	}
}