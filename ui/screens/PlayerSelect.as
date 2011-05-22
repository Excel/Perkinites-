package ui.screens{

	import flash.display.MovieClip;
	import flash.events.*;
	import flash.ui.*;
	import flash.filters.GlowFilter;

	import actors.*;
	import game.*;
	import levels.*;
	public class PlayerSelect extends MovieClip {

		public var entries:Array;
		public var teamSelected:Boolean;

		function PlayerSelect() {
			trace("there's a bug that only allows an entry to be clicked on a non-text field. i don't get it yet. :(");
			trace("also font needs to change for some stuff like entries :(");
			trace("also this doesn't select characters yet :(");
			x=0;
			y=0;
			entries = new Array();
			teamSelected=false;

			showEntries();
			scrollPane.source=playerList;

			var gf1=new GlowFilter(0x666666,100,30,30,3,10,true,false);
			beginButton.filters=[gf1];
			beginButton.buttonText.text="Start!";

			unitName1.visible=false;
			unitName2.visible=false;
		}


		public function overHandler(e) {
			var gf1=new GlowFilter(0xFF9900,100,20,20,1,10,true,false);
			beginButton.filters=[gf1];
		}
		public function outHandler(e) {
			beginButton.filters=[];
		}
		function showEntries() {
			//TEMPORARY FIX
			var yOffset=0;
			var names=ActorDatabase.names;
			//Must only show available Units, not all Units!
			for (var i = 0; i < names.length; i+=2) {
				var entry = new Entry();
				entry.playerName1.text=names[i];
				entry.playerName2.text=names[i+1];
				//GOTTA ADD LISTENERS TO ENTRIES AND GOTTA FIX THEM
				entry.addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
				entry.addEventListener(MouseEvent.MOUSE_UP, upHandler);
				entry.addEventListener(MouseEvent.CLICK, clickHandler);

				//GOTTA ADD
				playerList.addChild(entry);
				entry.y=yOffset;
				entry.x=0;
				entries.push(entry);
				yOffset+=16;
			}

		}

		function downHandler(e) {
			var gf1=new GlowFilter(0xFFFFFF,100,20,20,1,10,true,false);
			e.target.filters=[gf1];
		}
		function upHandler(e) {
			e.target.filters=[];
		}
		function clickHandler(e) {
			beginButton.filters=[];
			teamSelected=true;
			beginButton.addEventListener(MouseEvent.MOUSE_OVER, overHandler);
			beginButton.addEventListener(MouseEvent.MOUSE_OUT, outHandler);
			beginButton.addEventListener(MouseEvent.CLICK, startLevel);

			unitName1.visible=true;
			unitName2.visible=true;
			//FIX THIS
			/*var pn1=ActorDatabase.names.indexOf(e.target().playerName1);
			
			unitName1.text=ActorDatabase.names[pn1];
			unitName2.text=ActorDatabase.names[pn1+1];
			*/
		}

		function startLevel(e) {
			trace("this will start the level in a non-gimmicky way eventually");
			stage.removeChild(this);
			ActionConstants.startLevel=true;
		}
	}
}