package game{
	
	import enemies.*;
	import maps.MapObject;
	import ui.*;
	
	import flash.display.MovieClip;
	import flash.display.Stage;
	
	public class GameVariables {

		public static var difficulty:int;
		public static var stageLevel:int;
		public static var maxStageLevel:int = 1;
		public static var setLevel:int = 0;
		public static var startLevel:Boolean=false;

		public static var stageRef:Stage;
		public static var time:int = 0;
		public static var gameClient:GameClient; 
		
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
		
		
		/**
		 * These are the variables to determine the mouse type.
		 */
		public static var mouseEnemy:Boolean = false;
		public static var mouseMapObject:Boolean = false;
		public static var mouseUnit:Boolean = false;
		public static var mouseAttack:Boolean = false;
		
		/**
		 * These are the variables involving battle.
		 * The attackTarget is the target to be moving around.
		 */
		public static var attackTarget:Target = new Target();
		
		/**
		 * These are the variables involving Map Objects.
		 * The mapObject is the MapObject currently being selected.
		 */
		public static var mapObject:MapObject;
		
		/**
		 * Switches and variables of the game. Very very very content/game-specific.
		 */
		public static var switchesArray = new Array(100);
		public static var variablesArray = new Array(100);
	}
}