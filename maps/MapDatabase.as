package maps{

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.xml.*;

	/**
	 * Holds Map information and dispatches events to signal when loading is complete. :)
	 */
	public class MapDatabase extends EventDispatcher {

		public var xmlLoader:URLLoader = new URLLoader();

		public const tilesetsURL:String="xml/Tilesets.xml";
		public const mapsURL:String="xml/Maps.xml";
		public const mapObjectsURL:String="xml/Maps/Map";

		public static var tilesetInfo = new Array();
		public static var mapInfo = new Array();
		public static var mapObjectInfo = new Array();

		/**
		 * Loads the tilesets, maps, and objects.
		 */

		public function MapDatabase() {

		}

		public function loadData() {
			this.loadObject(tilesetsURL, handleLoadedTilesets);
			this.addEventListener(MapDataEvent.TILESETS_LOADED, loadMaps);
			this.addEventListener(MapDataEvent.MAPS_LOADED, loadMapObjects);
		}

		/**
		 * Creates a request using the passed URL and calls the passed function on complete.
		 *
		 * @param url The URL to request.
		 * @param handleFunction The function to be called on complete.
		 */

		public function loadObject(url:String, handleFunction:Function):void {
			var request:URLRequest=new URLRequest(url);
			xmlLoader.addEventListener(Event.COMPLETE, handleFunction);
			xmlLoader.load(request);
		}

		/**
		 * Loads the tilesets.
		 */
		public function handleLoadedTilesets(e:Event):void {
			xmlLoader.removeEventListener(Event.COMPLETE, handleLoadedTilesets);
			var xmlData=new XML(e.target.data);
			parseTilesetData(xmlData);
		}
		public function parseTilesetData(input:XML):void {
			for each (var tilesetElement:XML in input.Tileset) {
				var tileset = new Tileset();
				tileset.ID=tilesetElement.ID;
				tileset.picture=tilesetElement.Picture;

				for each (var tileElement:XML in tilesetElement.Tile) {
					tileset.tileTypes.push(""+tileElement.Type);
				}

				tilesetInfo.push(tileset);
			}
			this.dispatchEvent(new MapDataEvent(MapDataEvent.TILESETS_LOADED, true));
		}

		/**
		 * Loads the maps after loading tilesets.
		 */
		public function loadMaps(e:MapDataEvent):void {
			loadObject(mapsURL, this.handleLoadedMaps);
		}
		public function handleLoadedMaps(e:Event):void {
			xmlLoader.removeEventListener(Event.COMPLETE, handleLoadedMaps);
			var xmlData=new XML(e.target.data);
			parseMapData(xmlData);
		}
		public function parseMapData(input:XML):void {
			for each (var mapElement:XML in input.Map) {
				var map = new Map(mapElement.ID, mapElement.MapCode, mapElement.MapName, 
				  mapElement.TilesetID, mapElement.BGM, mapElement.BGS);
				mapInfo.push(map);
			}
			this.dispatchEvent(new MapDataEvent(MapDataEvent.MAPS_LOADED, true));
		}

		/**
		 * Loads the objects on the maps after loading maps.
		 */
		public function loadMapObjects(e:MapDataEvent):void {
			var objectXMLLoaders:Array = new Array();

			for (var i = 0; i < mapInfo.length; i++) {
				var oXMLLoader:URLLoader = new URLLoader();
				objectXMLLoaders.push(oXMLLoader);
			}

			for (var j = 0; j< mapInfo.length; j++) {
				objectXMLLoaders[j].addEventListener(Event.COMPLETE, handleLoadedMapObjects);
				objectXMLLoaders[j].load(new URLRequest(mapObjectsURL+(j+1)+".xml"));

			}
		}
		public function handleLoadedMapObjects(e:Event):void {
			e.target.removeEventListener(Event.COMPLETE, handleLoadedMapObjects);
			var xmlData=new XML(e.target.data);
			parseMapObjectData(xmlData);
		}
		public function parseMapObjectData(input:XML):void {
			var eventArray = new Array();

			for each (var eventElement:XML in input.MapEvent) {
				var mapEvent = new MapObject();

				mapEvent.dir=eventElement.Graphic.Dir;

				var posString=eventElement.Graphic.Position;
				var ind1=posString.indexOf("(")+1;
				var ind2=posString.indexOf(",",ind1);
				mapEvent.xTile=parseInt(posString.substring(ind1,ind2));
				mapEvent.x=mapEvent.xTile*32+16;
				ind1=ind2+1;
				ind2=posString.indexOf(")");
				mapEvent.yTile=parseInt(posString.substring(ind1,ind2));
				mapEvent.y=mapEvent.yTile*32+16;

				for each (var conditionElement:XML in eventElement.Conditions) {
					mapEvent.conditions.push(conditionElement);
				}

				mapEvent.movement=eventElement.Movement.Type;
				mapEvent.speed=eventElement.Movement.Speed;
				mapEvent.wait=eventElement.Movement.Wait;

				mapEvent.aTrigger=eventElement.Activation.Trigger;
				mapEvent.determineActivation();
				mapEvent.range=eventElement.Activation.Range;

				for each (var commandElement:XML in eventElement.Commands.children()) {
					var action=MapObjectParser.parseCommand(mapEvent,commandElement);
					mapEvent.commands.push(action);
				}
				eventArray.push(mapEvent);
			}
			mapObjectInfo.push(eventArray);
			this.dispatchEvent(new MapDataEvent(MapDataEvent.MAPOBJECTS_LOADED, true));
		}

		public static function getTileset(id:int):Tileset {
			return tilesetInfo[id];
		}
		public static function getMap(id:int):Map {
			return mapInfo[id];
		}
		public static function getMapObjects(id:int):Array {
			return mapObjectInfo[id];
		}
	}

}