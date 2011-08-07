package maps{

    public class Tileset {

		public var ID:int
		public var picture:String;
		public var tileTypes:Array;

        /**
         *
		 * @param ID The ID of the map
         * @param mapCode The information to parse of the map.
         * @param mapName The name of the map.
		 * @param TilesetID The ID of the Tileset to use
         * @param BGM The tile set of the map.
         * @param BGS The array containing the map.
         *
         */

        public function Tileset() {
 			this.ID = 0;
			this.picture = "";
			this.tileTypes = new Array();
        }
    }
}