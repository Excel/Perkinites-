package game{

	import actors.Unit;
	import util.FunctionUtils;

	/**
	 * Generic condition checker to be subclassed for the fun of it.
	 */
	public class GameConditionChecker {

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
				}
			}
			return true;
		}
		
		public static function checkUnit(condition) {
			if (Unit.currentUnit.Name != condition && Unit.partnerUnit.Name != condition) {
				return false;
			}
			return true;
		}
		public static function checkSwitch(condition) {
			var parameters = condition.toString().split(":");
			
			var idx = parseInt(parameters[0]);
			var binary = parameters[1];
			
			if (binary == "ON") {
				if (!GameVariables.switchesArray[idx]){
					return false;
				}
			} else if (binary == "OFF") {
				if (GameVariables.switchesArray[idx]) {
					return false;
				}
			}
			return true;
		}
		public static function checkVariable(condition) {
			var parameters = condition.toString().split(":");
			
			var idx = parseInt(parameters[0]);
			var compare = parameters[1];
			var value = parseInt(parameters[2]);
			
			if (compare == ">") {
				if (GameVariables.variablesArray[idx] <= value) {
					return false;
				}												
			} else if (compare == "<") {
				if (GameVariables.variablesArray[idx] >= value) {
					return false;
				}						
			} else if (compare == "==") {
				if (GameVariables.variablesArray[idx] != value) {
					return false;
				}						
			} else if (compare == ">=") {
				if (GameVariables.variablesArray[idx] < value) {
					return false;
				}						
			} else if (compare == "<=") {
				if (GameVariables.variablesArray[idx] > value) {
					return false;
				}					
			}
			return true;
		}
	}
}