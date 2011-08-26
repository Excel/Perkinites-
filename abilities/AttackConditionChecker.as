package abilities{

	import actors.Unit;
	import game.GameConditionChecker;
	import game.GameUnit;
	import game.GameVariables;
	import util.FunctionUtils;

	/**
	 * Checks conditionals found in Attacks.
	 */
	public class AttackConditionChecker extends GameConditionChecker{

		public static function checkCondition(gameObject, conditions:Array):Boolean {
			for (var i = 0; i < conditions.length; i++) {
				var condition = conditions[i];
				if (condition.name() == "Unit") {
					//<Unit>Name</Unit>
					if (!checkUnit(condition)) {
						return false;
					}
					
				} else if (condition.name() == "Switch") {
					//<Switch>ID:Value</Switch>
					if (!checkSwitch(condition)) {
						return false;
					}
				} else if (condition.name() == "Variable") {
					//<Variable>ID:Compare:Value</Variable>
					if (!checkVariable(condition)) {
						return false;
					}
				} else if (condition.name() == "HitWall") {
					if (!gameObject.hitWall) {
						return false;
					}
				} 
			}
			return true;
		}
	}
}