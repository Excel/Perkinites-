package ui.screens{

	import flash.display.MovieClip;
	import flash.events.*;
	import flash.ui.*;

	import actors.*;
	import game.*;
	//Enriquez Iglesias
	import levels.*;
	public class Menu extends MovieClip {

		public var optionArray:Array;

		public var decide:Boolean;
		function Menu() {
			trace("There's a bug with menu and lost focus because they share the same pausing boolean. we should probably make respective booleans to handle this instead. D:");
			x=0;
			y=0;


			optionArray=new Array("Check yo active Perkinites! You got this gurrrrrrrrrl! ;)",
			  "Configure yo Boost Items to get Stat Bonuses! :)",
			  "View yo stock and configure your Items for yo Hotkeys! :)",
			  "Configure yo Special Abilities for yo Hotkeys! :)",
			  "Check yo friends! You got this Chicken McNugget! ;)");
			gotoPage(1);
			
			arrow.gotoAndStop(1);

			statusOption.addEventListener(MouseEvent.CLICK, pageHandler);
			boostsOption.addEventListener(MouseEvent.CLICK, pageHandler2);
			itemsOption.addEventListener(MouseEvent.CLICK, pageHandler3);
			abilitiesOption.addEventListener(MouseEvent.CLICK, pageHandler4);
			friendsOption.addEventListener(MouseEvent.CLICK, pageHandler5);
			
		}

		public function enableKeyHandler() {
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyHandler);
		}
		public function disableKeyHandler() {
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyHandler);
		}
		public function keyHandler(e) {
			if (e.keyCode=="X".charCodeAt(0)) {
				exit();
			}
		}

		public function pageHandler(e) {
			gotoPage(1);
			arrow.y=89;
		}
		public function pageHandler2(e) {
			gotoPage(2);
			arrow.y=89+32;
		}
		public function pageHandler3(e) {
			gotoPage(3);
			arrow.y=89+32*2;
		}
		public function pageHandler4(e) {
			gotoPage(4);
			arrow.y=89+32*3;
		}
		public function pageHandler5(e) {
			gotoPage(5);
			arrow.y=89+32*4;
		}
		public function exitHandler(e) {
			exit();
		}
		public function exit() {
			var sound = new se_timeout();
			sound.play();

			disableKeyHandler();
			this.parent.removeChild(this);
			GameUnit.superPause=false;
			Unit.menuDelay=-5;
		}
		public function gotoPage(i:int) {
			gotoAndStop(i);
			update();
		}
		public function update() {
			optionDescription.text=optionArray[currentFrame-1];
			switch (currentFrame) {
				case 1 :
					optionDisplay.text="Status";
					levelCount.text=Unit.maxLP;
					EXPCount.text=Unit.EXP;
					nextCount.text =(Unit.maxLP * 100 - Unit.EXP)+"";//fix
					unitName1.text=Unit.currentUnit.Name;
					unitName2.text=Unit.partnerUnit.Name;

					HPCount1.text=Unit.currentUnit.HP;
					APCount1.text=Unit.currentUnit.AP;
					SPCount1.text=Unit.currentUnit.speed;

					HPCount2.text=Unit.partnerUnit.HP;
					APCount2.text=Unit.partnerUnit.AP;
					SPCount2.text=Unit.partnerUnit.speed;
					break;
				case 2 :
					optionDisplay.text="Boosts";
					break;
				case 3 :
					optionDisplay.text="Items";
					break;
				case 4 :
					optionDisplay.text="Abilities";
					break;
				case 5 :
					optionDisplay.text="Friends";
					break;
			}



		}
		public function updateText() {
			/*levelDisplay.text=Unit.maxLP;
			expDisplay.text=Unit.EXP;
			nextDisplay.text =(Unit.maxLP * 100 - Unit.EXP)+""; //fix
			unitName1.text=Unit.currentUnit.Name;
			unitName2.text=Unit.partnerUnit.Name;
			
			HPDisplay1.text=Unit.currentUnit.HP;
			APDisplay1.text=Unit.currentUnit.AP;
			SPDisplay1.text=Unit.currentUnit.speed;
			
			HPDisplay2.text=Unit.partnerUnit.HP;
			APDisplay2.text=Unit.partnerUnit.AP;
			SPDisplay2.text=Unit.partnerUnit.speed;
			*/
		}

	}
}