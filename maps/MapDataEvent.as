package maps {
	import flash.events.Event;

	/**
	 * Event to signal when the map data can be used.
	 */

	public class MapDataEvent extends Event {

		public static const TILESETS_LOADED:String = "TilesetsLoaded";
		public static const MAPS_LOADED:String = "MapsLoaded";
		public static const MAPEVENTS_LOADED:String = "MapEventsLoaded";

		public function MapDataEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}
	}
}
