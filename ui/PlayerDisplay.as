package ui{

	import flash.text.TextField;

	import abilities.*;
	import actors.*;

	import flash.display.MovieClip;
	import flash.events.*;
	import flash.ui.*;
	import flash.filters.GlowFilter;

	public class PlayerDisplay extends MovieClip {

		var index;
		public var gf1;

		var icons:Array;
		var names:Array;
		var descriptions:Array;
		function PlayerDisplay() {
			index=0;
			gf1=new GlowFilter(0xFF9900,100,20,20,1,5,true,false);
			gotoAndStop(1);


			icons=new Array(page3.icon1,page3.icon2,page3.icon3,page3.icon4,page3.icon5);
			names=new Array(page3.abilityName1,page3.abilityName2,page3.abilityName3,page3.abilityName4,page3.abilityName5);
			descriptions = new Array(page3.description1, page3.description2, page3.description3,
			 page3.description4, page3.description5);

			button1.buttonText.text="1";
			button2.buttonText.text="2";
			button3.buttonText.text="3";
			button4.buttonText.text="4";

			/*button1.addEventListener(MouseEvent.CLICK, pageHandler);
			button2.addEventListener(MouseEvent.CLICK, pageHandler2);
			button3.addEventListener(MouseEvent.CLICK, pageHandler3);
			button4.addEventListener(MouseEvent.CLICK, pageHandler4);
			*/

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




		public function update() {
			switch (currentFrame) {
				case 1 :
					portrait.visible=true;
					page2.visible=false;
					page3.visible=false;
					page4.visible=false;
					break;
				case 2 :
					portrait.visible=false;
					page2.visible=true;
					page3.visible=false;
					page4.visible=false;
					break;
				case 3 :
					portrait.visible=false;
					page2.visible=false;
					page3.visible=true;
					page4.visible=false;
					break;
				case 4 :
					portrait.visible=false;
					page2.visible=false;
					page3.visible=false;
					page4.visible=true;
					break;
			}
			switch (currentFrame) {
				case 1 :
					portrait.gotoAndStop(index+1);
					break;
				case 2 :
					page2.HPCount.text=ActorDatabase.getHP(index)+"";
					page2.APCount.text=ActorDatabase.getDmg(index)+"";
					page2.SPCount.text=ActorDatabase.getSpeed(index)+"";
					page2.weaponName.text=ActorDatabase.getWeapon(index);

					page2.wIcon.gotoAndStop(index+1);
					break;
				case 3 :
					//edit this later
					var basicAbilities=AbilityDatabase.getBasicAbilities(ActorDatabase.getName(index));

					for (var i = 0; i < icons.length; i++) {
						if (i<basicAbilities.length) {
							icons[i].useCount.visible=false;
							icons[i].visible=true;
							names[i].visible=true;
							descriptions[i].visible=true;
							icons[i].gotoAndStop(basicAbilities[i].index);
							names[i].text=basicAbilities[i].Name;
							descriptions[i].text=basicAbilities[i].getSpecInfo();
							icons[i].gotoAndStop(basicAbilities[i].index);
						} else {
							break;
						}
					}


					for (i; i < icons.length; i++) {
						icons[i].gotoAndStop(1);
						icons[i].useCount.visible=false;
						icons[i].visible=false;
						names[i].visible=false;
						descriptions[i].visible=false;
					}
					break;
				case 4 :
					/*page4.ffName.text=ActorDatabase.getFFName(index);
					page4.ffDescription.text=ActorDatabase.getFFDescription(index);
					page4.ffBonus.text=ActorDatabase.getFFBonus(index);

					page4.ffIcon.gotoAndStop(Math.ceil((index+1)/2));
					*/
					page4.ffIcon.gotoAndStop(1);
					break;
			}

		}

		public function gotoPage(i:int) {
			gotoAndStop(i);
			update();
		}
	}
}