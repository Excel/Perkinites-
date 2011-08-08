package game{
    import flash.events.Event;
    
    /**
     * Event to signal when the game (map, units, events, enemies, blah) can be initialized.
     */
    
    public class GameDataEvent extends Event {
		
		public static const SCREEN_ON:String = "screenOn";
		public static const MAP_ON:String = "mapOn";
        public static const DATA_LOADED:String = "gameLoaded";
		public static const CHANGE_MAP:String = "changeMap";
        
        public function GameDataEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
            super(type, bubbles, cancelable);
        }
    }
}