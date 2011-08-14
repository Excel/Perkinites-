package maps{

	import actors.Unit;
	import game.GameUnit;
	import util.FunctionUtils;

	/**
	 * In MapObject initialization, checks whether the Object can be created.
	 */
	public class MapObjectConditionChecker {

		public static function checkCondition(mapObject:MapObject):Boolean {
			for (var i = 0; i < mapObject.conditions.length; i++) {
				var condition = mapObject.conditions[i];
				if (condition.name() == "Unit") {
					if (Unit.currentUnit.Name != condition && Unit.partnerUnit.Name != condition) {
						return false;
					}
				}
			}
			return true;
		}
	}
}