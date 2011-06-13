package ui{

	import flash.text.TextField;
	import actors.*;

	import flash.display.MovieClip;
	import flash.events.*;
	import flash.ui.*;
	import flash.filters.GlowFilter;

	public class PlayerDisplay extends MovieClip {

		var index;
		var gf1;
		function PlayerDisplay() {
			index=0;
			gf1=new GlowFilter(0xFF9900,100,20,20,1,5,true,false);
			gotoAndStop(1);
			button1.buttonText.text="1";
			button2.buttonText.text="2";
			button3.buttonText.text="3";
			button4.buttonText.text="4";

			button1.addEventListener(MouseEvent.CLICK, pageHandler);
			button2.addEventListener(MouseEvent.CLICK, pageHandler2);
			button3.addEventListener(MouseEvent.CLICK, pageHandler3);
			button4.addEventListener(MouseEvent.CLICK, pageHandler4);


			button1.mouseChildren=false;
			button2.mouseChildren=false;
			button3.mouseChildren=false;
			button4.mouseChildren=false;
		}

		public function setUnitIndex(i:int) {
			index=i;
			update();
		}

		public function displayAgain() {
			this.visible=true;
			button1.filters=[gf1];
		}


		public function pageHandler(e) {


			gotoPage(1);
			button1.filters=[gf1];
			button2.filters=[];
			button3.filters=[];
			button4.filters=[];
		}
		public function pageHandler2(e) {
			gotoPage(2);
			button1.filters=[];
			button2.filters=[gf1];
			button3.filters=[];
			button4.filters=[];


		}
		public function pageHandler3(e) {
			gotoPage(3);
			button1.filters=[];
			button2.filters=[];
			button3.filters=[gf1];
			button4.filters=[];
		}
		public function pageHandler4(e) {
			gotoPage(4);
			button1.filters=[];
			button2.filters=[];
			button3.filters=[];
			button4.filters=[gf1];
		}

		public function update() {

			switch (currentFrame) {
				case 1 :
					portrait.gotoAndStop(index+1);
					break;
				case 2 :
					HPCount.text=ActorDatabase.getHP(index)+"";
					APCount.text=ActorDatabase.getDmg(index)+"";
					SPCount.text=ActorDatabase.getSpeed(index)+"";
					CPCount.text=ActorDatabase.getCarry(index)+"";
					weaponName.text=ActorDatabase.getWeapon(index);

					wIcon.gotoAndStop(index+1);
					break;
				case 3 :
					//edit this later
					icon1.gotoAndStop(1);
					icon2.gotoAndStop(1);
					icon3.gotoAndStop(1);
					icon4.gotoAndStop(1);
					icon5.gotoAndStop(1);
					break;
				case 4 :
					ffName.text=ActorDatabase.getFFName(index);
					ffDescription.text=ActorDatabase.getFFDescription(index);
					ffBonus.text=ActorDatabase.getFFBonus(index);

					ffIcon.gotoAndStop(Math.ceil((index+1)/2));

					break;
			}

		}

		public function gotoPage(i:int) {
			gotoAndStop(i);
			update();
		}
	}
}