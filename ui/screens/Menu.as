﻿package ui.screens{

	import flash.display.InterpolationMethod;
	import flash.text.TextField;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.*;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;
	import flash.ui.*;

	import fl.events.SliderEvent;

	import flash.display.Sprite;
	import flash.geom.Rectangle;

	import abilities.*;
	import actors.*;
	import game.*;
	import maps.*;

	public class Menu extends BaseScreen {

		public var passiveThing;
		static public var menuPage:int = -1;
		static public var iaOption:int = -1;
		static public var setUnitIndex:int = -1;
		static public var currentActivated:Boolean=true;
		static public var sliderValueArray:Array = new Array();

		public var hotkeyArray:Array;
		public var hotkeyIconArray:Array;
		public var blockedHotkeyArray:Array;
		public var optionArray:Array;


		public var aCover;
		public var pCover1;
		public var pCover2;

		public var iconCover;
		public var redCover;

		public var gf1;

		function Menu(stageRef:Stage = null) {

			this.stageRef=stageRef;

			if (iaOption==-1) {
				iaOption=1;
			}
			if (menuPage == -1) {
				menuPage = 1;
			}
			if (Unit.currentUnit.id!=setUnitIndex&&Unit.partnerUnit.id!=setUnitIndex) {
				setUnitIndex=Unit.currentUnit.id;
				currentActivated=true;
			}
			if (sliderValueArray.length==0) {
				sliderValueArray=new Array(1,1,1,1,1,1);
			}

			x=0;
			y=0;

			hotkeyArray=new Array(Unit.hk1,Unit.hk2,Unit.hk3,Unit.hk4,Unit.hk5,Unit.hk6,Unit.hk7);
			hotkeyIconArray = new Array();
			blockedHotkeyArray=new Array(false,false,false,false,false,false,false);
			optionArray=new Array("\nCheck on yo Perkinites! You got this gurrrrrrrrrl! ;)",
			  "Drag + drop Active Icons to your Hotkeys for battle and Passive Icons to the sidebars for innate effects! Passive sidebars can't have duplicates though! :)",
			  "\nConfigure yo Abilities' powers! You got this Chicken McNugget! ;)");


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

			iconCover=new ColorTransform(0.3,0.3,0.3,0.5,0,0,0,0);
			redCover=new ColorTransform(0.75,0.3,0.3,0.5,0,0,0,0);


			gf1=new GlowFilter(0xFF9900,100,20,20,1,5,true,false);

			gotoAndStop(1);
			gotoPage(menuPage);

			arrow.gotoAndStop(1);
			if (currentFrame == 1) {
				arrow.y = 71;
				hover.y = 64;
			} else if (currentFrame == 2) {
				arrow.y = 71+64;
				hover.y = 64+64;
			} else if (currentFrame == 3) {
				arrow.y = 71 + 32;
				hover.y = 64 + 32;
			}
			statusOption.addEventListener(MouseEvent.CLICK, pageHandler);
			setupOption.addEventListener(MouseEvent.CLICK, pageHandler3);
			abilitiesOption.addEventListener(MouseEvent.CLICK, pageHandler2);

			configOption.addEventListener(MouseEvent.CLICK, configHandler);
			saveOption.addEventListener(MouseEvent.CLICK, saveHandler);
			loadOption.addEventListener(MouseEvent.CLICK, loadHandler);
			exitOption.addEventListener(MouseEvent.CLICK, exitHandler);

			page2.recycleButton.visible=false;
			page2.recycleButton.addEventListener(MouseEvent.CLICK, recycleHandler);
			page2.recycleButton.mouseChildren=false;

			page3.currentButton.addEventListener(MouseEvent.CLICK, setCurrentHandler);
			page3.partnerButton.addEventListener(MouseEvent.CLICK, setPartnerHandler);

			flexPointsDisplay.text=Unit.flexPoints.toFixed(2);
			locationDisplay.text=MapManager.mapName;


			exampleIcon.useCount.visible=false;
			coverIcon.useCount.visible=false;
			redIcon.useCount.visible=false;
			exampleIcon.gotoAndStop(1);
			coverIcon.gotoAndStop(1);
			redIcon.gotoAndStop(1);
			coverIcon.transform.colorTransform=iconCover;
			redIcon.transform.colorTransform=redCover;
			
			
			GameUnit.menuPause=true;
			load();

		}


		override public function keyHandler(e:KeyboardEvent):void {
			/*if (e.keyCode=="X".charCodeAt(0)) {
				exit();
			}*/
		}

		public function pageHandler(e) {
			if (currentFrame!=1) {
				arrow.y=71;
				hover.y = 64;
				menuPage = 1;
				gotoPage(1);
			}
		}
		public function pageHandler2(e) {
			if (currentFrame!=2) {
				arrow.y=71+32*2;
				hover.y = 64 + 32 * 2;
				menuPage = 2;
				gotoPage(2);
			}
		}
		public function pageHandler3(e) {
			if (currentFrame!=3) {
				arrow.y=71+32;
				hover.y = 64 + 32;
				menuPage = 3;
				gotoPage(3);
			}
		}
		public function configHandler(e) {
			unload(new ConfigScreen(this, stage));

		}
		public function saveHandler(e) {
			GameVariables.gameClient.saveGame();
			//unload(new FileScreen(false,this,stageRef));
		}
		public function loadHandler(e) {
			GameVariables.gameClient.loadGame();
			//unload(new FileScreen(true,this,stageRef));
		}
		public function exitHandler(e) {
			exit();
		}
		public function exit() {
			var sound = new se_timeout();
			sound.play();
			unload();
			GameUnit.menuPause=false;
		}
		public function gotoPage(i:int) {
			gotoAndStop(i);

			switch (i) {
				case 1 :
					page1.visible=true;
					page2.visible=false;
					page3.visible=false;
					break;
				case 2 :
					page1.visible=false;
					page2.visible=true;
					page3.visible=false;
					break;
				case 3 :
					page1.visible=false;
					page2.visible=false;
					page3.visible=true;
					break;
			}
			removeCovers();
			update();
		}
		public function update() {
			optionDescription.text=optionArray[currentFrame-1];
			switch (currentFrame) {
				case 1 :
					optionDisplay.text="Status";
					page1.levelDisplay.text=Unit.maxLP;
					page1.EXPDisplay.text=Unit.EXP;
					page1.nextDisplay.text =(Unit.nextEXP - Unit.EXP);
					page1.unitName1.text=Unit.currentUnit.Name;
					page1.unitName2.text=Unit.partnerUnit.Name;

					page1.HPDisplay1.text=Unit.currentUnit.HP;
					page1.maxHPDisplay1.text=Unit.currentUnit.maxHP;
					page1.APDisplay1.text = Unit.currentUnit.getAttack();
					page1.SPDisplay1.text = Unit.currentUnit.getSpeed();

					page1.HPDisplay2.text=Unit.partnerUnit.HP;
					page1.maxHPDisplay2.text=Unit.partnerUnit.maxHP;
					page1.APDisplay2.text = Unit.partnerUnit.getAttack();
					page1.SPDisplay2.text = Unit.partnerUnit.getSpeed();

					freezeFaces();
					eraseDescription();
					setSliders();
					break;
				case 2 :
					optionDisplay.text="Equip";
					eraseDescription();
					freezeHotkeys();
					setInventory(iaOption);
					setPassives(iaOption);
					setButtons();
					break;
				case 3 :
					optionDisplay.text="Upgrade";
					eraseDescription();
					freezeHotkeys();
					setToggles();
					page3.currentButton.buttonText.text="Set 1";
					page3.partnerButton.buttonText.text="Set 2";
					break;
				case 4 :
					break;
				case 5 :
					break;
			}
		}

		public function eraseDescription() {
			page2.recycleButton.visible=false;
			thingIcon.visible=false;
			thingName.text="";
			useInfo.text="";
			effectInfo.text="";
			rangeInfo.text="";
			cooldownInfo.text="";		
			availabilityInfo.text="";
			thingDescription.text="";
		}

		public function makeDescription(index:int, type:String, recycle:Boolean = true) {
			var thing = AbilityDatabase.getAbility(index);
			
			if (currentFrame==2&&recycle) {
				if (thing.value>0) {
					page2.recycleButton.visible=true;
					page2.recycleButton.type=type;
					page2.recycleButton.index=index;
					page2.recycleButton.valueDisplay.text=thing.value.toFixed(2);
				} else {
					page2.recycleButton.visible=false;
				}
			} else {
				page2.recycleButton.visible=false;
			}
			thingIcon.visible=true;

			thingIcon.gotoAndStop(thing.index);
			thingName.text=thing.Name;

			useInfo.text=grabActivation(thing.ID,type);
			effectInfo.text=thing.getSpecInfo();
			rangeInfo.text="RANGE: "+thing.range;
			cooldownInfo.text="COOLDOWN: "+thing.maxCooldown;
			
			availabilityInfo.text="Available to "+thing.availability;
			thingDescription.text=thing.getDescription();
		}
		public function updateEquippedBasicAbilities() {
			var i;
			var j;
			var basicAbility;
			var index;
			for (i = 0; i < Unit.currentUnit.basicAbilities.length; i++) {
				basicAbility=Unit.currentUnit.basicAbilities[i];
				index=basicAbility.ID;
				for (j = 0; j < hotkeyArray.length; j++) {
					if (hotkeyArray[j]!=null&&hotkeyArray[j].Name==basicAbility.Name) {
						hotkeyArray[j]=getBasicAbility(index);
						Unit.setHotkey(j+1, getBasicAbility(index));
					}
				}
				for (j = 0; j < Unit.currentUnit.passiveAbilities.length; j++) {
					if (Unit.currentUnit.passiveAbilities[j].Name == basicAbility.Name) {
						Unit.currentUnit.passiveAbilities[j].cancel();
						Unit.currentUnit.passiveAbilities[j] = basicAbility;
						basicAbility.startAbility(Unit.currentUnit);						
					}
				}
			}
			for (i = 0; i < Unit.partnerUnit.basicAbilities.length; i++) {
				basicAbility=Unit.partnerUnit.basicAbilities[i];
				index=basicAbility.ID;
				for (j = 0; j < hotkeyArray.length; j++) {
					if (hotkeyArray[j]!=null&&hotkeyArray[j].Name==basicAbility.Name) {
						hotkeyArray[j]=getBasicAbility(index);
						Unit.setHotkey(j+1, getBasicAbility(index));
					}
				}
				for (j = 0; j < Unit.partnerUnit.passiveAbilities.length; j++) {
					if (Unit.partnerUnit.passiveAbilities[j].Name==basicAbility.Name) {
						Unit.partnerUnit.passiveAbilities[j].cancel();
						Unit.partnerUnit.passiveAbilities[j] = basicAbility;
						basicAbility.startAbility(Unit.partnerUnit);
					}
				}
			}
		}
		public function getBasicAbility(index) {
			var i;
			var ability;
			var basicAbilities;
			if (Unit.currentUnit.Name==AbilityDatabase.getAbility(index).availability) {
				basicAbilities=Unit.currentUnit.basicAbilities;
				for (i = 0; i < basicAbilities.length; i++) {
					if (AbilityDatabase.getAbility(index).Name==basicAbilities[i].Name) {
						ability=basicAbilities[i];
						break;
					}
				}
			} else if (Unit.partnerUnit.Name == AbilityDatabase.getAbility(index).availability) {
				basicAbilities=Unit.partnerUnit.basicAbilities;
				for (i = 0; i < basicAbilities.length; i++) {
					if (AbilityDatabase.getAbility(index).Name==basicAbilities[i].Name) {
						ability=basicAbilities[i];
					}
				}
			}
			return ability;
		}

		public function basicCooldownNotActive(index) {
			var Name=AbilityDatabase.getAbility(index).Name;
			for (var i = 0; i < hotkeyArray.length; i++) {
				if (hotkeyArray[i] != null && hotkeyArray[i].Name == Name) {
					if (hotkeyArray[i].cooldown<hotkeyArray[i].maxCooldown) {
						return false;
					} else {
						return true;
					}
				}
			}
			return true;
		}

		public function grabActivation(index:int, type:String) {
			var activation="USE: ";
			//activation=activation+AbilityDatabase.getActivationLabel(index);
			return activation;
		}
		public function freezeHotkeys() {
			var hotkeyHolder;
			if (currentFrame!=3) {
				hotkeyHolder=page2.hotkeyHolder;
				hotkeyIconArray=[hotkeyHolder.qIcon,hotkeyHolder.wIcon,
				 hotkeyHolder.eIcon,hotkeyHolder.aIcon,
				  hotkeyHolder.sIcon,hotkeyHolder.dIcon,
				 hotkeyHolder.fIcon];

			} else {
				hotkeyIconArray=[page3.icon1,page3.icon2,page3.icon3,page3.icon4,page3.icon5];
			}
			var i;
			for (i = 0; i < hotkeyIconArray.length; i++) {
				hotkeyIconArray[i].useCount.visible=false;
				if (currentFrame!=3) {
					hotkeyIconArray[i].addEventListener(MouseEvent.MOUSE_DOWN, moveActiveIcon);
				} else {
					hotkeyIconArray[i].addEventListener(MouseEvent.MOUSE_DOWN, displayIcon);
				}

				if (currentFrame==2) {
					if (hotkeyArray[i]!=null) {
						hotkeyIconArray[i].gotoAndStop(hotkeyArray[i].index);
						if (hotkeyArray[i] is Item) {
							hotkeyIconArray[i].type="Item";
						} else if (hotkeyArray[i] is Ability) {
							hotkeyIconArray[i].type="Ability";
						}
						if (hotkeyArray[i].min<=0) {
							hotkeyIconArray[i].transform.colorTransform=redCover;
						} else if (hotkeyArray[i].cooldown < hotkeyArray[i].maxCooldown) {
							hotkeyIconArray[i].transform.colorTransform=iconCover;
						} else {
							hotkeyIconArray[i].transform.colorTransform=new ColorTransform();
						}
					} else {
						hotkeyIconArray[i].gotoAndStop(1);
					}
				}

				if (currentFrame==3) {
					updatePowerupPage();
				}
			}
			thingIcon.useCount.visible=false;
		}

		public function freezeFaces() {
			page1.faceIcon1.gotoAndStop(Unit.currentUnit.id+2);
			page1.faceIcon2.gotoAndStop(Unit.partnerUnit.id+2);
		}


		public function setSliders() {
			page1.HPSlider1.minimum = page1.APSlider1.minimum = 
			page1.SPSlider1.minimum = page1.HPSlider2.minimum = 
			page1.APSlider2.minimum = page1.SPSlider2.minimum = 1;

			page1.HPSlider1.maximum = page1.APSlider1.maximum = 
			page1.SPSlider1.maximum = page1.HPSlider2.maximum = 
			page1.APSlider2.maximum = page1.SPSlider2.maximum = Unit.maxLP;

			page1.HPSlider1.addEventListener(SliderEvent.THUMB_DRAG, changeHPHandler1);
			page1.APSlider1.addEventListener(SliderEvent.THUMB_DRAG, changeAPHandler1);
			page1.SPSlider1.addEventListener(SliderEvent.THUMB_DRAG, changeSPHandler1);
			page1.HPSlider2.addEventListener(SliderEvent.THUMB_DRAG, changeHPHandler2);
			page1.APSlider2.addEventListener(SliderEvent.THUMB_DRAG, changeAPHandler2);
			page1.SPSlider2.addEventListener(SliderEvent.THUMB_DRAG, changeSPHandler2);

			page1.HPSlider1.value=sliderValueArray[0];
			page1.APSlider1.value=sliderValueArray[1];
			page1.SPSlider1.value=sliderValueArray[2];
			page1.HPSlider2.value=sliderValueArray[3];
			page1.APSlider2.value=sliderValueArray[4];
			page1.SPSlider2.value=sliderValueArray[5];
		}

		public function changeHPHandler1(e) {
			Unit.currentUnit.maxHP = ActorDatabase.getHP(Unit.currentUnit.id) + 
										(e.value-1)*ActorDatabase.getHPChange(Unit.currentUnit.id);
			if (Unit.currentUnit.HP>Unit.currentUnit.maxHP) {
				Unit.currentUnit.HP=Unit.currentUnit.maxHP;
			}
			sliderValueArray[0]=e.value;
			update();
		}
		public function changeAPHandler1(e) {
			Unit.currentUnit.AP = ActorDatabase.getDmg(Unit.currentUnit.id) +
										(e.value-1)*ActorDatabase.getDmgChange(Unit.currentUnit.id);
			sliderValueArray[1]=e.value;
			update();
		}
		public function changeSPHandler1(e) {
			Unit.currentUnit.speed = ActorDatabase.getSpeed(Unit.currentUnit.id) +
										(e.value-1)*ActorDatabase.getSpeedChange(Unit.currentUnit.id);
			sliderValueArray[2]=e.value;
			update();
		}
		public function changeHPHandler2(e) {
			Unit.partnerUnit.maxHP = ActorDatabase.getHP(Unit.partnerUnit.id)  +
										(e.value-1)*ActorDatabase.getHPChange(Unit.partnerUnit.id);
			if (Unit.partnerUnit.HP>Unit.partnerUnit.maxHP) {
				Unit.partnerUnit.HP=Unit.partnerUnit.maxHP;
			}
			sliderValueArray[3]=e.value;
			update();
		}
		public function changeAPHandler2(e) {
			Unit.partnerUnit.AP = ActorDatabase.getDmg(Unit.partnerUnit.id)  +
										(e.value-1)*ActorDatabase.getDmgChange(Unit.partnerUnit.id);
			sliderValueArray[4]=e.value;
			update();

		}
		public function changeSPHandler2(e) {
			Unit.partnerUnit.speed = ActorDatabase.getSpeed(Unit.partnerUnit.id)  +
													(e.value-1)*ActorDatabase.getSpeedChange(Unit.partnerUnit.id);
			sliderValueArray[5]=e.value;
			update();
		}
		/************************************************************************
		PAGE 2 STUFF
		************************************************************************/
		public function recycleHandler(e) {
			var obj=e.target;
			if (obj.type=="Item") {
				Unit.itemAmounts[obj.index]-=1;
			} else if (obj.type == "Ability") {
				Unit.abilityAmounts[obj.index]-=1;
			}
			Unit.flexPoints+=AbilityDatabase.getAbility(obj.index).value;			
			update();
			flexPointsDisplay.text=Unit.flexPoints.toFixed(2);

			if ((obj.type == "Item" && Unit.itemAmounts[obj.index]>0) || 
			(obj.type == "Ability" && Unit.abilityAmounts[obj.index]>0)) {
				makeDescription(obj.index, obj.type);
			}
		}

		public function setButtons() {
			page2.iaButton.buttonText.text="I + A";
			page2.aiButton.buttonText.text="A + I";
			page2.iButton.buttonText.text="Items";
			page2.aButton.buttonText.text="Abilities";

			page2.iaButton.addEventListener(MouseEvent.CLICK, iaHandler);
			page2.aiButton.addEventListener(MouseEvent.CLICK, aiHandler);
			page2.iButton.addEventListener(MouseEvent.CLICK, iHandler);
			page2.aButton.addEventListener(MouseEvent.CLICK, aHandler);

			colorButtons();
			//add event listeners
		}

		public function iaHandler(e) {
			setInventory(0);
			setPassives(0);
			colorButtons();
		}
		public function aiHandler(e) {
			setInventory(1);
			setPassives(1);
			colorButtons();
		}
		public function iHandler(e) {
			setInventory(2);
			setPassives(2);
			colorButtons();
		}
		public function aHandler(e) {
			setInventory(3);
			setPassives(3);
			colorButtons();
		}

		public function colorButtons() {
			switch (iaOption) {
				case 0 :
					page2.iaButton.filters=[gf1];
					page2.aiButton.filters=[];
					page2.iButton.filters=[];
					page2.aButton.filters=[];
					break;
				case 1 :
					page2.iaButton.filters=[];
					page2.aiButton.filters=[gf1];
					page2.iButton.filters=[];
					page2.aButton.filters=[];
					break;
				case 2 :
					page2.iaButton.filters=[];
					page2.aiButton.filters=[];
					page2.iButton.filters=[gf1];
					page2.aButton.filters=[];
					break;
				case 3 :
					page2.iaButton.filters=[];
					page2.aiButton.filters=[];
					page2.iButton.filters=[];
					page2.aButton.filters=[gf1];
					break;
			}
		}
		public function setInventory(option:int = 0) {
			var bound:Sprite = new Sprite();

			iaOption=option;
			/*
			option = 0 // items + abilities
			option = 1 //abilities + items
			option = 2 only i
			option = 3 only a
			*/
			clearDisplayList(page2.inventoryList);
			var yOffset=8;
			switch (option) {
				case 0 :
					yOffset=setInventoryItems(yOffset);
					setInventoryAbilities(yOffset);
					break;
				case 1 :
					yOffset=setInventoryAbilities(yOffset);
					setInventoryItems(yOffset);
					break;
				case 2 :
					setInventoryItems(yOffset);
					break;
				case 3 :
					setInventoryAbilities(yOffset);
					break;
			}
			if (page2.inventoryList.getChildAt(page2.inventoryList.numChildren-1).y>=116) {
				var difference = Math.floor((page2.inventoryList.getChildAt(page2.inventoryList.numChildren-1).y - 116)/36)+1;
				page2.inventoryList.addChildAt(bound, 1);
				bound.graphics.lineStyle(1,0x000000);
				bound.graphics.beginFill(0x565656);
				bound.graphics.drawRect(0,0,272,144+36 * difference);
				bound.graphics.endFill();
			}
			page2.inventory.source=page2.inventoryList;
		}

		public function clearDisplayList(list) {
			while (list.numChildren > 1) {
				list.removeChild(list.getChildAt(list.numChildren-1));
			}
		}

		public function setInventoryItems(yOffset:int) {
			var i;
			var xOffset=16;
			var amount=0;
			var confirm=false;

			for (i = 0; i < Unit.itemAmounts.length; i++) {
				if (amount%6==0&&amount!=0&&confirm) {
					xOffset=16;
					yOffset+=36;
					confirm=false;
				}
				if (Unit.itemAmounts[i]>0) {
					var itemIcon = new AbilityIcon();
					itemIcon.gotoAndStop(AbilityDatabase.getAbility(i).index);
					itemIcon.x=xOffset;
					itemIcon.y=yOffset;
					itemIcon.useCount.text=Unit.itemAmounts[i]+"";
					itemIcon.useCount.visible=true;
					itemIcon.type="Item";
					page2.inventoryList.addChild(itemIcon);
					itemIcon.addEventListener(MouseEvent.MOUSE_DOWN, moveIcon);
					xOffset+=40;
					amount++;
					confirm=true;
				}
			}

			if (amount>0) {
				return yOffset+36;
			} else {
				return yOffset;
			}
		}
		public function setInventoryAbilities(yOffset:int) {
			var i;
			var xOffset=16;
			var amount=0;
			var confirm=false;
			var ability;
			var abilityIcon;

			var tempUnitArray=new Array(Unit.currentUnit,Unit.partnerUnit);

			for (var a = 0; a < tempUnitArray.length; a++) {
				var unit=tempUnitArray[a];
				for (i = 0; i < unit.basicAbilities.length; i++) {
					if (amount%6==0&&amount!=0&&confirm) {
						xOffset=16;
						yOffset+=36;
						confirm=false;
					}
					ability=unit.basicAbilities[i];
					if (ability.min>0&&Unit.abilityAmounts[ability.ID]>0) {
						abilityIcon = new AbilityIcon();
						abilityIcon.gotoAndStop(ability.index);
						abilityIcon.x=xOffset;
						abilityIcon.y=yOffset;
						abilityIcon.useCount.text=Unit.abilityAmounts[ability.ID]+"";
						abilityIcon.useCount.visible=true;
						abilityIcon.type="Ability";
						page2.inventoryList.addChild(abilityIcon);
						abilityIcon.addEventListener(MouseEvent.MOUSE_DOWN, moveIcon);
						xOffset+=40;
						amount++;
						confirm=true;
					}
				}
			}

			xOffset=16;
			if (amount>0) {
				yOffset+=36;
			}
			confirm=false;
			amount=0;


			yOffset=page2.inventoryList.getChildAt(page2.inventoryList.numChildren-1).y+36;
			for (i = 0; i < Unit.abilityAmounts.length; i++) {
				if (amount%6==0&&amount!=0&&confirm) {
					xOffset=16;
					yOffset+=36;
					confirm=false;
				}

				if (Unit.abilityAmounts[i]>0&&! AbilityDatabase.isBasicAbility(i)) {
					abilityIcon = new AbilityIcon();
					abilityIcon.gotoAndStop(AbilityDatabase.getAbility(i).index);
					abilityIcon.x=xOffset;
					abilityIcon.y=yOffset;
					abilityIcon.useCount.text=Unit.abilityAmounts[i]+"";
					abilityIcon.useCount.visible=true;
					abilityIcon.type="Ability";
					page2.inventoryList.addChild(abilityIcon);
					abilityIcon.addEventListener(MouseEvent.MOUSE_DOWN, moveIcon);
					xOffset+=40;
					amount++;
					confirm=true;
				}
			}

			if (amount>0) {
				return yOffset+36;
			} else {
				return yOffset;
			}
		}

		public function setPassives(option:int = 0) {
			iaOption=option;
			var yOffsets=new Array(8,8);

			clearDisplayList(page2.passiveList1);
			clearDisplayList(page2.passiveList2);

			Unit.currentUnit.passiveItems.sortOn("ID", Array.NUMERIC);
			Unit.partnerUnit.passiveItems.sortOn("ID", Array.NUMERIC);
			Unit.currentUnit.passiveAbilities.sortOn("ID", Array.NUMERIC);
			Unit.partnerUnit.passiveAbilities.sortOn("ID", Array.NUMERIC);

			switch (option) {
				case 0 :
					yOffsets=setPassiveItems();
					setPassiveAbilities(yOffsets, false);
					break;
				case 1 :
					yOffsets=setPassiveAbilities();
					setPassiveItems(yOffsets, false);
					break;
				case 2 :
					setPassiveItems();
					break;
				case 3 :
					setPassiveAbilities();
					break;
			}
			page2.passive1.source=page2.passiveList1;
			page2.passive2.source=page2.passiveList2;
		}

		public function setPassiveItems(offsets:Array = null, drawBG:Boolean = true) {
			var xOffset=8;
			var yOffsets;
			if (offsets==null) {
				yOffsets=new Array(8,8);
			} else {
				yOffsets=offsets;
			}
			var itemIcon;
			var i;
			var bound:Sprite = new Sprite();


			if (iaOption==0||iaOption==1) {
				if (Unit.currentUnit.passiveItems.length+Unit.currentUnit.passiveAbilities.length>2&&drawBG) {
					page2.passiveList1.addChild(bound);
					bound.graphics.lineStyle(1,0x000000);
					bound.graphics.beginFill(0x565656);
					bound.graphics.drawRect(0,0,48,96+36 * (Unit.currentUnit.passiveItems.length+Unit.currentUnit.passiveAbilities.length - 2));
					bound.graphics.endFill();
				}
			} else if (iaOption == 2) {
				if (Unit.currentUnit.passiveItems.length>2) {
					page2.passiveList1.addChild(bound);
					bound.graphics.lineStyle(1,0x000000);
					bound.graphics.beginFill(0x565656);
					bound.graphics.drawRect(0,0,48,96+36 * (Unit.currentUnit.passiveItems.length - 2));
					bound.graphics.endFill();
				}
			}

			for (i = 0; i < Unit.currentUnit.passiveItems.length; i++) {
				itemIcon = new AbilityIcon();
				itemIcon.gotoAndStop(Unit.currentUnit.passiveItems[i].index);
				itemIcon.x=xOffset;
				itemIcon.y=yOffsets[0];
				itemIcon.useCount.visible=false;
				itemIcon.type="Item";
				page2.passiveList1.addChild(itemIcon);
				itemIcon.addEventListener(MouseEvent.MOUSE_DOWN, movePassiveIcon);
				yOffsets[0]+=36;
			}

			xOffset=8;


			var bound2:Sprite = new Sprite();
			if (iaOption==0||iaOption==1) {
				if (Unit.partnerUnit.passiveItems.length+Unit.partnerUnit.passiveAbilities.length>2&&drawBG) {
					page2.passiveList2.addChild(bound2);
					bound2.graphics.lineStyle(1,0x000000);
					bound2.graphics.beginFill(0x565656);
					bound2.graphics.drawRect(0,0,48,96+36 * (Unit.partnerUnit.passiveItems.length+Unit.partnerUnit.passiveAbilities.length - 2));
					bound2.graphics.endFill();
				}
			} else if (iaOption == 2) {
				if (Unit.partnerUnit.passiveItems.length>2) {
					page2.passiveList2.addChild(bound2);
					bound2.graphics.lineStyle(1,0x000000);
					bound2.graphics.beginFill(0x565656);
					bound2.graphics.drawRect(0,0,48,96+36 * (Unit.partnerUnit.passiveItems.length - 2));
					bound2.graphics.endFill();
				}
			}
			for (i = 0; i < Unit.partnerUnit.passiveItems.length; i++) {
				itemIcon = new AbilityIcon();
				itemIcon.gotoAndStop(Unit.partnerUnit.passiveItems[i].index);
				itemIcon.x=xOffset;
				itemIcon.y=yOffsets[1];
				itemIcon.useCount.visible=false;
				itemIcon.type="Item";
				page2.passiveList2.addChild(itemIcon);
				itemIcon.addEventListener(MouseEvent.MOUSE_DOWN, movePassiveIcon);
				yOffsets[1]+=36;
			}
			return yOffsets;
		}


		public function setPassiveAbilities(offsets:Array = null, drawBG:Boolean = true) {
			var xOffset=8;
			var yOffsets;
			if (offsets==null) {
				yOffsets=new Array(8,8);
			} else {
				yOffsets=offsets;
			}

			var abilityIcon;
			var i;
			var bound:Sprite = new Sprite();
			if (iaOption==0||iaOption==1) {
				if (Unit.currentUnit.passiveItems.length+Unit.currentUnit.passiveAbilities.length>2&&drawBG) {
					page2.passiveList1.addChild(bound);
					bound.graphics.lineStyle(1,0x000000);
					bound.graphics.beginFill(0x565656);
					bound.graphics.drawRect(0,0,48,96+36 * (Unit.currentUnit.passiveItems.length+Unit.currentUnit.passiveAbilities.length - 2));
					bound.graphics.endFill();
				}
			} else if (iaOption == 3) {
				if (Unit.currentUnit.passiveAbilities.length>2) {
					page2.passiveList1.addChild(bound);
					bound.graphics.lineStyle(1,0x000000);
					bound.graphics.beginFill(0x565656);
					bound.graphics.drawRect(0,0,48,96+36 * (Unit.currentUnit.passiveAbilities.length - 2));
					bound.graphics.endFill();
				}
			}

			for (i = 0; i < Unit.currentUnit.passiveAbilities.length; i++) {

				abilityIcon = new AbilityIcon();
				abilityIcon.gotoAndStop(Unit.currentUnit.passiveAbilities[i].index);
				abilityIcon.x=xOffset;
				abilityIcon.y=yOffsets[0];
				abilityIcon.useCount.visible=false;
				abilityIcon.type="Ability";
				if (Unit.currentUnit.passiveAbilities[i].min>0) {
					abilityIcon.transform.colorTransform = new ColorTransform();
				} else {
					abilityIcon.transform.colorTransform=redCover;
				}
				page2.passiveList1.addChild(abilityIcon);
				abilityIcon.addEventListener(MouseEvent.MOUSE_DOWN, movePassiveIcon);
				yOffsets[0]+=36;
			}

			xOffset=8;

			var bound2:Sprite = new Sprite();
			if (iaOption==0||iaOption==1) {
				if (Unit.partnerUnit.passiveItems.length+Unit.partnerUnit.passiveAbilities.length>2&&drawBG) {
					page2.passiveList2.addChild(bound2);
					bound2.graphics.lineStyle(1,0x000000);
					bound2.graphics.beginFill(0x565656);
					bound2.graphics.drawRect(0,0,48,96+36 * (Unit.partnerUnit.passiveItems.length+Unit.partnerUnit.passiveAbilities.length - 2));
					bound2.graphics.endFill();
				}
			} else if (iaOption == 3) {
				if (Unit.partnerUnit.passiveAbilities.length>2) {
					page2.passiveList2.addChild(bound2);
					bound2.graphics.lineStyle(1,0x000000);
					bound2.graphics.beginFill(0x565656);
					bound2.graphics.drawRect(0,0,48,96+36 * (Unit.partnerUnit.passiveAbilities.length - 2));
					bound2.graphics.endFill();
				}
			}
			for (i = 0; i < Unit.partnerUnit.passiveAbilities.length; i++) {
				abilityIcon = new AbilityIcon();
				abilityIcon.gotoAndStop(Unit.partnerUnit.passiveAbilities[i].index);
				abilityIcon.x=xOffset;
				abilityIcon.y=yOffsets[1];
				abilityIcon.useCount.visible=false;
				abilityIcon.type="Ability";
				if (Unit.partnerUnit.passiveAbilities[i].min>0) {
					abilityIcon.transform.colorTransform = new ColorTransform();
				} else {
					abilityIcon.transform.colorTransform=redCover;
				}
				page2.passiveList2.addChild(abilityIcon);
				abilityIcon.addEventListener(MouseEvent.MOUSE_DOWN, movePassiveIcon);
				yOffsets[1]+=36;
			}
			return yOffsets;
		}
		public function displayIcon(e) {
			var obj=e.target;

			if (obj is TextField) {
				obj=obj.parent;
			}
			var index;
			if (obj.parent!=stageRef) {
				index=obj.currentFrame-2;
				makeDescription(index, obj.type);
			}
		}


		public function moveIcon(e) {
			var obj=e.target;
			if (obj is TextField) {
				obj=obj.parent;
			}
			if (obj.parent!=stageRef) {
				var index;
				index=obj.currentFrame-2;
				makeDescription(index, obj.type);
				addCovers(index, obj.type);
				
				stageRef.addChild(obj);
				obj.x=mouseX-16;
				obj.y=mouseY-16;
				obj.addEventListener(MouseEvent.MOUSE_UP, releaseIcon);
			}
			//make this easier to use when mouse goes off screen?
			obj.startDrag(false, new Rectangle(8,8,592,432));
		}

		public function releaseIcon(e) {
			var hkIcon;//the icon that might collide with the dragged icon
			var index;//the index of the item/ability in the Item/AbilityDatabase
			var i;//for for loops
			var thing;
			var unit;
			var obj=e.target;

			index=obj.currentFrame-2;

			//Assuming the icon holds an Item
			if (obj.type=="Item") {
				//if it hits passiveList1
				if (obj.hitTestObject(page2.passiveList1)&&pCover1.parent!=stageRef) {
					if (! AbilityDatabase.getAbility(index).active) {
						Unit.itemAmounts[index]--;
						thing = new Item(index, 1);
						thing.startAbility(Unit.currentUnit);
						Unit.currentUnit.passiveItems.push(thing);
						unit = Unit.currentUnit;						
					}
					//if it hits passiveList2
				} else if (obj.hitTestObject(page2.passiveList2)  && pCover2.parent != stageRef) {
					if (! AbilityDatabase.getAbility(index).active) {
						Unit.itemAmounts[index]--;
						thing = new Item(index, 1);						
						thing.startAbility(Unit.partnerUnit);
						unit = Unit.partnerUnit;	
						Unit.partnerUnit.passiveItems.push(thing);
					}
					//if it hits nothing or a hotkeyIcon
				} else {
					if (AbilityDatabase.getAbility(index).active) {
						for (i = 0; i < hotkeyIconArray.length; i++) {
							hkIcon=hotkeyIconArray[i];

							if (hkIcon.hitTestPoint(obj.x+16,obj.y+16,false) && 
							!blockedHotkeyArray[i] &&
							(hotkeyArray[i] == null ||
							(hotkeyArray[i] != null && hotkeyArray[i].cooldown >= hotkeyArray[i].maxCooldown))) {

								//if the hotkey had something in it
								if (hotkeyArray[i]!=null) {
									if (hotkeyArray[i] is Item) {
										//nothing should really happen?
									} else if (hotkeyArray[i] is Ability) {
										Unit.abilityAmounts[hotkeyArray[i].ID]+=1;
									}
								}

								//continue processing
								hkIcon.gotoAndStop(obj.currentFrame);
								hkIcon.visible=true;
								hkIcon.type = "Item";
								
								hotkeyArray[i]=new Item(index,0);
								Unit.setHotkey(i + 1, new Item(index, 0));

								if (i == 0 || i == 1 || i == 3 || i == 4) {
									unit = Unit.currentUnit;
								} else if(i == 2 || i == 7 || i == 5 || i == 6) {
									unit = Unit.partnerUnit;
								}								
							}
						}
					}
				}

			} else if (obj.type == "Ability") {
				if (obj.hitTestObject(page2.passiveList1)&&pCover1.parent!=stageRef) {
					if (! AbilityDatabase.getAbility(index).active) {
						Unit.abilityAmounts[index]--;
						thing = new Ability(index, 1);
						thing.startAbility(Unit.currentUnit);
						Unit.currentUnit.passiveAbilities.push(thing);
						unit = Unit.currentUnit;								
					}
				} else if (obj.hitTestObject(page2.passiveList2) && pCover2.parent != stageRef) {
					if (! AbilityDatabase.getAbility(index).active) {
						Unit.abilityAmounts[index]--;
						thing = new Ability(index, 1);
						thing.startAbility(Unit.partnerUnit);						
						Unit.partnerUnit.passiveAbilities.push(thing);
						unit = Unit.partnerUnit;
					}
				} else {
					if (AbilityDatabase.getAbility(index).active) {

						for (i = 0; i < hotkeyIconArray.length; i++) {
							hkIcon=hotkeyIconArray[i];
							if (hkIcon.hitTestPoint(obj.x+16,obj.y+16,false)  && 
							!blockedHotkeyArray[i] &&
							(hotkeyArray[i] == null ||
							(hotkeyArray[i] != null && hotkeyArray[i].cooldown >= hotkeyArray[i].maxCooldown))) {

								//if the hotkey had something in it
								if (hotkeyArray[i]!=null) {
									if (hotkeyArray[i] is Item) {
										//nothing should really happen?
									} else if (hotkeyArray[i] is Ability) {
										Unit.abilityAmounts[hotkeyArray[i].ID]+=1;
									}
								}
								hkIcon.gotoAndStop(obj.currentFrame);
								hkIcon.visible=true;
								hkIcon.type="Ability";
								hotkeyArray[i]=new Ability(index,AbilityDatabase.getAbility(index).uses);
								Unit.setHotkey(i + 1, new Ability(index, AbilityDatabase.getAbility(index).uses));
								
								if (i == 0 || i == 1 || i == 3 || i == 4) {
									unit = Unit.currentUnit;
								} else if(i == 2 || i == 7 || i == 5 || i == 6) {
									unit = Unit.partnerUnit;
								}	
								Unit.abilityAmounts[index]--;
								break;
							}
						}
					}
				}

			}

			createDebuffs(unit, index);
			removeCovers();
			updateEquippedBasicAbilities();
			freezeHotkeys();
			setInventory(iaOption);
			setPassives(iaOption);
			stageRef.removeChild(obj);
			obj.stopDrag();
			obj.removeEventListener(MouseEvent.MOUSE_UP, releaseIcon);
			stageRef.focus=null;
		}

		public function moveActiveIcon(e) {
			var obj = e.target;
			var unit;
			var j = hotkeyIconArray.indexOf(obj);

			if (obj is TextField) {
				obj=obj.parent;
			}
			var hotkey=hotkeyArray[j];
			if (hotkey!=null&&hotkey.cooldown>=hotkey.maxCooldown) {
				var index;
				if (obj.parent!=stageRef) {
					index = obj.currentFrame-2;				
					
					makeDescription(index, obj.type);
					addCovers(index, obj.type);

					stageRef.addChild(obj);
					obj.x=mouseX-16;
					obj.y=mouseY-16;
					obj.addEventListener(MouseEvent.MOUSE_UP, releaseActiveIcon);
					
					//if the ability has a buff, remove it before moving
					if (j == 0 || j == 1 || j == 3 || j == 4) {
						unit = Unit.currentUnit;
					} else if(j == 2 || j == 7 || j == 5 || j == 6) {
						unit = Unit.partnerUnit;
					}
					for (var b = unit.buffs.length - 1; b >= 0 ; b--) {
						if (unit.buffs[b].Name == AbilityDatabase.getAbility(index).Name) {
							unit.buffs.splice(b, 1);
						}
					}	
					unit = null;
				}
				
				obj.startDrag(false, new Rectangle(8,8,592,432));
			} else if(hotkey != null) {
				index=obj.currentFrame-2;
				
				makeDescription(index, obj.type, false);
			}
		}


		public function releaseActiveIcon(e) {
			var obj = e.target;
			var index = obj.currentFrame-2;
			
			var i;//the icon to switch to
			var j;//the icon you're dragging
			var unit;

			var backToInventory=true;

			for (i = 0; i < hotkeyIconArray.length; i++) {
				var hkIcon=hotkeyIconArray[i];
				if (hkIcon.hitTestPoint(obj.x+16,obj.y+16,false)&&hkIcon!=obj &&
				!blockedHotkeyArray[i] &&
				(hotkeyArray[i] == null ||
				(hotkeyArray[i] != null && hotkeyArray[i].cooldown >= hotkeyArray[i].maxCooldown))) {
					backToInventory = false;
					
					//if the ability to switch with has a buff, remove it
					if (i == 0 || i == 1 || i == 3 || i == 4) {
						unit = Unit.currentUnit;
					} else if(i == 2 || i == 7 || i == 5 || i == 6) {
						unit = Unit.partnerUnit;
					}
					for (var b = unit.buffs.length - 1; b >= 0 ; b--) {
						if (unit.buffs[b].Name == AbilityDatabase.getAbility(hotkeyArray[i].ID).Name) {
							unit.buffs.splice(b, 1);
						}
					}
					unit = null;
					
					//now if that ability to switch has a buff, add it again in the right place
					if (j == 0 || j == 1 || j == 3 || j == 4) {
						unit = Unit.currentUnit;
					} else if(j == 2 || j == 7 || j == 5 || j == 6) {
						unit = Unit.partnerUnit;
					}
					createDebuffs(unit, index);					
					unit = null;
					if (hotkeyArray[i]!=null) {
						//set the old icon to the new icon
						j=hotkeyIconArray.indexOf(obj);
						var tempFrame=obj.currentFrame;
						var tempHotkey=hotkeyArray[j];
						var tempType = obj.type;
						
						if (j == 0 || j == 1 || j == 3 || j == 4) {
							unit = Unit.currentUnit;
						} else if(j == 2 || j == 7 || j == 5 || j == 6) {
							unit = Unit.partnerUnit;
						}
						createDebuffs(unit, index);		
						unit = null;							
						
						obj.gotoAndStop(hkIcon.currentFrame);
						hotkeyArray[j]=hotkeyArray[i];
						Unit.setHotkey(j+1, hotkeyArray[j]);
						hotkeyIconArray[j].type = hotkeyIconArray[i].type;					

						//set the new icon to the old icon
						hkIcon.gotoAndStop(tempFrame);
						hkIcon.visible=true;
						hotkeyArray[i]=tempHotkey;
						Unit.setHotkey(i+1, hotkeyArray[i]);
						hkIcon.type=tempType;

					} else {
						j=hotkeyIconArray.indexOf(obj);

						//set the new icon to the old icon
						hkIcon.gotoAndStop(obj.currentFrame);
						hkIcon.visible=true;
						hotkeyArray[i]=hotkeyArray[j];
						Unit.setHotkey(i+1, hotkeyArray[i]);
						hotkeyIconArray[i].type=hotkeyIconArray[j].type;
						hotkeyIconArray[j].type="";

						//erase the old icon
						//obj.visible=false;
						obj.gotoAndStop(1);

						hotkeyArray[j]=null;
						Unit.setHotkey(j+1, null);
					}
					break;
				}
			}


			if (backToInventory) {
				if (! obj.hitTestObject(aCover)) {
					//obj.visible=false;
					obj.gotoAndStop(1);
					j=hotkeyIconArray.indexOf(obj);
					if (hotkeyIconArray[j].type=="Ability") {
						Unit.abilityAmounts[index]+=1;
					}
					hotkeyIconArray[j].type=null;
					hotkeyArray[j]=null;
					Unit.setHotkey(j + 1, null);
				} else {
					//add it again
					unit = null;					
					if (j == 0 || j == 1 || j == 3 || j == 4) {
						unit = Unit.currentUnit;
					} else if(j == 2 || j == 7 || j == 5 || j == 6) {
						unit = Unit.partnerUnit;
					}
					createDebuffs(unit, index);		
					unit = null;				
				}
			}

			obj.y=16;
			obj.x=0+48*hotkeyIconArray.indexOf(obj);
			page2.hotkeyHolder.addChild(obj);
			removeCovers();
			updateEquippedBasicAbilities();
			freezeHotkeys();
			obj.stopDrag();
			setInventory(iaOption);
		}


		public function movePassiveIcon(e) {
			var obj = e.target;
			var unit;
			if (obj.parent!=stageRef) {
				var passive;
				var index=obj.currentFrame-2;
				var i;
				
				addCovers(index, obj.type);

				if (obj.type=="Item") {
					if (obj.parent==page2.passiveList1) {
						passive=Unit.currentUnit.passiveItems;
						for (i = 0; i < passive.length; i++) {
							if (passive[i].ID == index) {
								passive[i].cancel();
								passive.splice(i,1);
								break;
							}
						}
						unit = Unit.currentUnit;
					} else if (obj.parent == page2.passiveList2) {
						passive=Unit.partnerUnit.passiveItems;
						for (i = 0; i < passive.length; i++) {
							if (passive[i].ID == index) {
								passive[i].cancel();								
								passive.splice(i,1);
								break;
							}
						}
						unit = Unit.partnerUnit;
					}
				} else if (obj.type == "Ability") {
					if (obj.parent==page2.passiveList1) {
						passive=Unit.currentUnit.passiveAbilities;
						for (i = 0; i < passive.length; i++) {
							if (passive[i].ID == index) {
								passive[i].cancel();									
								passive.splice(i,1);
								break;
							}
						}
						unit = Unit.currentUnit;

					} else if (obj.parent == page2.passiveList2) {
						passive=Unit.partnerUnit.passiveAbilities;
						for (i = 0; i < passive.length; i++) {
							if (passive[i].ID == index) {
								passiveThing = passive[i];
								passive[i].cancel();
								passive.splice(i,1);
								break;
							}
						}
						unit = Unit.partnerUnit;
					}
				}
				
				for (var b = unit.buffs.length - 1; b >= 0 ; b--) {
					if (unit.buffs[b].Name == AbilityDatabase.getAbility(index).Name) {
						unit.buffs.splice(b, 1);
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
			var index = obj.currentFrame - 2;
			var unit;
			
			if (obj.type=="Item") {
				if (obj.hitTestObject(page2.passiveList1)&&pCover1.parent!=stageRef) {
					Unit.currentUnit.passiveItems.push(new Item(index, 1));
					unit = Unit.currentUnit;
				} else if (obj.hitTestObject(page2.passiveList2) && pCover2.parent != stageRef) {
					Unit.partnerUnit.passiveItems.push(new Item(index, 1));
					unit = Unit.partnerUnit;
				} else {
					Unit.itemAmounts[index] += 1;
					
				}
			} else if (obj.type=="Ability") {
				if (obj.hitTestObject(page2.passiveList1)&&pCover1.parent!=stageRef) {
					Unit.currentUnit.passiveAbilities.push(new Ability(index, 1));
					unit = Unit.currentUnit;					
				} else if (obj.hitTestObject(page2.passiveList2) && pCover2.parent != stageRef) {
					Unit.partnerUnit.passiveAbilities.push(new Ability(index, 1));
					unit = Unit.partnerUnit;					
				} else {
					Unit.abilityAmounts[index]+=1;
				}

			}
			
			//if the ability has a buff, equip it	
			createDebuffs(unit, index);				
			removeCovers();
			updateEquippedBasicAbilities();
			setPassives(iaOption);
			setInventory(iaOption);
			stageRef.removeChild(obj);
			obj.stopDrag();

			obj.removeEventListener(MouseEvent.MOUSE_UP, releasePassiveIcon);
		}


		public function addCovers(index:int, type:String) {
			var active;
			var availability:String;
			var thing = AbilityDatabase.getAbility(index);
			active = thing.active;
			availability = thing.availability;
			
			//deal with A/P zones
			if (active) {
				stageRef.addChild(pCover1);
				stageRef.addChild(pCover2);
				if (aCover.parent!=null) {
					aCover.parent.removeChild(aCover);
				}
				//deal with units in hotkeys
				if (availability=="All Girls") {
					//check for girls
				} else if (availability == "All Boys") {
					//check for boys
				} else if (availability != "All Perkinites") {
					if (Unit.currentUnit.Name!=availability) {
						hotkeyIconArray[0].transform.colorTransform=iconCover;
						hotkeyIconArray[1].transform.colorTransform=iconCover;
						hotkeyIconArray[2].transform.colorTransform=iconCover;
						hotkeyIconArray[3].transform.colorTransform=iconCover;
						hotkeyIconArray[4].transform.colorTransform=iconCover;
						blockedHotkeyArray[0]=true;
						blockedHotkeyArray[1]=true;
						blockedHotkeyArray[2]=true;						
						blockedHotkeyArray[3]=true;
						blockedHotkeyArray[4]=true;
					}
					if (Unit.partnerUnit.Name!=availability) {
						hotkeyIconArray[0].transform.colorTransform=iconCover;
						hotkeyIconArray[1].transform.colorTransform=iconCover;
						hotkeyIconArray[2].transform.colorTransform=iconCover;						
						hotkeyIconArray[5].transform.colorTransform=iconCover;
						hotkeyIconArray[6].transform.colorTransform=iconCover;
						blockedHotkeyArray[0]=true;
						blockedHotkeyArray[1]=true;
						blockedHotkeyArray[2]=true;
						blockedHotkeyArray[5]=true;
						blockedHotkeyArray[6]=true;
					}
				}
			} else {
				stageRef.addChild(aCover);
				if (pCover1.parent!=null) {
					pCover1.parent.removeChild(pCover1);
				}
				if (pCover2.parent!=null) {
					pCover2.parent.removeChild(pCover2);
				}
				//deal with units in passives
				if (availability=="All Girls") {
					//check for girls
				} else if (availability == "All Boys") {
					//check for boys
				} else if (availability != "All Perkinites") {
					if (Unit.currentUnit.Name!=availability) {
						stageRef.addChild(pCover1);
					}
					if (Unit.partnerUnit.Name!=availability) {
						stageRef.addChild(pCover2);
					}
				}
			}



		}
		public function removeCovers() {
			if (aCover.parent!=null) {
				aCover.parent.removeChild(aCover);
			}
			if (pCover1.parent!=null) {
				pCover1.parent.removeChild(pCover1);
			}
			if (pCover2.parent!=null) {
				pCover2.parent.removeChild(pCover2);
			}
			for (var i = 0; i < hotkeyIconArray.length; i++) {
				hotkeyIconArray[i].transform.colorTransform = new ColorTransform();
			}
			blockedHotkeyArray=new Array(false,false,false,false,false,false,false);
		}
		
		public function createDebuffs(unit, index) {
			var a = AbilityDatabase.getAbility(index);			
			if (unit != null && a.equipDebuff == "Yes") {
					if (a.stunDuration != 0) {
						unit.buffs.push(new Buff(a, "Stun", unit));	
					} 
					if (a.slowDuration != 0) {
						unit.buffs.push(new Buff(a, "Slow", unit));	
					}
					if (a.sickDuration != 0) {
						unit.buffs.push(new Buff(a, "Sick", unit));	
					}
					if (a.exhaustDuration != 0) {
						unit.buffs.push(new Buff(a, "Exhaust", unit));	
					} 
					if (a.regenDuration != 0) {
						unit.buffs.push(new Buff(a, "Regen", unit));						
					}
			}
		}
		public function replaceDebuffs(unit, index) {
			var a = AbilityDatabase.getAbility(index);			
			if (unit != null && a.equipDebuff == "Yes") {
				for (var b = 0; b < unit.buffs.length; b++) {
					if (unit.buffs[b].Name == a.Name) { 
						if (a.stunDuration != 0) {
							unit.buffs[b] = (new Buff(a, "Stun", unit));	
						} 
						if (a.slowDuration != 0) {
							unit.buffs[b] = (new Buff(a, "Slow", unit));	
						}
						if (a.sickDuration != 0) {
							unit.buffs[b] = (new Buff(a, "Sick", unit));	
						}
						if (a.exhaustDuration != 0) {
							unit.buffs[b] = (new Buff(a, "Exhaust", unit));	
						} 
						if (a.regenDuration != 0) {
							unit.buffs[b] = (new Buff(a, "Regen", unit));						
						}					
					
					}
				}

			}
		}			
		/************************************************************************
		PAGE 3 STUFF
		************************************************************************/

		public function updatePowerupPage() {
			if (currentActivated) {
				page3.ppRemainingDisplay.text=Unit.currentUnit.powerpoints;
				if (page3.ppRemainingDisplay.text.length==1) {
					page3.ppRemainingDisplay.text="0"+Unit.currentUnit.powerpoints;
				}
				page3.currentButton.filters=[gf1];
				page3.partnerButton.filters=[];

			} else {
				page3.ppRemainingDisplay.text=Unit.partnerUnit.powerpoints;
				if (page3.ppRemainingDisplay.text.length==1) {
					page3.ppRemainingDisplay.text="0"+Unit.partnerUnit.powerpoints;
				}
				page3.currentButton.filters=[];
				page3.partnerButton.filters=[gf1];
			}

			hotkeyIconArray=[page3.icon1,page3.icon2,page3.icon3,page3.icon4,page3.icon5];


			var i;
			var basicAbilities;
			if (currentActivated) {
				basicAbilities=Unit.currentUnit.basicAbilities;
			} else {
				basicAbilities=Unit.partnerUnit.basicAbilities;
			}
			var names=new Array(page3.abilityName1,page3.abilityName2,page3.abilityName3,page3.abilityName4,page3.abilityName5);
			var descriptions = new Array(page3.description1, page3.description2, page3.description3,
			 page3.description4, page3.description5);
			var fractions=new Array(page3.fraction1,page3.fraction2,page3.fraction3,page3.fraction4,page3.fraction5);

			for (i = 0; i < hotkeyIconArray.length; i++) {
				if (i<basicAbilities.length) {
					hotkeyIconArray[i].useCount.visible=false;
					hotkeyIconArray[i].visible=true;
					hotkeyIconArray[i].type="Ability";
					names[i].visible=true;
					descriptions[i].visible=true;
					fractions[i].visible=true;
					page3.increaseHolder.getChildAt(i).visible=true;
					page3.decreaseHolder.getChildAt(i).visible=true;
					page3.resetHolder.getChildAt(i).visible=true;
					page3.maxHolder.getChildAt(i).visible=true;
					hotkeyIconArray[i].gotoAndStop(basicAbilities[i].index);
					names[i].text=basicAbilities[i].Name;
					descriptions[i].text=basicAbilities[i].getSpecInfo();
					fractions[i].text=basicAbilities[i].min+"\n-\n"+basicAbilities[i].max;
					//hotkeyIconArray[i].gotoAndStop(basicAbilities[i].index);


					if (basicAbilities[i].min==basicAbilities[i].max) {
						fractions[i].textColor=0x0098FF;
						hotkeyIconArray[i].transform.colorTransform = new ColorTransform();
					} else if (basicAbilities[i].min>0) {
						hotkeyIconArray[i].transform.colorTransform = new ColorTransform();
						fractions[i].textColor=0x33FF33;
					} else {
						hotkeyIconArray[i].transform.colorTransform=redCover;
						fractions[i].textColor=0xFF3333;
					}
					if (! basicCooldownNotActive(basicAbilities[i].ID)) {
						hotkeyIconArray[i].transform.colorTransform=iconCover;
						fractions[i].textColor=0x333333;
					}
				} else {
					break;
				}
			}


			for (i; i < hotkeyIconArray.length; i++) {
				hotkeyIconArray[i].gotoAndStop(1);
				hotkeyIconArray[i].useCount.visible=false;
				hotkeyIconArray[i].visible=false;
				names[i].visible=false;
				descriptions[i].visible=false;
				fractions[i].visible=false;
				page3.increaseHolder.getChildAt(i).visible=false;
				page3.decreaseHolder.getChildAt(i).visible=false;
				page3.resetHolder.getChildAt(i).visible=false;
				page3.maxHolder.getChildAt(i).visible=false;
			}
		}

		public function setCurrentHandler(e) {
			if (! currentActivated) {
				currentActivated=true;
				setUnitIndex--;
				updatePowerupPage();
			}
		}
		public function setPartnerHandler(e) {
			if (currentActivated) {
				currentActivated=false;
				setUnitIndex++;
				updatePowerupPage();
			}
		}




		public function setToggles() {
			var holderArray=[page3.increaseHolder,page3.decreaseHolder,page3.resetHolder,page3.maxHolder];
			var display;
			var listener;
			for (var i = 0; i < 4; i++) {
				switch (i) {
					case 0 :
						display="+1";
						listener=increasePower;
						break;
					case 1 :
						display="-1";
						listener=decreasePower;
						break;
					case 2 :
						display="RESET";
						listener=resetPower;
						break;
					case 3 :
						display="MAX";
						listener=maxPower;
						break;
				}
				for (var j = 0; j < holderArray[i].numChildren; j++) {
					holderArray[i].getChildAt(j).buttonText.text=display;
					holderArray[i].getChildAt(j).addEventListener(MouseEvent.CLICK, listener);
					holderArray[i].getChildAt(j).mouseChildren=false;
				}
			}
		}

		public function increasePower(e) {
			var obj=e.target;
			var par=e.target.parent;
			var index=par.getChildIndex(obj);
			var basicAbilities;
			var pp;
			if (currentActivated) {
				basicAbilities=Unit.currentUnit.basicAbilities;
				pp=Unit.currentUnit.powerpoints;
			} else {
				basicAbilities=Unit.partnerUnit.basicAbilities;
				pp=Unit.partnerUnit.powerpoints;
			}

			if (pp>0&&basicAbilities[index].min+1<Unit.maxLP/2+1 && 
			   basicAbilities[index].min+1 <= basicAbilities[index].max &&
			   basicCooldownNotActive(basicAbilities[index].ID)) {
				pp--;
				basicAbilities[index].min++;
				basicAbilities[index].updateAbility();
			} else {
				//do something
			}
			if (currentActivated) {
				Unit.currentUnit.powerpoints = pp;
				replaceDebuffs(Unit.currentUnit, basicAbilities[index].ID);
			} else {
				Unit.partnerUnit.powerpoints = pp;
				replaceDebuffs(Unit.partnerUnit, basicAbilities[index].ID);				
			}
			makeDescription(basicAbilities[index].ID, "Ability");
			updatePowerupPage();
		}
		public function decreasePower(e) {
			var obj=e.target;
			var par=e.target.parent;
			var index=par.getChildIndex(obj);
			var basicAbilities;
			var pp;
			if (currentActivated) {
				basicAbilities=Unit.currentUnit.basicAbilities;
				pp=Unit.currentUnit.powerpoints;
			} else {
				basicAbilities=Unit.partnerUnit.basicAbilities;
				pp=Unit.partnerUnit.powerpoints;
			}
			makeDescription(basicAbilities[index].ID, "Ability");
			if (basicAbilities[index].min>AbilityDatabase.getMinAbility(basicAbilities[index].ID).min
			 &&   basicCooldownNotActive(basicAbilities[index].ID)) {
				pp++;
				basicAbilities[index].min--;
				basicAbilities[index].updateAbility();
			} else {
				//do something
			}
			if (currentActivated) {
				Unit.currentUnit.powerpoints = pp;
				replaceDebuffs(Unit.currentUnit, basicAbilities[index].ID);
			} else {
				Unit.partnerUnit.powerpoints = pp;
				replaceDebuffs(Unit.partnerUnit, basicAbilities[index].ID);				
			}

			makeDescription(basicAbilities[index].ID, "Ability");
			updatePowerupPage();
		}
		public function resetPower(e) {
			var obj=e.target;
			var par=e.target.parent;
			var index=par.getChildIndex(obj);
			var basicAbilities;
			var pp;
			if (currentActivated) {
				basicAbilities=Unit.currentUnit.basicAbilities;
				pp=Unit.currentUnit.powerpoints;
			} else {
				basicAbilities=Unit.partnerUnit.basicAbilities;
				pp=Unit.partnerUnit.powerpoints;
			}

			if (basicCooldownNotActive(basicAbilities[index].ID)) {
				var difference=basicAbilities[index].min-AbilityDatabase.getMinAbility(basicAbilities[index].ID).min;
				pp+=difference;
				basicAbilities[index].min -= difference;
				basicAbilities[index].updateAbility();
				if (currentActivated) {
					Unit.currentUnit.powerpoints = pp;
					replaceDebuffs(Unit.currentUnit, basicAbilities[index].ID);
				} else {
					Unit.partnerUnit.powerpoints = pp;
					replaceDebuffs(Unit.partnerUnit, basicAbilities[index].ID);				
				}
			}
			makeDescription(basicAbilities[index].ID, "Ability");
			updatePowerupPage();
		}
		public function maxPower(e) {
			var obj=e.target;
			var par=e.target.parent;
			var index=par.getChildIndex(obj);
			var basicAbilities;
			var pp;
			if (currentActivated) {
				basicAbilities=Unit.currentUnit.basicAbilities;
				pp=Unit.currentUnit.powerpoints;
			} else {
				basicAbilities=Unit.partnerUnit.basicAbilities;
				pp=Unit.partnerUnit.powerpoints;
			}

			if (basicCooldownNotActive(basicAbilities[index].ID)) {
				var confirm=true;
				while (confirm) {
					if (pp>0&&basicAbilities[index].min+1<Unit.maxLP/2+1 && 
					   basicAbilities[index].min+1 <= basicAbilities[index].max) {
						pp--;
						basicAbilities[index].min++;
						basicAbilities[index].updateAbility();
					} else {
						confirm=false;
					}
					if (currentActivated) {
						Unit.currentUnit.powerpoints=pp;
					} else {
						Unit.partnerUnit.powerpoints=pp;
					}
				}
				if (currentActivated) {
					replaceDebuffs(Unit.currentUnit, basicAbilities[index].ID);
				} else {
					replaceDebuffs(Unit.partnerUnit, basicAbilities[index].ID);				
				}				
			}
			makeDescription(basicAbilities[index].ID, "Ability");
			updatePowerupPage();
		}
	}
}