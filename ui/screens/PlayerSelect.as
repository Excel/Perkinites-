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
		public var pn1:int;

		function PlayerSelect(stage:Object) {
			trace("there's a bug that only allows an entry to be clicked on a non-text field. there's a very hacky fix to it right now :(");
			trace("GOTTA FIX PLAYER DISPLAY");
			x=0;
			y=0;
			entries = new Array();
			teamSelected=false;
			pn1=-1;

			showEntries();
			scrollPane.source=playerList;

			var gf1=new GlowFilter(0x666666,100,30,30,3,10,true,false);
			beginButton.filters=[gf1];
			beginButton.buttonText.text="Start!";

			unitName1.visible=false;
			unitName2.visible=false;
			playerDisplay1.visible=false;
			playerDisplay2.visible=false;

			stage.addChild(this);
			enableKeyHandler();


		}

		public function enableKeyHandler() {
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyHandler);
		}
		public function disableKeyHandler() {
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyHandler);
		}
		public function keyHandler(e) {
			var sound;

			if (e.keyCode=="X".charCodeAt(0)) {
				sound = new se_timeout();
				sound.play();
				disableKeyHandler();
				var stageSelect=new StageSelect(SuperLevel.setLevel,SuperLevel.diff,stage);
				stage.removeChild(this);

			}

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
				entry.addEventListener(MouseEvent.MOUSE_OVER, entryOverHandler);
				entry.addEventListener(MouseEvent.MOUSE_OUT, entryOutHandler);
				entry.addEventListener(MouseEvent.CLICK, clickHandler);

				entry.playerName1.addEventListener(MouseEvent.MOUSE_OVER, entryOverHandler2);
				entry.playerName1.addEventListener(MouseEvent.MOUSE_OUT, entryOutHandler2);
				entry.playerName1.addEventListener(MouseEvent.CLICK, clickHandler2);

				entry.playerName2.addEventListener(MouseEvent.MOUSE_OVER, entryOverHandler2);
				entry.playerName2.addEventListener(MouseEvent.MOUSE_OUT, entryOutHandler2);
				entry.playerName2.addEventListener(MouseEvent.CLICK, clickHandler2);

				//GOTTA ADD
				playerList.addChild(entry);
				entry.y=yOffset;
				entry.x=0;
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
		function entryOverHandler2(e) {
			var gf1=new GlowFilter(0xFFFFFF,100,20,20,1,10,true,false);
			e.target.parent.filters=[gf1];
		}
		function entryOutHandler2(e) {
			e.target.parent.filters=[];
		}
		function clickHandler(e) {
			if (!(e.target is TextField)) {
				var sound = new se_timeout();
				sound.play();
				beginButton.filters=[];
				teamSelected=true;
				beginButton.addEventListener(MouseEvent.MOUSE_OVER, overHandler);
				beginButton.addEventListener(MouseEvent.MOUSE_OUT, outHandler);
				beginButton.addEventListener(MouseEvent.CLICK, startLevel);

				unitName1.visible=true;
				unitName2.visible=true;

				pn1=ActorDatabase.names.indexOf(e.target.playerName1.text);

				unitName1.text=ActorDatabase.getName(pn1);
				unitName2.text=ActorDatabase.getName(pn1+1);

				playerDisplay1.setUnitIndex(pn1);
				playerDisplay2.setUnitIndex(pn1+1);
				playerDisplay1.visible=true;
				playerDisplay2.visible=true;
			}
		}

		function clickHandler2(e) {
			var sound = new se_timeout();
			sound.play();
			beginButton.filters=[];
			teamSelected=true;
			beginButton.addEventListener(MouseEvent.MOUSE_OVER, overHandler);
			beginButton.addEventListener(MouseEvent.MOUSE_OUT, outHandler);
			beginButton.addEventListener(MouseEvent.CLICK, startLevel);

			unitName1.visible=true;
			unitName2.visible=true;
			pn1=ActorDatabase.names.indexOf(e.target.parent.playerName1.text);

			unitName1.text=ActorDatabase.getName(pn1);
			unitName2.text=ActorDatabase.getName(pn1+1);

			playerDisplay1.setUnitIndex(pn1);
			playerDisplay2.setUnitIndex(pn1+1);
			playerDisplay1.visible=true;
			playerDisplay2.visible=true;
		}

		function startLevel(e) {
			var sound = new se_chargeup();
			sound.play();
			trace("this will start the level in a non-gimmicky way eventually");
			disableKeyHandler();
			stage.removeChild(this);
			ActionConstants.startLevel=true;

			Unit.currentUnit=new Unit(pn1);
			Unit.partnerUnit=new Unit(pn1+1);


		}
	}
}