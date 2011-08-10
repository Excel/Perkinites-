package maps{

	import util.FunctionUtils;

	/**
	 * AHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH
	 * ADSKJASJDKAHFKJAHSKFJAHSKDJHASKJDHKAJSHDKJASHDKJASHDKJAHSKJDHASKJDHAKJSHDKJH
	 */
	public class MapObjectParser {

		public static function parseCommand(mapEvent, command) {
			var func;
			var ind;
			var xTile;
			var yTile;
			var dir;

			if (command.name()=="Message") {//PAGE 1
				//<Message>Name:Message:Portrait:FaceIcon</Message>
				ind=command.indexOf(":");
				var nameString=command.substring(0,ind);
				var messageString=command.substring(ind+1,command.indexOf(":",ind+1));
				ind=command.indexOf(":",ind+1);
				var portrait=command.substring(ind+1,command.indexOf(":",ind+1));
				ind=command.indexOf(":",ind+1);
				var faceIcon=command.substring(ind+1,command.toString().length);
				func=FunctionUtils.thunkify(mapEvent.displayMessage,nameString,messageString,portrait,faceIcon);
				
			} else if (command.name() == "Choices") {
				//<Choices></Choices>
			
			} else if (command.name() == "EraseObject") {
				//<EraseObject></EraseObject>
				func=mapEvent.eraseObject;
			
			} else if (command.name() == "JumpTo") {
				//<JumpTo>CommandIndex</JumpTo>
				var commandIndex=parseInt(command.substring(0,command.toString().length));
				func=FunctionUtils.thunkify(mapEvent.jumpTo,commandIndex);
			
			} else if (command.name() == "ChangeFlexPoints") {
				//<ChangeStat>ChangeType:ChangeValue</ChangeStat>
				ind=command.indexOf(":");
				var changeType=command.substring(0,ind);
				var changeValue=parseFloat(command.substring(ind+1,command.toString().length));
				func=FunctionUtils.thunkify(mapEvent.changeFlexPoints,changeType,changeValue);
			
			} else if (command.name() == "ChangeStat") {
				//<ChangeStat>UnitType:StatType:NewStat</ChangeStat>
				ind=command.indexOf(":");
				var unitType=command.substring(0,ind);
				var statType=command.substring(ind+1,command.indexOf(":",ind+1));
				ind=command.indexOf(":",ind+1);
				var newStat=parseInt(command.substring(ind+1,command.toString().length));
				func=FunctionUtils.thunkify(mapEvent.changeStat,unitType,statType,newStat);
			
			} else if (command.name() == "GetPrize") {
				//<GetPrize>Type:PrizeID:Amount:DisplayType</GetPrize>
				ind=command.indexOf(":");
				var type=command.substring(0,ind);
				var ID=parseInt(command.substring(ind+1,command.indexOf(":",ind+1)));
				ind=command.indexOf(":",ind+1);
				var amount=parseInt(command.substring(ind+1,command.indexOf(":",ind+1)));
				ind=command.indexOf(":",ind+1);
				var display=(command.substring(ind+1,command.toString().length));
				func=FunctionUtils.thunkify(mapEvent.getPrize,type, ID, amount, display);
			
			} else if (command.name() == "Teleport") {//PAGE 2
				//<Teleport>MapID(xTile,yTile):dir:Transition</Teleport>
				ind=command.indexOf("(");
				var mapID=parseInt(command.substring(0,ind));
				xTile=parseInt(command.substring(ind+1,command.indexOf(",")));
				ind=command.indexOf(",");
				yTile=parseInt(command.substring(ind+1,command.indexOf(")")));
				ind=command.indexOf(":",ind);
				dir=parseInt(command.substring(ind+1,command.indexOf(":",ind+1)));
				ind=command.indexOf(":",ind+1);
				var transition=command.substring(ind+1,command.toString().length);
				func=FunctionUtils.thunkify(mapEvent.teleportToMap,mapID,xTile,yTile,dir,transition);

			} else if (command.name() == "ChangeObjectPosition") {
				//<ChangeObjectPosition>EventID(xTile,yTile):dir</ChangeObjectPosition>
				ind=command.indexOf("(");
				var eventID=parseInt(command.substring(0,ind));
				xTile=parseInt(command.substring(ind+1,command.indexOf(",")));
				ind=command.indexOf(",");
				yTile=parseInt(command.substring(ind+1,command.indexOf(")")));
				ind=command.indexOf(":");
				dir=parseInt(command.substring(ind+1,command.toString().length));
				func=FunctionUtils.thunkify(mapEvent.changeObjectPosition,eventID,xTile,yTile,dir);
			
			} else if (command.name() == "ScrollMap") {
				//<ScrollMap>ScrollDir:NumTiles:Speed</ScrollMap>
				ind=command.indexOf(":");
				var scrollDir=parseInt(command.substring(0,ind));
				var numTiles=parseInt(command.substring(ind+1,command.indexOf(":",ind+1)));
				ind=command.indexOf(":",ind+1);
				var speed=parseInt(command.substring(ind+1,command.toString().length));
				func=FunctionUtils.thunkify(mapEvent.scrollMap,scrollDir,numTiles,speed);

			}
			return func;

		}
	}
}