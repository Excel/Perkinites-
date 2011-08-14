package maps{

	import actors.Unit;
	import game.GameUnit;
	import game.GameVariables;
	import util.FunctionUtils;

	/**
	 * In MapObject initialization, checks whether the Object can be created.
	 */
	public class MapObjectConditionChecker {

		public static function checkCondition(conditions:Array):Boolean {
			var ind = 0;
			var idx = 0;
			for (var i = 0; i < conditions.length; i++) {
				var condition = conditions[i];
				if (condition.name() == "Unit") {
					//<Unit>Name</Unit>
					if (Unit.currentUnit.Name != condition && Unit.partnerUnit.Name != condition) {
						return false;
					}
				} else if (condition.name() == "Switch") {
					//<Switch>ID:Value</Switch>
					ind=condition.indexOf(":");
					idx= parseInt(condition.substring(0, ind));
					var binary= condition.substring(ind + 1, condition.toString().length);
					
					if (binary == "ON") {
						if (!GameVariables.switchesArray[idx]){
							return false;
						}
					} else if (binary == "OFF") {
						if (GameVariables.switchesArray[idx]) {
							return false;
						}
					}
				} else if (condition.name() == "Variable") {
					//<Variable>ID:Compare:Value</Variable>
					ind=condition.indexOf(":");
					idx = parseInt(condition.substring(0, ind));
					var compare= condition.substring(ind+1, condition.indexOf(":", ind+1));					
					ind=condition.indexOf(":", ind+1);
					var value = parseInt(condition.substring(ind + 1, condition.toString().length));
					
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
				}
			}
			return true;
		}
	}
}