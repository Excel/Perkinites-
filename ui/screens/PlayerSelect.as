﻿package ui.screens{

	import flash.text.TextField;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.*;
	import flash.filters.GlowFilter;
	import flash.ui.Keyboard;

	import actors.*;
	import game.*;
	import levels.*;

	public class PlayerSelect extends BaseScreen {

		public var entries:Array;
		public var teamSelected:Boolean;
		public var pn1:int;

		function PlayerSelect(stageRef:Stage) {
			this.stageRef=stageRef;


			entries = new Array();
			teamSelected=false;
			pn1=Unit.currentUnit.id;


			showEntries();
			scrollPane.source=playerList;

			var gf1=new GlowFilter(0x666666,100,30,30,3,10,true,false);
			beginButton.filters=[gf1];
			beginButton.buttonText.text="Start!";

			unitName1.visible=false;
			unitName2.visible=false;
			playerDisplay1.visible=false;
			playerDisplay2.visible=false;

			playerDisplay1.button1.addEventListener(MouseEvent.CLICK, pageHandler);
			playerDisplay1.button2.addEventListener(MouseEvent.CLICK, pageHandler2);
			playerDisplay1.button3.addEventListener(MouseEvent.CLICK, pageHandler3);
			playerDisplay1.button4.addEventListener(MouseEvent.CLICK, pageHandler4);

			playerDisplay2.button1.addEventListener(MouseEvent.CLICK, pageHandler);
			playerDisplay2.button2.addEventListener(MouseEvent.CLICK, pageHandler2);
			playerDisplay2.button3.addEventListener(MouseEvent.CLICK, pageHandler3);
			playerDisplay2.button4.addEventListener(MouseEvent.CLICK, pageHandler4);

			if (pn1!=-1) {
				beginButton.filters=[];
				teamSelected=true;
				beginButton.addEventListener(MouseEvent.MOUSE_OVER, overHandler);
				beginButton.addEventListener(MouseEvent.MOUSE_OUT, outHandler);
				beginButton.addEventListener(MouseEvent.CLICK, startLevel);

				unitName1.visible=true;
				unitName2.visible=true;
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
			}

			load();

		}


		override public function keyHandler(e:KeyboardEvent):void {
			var sound;

			if (e.keyCode=="X".charCodeAt(0)) {
				sound = new se_timeout();
				sound.play();
				unload(new StageSelect(GameVariables.setLevel, GameVariables.difficulty, stageRef));
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
				entry.id=i;

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
		function clickHandler(e) {
			var btn=e.target;

			var sound = new se_timeout();
			sound.play();
			beginButton.filters=[];
			teamSelected=true;
			beginButton.addEventListener(MouseEvent.MOUSE_OVER, overHandler);
			beginButton.addEventListener(MouseEvent.MOUSE_OUT, outHandler);
			beginButton.addEventListener(MouseEvent.CLICK, startLevel);
			unitName1.visible=true;
			unitName2.visible=true;

			pn1=btn.id;
			//pn1=ActorDatabase.names.indexOf(e.target.playerName1.text);

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

			Unit.currentUnit=new Unit(pn1);
			Unit.partnerUnit=new Unit(pn1+1);

		}

		function startLevel(e) {
			startGame();
		}

		function startGame() {
			var sound = new se_chargeup();
			sound.play();
			unload();
			GameVariables.startLevel=true;

			Unit.currentUnit=new Unit(pn1);
			Unit.partnerUnit=new Unit(pn1+1);

			//implement this later
			var i;
			for (i = 0; i < Unit.currentUnit.basicAbilities.length; i++) {
				Unit.abilityAmounts[Unit.currentUnit.basicAbilities[i].id]=1;
			}
			for (i = 0; i < Unit.partnerUnit.basicAbilities.length; i++) {
				Unit.abilityAmounts[Unit.partnerUnit.basicAbilities[i].id]=1;
			}
		}

		public function pageHandler(e) {
			playerDisplay1.gotoPage(1);
			playerDisplay1.button1.filters=[playerDisplay1.gf1];
			playerDisplay1.button2.filters=[];
			playerDisplay1.button3.filters=[];
			playerDisplay1.button4.filters=[];

			playerDisplay2.gotoPage(1);
			playerDisplay2.button1.filters=[playerDisplay2.gf1];
			playerDisplay2.button2.filters=[];
			playerDisplay2.button3.filters=[];
			playerDisplay2.button4.filters=[];
		}
		public function pageHandler2(e) {
			playerDisplay1.gotoPage(2);
			playerDisplay1.button1.filters=[];
			playerDisplay1.button2.filters=[playerDisplay1.gf1];
			playerDisplay1.button3.filters=[];
			playerDisplay1.button4.filters=[];

			playerDisplay2.gotoPage(2);
			playerDisplay2.button1.filters=[];
			playerDisplay2.button2.filters=[playerDisplay2.gf1];
			playerDisplay2.button3.filters=[];
			playerDisplay2.button4.filters=[];
		}
		public function pageHandler3(e) {
			playerDisplay1.gotoPage(3);
			playerDisplay1.button1.filters=[];
			playerDisplay1.button2.filters=[];
			playerDisplay1.button3.filters=[playerDisplay1.gf1];
			playerDisplay1.button4.filters=[];

			playerDisplay2.gotoPage(3);
			playerDisplay2.button1.filters=[];
			playerDisplay2.button2.filters=[];
			playerDisplay2.button3.filters=[playerDisplay2.gf1];
			playerDisplay2.button4.filters=[];
		}
		public function pageHandler4(e) {
			playerDisplay1.gotoPage(4);
			playerDisplay1.button1.filters=[];
			playerDisplay1.button2.filters=[];
			playerDisplay1.button3.filters=[];
			playerDisplay1.button4.filters=[playerDisplay1.gf1];

			playerDisplay2.gotoPage(4);
			playerDisplay2.button1.filters=[];
			playerDisplay2.button2.filters=[];
			playerDisplay2.button3.filters=[];
			playerDisplay2.button4.filters=[playerDisplay2.gf1];
		}

	}
}