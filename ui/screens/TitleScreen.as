package ui.screens{

	import flash.display.MovieClip;
	import flash.events.*;
	import flash.ui.*;
	import flash.filters.GlowFilter;


	public class TitleScreen extends MovieClip {

		public var frame:int;

		function TitleScreen() {

			frame=0;

			continueButton.buttonText.text="Continue";
			configButton.buttonText.text="Config";
			
			addEventListener(Event.ENTER_FRAME, gameHandler);

		}

		function gameHandler(e) {
			frame++;
			if (frame%24) {
				/*var number=new MovieClip();
				number.x=Math.floor(Math.random()*620+10);
				number.y=-50;
				stage.addChild(number);
				trace("oops");
				number.addEventListener(Event.ENTER_FRAME, matrixHandler);*/
			}
		}

		function matrixHandler(e) {
			e.getSource().y+=10;
			if (e.getSource().y>640) {
				e.getSource().removeEventListener(Event.ENTER_FRAME, matrixHandler);
				stage.removeChild(e.getSource());
			}
		}
	}
}