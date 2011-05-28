package ui.screens{

	import flash.display.MovieClip;
	import flash.events.*;
	import flash.ui.*;
	import flash.filters.GlowFilter;


	public class TitleScreen extends MovieClip {

		function TitleScreen() {


			continueButton.buttonText.text="Continue";
			configButton.buttonText.text="Config";

			newButton.addEventListener(MouseEvent.CLICK, newGame);
			continueButton.addEventListener(MouseEvent.CLICK, continueGame);
			configButton.addEventListener(MouseEvent.CLICK, config);

			newButton.addEventListener(MouseEvent.MOUSE_OVER, overHandler1);
			continueButton.addEventListener(MouseEvent.MOUSE_OVER, overHandler2);
			configButton.addEventListener(MouseEvent.MOUSE_OVER, overHandler3);
			newButton.addEventListener(MouseEvent.MOUSE_OUT, outHandler1);
			continueButton.addEventListener(MouseEvent.MOUSE_OUT, outHandler2);
			configButton.addEventListener(MouseEvent.MOUSE_OUT, outHandler3);

		}

		public function newGame(e) {
			var stageSelect=new StageSelect(1,0,stage);
			stage.removeChild(this);
		}
		public function continueGame(e) {
			var filescreen=new FileScreen(true,this,stage);
			stage.removeChild(this);
		}
		public function config(e) {
			stage.removeChild(this);
		}
		public function enableKeyHandler(){
			
		}
		public function disableKeyHandler(){
			
		}

		public function overHandler1(e) {
			var gf1=new GlowFilter(0xFF0000,100,20,20,1,10,true,false);
			newButton.filters=[gf1];
		}
		public function overHandler2(e) {
			var gf1=new GlowFilter(0x00FF00,100,20,20,1,10,true,false);
			continueButton.filters=[gf1];
		}
		public function overHandler3(e) {
			var gf1=new GlowFilter(0x0000FF,100,20,20,1,10,true,false);
			configButton.filters=[gf1];
		}
		public function outHandler1(e) {
			newButton.filters=[];
		}
		public function outHandler2(e) {
			continueButton.filters=[];
		}
		public function outHandler3(e) {
			configButton.filters=[];
		}

	}
}