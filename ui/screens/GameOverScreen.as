package ui.screens{

	import actors.*;
	
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.*;
	import flash.ui.*;
	import flash.filters.GlowFilter;
	import flash.net.SharedObject;
	
	public class GameOverScreen extends BaseScreen {

		function GameOverScreen(stageRef:Stage = null) {
			//var gf1=new GlowFilter(0xFF9900,100,20,20,1,5,true,false);
			
			this.stageRef = stageRef;
			
			retryButton.buttonText.text="Retry!";
			loadButton.buttonText.text="Load Game";

			retryButton.addEventListener(MouseEvent.CLICK, retry);
			loadButton.addEventListener(MouseEvent.CLICK, loadGame);

			load();
		}
		
		public function retry(e){
			/*var retry = SharedObject.getLocal("RetryLevel");
			Unit.currentUnit = retry.data.currentUnit;
			Unit.partnerUnit = retry.data.partnerUnit;
			retry.clear();
			*/
			//removeDisplay();
			unload();

		}
		public function loadGame(e){
			unload(new FileScreen(true,this,stageRef));
		}	
	}
}