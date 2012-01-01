package 
{
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.*;
	import flash.ui.*;
	import flash.display.Sprite;

	public class InputList extends MovieClip
	{
		var cs;
		var ps;
		var inputType;
		public function InputList()
		{
			cs = new Array(c1,c2,c3,c4,c5,c6,c7);
			ps = new Array(p1,p2,p3,p4,p5,p6,p7);
			
		}

		public function updateInputs(type:String, fields:String)
		{
			hideFields();
			inputType = type;
			switch (type)
			{
				case "Unit" :
					description.text = "This object will only appear if the following Unit is active."
					;
					showFields(1);
					c1.text = "Unit's Name:";
					break;
				case "Switch" :
					description.text = "This object will only appear if the numbered switch is ON (true) or OFF(false).";
					showFields(2);
					c1.text = "Switch Number:";
					c2.text = "ON or OFF:";
					break;
				case "Variable" :
					description.text = "This object will only appear if the numbered variable is </<=/==/>/>= to the given value."
					;
					showFields(3);
					c1.text = "Variable Number:";
					c2.text = "<, <=, ==, >, >=:";
					c3.text = "Value to Compare:";
					break;
				case "Message": //somehow deal with COLON, NEWSPACE, AND LESSTHANTHREE
					description.text = "";
					showFields(5);
					c1.text = "Name:";
					c2.text = "Actual Message:";
					c3.text = "Include Portrait (Filename or None)";
					c4.text = "Include Face Icon (Name or None)";
					c5.text = "Included in Choices (No)";
					p5.text = "No";
					break;
				//choices
				case "Wait":
					description.text = "Wait for this many frames before going to the next command.";
					showFields(1);
					c1.text = "Waiting Time (in frames)";
					break;
				//conditional
				case "EraseObject":
					description.text = "Erase this object. Will reappear when you teleport to this map later."
					break;
				case "JumpTo":
					description.text = "Jump to this command.";
					showFields(1);
					c1.text = "Number of Command to jump to.";
					break;
				case "SwitchOp":
					description.text = "Turns ON/OFF a specific switch.";
					showFields(2);
					c1.text = "Switch Number:";
					c2.text = "ON or OFF:"; //this was originally true/false. change gameunit
					break;					
				case "VariableOp":
					description.text = "Changes a specific variable.";
					showFields(3);
					c1.text = "Variable Number:";
					c2.text = "+, -, *, /, =, or RAND";
					c3.text = "Value:";
					break;
				case "ChangeFlexPoints":
					description.text = "Change the amount of FlexPoints the Perkinites have.";
					showFields(2);
					c1.text = "Increase, Decrease, or Set:";
					c2.text = "FlexPoint Amount:";
					break;
				case "ChangeStat":
					description.text = "Changes an active unit's stat. Stat Types are Health, Health+, Health-, MaxHealth, Attack, Defense, Speed. This list will definitely change, just give me some time.";
					showFields(4);
					c1.text = "Unit Type (Current or Partner):";
					c2.text = "Stat Type:";
					c3.text = "Value of the New Stat:";
					c4.text = "Display Change on-screen (Yes or No):";
					break;
				case "GetPrize":
					description.text = "Gives the Perkinites a Prize! Simple Mode is displaying a simple popup in the top left corner. Cutscene Mode is displaying the item popup in the middle.";
					showFields(4);
					c1.text = "Item or Ability:";
					c2.text = "ID of the Item/Ability:";
					c3.text = "Amount Received:";
					c4.text = "Simple or Cutscene:";
					break;
				case "Teleport":
					description.text = "Teleports the Perkinites to a different map.";
					showFields(3);
					c1.text = "MapID(xTile,yTile):";
					c2.text = "Direction (2,4,6,8):";
					c3.text = "Show Transition (Yes or No):"
					break;
				case "ChangeObjectPosition":
					description.text = "Teleports the MapObject to a different set of coordinates on the same map.";
					showFields(2);
					c1.text = "ObjectID(xTile,yTile):"
					c2.text = "Direction (2,4,6,8):";
					break;
				case "ScrollMap":
					description.text = "Scrolls the camera in a given direction, length, and speed. They are all Numbers. If you want to return to the original, you have to make another ScrollMap command.";
					showFields(3);
					c1.text = "Scroll Direction (2/4/6/8):";
					c2.text = "Number of Tiles to Scroll:";
					c3.text = "Speed:";
					break;
				case "PlayBGM":
					description.text = "Plays a BGM. Eventually this will also have volume control if I can figure that out.";
					showFields(1);
					c1.text = "BGM Name:";
					break;
				case "StopBGM":
					description.text = "Stops a BGM from playing. Now it is just silence...and BGS noises.";
					break;				
				//shop;
				case "StartCutscene":
					description.text = "Note when the cutscene starts. Cutscenes can be skipped. When skipped, all the commands in between StartCutscene and EndCutscene are ignored.";
					break;
				case "EndCutscene":
					description.text = "Note when the cutscene ends. Cutscenes can be skipped. When skipped, all the commands in between StartCutscene and EndCutscene are ignored.";
					break;					
			}
			fillFields(fields);
		}
		public function hideFields()
		{
			for (var i = 0; i < cs.length; i++)
			{
				cs[i].visible = false;
				ps[i].visible = false;
			}
		}
		public function showFields(numFields:int){
			for(var i = 0; i < numFields; i++){
				cs[i].visible = true;
				ps[i].visible = true;
			}
		}
		public function fillFields(fields:String){
			var parameters = fields.toString().split(":");
			for(var i = 0; i < parameters.length; i++){
				ps[i].text = parameters[i];
			}
		}
		public function getCommand(){
			var commandXML;
			var count = 0;
			var command = "";
			for (var i = 0; i < cs.length; i++){
				if(ps[i].visible){
					count++;
				}
			}		
			for(i = 0; i < count; i++){
				command = command.concat(ps[i].text);
				if(i != count-1){
					command = command.concat(":");
				}
			}
			
			commandXML = <item>{command}</item>;
			commandXML.setName(inputType);
			return commandXML;
		}
		public function turnOff()
		{
			hideFields();
			description.text = "";
			for (var i = 0; i < cs.length; i++)
			{
				cs[i].text = "";
				ps[i].text = "";
			}
		}
	}
}