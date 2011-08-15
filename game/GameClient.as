package game{

	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.SharedObject;
	import flash.net.URLRequest;
	import flash.utils.Timer;

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
		public var bgmDatabase;
		public var mapDatabase;

		public var mainGame;
		
		public var gameTimer;
		public static var soundTimer;
		
		public static var BGM:String;
		public static var end;

		public function GameClient(stageRef:Stage):void {
			this.stageRef=stageRef;

			//Create databases
			actorDatabase = new ActorDatabase();
			bgmDatabase = new BGMDatabase();
			mapDatabase = new MapDatabase();

			//Load XML Data in order!
			AbilityDatabase.loadData();
			actorDatabase.loadData();
			bgmDatabase.loadData();
			mapDatabase.addEventListener(MapDataEvent.MAPS_LOADED, startGame);
			mapDatabase.loadData();

			for (var i = 0; i < 100; i++) {
				GameVariables.switchesArray[i] = false;
				GameVariables.variablesArray[i] = 0;				
			}
			var mapClip = new MovieClip();
			gameTimer = new Timer(1000);
			soundTimer = new Timer(1);

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
		public function startTimer():void {
			gameTimer.addEventListener(TimerEvent.TIMER, gameTimeHandler);
			gameTimer.start();
		}
		public function gameTimeHandler(e:TimerEvent):void {
			GameVariables.time++;
		}
		public static function BGMTimeHandler(e:Event):void {
			if (int(GameVariables.bgmChannel.position) >= end) {
				stopBGM();
				playBGM(BGM, true);
			}
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
		public static function playBGM(BGM:String, loop:Boolean = false):void {
			GameClient.BGM = BGM;
			stopBGM();
			var snd = BGMDatabase.getBGM(BGM);
			if(loop){
				GameVariables.bgmChannel = snd.play(BGMDatabase.getLoop(BGM), 9999);
			}
			else {
				GameVariables.bgmChannel = snd.play(BGMDatabase.getOffset(BGM), 9999);
			}
			GameClient.end = BGMDatabase.getEnd(BGM);
			soundTimer.addEventListener(TimerEvent.TIMER, BGMTimeHandler);
			soundTimer.start();
		}
		public static function stopBGM():void {
			GameVariables.bgmChannel.stop();
			soundTimer.removeEventListener(TimerEvent.TIMER, BGMTimeHandler);
			soundTimer.stop();
		}
	}
}