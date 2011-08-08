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
		public const mapEventsURL:String="xml/Maps/Map";

		public static var tilesetInfo = new Array();
		public static var mapInfo = new Array();
		public static var mapEventInfo = new Array();

		/**
		 * Loads the tilesets, maps, and events.
		 */

		public function MapDatabase() {

		}

		public function loadData() {
			this.loadObject(tilesetsURL, handleLoadedTilesets);
			this.addEventListener(MapDataEvent.TILESETS_LOADED, loadMaps);
			this.addEventListener(MapDataEvent.MAPS_LOADED, loadMapEvents);
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
		 * Loads the events on the maps after loading maps.
		 */
		public function loadMapEvents(e:MapDataEvent):void {
			var eventXMLLoaders:Array = new Array();

			for (var i = 0; i < mapInfo.length; i++) {
				var eXMLLoader:URLLoader = new URLLoader();
				eventXMLLoaders.push(eXMLLoader);
			}

			for (var j = 0; j< mapInfo.length; j++) {
				eventXMLLoaders[j].addEventListener(Event.COMPLETE, handleLoadedMapEvents);
				eventXMLLoaders[j].load(new URLRequest(mapEventsURL+(j+1)+".xml"));

			}
		}
		public function handleLoadedMapEvents(e:Event):void {
			e.target.removeEventListener(Event.COMPLETE, handleLoadedMaps);
			var xmlData=new XML(e.target.data);
			parseMapEventData(xmlData);
		}
		public function parseMapEventData(input:XML):void {
			var eventArray = new Array();

			for each (var eventElement:XML in input.MapEvent) {
				var mapEvent = new MapEvent();

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
			mapEventInfo.push(eventArray);
			this.dispatchEvent(new MapDataEvent(MapDataEvent.MAPEVENTS_LOADED, true));
		}

		public static function getTileset(id:int):Tileset {
			return tilesetInfo[id];
		}
		public static function getMap(id:int):Map {
			return mapInfo[id];
		}
		public static function getMapEvents(id:int):Array {
			return mapEventInfo[id];
		}
	}

}