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
					c1.visible = true;
					p1.visible = true;
					c1.text = "Unit's Name:";
					break;
				case "Switch" :
					description.text = "This object will only appear if the numbered switch is ON (true) or OFF(false).";
					c1.visible = true;
					p1.visible = true;
					c1.text = "Switch Number:";
					c2.visible = true;
					p2.visible = true;
					c2.text = "ON or OFF:";
					break;
				case "Variable" :
					description.text = "This object will only appear if the numbered variable is </<=/==/>/>= to the given value."
					;
					c1.visible = true;
					p1.visible = true;
					c1.text = "Variable Number:";
					c2.visible = true;
					p2.visible = true;
					c2.text = "<, <=, ==, >, >=:";
					c3.visible = true;
					p3.visible = true;
					c3.text = "Value to Compare:";
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