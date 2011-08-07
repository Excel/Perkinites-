package game{
	
	import flash.display.Stage;
	
	public class GameVariables {

		public static var difficulty:int;
		public static var stageLevel:int;
		public static var maxStageLevel:int = 1;
		public static var setLevel:int = 0;
		public static var startLevel:Boolean=false;

		public static var stageRef:Stage;
		public static var time:int = 0;
		
		
		/**
		 * These are the destination variables. MapEvents will modify this a lot.
		 * The mapID will say what map you are going to now. 
		 * If xTile and yTile are -1, then the mapCode's starting position will be used.
		 * Otherwise, the starting position will be the xTile and yTile specified here.
		 */
		public static var prevMapID:int = -1;
		public static var nextMapID:int = -1;
		public static var xTile:int = -1;
		public static var yTile:int = -1;
	}
}