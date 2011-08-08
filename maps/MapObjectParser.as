package maps{
	
	import util.FunctionUtils;
	
	public class MapObjectParser{

		public static function parseCommand(mapEvent, command) {
			var func;
			var ind;

			if (command.name()=="Message") {
				
				ind=command.indexOf(":");
				var nameString=command.substring(0,ind);
				var messageString=command.substring(ind+1,command.indexOf(":",ind+1));
				ind=command.indexOf(":",ind+1);
				var portrait=command.substring(ind+1,command.indexOf(":",ind+1));
				ind=command.indexOf(":",ind+1);
				var faceIcon=command.substring(ind+1,command.toString().length);
				func=FunctionUtils.thunkify(mapEvent.displayMessage,nameString,messageString,portrait,faceIcon);
			
			} else if (command.name() == "Teleport") {
				
				ind=command.indexOf("(");
				var mapID=parseInt(command.substring(0,ind));
				var xTile=parseInt(command.substring(ind+1,command.indexOf(",")));
				ind=command.indexOf(",");
				var yTile=parseInt(command.substring(ind+1,command.indexOf(")")));
				func=FunctionUtils.thunkify(mapEvent.teleportToMap,mapID, xTile, yTile);
			
			}
			return func;

		}
	}
}