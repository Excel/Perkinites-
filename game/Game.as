package game {
	import maps.*;
	import tileMapper.*;
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
        public static const FILLER_TILE_CLASS:String = "com.ironcoding.game.content.tiles.FillerTile"

		public var stageRef:Stage;
        public var mapClip:MovieClip;

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

        public function Game(stageRef:Stage, mapClip:MovieClip, tileW:int, tileH:int) {
            this.stageRef = stageRef;
			this.mapClip = mapClip;
            this.tileW = tileW;
            this.tileH = tileH;
        }
		
		public function buildMap(){
			MapManager.stageRef=stageRef;
			mapClip = MapManager.loadMap(1);
			stageRef.addChild(mapClip);
			HUDManager.setup(stageRef);
			HUDManager.toggleUnitHUD(true);
			HUDManager.toggleEnemyHUD(false);
		}
		
		public function destroyMap(){
			stageRef.removeChild(mapClip);
			mapClip = new MovieClip();
		}
    }
}