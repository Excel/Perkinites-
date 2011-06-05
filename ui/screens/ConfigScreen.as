package ui.screens{

	import flash.display.MovieClip;
	import flash.events.*;
	import flash.ui.*;
	import flash.filters.GlowFilter;
	import flash.display.Stage;


	public class ConfigScreen extends BaseScreen {

		public var prevScreen:BaseScreen;
		public var buttonArray:Array;

		function ConfigScreen(prevScreen:BaseScreen,stageRef:Stage = null) {

			this.prevScreen=prevScreen;
			this.stageRef=stageRef;

			buttonArray = new Array(toggleUHB_off,
			toggleUHB_on,
			toggleEHB_off,
			toggleEHB_on,
			toggleMD_off,
			toggleMD_minimap,
			toggleMD_expanded,
			toggleQ_low,
			toggleQ_medium,
			toggleQ_high
			
			
			);

			toggleUHB_off.buttonText.text="Off";
			toggleUHB_on.buttonText.text="On";
			toggleEHB_off.buttonText.text="Off";
			toggleEHB_on.buttonText.text="On";
			toggleMD_off.buttonText.text="Off";
			toggleMD_minimap.buttonText.text="Minimap";
			toggleMD_expanded.buttonText.text="Expanded";
			toggleQ_low.buttonText.text="Low";
			toggleQ_medium.buttonText.text="Medium";
			toggleQ_high.buttonText.text="Radical";
			
			
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
		
		public function loadConfig(){
			
		}
	}

}