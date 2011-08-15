package ui.screens{

	import flash.text.TextField;
	import actors.*;
	import abilities.*;
	import game.GameUnit;
	import items.*;
	
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.ui.*;
	import flash.filters.GlowFilter;
	import flash.display.Stage;


	public class ShopScreen extends BaseScreen {

		public var prevScreen:BaseScreen;
		public var itemArray:Array;
		public var abilityArray:Array;
		public var gameObject:GameUnit;
		public var gf1:GlowFilter;
		function ShopScreen(prevScreen:BaseScreen, itemArray:Array, abilityArray:Array, stageRef:Stage = null, gameObject:GameUnit = null) {

			this.prevScreen=prevScreen;
			this.stageRef=stageRef;
			this.itemArray=itemArray;
			this.abilityArray = abilityArray;
			this.gameObject = gameObject;

			flexPointsDisplay.text=Unit.flexPoints.toFixed(2);

			iaButton.buttonText.text="I + A";
			aiButton.buttonText.text="A + I";
			iButton.buttonText.text="Items";
			aButton.buttonText.text = "Abilities";
			
			iaButton.addEventListener(MouseEvent.CLICK, iaHandler);
			aiButton.addEventListener(MouseEvent.CLICK, aiHandler);
			iButton.addEventListener(MouseEvent.CLICK, iHandler);
			aButton.addEventListener(MouseEvent.CLICK, aHandler);
			
			gf1=new GlowFilter(0xFF9900,100,20,20,1,5,true,false);

			gotoAndStop(1);
			setInventory();
			load();
		}
		
		public function iaHandler(e) {
			setInventory(0);
			colorButtons(0);
		}
		public function aiHandler(e) {
			setInventory(1);
			colorButtons(1);
		}
		public function iHandler(e) {
			setInventory(2);
			colorButtons(2);
		}
		public function aHandler(e) {
			setInventory(3);
			colorButtons(3);
		}
		
		public function colorButtons(iaOption) {
			switch (iaOption) {
				case 0 :
					iaButton.filters=[gf1];
					aiButton.filters=[];
					iButton.filters=[];
					aButton.filters=[];
					break;
				case 1 :
					iaButton.filters=[];
					aiButton.filters=[gf1];
					iButton.filters=[];
					aButton.filters=[];
					break;
				case 2 :
					iaButton.filters=[];
					aiButton.filters=[];
					iButton.filters=[gf1];
					aButton.filters=[];
					break;
				case 3 :
					iaButton.filters=[];
					aiButton.filters=[];
					iButton.filters=[];
					aButton.filters=[gf1];
					break;
			}
		}		
		

		override public function keyHandler(e:KeyboardEvent):void {
			var sound;
			if (e.keyCode=="X".charCodeAt(0)) {
				sound = new se_timeout();
				sound.play();
				if (gameObject != null) {
					gameObject.moveCount++;
				}
				unload(prevScreen);
			}
		}



		public function setInventory(option:int = 1) {
			/*
			option = 0 // items + abilities
			option = 1 //abilities + items
			option = 2 only i
			option = 3 only a
			*/
			for (var i = 0; i < numChildren; i++ ) {
				if (getChildAt(i) is AbilityIcon) {
					removeChild(getChildAt(i));
					i--;
				}
			}
			var yOffset=128;
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
		}

		public function setInventoryItems(yOffset:int) {
			var i;
			var xOffset=196+16;
			for (i = 0; i < itemArray.length; i++) {
				if (i%6==0&&i!=0) {
					xOffset=196+16;
					yOffset+=36;
				}
				if (itemArray[i].amount>0) {
					var itemIcon = new AbilityIcon();
					itemIcon.gotoAndStop(ItemDatabase.getIndex(i));
					itemIcon.x=xOffset;
					itemIcon.y=yOffset;
					//itemIcon.useCount.text=Unit.itemAmounts[i]+"";
					itemIcon.useCount.visible=false;
					itemIcon.type="Item";
					addChild(itemIcon);
					itemIcon.addEventListener(MouseEvent.MOUSE_DOWN, moveIcon);
					xOffset+=36;
				}
			}
			return yOffset+36;
		}
		public function setInventoryAbilities(yOffset:int) {
			var i;
			var xOffset=196+16;
			for (i = 0; i < abilityArray.length; i++) {
				if (i%6==0&&i!=0) {
					xOffset=196+16;
					yOffset+=36;
				}
				if (abilityArray[i].amount>0) {
					var abilityIcon = new AbilityIcon();
					abilityIcon.gotoAndStop(AbilityDatabase.getIndex(i));
					abilityIcon.x=xOffset;
					abilityIcon.y=yOffset;
					//abilityIcon.useCount.text=Unit.abilityAmounts[i]+"";
					abilityIcon.useCount.visible=false;
					abilityIcon.type="Ability";
					addChild(abilityIcon);
					abilityIcon.addEventListener(MouseEvent.MOUSE_DOWN, moveIcon);
					xOffset+=36;
				}
			}
			return yOffset + 36;
		}
		public function updateProductInfo(product) {

		}
		public function transaction() {

		}

		public function moveIcon(e) {

		}

		public function releaseIcon(e) {

		}


	}
}