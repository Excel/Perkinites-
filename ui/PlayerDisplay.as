package ui{


	import actors.*;

	import flash.display.MovieClip;
	import flash.events.*;
	import flash.ui.*;

	public class PlayerDisplay extends MovieClip {

		var index;
		function PlayerDisplay() {
			index=0;
			gotoAndStop(1);
			button1.buttonText.text="1";
			button2.buttonText.text="2";
			button3.buttonText.text="3";
			button4.buttonText.text="4";

			button1.addEventListener(MouseEvent.CLICK, pageHandler);
			button2.addEventListener(MouseEvent.CLICK, pageHandler2);
			button3.addEventListener(MouseEvent.CLICK, pageHandler3);
			button4.addEventListener(MouseEvent.CLICK, pageHandler4);
		}

		public function setUnitIndex(i:int) {
			index=i;
			//portrait.gotoAndStop(index+1);
			//WHY THIS NOT WORK
			/*HPCount.text=ActorDatabase.getHP(index)+"";
			APCount.text=ActorDatabase.getDmg(index)+"";
			SPCount.text=ActorDatabase.getSpeed(index)+"";
			*/
		}

		//THERE IS AN EASIER WAY TO DO THIS 
		//THIS WILL BE CHANGED WHEN NOT LAZY
		//SORRY SORRY SORRY :(
		public function pageHandler(e) {
			e.target.parent.gotoAndStop(1);
			gotoPage(1);
			button1.filters=[];
			button2.filters=[];
			button3.filters=[];
			button4.filters=[];
		}
		public function pageHandler2(e) {
			e.target.parent.gotoAndStop(2);
			gotoPage(2);
		}
		public function pageHandler3(e) {
			e.target.parent.gotoAndStop(3);
			gotoPage(3);
		}
		public function pageHandler4(e) {
			e.target.parent.gotoAndStop(4);
			gotoPage(4);
		}

		public function gotoPage(i:int) {
			gotoAndStop(i);
		}
	}
}