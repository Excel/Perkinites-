﻿package game{

	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.net.SharedObject;

	import abilities.*;
	import actors.*;
	import attacks.*;
	import enemies.*;
	import game.*;
	import maps.*;
	import tileMapper.*;
	import ui.*;
	import ui.hud.*;
	import ui.screens.*;
	import util.*;

	/**
	  * Handles everything aboot the game. 
	  */

	public class GameClient extends MovieClip {

		public var stageRef:Stage;

		public var actorDatabase;
		public var mapDatabase;

		public var mainGame;

		public function GameClient(stageRef:Stage):void {
			this.stageRef=stageRef;

			//Create databases
			actorDatabase = new ActorDatabase();
			mapDatabase = new MapDatabase();

			//Load XML Data in order!
			AbilityDatabase.loadData();
			actorDatabase.loadData();
			mapDatabase.addEventListener(MapDataEvent.MAPS_LOADED, startGame);
			mapDatabase.loadData();

			for (var i = 0; i < 100; i++) {
				GameVariables.switchesArray[i] = false;
				GameVariables.variablesArray[i] = 0;				
			}
			var mapClip = new MovieClip();

			mainGame = new Game(stageRef, mapClip);
			mapDatabase.addEventListener(MapDataEvent.MAPS_LOADED, startGame);
		}


		public function loadAbilities() {

		}
		public function loadUnits() {

		}
		public function loadEnemies() {

		}
		public function loadMaps() {

		}
		/**
		 * Called when the tilesets and maps are ready.  Tells the document class that the game is ready to be initialized.
		 */
		public function startGame(e:MapDataEvent):void {
			this.dispatchEvent(new GameDataEvent(GameDataEvent.DATA_LOADED));
		}
		public function showMap():void {
			mainGame.buildMap();
		}
		public function changeMap():void {
			mainGame.changeMap();
		}
		public function saveGame():void {
			var sObj=SharedObject.getLocal("savegame");
			if (! sObj.data.name) {
				sObj.data.name="A";
			} else {
				sObj.data.name="B";
			}
			if (!sObj.data.mainGame) {
				sObj.data.mainGame = mainGame;
			}
			sObj.flush();
		}
		public function loadGame():void {
			var sObj=SharedObject.getLocal("savegame");
			var a=sObj.data.name;
			trace(a);
			showMap();
		}
	}
}