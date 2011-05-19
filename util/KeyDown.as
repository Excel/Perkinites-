package util{
	import flash.events.KeyboardEvent;
	public class KeyDown{
		public static var myStage;
		public static var myArray;
		public static function init(s){
			myArray = new Array(999);
			
			myStage = s;
			myStage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			myStage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
		}
		public static function keyDownHandler(e){
			myArray[e.keyCode] = true;
		}
		public static function keyUpHandler(e){
			myArray[e.keyCode] = false;
		}
		public static function keyIsDown(num){
			return myArray[num] == true;
		}
	}
}

