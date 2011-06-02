﻿package ui{

	import actors.*;
	import ui.screens.*;
	
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.ui.*;
	import flash.filters.GlowFilter;
	import flash.net.SharedObject;
	
	//will rework this later
	public class GameOverDisplay extends BaseScreen {

		function GameOverDisplay() {
			//var gf1=new GlowFilter(0xFF9900,100,20,20,1,5,true,false);
			retryButton.buttonText.text="Retry!";
			loadButton.buttonText.text="Load Game";

			retryButton.addEventListener(MouseEvent.CLICK, retry);
			loadButton.addEventListener(MouseEvent.CLICK, loadGame);

		}
		
		public function retry(e){
			/*var retry = SharedObject.getLocal("RetryLevel");
			Unit.currentUnit = retry.data.currentUnit;
			Unit.partnerUnit = retry.data.partnerUnit;
			retry.clear();
			*/
			//removeDisplay();

		}
		public function loadGame(e){
			disableKeyHandler();
			var filescreen=new FileScreen(true,this,stage);
			removeDisplay();
		}
		
		public function removeDisplay(){
			this.parent.removeChild(this);
		}
		

		

	}
}