package ui.screens{

	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.*;
	import flash.filters.GlowFilter;
	import flash.ui.*;

	import flash.display.Sprite;
	import flash.geom.Rectangle;

	import abilities.*;
	import actors.*;
	import game.*;
	import items.*;
	import levels.*;

	public class Menu extends BaseScreen {

		public var hotkeyArray:Array;
		public var hotkeyIconArray:Array;
		public var optionArray:Array;
		public var toggleArray1:Array;
		public var toggleArray2:Array;

		public var aCover;
		public var pCover1;
		public var pCover2;

		public var decide:Boolean;
		function Menu(stageRef:Stage = null) {
			this.stageRef=stageRef;

			trace("Equipping abilities/items should work now! Once the databases get updated though, I have to go back to this again... =___=");
			trace("EVERYTHING ELSE STILL NEEDS UPDATING");
			x=0;
			y=0;

			hotkeyArray = new Array(Unit.currentUnit.hk1, Unit.currentUnit.hk2, Unit.currentUnit.hk3,
			Unit.currentUnit.hk4, Unit.currentUnit.hk5, Unit.currentUnit.hk6,
			Unit.partnerUnit.hk1, Unit.partnerUnit.hk2, Unit.partnerUnit.hk3,
			Unit.partnerUnit.hk4, Unit.partnerUnit.hk5, Unit.partnerUnit.hk6);
			hotkeyIconArray = new Array();
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

			aCover = new Cover();
			aCover.x=168;
			aCover.y=207;
			pCover1 = new Cover();
			pCover1.x=168;
			pCover1.y=280;
			pCover1.width=88;
			pCover1.height=144;
			pCover2= new Cover();
			pCover2.x=544;
			pCover2.y=280;
			pCover2.width=88;
			pCover2.height=144;
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
			
			
			EXPCount.text = Unit.EXP+"";
			nextCount.text = Unit.nextEXP+"";
			FPDisplay.text = Unit.flexPoints.toFixed(2);
			load();

		}


		override public function keyHandler(e:KeyboardEvent):void {
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
			//disableKeyHandler();

		}
		public function saveHandler(e) {
			unload(new FileScreen(false,this,stageRef));
		}
		public function loadHandler(e) {
			unload(new FileScreen(true,this,stageRef));
		}
		public function exitHandler(e) {
			exit();
		}
		public function exit() {
			var sound = new se_timeout();
			sound.play();
			unload();
			GameUnit.menuPause=false;
			Unit.menuDelay=-5;
		}
		public function gotoPage(i:int) {
			gotoAndStop(i);
			if (aCover.parent!=null) {
				aCover.parent.removeChild(aCover);
			}
			if (pCover1.parent!=null) {
				pCover1.parent.removeChild(pCover1);
			}
			if (pCover2.parent!=null) {
				pCover2.parent.removeChild(pCover2);
			}
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
					eraseDescription();
					freezeHotkeys();
					setPassives(true);
					setInventory(true);
					break;
				case 4 :
					optionDisplay.text="Abilities";
					eraseDescription();
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

		public function eraseDescription() {
			thingIcon.visible=false;
			thingName.text="";
			useInfo.text="";
			rangeInfo.text="";
			cooldownInfo.text="";
			availabilityInfo.text="";
			thingDescription.text="";
		}

		public function makeDescription(index:int, type:String) {
			thingIcon.visible=true;

			if (type=="Item") {
				thingName.text=ItemDatabase.getName(index);
				useInfo.text="";
				rangeInfo.text="";
				cooldownInfo.text="COOLDOWN: "+ItemDatabase.getCooldown(index);
				availabilityInfo.text="";
				thingDescription.text=ItemDatabase.getDescription(index);
			} else if (type == "Ability") {
				thingName.text=AbilityDatabase.getName(index);
				useInfo.text="";
				rangeInfo.text="";
				cooldownInfo.text="COOLDOWN: "+AbilityDatabase.getCooldown(index);
				availabilityInfo.text="";
				thingDescription.text=AbilityDatabase.getDescription(index);
			}




		}
		public function freezeHotkeys() {
			if (currentFrame!=5) {
				hotkeyIconArray=[hotkeyHolder.qIcon1,hotkeyHolder.wIcon1,
				 hotkeyHolder.eIcon1,hotkeyHolder.aIcon1,
				 hotkeyHolder.sIcon1,hotkeyHolder.dIcon1,
				 hotkeyHolder.qIcon2,hotkeyHolder.wIcon2,
				 hotkeyHolder.eIcon2,hotkeyHolder.aIcon2,
				 hotkeyHolder.sIcon2,hotkeyHolder.dIcon2];
			} else {
				hotkeyIconArray=[qIcon1, wIcon1, eIcon1, aIcon1, sIcon1, dIcon1,
				 qIcon2, wIcon2, eIcon2, aIcon2, sIcon2, dIcon2];
			}
			var i;
			for (i = 0; i < hotkeyIconArray.length; i++) {
				hotkeyIconArray[i].useCount.visible=false;
				if (currentFrame!=5) {
					hotkeyIconArray[i].addEventListener(MouseEvent.MOUSE_DOWN, moveActiveIcon);
				} else {
					hotkeyIconArray[i].removeEventListener(MouseEvent.MOUSE_DOWN, moveActiveIcon);
				}
				if (hotkeyArray[i]!=null) {
					hotkeyIconArray[i].gotoAndStop(hotkeyArray[i].index);
				} else {
					hotkeyIconArray[i].gotoAndStop(1);
					if (currentFrame!=5) {
						hotkeyIconArray[i].visible=false;
					}
				}
			}

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

				if (Unit.currentUnit.passiveItems.length>2) {
					var bound:Sprite = new Sprite();
					passiveList1.addChild(bound);
					bound.graphics.lineStyle(1,0x000000);
					bound.graphics.beginFill(0x565656);
					bound.graphics.drawRect(0,0,48,96+36 * (Unit.currentUnit.passiveItems.length - 2));
					bound.graphics.endFill();
				}
				for (i = 0; i < Unit.currentUnit.passiveItems.length; i++) {
					itemIcon = new AbilityIcon();
					itemIcon.gotoAndStop(Unit.currentUnit.passiveItems[i].index);
					itemIcon.x=xOffset;
					itemIcon.y=yOffset;
					itemIcon.useCount.visible=false;
					itemIcon.type="Item";
					passiveList1.addChild(itemIcon);
					itemIcon.addEventListener(MouseEvent.MOUSE_DOWN, movePassiveIcon);
					yOffset+=36;
				}

				xOffset=8;
				yOffset=8;

				if (Unit.partnerUnit.passiveItems.length>2) {
					var bound2:Sprite = new Sprite();
					passiveList2.addChild(bound2);
					bound2.graphics.lineStyle(1,0x000000);
					bound2.graphics.beginFill(0x565656);
					bound2.graphics.drawRect(0,0,48,96+36 * (Unit.partnerUnit.passiveItems.length - 2));
					bound2.graphics.endFill();
				}
				for (i = 0; i < Unit.partnerUnit.passiveItems.length; i++) {
					itemIcon = new AbilityIcon();
					itemIcon.gotoAndStop(Unit.partnerUnit.passiveItems[i].index);
					itemIcon.x=xOffset;
					itemIcon.y=yOffset;
					itemIcon.useCount.visible=false;
					itemIcon.type="Item";
					passiveList2.addChild(itemIcon);
					itemIcon.addEventListener(MouseEvent.MOUSE_DOWN, movePassiveIcon);
					yOffset+=36;
				}
			} else {

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
				for (i = 0; i < Unit.itemAmounts.length; i++) {
					if (i%6==0&&i!=0) {
						xOffset=16;
						yOffset+=36;
					}
					if (Unit.itemAmounts[i]>0) {
						var itemIcon = new AbilityIcon();
						itemIcon.gotoAndStop(ItemDatabase.getIndex(i));
						itemIcon.x=xOffset;
						itemIcon.y=yOffset;
						itemIcon.useCount.text=Unit.itemAmounts[i]+"";
						itemIcon.useCount.visible=true;
						itemIcon.type="Item";
						inventoryList.addChild(itemIcon);
						itemIcon.addEventListener(MouseEvent.MOUSE_DOWN, moveIcon);
						xOffset+=40;
					}
				}
			} else {
				for (i = 0; i < Unit.abilityAmounts.length; i++) {
					if (i%6==0&&i!=0) {
						xOffset=16;
						yOffset+=36;
					}
					if (Unit.abilityAmounts[i]>0) {
						var abilityIcon = new AbilityIcon();
						abilityIcon.gotoAndStop(AbilityDatabase.getIndex(i));
						abilityIcon.x=xOffset;
						abilityIcon.y=yOffset;
						abilityIcon.useCount.text=Unit.abilityAmounts[i]+"";
						abilityIcon.useCount.visible=true;
						abilityIcon.type="Ability";
						inventoryList.addChild(abilityIcon);
						abilityIcon.addEventListener(MouseEvent.MOUSE_DOWN, moveIcon);
						xOffset+=40;
					}
				}
			}

			inventory.source=inventoryList;

		}

		public function moveIcon(e) {
			var obj=e.target;
			if (obj is TextField) {
				obj=obj.parent;
			}
			if (obj.parent!=stageRef) {
				var index;
				if (obj.type=="Item") {
					index=ItemDatabase.index.indexOf(obj.currentFrame);
					makeDescription(index, obj.type);

					if (ItemDatabase.getActive(index)) {
						stageRef.addChild(pCover1);
						stageRef.addChild(pCover2);
						if (aCover.parent!=null) {
							aCover.parent.removeChild(aCover);
						}
					} else {
						stageRef.addChild(aCover);
						if (pCover1.parent!=null) {
							pCover1.parent.removeChild(pCover1);
						}
						if (pCover2.parent!=null) {
							pCover2.parent.removeChild(pCover2);
						}
					}

				} else {
					index=AbilityDatabase.index.indexOf(obj.currentFrame);
					makeDescription(index, obj.type);
					if (AbilityDatabase.getActive(index)) {
						stageRef.addChild(pCover1);
						stageRef.addChild(pCover2);
						if (aCover.parent!=null) {
							aCover.parent.removeChild(aCover);
						}
					} else {
						stageRef.addChild(aCover);
						if (pCover1.parent!=null) {
							pCover1.parent.removeChild(pCover1);
						}
						if (pCover2.parent!=null) {
							pCover2.parent.removeChild(pCover2);
						}
					}

				}
				stageRef.addChild(obj);
				obj.x=mouseX-16;
				obj.y=mouseY-16;
				obj.addEventListener(MouseEvent.MOUSE_UP, releaseIcon);
			}
			//make this easier to use when mouse goes off screen?
			obj.startDrag(false, new Rectangle(8,8,592,432));
		}

		public function releaseIcon(e) {
			var hkIcon;
			var index;
			var i;

			var obj=e.target;

			if (obj.type=="Item") {
				index=ItemDatabase.index.indexOf(obj.currentFrame);
				if (ItemDatabase.getActive(index)) {
					stageRef.removeChild(pCover1);
					stageRef.removeChild(pCover2);
				} else {
					stageRef.removeChild(aCover);
				}


				if (obj.hitTestObject(passiveList1)) {
					if (! ItemDatabase.getActive(index)) {
						Unit.itemAmounts[index]--;
						Unit.currentUnit.passiveItems.push(new Item(index, 1));
						setPassives(true);
					}
				} else if (obj.hitTestObject(passiveList2)) {
					if (! ItemDatabase.getActive(index)) {
						Unit.itemAmounts[index]--;
						Unit.partnerUnit.passiveItems.push(new Item(index, 1));
						setPassives(true);
					}
				} else {
					if (ItemDatabase.getActive(index)) {
						for (i = 0; i < hotkeyIconArray.length; i++) {
							hkIcon=hotkeyIconArray[i];
							if (hkIcon.hitTestPoint(obj.x+16,obj.y+16,false)) {
								hkIcon.gotoAndStop(obj.currentFrame);
								hkIcon.visible=true;
								hotkeyArray[i]=new Item(index,0);
								if (i>5) {
									Unit.partnerUnit.setHotkey(i-5, new Item(index, 0));
								} else {
									Unit.currentUnit.setHotkey(i+1, new Item(index, 0));
								}
							}
						}
					}


				}
				setInventory(true);

			} else if (obj.type == "Ability") {
				index=AbilityDatabase.index.indexOf(obj.currentFrame);
				if (AbilityDatabase.getActive(index)) {
					stageRef.removeChild(pCover1);
					stageRef.removeChild(pCover2);
				} else {
					stageRef.removeChild(aCover);
				}

				if (obj.hitTestObject(passiveList1)) {
					if (! AbilityDatabase.getActive(index)) {
						Unit.abilityAmounts[index]--;
						Unit.currentUnit.passiveAbilities.push(new Ability(index, 1));
						setPassives(false);
					}
				} else if (obj.hitTestObject(passiveList2)) {
					if (! AbilityDatabase.getActive(index)) {
						Unit.abilityAmounts[index]--;
						Unit.partnerUnit.passiveAbilities.push(new Ability(index, 1));
						setPassives(false);
					}
				} else {
					if (AbilityDatabase.getActive(index)) {
						for (i = 0; i < hotkeyIconArray.length; i++) {
							hkIcon=hotkeyIconArray[i];
							if (hkIcon.hitTestPoint(obj.x+16,obj.y+16,false)) {
								hkIcon.gotoAndStop(obj.currentFrame);
								hkIcon.visible=true;
								hotkeyArray[i]=new Ability(index,0);
								if (i>5) {
									Unit.partnerUnit.setHotkey(i-5, new Ability(index, 0));
								} else {
									Unit.currentUnit.setHotkey(i+1, new Ability(index, 0));
								}

								Unit.abilityAmounts[index]--;
								break;
							}
						}
					}
				}
				setInventory(false);
			}
			stageRef.removeChild(obj);
			obj.stopDrag();

			obj.removeEventListener(MouseEvent.MOUSE_UP, releaseIcon);
		}


		public function moveActiveIcon(e) {
			var obj=e.target;

			if (obj is TextField) {
				obj=obj.parent;
			}
			if (hotkeyArray[hotkeyIconArray.indexOf(obj)]!=null) {
				var index;
				if (obj.parent!=stageRef) {
					if (obj.type=="Item") {
						index=ItemDatabase.index.indexOf(obj.currentFrame);
					} else if (obj.type == "Ability") {
						index=AbilityDatabase.index.indexOf(obj.currentFrame);
					}
					makeDescription(index, obj.type);
					stageRef.addChild(pCover1);
					stageRef.addChild(pCover2);

					if (aCover.parent!=null) {
						aCover.parent.removeChild(aCover);
					}

					stageRef.addChild(obj);
					obj.x=mouseX-16;
					obj.y=mouseY-16;
					obj.addEventListener(MouseEvent.MOUSE_UP, releaseActiveIcon);

				}
				//make this easier to use when mouse goes off screen?
				obj.startDrag(false, new Rectangle(8,8,592,432));
			}
		}


		public function releaseActiveIcon(e) {
			var obj=e.target;
			var index;
			if (obj.type=="Item") {
				index=ItemDatabase.index.indexOf(obj.currentFrame);
			} else {
				index=AbilityDatabase.index.indexOf(obj.currentFrame);
			}
			var i;
			var j;

			stageRef.removeChild(pCover1);
			stageRef.removeChild(pCover2);

			var backToInventory=true;

			for (i = 0; i < hotkeyIconArray.length; i++) {
				var hkIcon=hotkeyIconArray[i];
				if (hkIcon.hitTestPoint(obj.x+16,obj.y+16,false)&&hkIcon!=obj) {
					backToInventory=false;


					if (hotkeyArray[i]!=null) {
						//set the old icon to the new icon
						j=hotkeyIconArray.indexOf(obj);
						var tempFrame=obj.currentFrame;
						var tempHotkey=hotkeyArray[j];

						obj.gotoAndStop(hkIcon.currentFrame);
						hotkeyArray[j]=hotkeyArray[i];
						if (j>5) {
							Unit.partnerUnit.setHotkey(j-5, hotkeyArray[j]);
						} else {
							Unit.currentUnit.setHotkey(j+1, hotkeyArray[j]);
						}

						//set the new icon to the old icon
						hkIcon.gotoAndStop(tempFrame);
						hkIcon.visible=true;
						hotkeyArray[i]=tempHotkey;
						if (i>5) {
							Unit.partnerUnit.setHotkey(i-5, hotkeyArray[i]);
						} else {
							Unit.currentUnit.setHotkey(i+1, hotkeyArray[i]);
						}



					} else {
						j=hotkeyIconArray.indexOf(obj);

						//set the new icon to the old icon
						hkIcon.gotoAndStop(obj.currentFrame);
						hkIcon.visible=true;
						hotkeyArray[i]=hotkeyArray[j];
						if (i>5) {
							Unit.partnerUnit.setHotkey(i-5, hotkeyArray[i]);
						} else {
							Unit.currentUnit.setHotkey(i+1, hotkeyArray[i]);
						}

						//erase the old icon
						obj.visible=false;
						obj.gotoAndStop(1);

						hotkeyArray[j]=null;
						if (j>5) {
							Unit.partnerUnit.setHotkey(j-5, null);
						} else {
							Unit.currentUnit.setHotkey(j+1, null);
						}
					}
					break;
				}
			}


			if (backToInventory) {
				if (! obj.hitTestObject(aCover)) {
					obj.visible=false;
					obj.gotoAndStop(1);
					j=hotkeyIconArray.indexOf(obj);
					hotkeyArray[j]=null;
					if (j>5) {
						Unit.partnerUnit.setHotkey(j-5, null);
					} else {
						Unit.currentUnit.setHotkey(j+1, null);
					}

					Unit.abilityAmounts[index]+=1;
				}

			}
			obj.y=0;
			if (hotkeyIconArray.indexOf(obj)>5) {
				obj.x=224+32*hotkeyIconArray.indexOf(obj);
			} else {
				obj.x=0+32*hotkeyIconArray.indexOf(obj);
			}
			hotkeyHolder.addChild(obj);


			obj.stopDrag();
			if (obj.type=="Item") {
				setInventory(true);
			} else {
				setInventory(false);
			}
			//obj.removeEventListener(MouseEvent.MOUSE_UP, releaseActiveIcon);
		}


		public function movePassiveIcon(e) {
			var obj=e.target;


			if (obj.parent!=stageRef) {
				var passive;
				var index;
				var i;
				if (obj.type=="Item") {
					index=ItemDatabase.index.indexOf(obj.currentFrame);
				} else {
					index=AbilityDatabase.index.indexOf(obj.currentFrame);
				}

				stageRef.addChild(aCover);
				if (pCover1.parent!=null) {
					pCover1.parent.removeChild(pCover1);
				}
				if (pCover2.parent!=null) {
					pCover2.parent.removeChild(pCover2);
				}
				if (obj.type=="Item") {
					if (obj.parent==passiveList1) {
						passive=Unit.currentUnit.passiveItems;
						for (i = 0; i < passive.length; i++) {
							if (passive[i].id==index) {
								passive.splice(i,1);
								break;
							}
						}

					} else if (obj.parent == passiveList2) {
						passive=Unit.partnerUnit.passiveItems;
						for (i = 0; i < passive.length; i++) {
							if (passive[i].id==index) {
								passive.splice(i,1);
								break;
							}
						}
					}
				} else if (obj.type == "Ability") {
					if (obj.parent==passiveList1) {
						passive=Unit.currentUnit.passiveAbilities;
						for (i = 0; i < passive.length; i++) {
							if (passive[i].id==index) {
								passive.splice(i,1);
								break;
							}
						}

					} else if (obj.parent == passiveList2) {
						passive=Unit.partnerUnit.passiveAbilities;
						for (i = 0; i < passive.length; i++) {
							if (passive[i].id==index) {
								passive.splice(i,1);
								break;
							}
						}
					}
				}
				stageRef.addChild(obj);
				obj.x=mouseX-16;
				obj.y=mouseY-16;
				obj.addEventListener(MouseEvent.MOUSE_UP, releasePassiveIcon);

				makeDescription(index, obj.type);

			}
			obj.startDrag(false, new Rectangle(8,8,592,432));
		}

		public function releasePassiveIcon(e) {
			var obj=e.target;
			var index;

			if (obj.type=="Item") {
				index=ItemDatabase.index.indexOf(obj.currentFrame);
			} else {
				index=AbilityDatabase.index.indexOf(obj.currentFrame);
			}

			stageRef.removeChild(aCover);
			if (obj.type=="Item") {
				if (obj.hitTestObject(passiveList1)) {
					Unit.currentUnit.passiveItems.push(new Item(index, 1));
				} else if (obj.hitTestObject(passiveList2)) {
					Unit.partnerUnit.passiveItems.push(new Item(index, 1));
				} else {
					Unit.itemAmounts[index]+=1;
				}
				setPassives(true);
				setInventory(true);
			} else if (obj.type=="Ability") {
				if (obj.hitTestObject(passiveList1)) {
					Unit.currentUnit.passiveAbilities.push(new Ability(index, 1));
				} else if (obj.hitTestObject(passiveList2)) {
					Unit.partnerUnit.passiveAbilities.push(new Ability(index, 1));
				} else {
					Unit.abilityAmounts[index]+=1;
				}
				setPassives(false);
				setInventory(false);
			}

			stageRef.removeChild(obj);
			obj.stopDrag();

			obj.removeEventListener(MouseEvent.MOUSE_UP, releasePassiveIcon);
		}
	}
}