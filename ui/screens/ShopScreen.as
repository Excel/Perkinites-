package ui.screens{

	import flash.text.TextField;
	import actors.*;
	import abilities.*;
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
		function ShopScreen(prevScreen:BaseScreen, itemArray:Array, abilityArray:Array, stageRef:Stage = null) {

			this.prevScreen=prevScreen;
			this.stageRef=stageRef;
			this.itemArray=itemArray;
			this.abilityArray=abilityArray;

			flexPointsDisplay.text=Unit.flexPoints.toFixed(2);

			iaButton.buttonText.text="I + A";
			iaButton.buttonText.text="A + I";
			iaButton.buttonText.text="Items";
			iaButton.buttonText.text="Abilities";

			gotoPage(1);
			load();
		}

		override public function keyHandler(e:KeyboardEvent):void {
			var sound;
			if (e.keyCode=="X".charCodeAt(0)) {
				sound = new se_timeout();
				sound.play();
				unload(prevScreen);
			}
		}

		public function gotoPage(i:int) {
			gotoAndStop(i);
			update();
		}


		public function update() {
			switch (currentFrame) {
				case 1 :
					break;
				case 2 :
					break;

			}
		}


		public function setInventory(option:int = 0) {
			/*
			option = 0 // items + abilities
			option = 1 //abilities + items
			option = 2 only i
			option = 3 only a
			*/
			var yOffset=96;
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
			var xOffset=196;
			for (i = 0; i < itemArray.length; i++) {
				if (i%6==0&&i!=0) {
					xOffset=196;
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
			var xOffset=196;
			for (i = 0; i < abilityArray.length; i++) {
				if (i%6==0&&i!=0) {
					xOffset=196;
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