package abilities {
	import flash.events.Event;

	/**
	 * Event to signal when the ability data can be used.
	 */

	public class AbilityDataEvent extends Event {

		public static const ABILITIES_LOADED:String = "AbilitiesLoaded";
		public static const ABILITYEFFECTS_LOADED:String = "AbilityEffectsLoaded";

		public function AbilityDataEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}
	}
}
