package maps{

	import actors.Unit;
	import game.GameUnit;
	import util.FunctionUtils;

	/**
	 * In MapObject initialization, checks whether the Object can be created.
	 */
	public class MapObjectConditionChecker {

		public static function checkCondition(conditions:Array):Boolean {
			for (var i = 0; i < conditions.length; i++) {
				var condition = conditions[i];
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