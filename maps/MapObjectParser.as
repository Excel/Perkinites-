package maps{

	import game.GameUnit;
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
			var ID;

			if (command.name()=="Message") {//PAGE 1
				//<Message>Name:Message:Portrait:FaceIcon</Message>
				ind=command.indexOf(":");
				var nameString=command.substring(0,ind);
				var messageString=command.substring(ind+1,command.indexOf(":",ind+1));
				ind=command.indexOf(":",ind+1);
				var portrait = command.substring(ind + 1, command.indexOf(":", ind + 1));
				if (portrait == command) {
					portrait = "";
				}
				ind = command.indexOf(":", ind + 1);
				var faceIcon=command.substring(ind+1,command.indexOf(":",ind+1));
				ind=command.indexOf(":",ind+1);				
				var withChoices = command.substring(ind + 1, command.toString().length);
				func=FunctionUtils.thunkify(mapEvent.displayMessage,nameString,messageString,portrait,faceIcon, withChoices);
				
			} else if (command.name() == "Choices") {
				//<Choices></Choices>
				var answersArray = new Array();
				var commandsArray = new Array();
				
				for each (var choiceElement:XML in command.children()) {
					var actions = new Array();
					for each(var subchoiceElement:XML in choiceElement.children()) {
						if (subchoiceElement.name() == "Display") {
							answersArray.push(subchoiceElement);
						} else {
							var action = MapObjectParser.parseCommand(mapEvent, subchoiceElement);
							actions.push(action);
						}
					}
					commandsArray.push(actions);						
				}
				
				func = FunctionUtils.thunkify(mapEvent.displayChoices, answersArray, commandsArray);
			} else if (command.name() == "Wait") {
				//<Wait>time</Wait>
				func = FunctionUtils.thunkify(mapEvent.waitFor, parseInt(command.toString()));
			} else if (command.name() == "Conditional") {
				//<Conditional><Conditions></Conditions><Pass></Pass><Fail></Fail></Conditional>
				var conditionsArray = new Array();
				var passArray = new Array();
				var failArray = new Array();
				
				for each(var conditionElement:XML in command.Conditions.children()) {
					conditionsArray.push(conditionElement);
				}
				for each (var passElement:XML in command.Pass.children()) {
					var pass=MapObjectParser.parseCommand(mapEvent,passElement);
					passArray.push(pass);			
				}
				for each (var failElement:XML in command.Fail.children()) {
					var fail=MapObjectParser.parseCommand(mapEvent,failElement);
					failArray.push(fail);			
				}				
				
				func = FunctionUtils.thunkify(mapEvent.useConditional,conditionsArray,passArray,failArray);
			} else if (command.name() == "EraseObject") {
				//<EraseObject></EraseObject>
				func=mapEvent.eraseObject;			
			} else if (command.name() == "JumpTo") {
				//<JumpTo>CommandIndex</JumpTo>
				var commandIndex=parseInt(command.substring(0,command.toString().length));
				func=FunctionUtils.thunkify(mapEvent.jumpTo,commandIndex);
			
			} else if (command.name() == "Switch") {
				//<Switch>SwitchID:TRUE/FALSE</Switch>
				ind=command.indexOf(":");
				ID = parseInt(command.substring(0,ind));
				var binary=command.substring(ind + 1, command.toString().length);
				func = FunctionUtils.thunkify(mapEvent.changeSwitch, ID, binary);
				
			} else if (command.name() == "Variable") {
				//<Variable>VariableID:Operation:Value</Variable>
				ind=command.indexOf(":");
				ID=parseInt(command.substring(0,ind));
				var operation=command.substring(ind+1,command.indexOf(":",ind+1));
				ind=command.indexOf(":",ind+1);
				var value=parseInt(command.substring(ind+1,command.toString().length));
				func=FunctionUtils.thunkify(mapEvent.changeVariable,ID, operation, value);			
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
				ID=parseInt(command.substring(ind+1,command.indexOf(":",ind+1)));
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
				func = FunctionUtils.thunkify(mapEvent.scrollMap, scrollDir, numTiles, speed);
				
			} else if (command.name() == "PlayBGM") {
				//<PlayBGM>BGM</PlayBGM>
				func = FunctionUtils.thunkify(mapEvent.playBGM, command);
			}  else if (command.name() == "StopBGM") {
				//<StopBGM></StopBGM>
				func = mapEvent.stopBGM;
			} else if (command.name() == "Shop") {
				//<Shop>(Item1:Item2:etc)(Abilities)(Amounts)PriceMod</Shop>
				var itemsArray = new Array();
				var abilitiesArray = new Array();
				var amountsArray = new Array();
				var priceMod = 1;
				func = FunctionUtils.thunkify(mapEvent.createShop, itemsArray, abilitiesArray, amountsArray,priceMod);
			} else if (command.name() == "StartCutscene") {
				//<StartCutscene></StartCutscene>
				func = mapEvent.startCutscene;
			
				
			} else if (command.name() == "EndCutscene") {
				//<EndCutscene></EndCutscene>
				func = mapEvent.endCutscene;
			
			}
			return func;

		}
	}
}