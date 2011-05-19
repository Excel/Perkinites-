package ui.screens{

	import flash.display.MovieClip;
	import flash.events.*;
	import flash.ui.*;

	import actors.*;
	import game.*;
	//Enriquez Iglesias
	import levels.*;
	public class Menu extends MovieClip {

		public var level:int;
		static public var maxLevel:int;
		public var diff:int;

		public var decide:Boolean;
		function Menu() {
			x=0;
			y=0;
			diff=0;

			updateText();
		}

		public function enableKeyHandler() {
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyHandler);
		}
		public function disableKeyHandler() {
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyHandler);
		}
		public function keyHandler(e) {
			if (e.keyCode=="X".charCodeAt(0)) {
				var sound = new se_timeout();
				sound.play();
				
				disableKeyHandler();
				this.parent.removeChild(this);
				Action.superPause = false;
				Unit.menuDelay = -5;
			}
		}

		public function selectHandler(e) {
			var sound = new se_chargeup();
			sound.play();
			SuperLevel.setLevel=level;

			SuperLevel.diff=diff;
			disableKeyHandler();
			stage.removeChild(this);
			Action.superPause = false;
		}


		public function resetText() {
		}
		public function updateText() {
			levelDisplay.text=Unit.maxLP;
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
		}

	}
}