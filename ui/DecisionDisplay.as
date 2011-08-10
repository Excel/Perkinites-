package ui{

	import flash.text.TextField;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.*;
	import flash.filters.GlowFilter;
	import flash.ui.Keyboard;

	import abilities.*;
	import actors.*;
	import game.*;
	import maps.*;

	public class DecisionDisplay extends MovieClip {

		public var entries:Array;
		public var pn1:int;
		
		function DecisionDisplay(){
			
		}
		/*function showEntries() {
			//TEMPORARY FIX
			var yOffset=0;
			var names=ActorDatabase.names;
			//Must only show available Units, not all Units!
			for (var i = 0; i < names.length; i+=2) {
				var entry = new Entry();
				entry.playerName1.text=names[i];
				entry.playerName2.text=names[i+1];
				entry.id=i;
				entry.gotoAndStop(1);

				//GOTTA ADD LISTENERS TO ENTRIES AND GOTTA FIX THEM
				entry.addEventListener(MouseEvent.MOUSE_OVER, entryOverHandler);
				entry.addEventListener(MouseEvent.MOUSE_OUT, entryOutHandler);
				entry.addEventListener(MouseEvent.CLICK, clickHandler);

				//GOTTA ADD
				playerList.addChild(entry);
				entry.mouseChildren=false;
				entry.x=0;
				entry.y=yOffset;
				entries.push(entry);
				yOffset+=16;
			}

		}
		function entryOverHandler(e) {
			var gf1=new GlowFilter(0xFFFFFF,100,20,20,1,10,true,false);
			e.target.filters=[gf1];
		}
		function entryOutHandler(e) {
			e.target.filters=[];
		}


		function entryOverHandler(e) {
			var gf1=new GlowFilter(0xFFFFFF,100,20,20,1,10,true,false);
			e.target.filters=[gf1];
		}
		function entryOutHandler(e) {
			e.target.filters=[];
		}
		function clickHandler(e) {
			var btn=e.target;

			var sound = new se_timeout();
			sound.play();
			beginButton.filters=[];
			beginButton.addEventListener(MouseEvent.MOUSE_OVER, overHandler);
			beginButton.addEventListener(MouseEvent.MOUSE_OUT, outHandler);
			beginButton.addEventListener(MouseEvent.CLICK, startLevel);
			unitName1.visible=true;
			unitName2.visible=true;

			for (var i = 0; i < entries.length; i++) {
				entries[i].gotoAndStop(1);
			}
			pn1=btn.id;
			btn.gotoAndStop(2);
			unitName1.text=ActorDatabase.getName(pn1);
			unitName2.text=ActorDatabase.getName(pn1+1);

			playerDisplay1.setUnitIndex(pn1);
			playerDisplay2.setUnitIndex(pn1+1);

			if (! playerDisplay1.visible) {
				playerDisplay1.displayAgain();
			}
			if (! playerDisplay2.visible) {
				playerDisplay2.displayAgain();
			}

			var units=ActorDatabase.getExistingUnits(pn1);
			if (units.length==0) {
				Unit.currentUnit=new Unit(pn1);
				Unit.partnerUnit=new Unit(pn1+1);
			} else {
				Unit.currentUnit=units[0];
				Unit.partnerUnit=units[1];
			}
		}*/
	}
}