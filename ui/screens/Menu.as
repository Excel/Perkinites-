package ui.screens{

	import flash.display.MovieClip;
	import flash.display.Sprite;
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
			trace("EQUIPPING ITEMS HAS LESS BUGS NOW, BUT EVERYTHING ELSE STILL NEEDS UPDATING");
			x=0;
			y=0;

			optionArray=new Array("\nCheck yo active Perkinites! You got this gurrrrrrrrrl! ;)",
			  "\nConfigure yo Boost Items to get Stat Bonuses! :)",
			  "Drag + drop Active Items to your Hotkeys for battle! Drag + drop Passive Items to the sidebars for innate effects! :)", 
			  "Drag + drop Active Items to your Hotkeys for battle! Drag + drop Passive Items to the sidebars for innate effects! Passive sidebars can't have duplicates though! :)",
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
			if (currentFrame!=1) {
				gotoPage(1);
				arrow.y=71;
				hover.y=64;
			}
		}
		public function pageHandler2(e) {
			if (currentFrame!=2) {
				gotoPage(2);
				arrow.y=71+32;
				hover.y=64+32;
			}
		}
		public function pageHandler3(e) {
			if (currentFrame!=3) {
				gotoPage(3);
				arrow.y=71+32*2;
				hover.y=64+32*2;
			}
		}
		public function pageHandler4(e) {
			if (currentFrame!=4) {
				gotoPage(4);
				arrow.y=71+32*3;
				hover.y=64+32*3;
			}
		}
		public function pageHandler5(e) {
			if (currentFrame!=5) {
				gotoPage(5);
				arrow.y=71+32*4;
				hover.y=64+32*4;
			}
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
					eraseDescriptionText();
					freezeHotkeys();
					setPassives(true);
					setInventory(true);
					break;
				case 4 :
					optionDisplay.text="Abilities";
					eraseDescriptionText();
					freezeHotkeys();
					setPassives(false);
					setInventory(false);
					break;
				case 5 :
					optionDisplay.text="Partners";
					freezeHotkeys();
					updateToggles();
					break;
			}
		}

		public function eraseDescriptionText(){
			thingName.text = "";
			useInfo.text = "";
			rangeInfo.text = "";
			cooldownInfo.text = "";
			availabilityInfo.text = "";
			thingDescription.text= "";
		}
		public function freezeHotkeys() {

			qIcon1.gotoAndStop(1);
			qIcon2.gotoAndStop(1);
			wIcon1.gotoAndStop(1);
			wIcon2.gotoAndStop(1);
			eIcon1.gotoAndStop(1);
			eIcon2.gotoAndStop(1);
			aIcon1.gotoAndStop(1);
			aIcon2.gotoAndStop(1);
			sIcon1.gotoAndStop(1);
			sIcon2.gotoAndStop(1);
			dIcon1.gotoAndStop(1);
			dIcon2.gotoAndStop(1);

			if (Unit.currentUnit.hk1!=null) {
				qIcon1.gotoAndStop(Unit.currentUnit.hk1.index);
			}
			if (Unit.currentUnit.hk2!=null) {
				wIcon1.gotoAndStop(Unit.currentUnit.hk2.index);
			}
			if (Unit.currentUnit.hk3!=null) {
				eIcon1.gotoAndStop(Unit.currentUnit.hk3.index);
			}
			if (Unit.currentUnit.hk4!=null) {
				aIcon1.gotoAndStop(Unit.currentUnit.hk4.index);
			}
			if (Unit.currentUnit.hk5!=null) {
				sIcon1.gotoAndStop(Unit.currentUnit.hk5.index);
			}
			if (Unit.currentUnit.hk6!=null) {
				dIcon1.gotoAndStop(Unit.currentUnit.hk6.index);
			}
			if (Unit.partnerUnit.hk1!=null) {
				qIcon2.gotoAndStop(Unit.partnerUnit.hk1.index);
			}
			if (Unit.partnerUnit.hk2!=null) {
				wIcon2.gotoAndStop(Unit.partnerUnit.hk2.index);
			}
			if (Unit.partnerUnit.hk3!=null) {
				eIcon2.gotoAndStop(Unit.partnerUnit.hk3.index);
			}
			if (Unit.partnerUnit.hk4!=null) {
				aIcon2.gotoAndStop(Unit.partnerUnit.hk4.index);
			}
			if (Unit.partnerUnit.hk5!=null) {
				sIcon2.gotoAndStop(Unit.partnerUnit.hk5.index);
			}
			if (Unit.partnerUnit.hk6!=null) {
				dIcon2.gotoAndStop(Unit.partnerUnit.hk6.index);
			}

			qIcon1.useCount.visible=false;
			wIcon1.useCount.visible=false;
			eIcon1.useCount.visible=false;
			aIcon1.useCount.visible=false;
			sIcon1.useCount.visible=false;
			dIcon1.useCount.visible=false;
			qIcon2.useCount.visible=false;
			wIcon2.useCount.visible=false;
			eIcon2.useCount.visible=false;
			aIcon2.useCount.visible=false;
			sIcon2.useCount.visible=false;
			dIcon2.useCount.visible=false;

			if (currentFrame==5) {
				asIcon1.gotoAndStop(1);
				asIcon2.gotoAndStop(1);
			} else {
				thingIcon.gotoAndStop(1);
				thingIcon.useCount.visible=false;
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

		public function clearDisplayList(list) {
			while (list.numChildren > 1) {
				list.removeChild(list.getChildAt(list.numChildren-1));
			}
		}
		public function setPassives(useItems:Boolean) {
			var xOffset=8;
			var yOffset=8;

			clearDisplayList(passiveList1);
			clearDisplayList(passiveList2);

			Unit.currentUnit.passiveItems.sortOn("id", Array.NUMERIC);
			Unit.partnerUnit.passiveItems.sortOn("id", Array.NUMERIC);

			if (useItems) {

				var itemIcon;
				var i;

				if (Unit.currentUnit.passiveItems.length>3) {
					passiveList1.height+=36 * (Unit.currentUnit.passiveItems.length - 3);

				}
				for (i = 0; i < Unit.currentUnit.passiveItems.length; i++) {
					itemIcon = new AbilityIcon();
					itemIcon.gotoAndStop(Unit.currentUnit.passiveItems[i].index);
					itemIcon.x=xOffset;
					itemIcon.y=yOffset;
					itemIcon.useCount.visible=false;
					passiveList1.addChild(itemIcon);
					itemIcon.addEventListener(MouseEvent.MOUSE_DOWN, movePassiveIconHandler);
					yOffset+=36;
				}

				xOffset=8;
				yOffset=8;
				for (i = 0; i < Unit.partnerUnit.passiveItems.length; i++) {
					itemIcon = new AbilityIcon();
					itemIcon.gotoAndStop(Unit.partnerUnit.passiveItems[i].index);
					itemIcon.x=xOffset;
					itemIcon.y=yOffset;
					itemIcon.useCount.visible=false;
					passiveList2.addChild(itemIcon);
					itemIcon.addEventListener(MouseEvent.MOUSE_DOWN, movePassiveIconHandler);
					yOffset+=36;
				}
			}

			passive1.source=passiveList1;
			passive2.source=passiveList2;
		}

		public function setInventory(useItems:Boolean) {

			var xOffset=16;
			var yOffset=8;
			var i;

			clearDisplayList(inventoryList);

			if (useItems) {
				for (i = 0; i < ItemDatabase.uses.length; i++) {
					if (i%6==0&&i!=0) {
						xOffset=16;
						yOffset+=36;
					}
					if (ItemDatabase.getUses(i)>0) {
						var itemIcon = new AbilityIcon();
						itemIcon.gotoAndStop(ItemDatabase.getIndex(i));
						itemIcon.x=xOffset;
						itemIcon.y=yOffset;
						itemIcon.useCount.text=ItemDatabase.getUses(i)+"";
						itemIcon.useCount.visible=true;
						inventoryList.addChild(itemIcon);
						itemIcon.addEventListener(MouseEvent.MOUSE_DOWN, moveIconHandler);
						xOffset+=40;
					}
				}
			} else {

			}

			inventory.source=inventoryList;

		}

		public function moveIconHandler(e) {
			var obj=e.target;
			if (obj is TextField) {
				obj=obj.parent;
			}
			if (obj.parent!=stage) {
				stage.addChild(obj);
				obj.x=mouseX-16;
				obj.y=mouseY-16;
				obj.addEventListener(MouseEvent.MOUSE_UP, releaseIcon);

				var index=ItemDatabase.index.indexOf(obj.currentFrame);

				thingName.text=ItemDatabase.getName(index);
				thingDescription.text=ItemDatabase.getDescription(index);

				cooldownInfo.text="COOLDOWN: "+ItemDatabase.getCooldown(index);

			}
			//make this easier to use when mouse goes off screen?
			obj.startDrag(false, new Rectangle(8,8,592,432));


		}

		public function releaseIcon(e) {
			var obj=e.target;
			var index=ItemDatabase.index.indexOf(obj.currentFrame);

			if (obj.hitTestObject(passiveList1)) {
				if (! ItemDatabase.getActive(index)) {
					ItemDatabase.uses[index]--;
					Unit.currentUnit.passiveItems.push(new Item(index, 1));
					setPassives(true);
				}
			} else if (obj.hitTestObject(passiveList2)) {
				if (! ItemDatabase.getActive(index)) {
					ItemDatabase.uses[index]--;
					Unit.partnerUnit.passiveItems.push(new Item(index, 1));
					setPassives(true);
				}
			} else {
				if (ItemDatabase.getActive(index)) {
					if (qIcon1.hitTestPoint(obj.x+16,obj.y+16,false)) {
						qIcon1.gotoAndStop(obj.currentFrame);
						Unit.currentUnit.hk1=new Item(index,0);
					} else if (qIcon2.hitTestPoint(obj.x+16,obj.y+16,false)) {
						qIcon2.gotoAndStop(obj.currentFrame);
						Unit.partnerUnit.hk1=new Item(index,0);
					} else if (wIcon1.hitTestPoint(obj.x+16,obj.y+16,false)) {
						wIcon1.gotoAndStop(obj.currentFrame);
						Unit.currentUnit.hk2=new Item(index,0);
					} else if (wIcon2.hitTestPoint(obj.x+16,obj.y+16,false)) {
						wIcon2.gotoAndStop(obj.currentFrame);
						Unit.partnerUnit.hk2=new Item(index,0);
					} else if (eIcon1.hitTestPoint(obj.x+16,obj.y+16,false)) {
						eIcon1.gotoAndStop(obj.currentFrame);
						Unit.currentUnit.hk3=new Item(index,0);
					} else if (eIcon2.hitTestPoint(obj.x+16,obj.y+16,false)) {
						eIcon2.gotoAndStop(obj.currentFrame);
						Unit.partnerUnit.hk3=new Item(index,0);
					} else if (aIcon1.hitTestPoint(obj.x+16,obj.y+16,false)) {
						aIcon1.gotoAndStop(obj.currentFrame);
						Unit.currentUnit.hk4=new Item(index,0);
					} else if (aIcon2.hitTestPoint(obj.x+16,obj.y+16,false)) {
						aIcon2.gotoAndStop(obj.currentFrame);
						Unit.partnerUnit.hk4=new Item(index,0);
					} else if (sIcon1.hitTestPoint(obj.x+16,obj.y+16,false)) {
						sIcon1.gotoAndStop(obj.currentFrame);
						Unit.currentUnit.hk5=new Item(index,0);
					} else if (sIcon2.hitTestPoint(obj.x+16,obj.y+16,false)) {
						sIcon2.gotoAndStop(obj.currentFrame);
						Unit.partnerUnit.hk5=new Item(index,0);
					} else if (dIcon1.hitTestPoint(obj.x+16,obj.y+16,false)) {
						dIcon1.gotoAndStop(obj.currentFrame);
						Unit.currentUnit.hk6=new Item(index,0);
					} else if (dIcon2.hitTestPoint(obj.x+16,obj.y+16,false)) {
						dIcon2.gotoAndStop(obj.currentFrame);
						Unit.partnerUnit.hk6=new Item(index,0);
					}
				}


			}

			stage.removeChild(obj);
			obj.stopDrag();
			setInventory(true);
			obj.removeEventListener(MouseEvent.MOUSE_UP, releaseIcon);
		}


		public function movePassiveIconHandler(e) {
			var obj=e.target;
			var index=ItemDatabase.index.indexOf(obj.currentFrame);


			if (obj.parent!=stage) {
				var passiveItems;
				var i;
				if (obj.parent==passiveList1) {
					passiveItems=Unit.currentUnit.passiveItems;
					for (i = 0; i < passiveItems.length; i++) {
						if (passiveItems[i].id==index) {
							passiveItems.splice(i,1);
							break;
						}
					}

				} else if (obj.parent == passiveList2) {
					passiveItems=Unit.partnerUnit.passiveItems;
					for (i = 0; i < passiveItems.length; i++) {
						if (passiveItems[i].id==index) {
							passiveItems.splice(i,1);
							break;
						}
					}
				}
				stage.addChild(obj);
				obj.x=mouseX-16;
				obj.y=mouseY-16;
				obj.addEventListener(MouseEvent.MOUSE_UP, releasePassiveIcon);


				thingName.text=ItemDatabase.getName(index);
				thingDescription.text=ItemDatabase.getDescription(index);

				cooldownInfo.text="COOLDOWN: "+ItemDatabase.getCooldown(index);

			}
			obj.startDrag(false, new Rectangle(8,8,592,432));


		}

		public function releasePassiveIcon(e) {
			var obj=e.target;
			var index=ItemDatabase.index.indexOf(obj.currentFrame);

			if (obj.hitTestObject(passiveList1)) {
				Unit.currentUnit.passiveItems.push(new Item(index, 1));
			} else if (obj.hitTestObject(passiveList2)) {
				Unit.partnerUnit.passiveItems.push(new Item(index, 1));
			} else {
				ItemDatabase.uses[index]+=1;
			}

			stage.removeChild(obj);
			obj.stopDrag();
			setPassives(true);
			setInventory(true);
			obj.removeEventListener(MouseEvent.MOUSE_UP, releasePassiveIcon);
		}


	}
}