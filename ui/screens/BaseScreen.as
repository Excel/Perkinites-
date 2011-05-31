package ui.screens{

	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.*;


	public class BaseScreen extends MovieClip {

		public var stageRef:Stage;
		public var nextScreen:BaseScreen;

		public function BaseScreen() {

		}

		public function unload(loadScreen:BaseScreen = null):void {
			nextScreen=loadScreen;

			disableKeyHandler();
			remove();
		}
		public function remove():void {
			if (stageRef.contains(this)) {
				stageRef.removeChild(this);
			}

			if (nextScreen!=null) {
				nextScreen.load();
			}
		}

		public function load():void {
			stageRef.addChild(this);
			enableKeyHandler();
			stageRef.focus=null;
		}

		public function enableKeyHandler():void {
			stageRef.addEventListener(KeyboardEvent.KEY_DOWN, keyHandler);
		}
		public function disableKeyHandler():void {
			stageRef.removeEventListener(KeyboardEvent.KEY_DOWN, keyHandler);
		}
		public function keyHandler(e:KeyboardEvent):void {

		}

	}
}