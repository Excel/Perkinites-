package maps{

    public class Map {

		public var ID:int
		public var mapCode:String;
        public var mapName:String;
		public var tilesetID:int;
		public var BGM:String;
		public var BGS:String;

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

        public function Map(ID:int, mapCode:String, mapName:String, tilesetID:int, BGM:String, BGS:String) {
            this.ID = ID;
			this.mapCode = mapCode;
            this.mapName = mapName;
            this.tilesetID = tilesetID;
            this.BGM = BGM;
			this.BGS = BGS;
        }
    }
}