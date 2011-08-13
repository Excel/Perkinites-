package game {
	import actors.Controls;
	import maps.*;
	import tileMapper.*;
	import ui.*;
	import ui.hud.*;
	
    import flash.display.MovieClip;
	import flash.display.Stage;
    import flash.utils.getDefinitionByName;

    /**
     *
     * Contains metadata about the current game.
     *
     */

    public class Game {

		public var stageRef:Stage;
        public var mapClip:MovieClip;
		public var controls:Controls;

        /**
         *
         * A multidimensional array describing all of the tiles on the map.  Contains a class reference to each tile.
         *
         */

        public var gameTiles:Object;
        public var tileW:int;
        public var tileH:int;
        public var map:Map;

        /**
         * @param mapClip Movieclip where all the game things are
         * @param tileW The width in pixels of the tiles
         * @param tileH The height in pixels of the tiles
         */

        public function Game(stageRef:Stage, mapClip:MovieClip) {
            this.stageRef = stageRef;
			this.mapClip = mapClip;
            this.tileW = 32;
            this.tileH = 32;
			
			this.controls = new Controls(this, stageRef);
        }
		
		public function buildMap(){
			MapManager.stageRef=stageRef;
			
			var mapID = GameVariables.nextMapID;
			if(mapID == -1){
				mapID = GameVariables.prevMapID;
				GameVariables.nextMapID = mapID;
			}
			mapClip = MapManager.loadMap(mapID);
			stageRef.addChild(mapClip);
			HUDManager.construct(stageRef);
			HUDManager.toggleUnitHUD(true);
			HUDManager.toggleEnemyHUD(false);
			controls.enable();
			var cursor = new Cursor(stageRef);
		}
		
		public function destroyMap(){
			stageRef.removeChild(mapClip);
			mapClip = new MovieClip();
			HUDManager.deconstruct(stageRef);
			controls.disable();
		}
		
		public function changeMap(){
			destroyMap();
			buildMap();
		}
    }
}