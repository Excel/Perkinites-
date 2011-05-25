package ui.screens{

	import flash.display.MovieClip;
	import flash.events.*;
	import flash.geom.Rectangle;
	import flash.ui.*;

	import actors.*;
	import game.*;
	import items.*;
	//Enriquez Iglesias
	import levels.*;
	public class Menu extends MovieClip {

		public var optionArray:Array;
		public var toggleArray1:Array;
		public var toggleArray2:Array;

		public var decide:Boolean;
		function Menu() {
			trace("There's a bug with menu and lost focus because they share the same pausing boolean. we should probably make respective booleans to handle this instead. D:");
			trace("Equipping items to hotkeys is on its way.");
			trace("You can only drag to hotkey A at the moment. THERE ARE SEVERAL BUGS I CAN FIX LATER");
			x=0;
			y=0;

			optionArray=new Array("\nCheck yo active Perkinites! You got this gurrrrrrrrrl! ;)",
			  "\nConfigure yo Boost Items to get Stat Bonuses! :)",
			  "\nView yo stock and configure your Items for yo Hotkeys! :)",
			  "\nConfigure yo Special Abilities for yo Hotkeys! :)",
			  "\nConfigure yo Player's Actions as a Partner Unit! You got this Chicken McNugget! ;)");

			toggleArray1=new Array("Frequently",
			   "Occasionally",
			"Seldomly",
			"Never");

			toggleArray2=new Array("Beatdown",
			   "Attack with Caution",
			"Grab Happy Orbs",
			"Follow the Leader");

			gotoPage(1);

			arrow.gotoAndStop(1);

			statusOption.addEventListener(MouseEvent.CLICK, pageHandler);
			boostsOption.addEventListener(MouseEvent.CLICK, pageHandler2);
			itemsOption.addEventListener(MouseEvent.CLICK, pageHandler3);
			abilitiesOption.addEventListener(MouseEvent.CLICK, pageHandler4);
			friendsOption.addEventListener(MouseEvent.CLICK, pageHandler5);

			configOption.addEventListener(MouseEvent.CLICK, configHandler);
			saveOption.addEventListener(MouseEvent.CLICK, saveHandler);
			loadOption.addEventListener(MouseEvent.CLICK, loadHandler);
			exitOption.addEventListener(MouseEvent.CLICK, exitHandler);

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
			arrow.y=71;
			hover.y=64;
		}
		public function pageHandler2(e) {
			gotoPage(2);
			arrow.y=71+32;
			hover.y=64+32;
		}
		public function pageHandler3(e) {
			gotoPage(3);
			arrow.y=71+32*2;
			hover.y=64+32*2;
		}
		public function pageHandler4(e) {
			gotoPage(4);
			arrow.y=71+32*3;
			hover.y=64+32*3;
		}
		public function pageHandler5(e) {
			gotoPage(5);
			arrow.y=71+32*4;
			hover.y=64+32*4;
		}
		public function configHandler(e) {
		}
		public function saveHandler(e) {
		}
		public function loadHandler(e) {
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

					freezeFaces();
					break;
				case 2 :
					optionDisplay.text="Boosts";
					freezeFaces();
					break;
				case 3 :
					optionDisplay.text="Items";
					freezeHotkeys();
					setPassives();
					setInventory(true);
					break;
				case 4 :
					optionDisplay.text="Abilities";
					freezeHotkeys();
					setPassives();
					setInventory(false);
					break;
				case 5 :
					optionDisplay.text="Partners";
					freezeHotkeys();
					updateToggles();
					break;
			}
		}

		public function freezeHotkeys() {
			qIcon1.gotoAndStop(1);
			wIcon1.gotoAndStop(1);
			eIcon1.gotoAndStop(1);
			aIcon1.gotoAndStop(1);
			sIcon1.gotoAndStop(1);
			dIcon1.gotoAndStop(1);
			qIcon2.gotoAndStop(1);
			wIcon2.gotoAndStop(1);
			eIcon2.gotoAndStop(1);
			aIcon2.gotoAndStop(1);
			sIcon2.gotoAndStop(1);
			dIcon2.gotoAndStop(1);

			if (currentFrame==5) {
				asIcon1.gotoAndStop(1);
				asIcon2.gotoAndStop(1);
			} else {
				thingIcon.gotoAndStop(1);
			}
		}

		public function updateToggles() {
			qToggle1.buttonText.text=toggleArray1[0];
			qToggle2.buttonText.text=toggleArray1[0];
			wToggle1.buttonText.text=toggleArray1[0];
			wToggle2.buttonText.text=toggleArray1[0];
			eToggle1.buttonText.text=toggleArray1[0];
			eToggle2.buttonText.text=toggleArray1[0];
			aToggle1.buttonText.text=toggleArray1[0];
			aToggle2.buttonText.text=toggleArray1[0];
			sToggle1.buttonText.text=toggleArray1[0];
			sToggle2.buttonText.text=toggleArray1[0];
			dToggle1.buttonText.text=toggleArray1[0];
			dToggle2.buttonText.text=toggleArray1[0];

			asToggle1.buttonText.text=toggleArray2[0];
			asToggle2.buttonText.text=toggleArray2[0];
		}

		public function freezeFaces() {
			faceIcon1.gotoAndStop(1);
			faceIcon2.gotoAndStop(2);
		}
		public function setPassives() {
			passive1.source=passiveList1;
			passive2.source=passiveList2;
		}
		public function setInventory(useItems:Boolean) {
			inventory.source=inventoryList;
			var xOffset=16;
			var yOffset=8;
			if (useItems) {
				var i;
				for (i = 0; i < Unit.Items.length; i++) {
					if (i%7==0&&i!=0) {
						xOffset=16;
						yOffset+=36;
					}
					var itemIcon = new AbilityIcon();
					itemIcon.gotoAndStop(Unit.Items[i].index);
					itemIcon.x=xOffset;
					itemIcon.y=yOffset;
					inventoryList.addChild(itemIcon);
					itemIcon.addEventListener(MouseEvent.MOUSE_DOWN, moveIconHandler);
					xOffset+=32;
				}
			} else {

			}
		}

		public function moveIconHandler(e) {
			var obj=e.target;

			if (obj.parent!=stage) {
				stage.addChild(obj);
				obj.x=mouseX-16;
				obj.y=mouseY-16;
				obj.addEventListener(MouseEvent.MOUSE_UP, releaseIcon);
			}
			//make this easier to use when mouse goes off screen :(
			obj.startDrag(false, new Rectangle(8,8,600-8,480-48));


		}

		public function releaseIcon(e) {
			var obj=e.target;

			if (obj.hitTestObject(aIcon1)) {
				aIcon1.gotoAndStop(obj.currentFrame);
				Unit.currentUnit.hk4=new Item_Drink(5);
			} else if (obj.hitTestObject(aIcon2)) {
				aIcon2.gotoAndStop(obj.currentFrame);
				Unit.partnerUnit.hk4=new Item_Drink(5);
			}
			stage.removeChild(obj);
			obj.stopDrag();
			setInventory(true);
			obj.removeEventListener(MouseEvent.MOUSE_UP, releaseIcon);
		}
	}
}