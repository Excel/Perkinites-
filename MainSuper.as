import flash.events.Event;
import flash.display.Stage;

//clean this class up more eventually...

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

var tileWidth=32;
var tileHeight=32;

var lostFocusScreen;
var titleScreen;
var gameClient=new GameClient(stage,tileWidth,tileHeight);
gameClient.addEventListener(GameDataEvent.DATA_LOADED, initialize);
stage.addEventListener(GameDataEvent.MAP_ON, showMap);
stage.addEventListener(GameDataEvent.CHANGE_MAP, changeMap);


var cheatCode="";

function initialize(e:GameDataEvent):void {
	lostFocusScreen = new LostFocusScreen();
	titleScreen=new TitleScreen(stage);
	Unit.currentUnit=new Unit(-1);
	Unit.partnerUnit=new Unit(-1);
	GameVariables.stageRef=stage;
	stage.stageFocusRect=false;

	stage.addEventListener(Event.DEACTIVATE, onLostFocus);
	
	stage.addEventListener(MouseEvent.MOUSE_WHEEL,cancelActionHandler);
	stage.addEventListener(KeyboardEvent.KEY_UP, cheatCodeHandler);
}

function showMap(e:GameDataEvent):void {
	gameClient.showMap();
}

function changeMap(e:GameDataEvent):void{
	gameClient.changeMap();
}


function onLostFocus(e) {
	stage.addChild(lostFocusScreen);
	GameUnit.superPause=true;
	lostFocusScreen.addEventListener(MouseEvent.CLICK, onFocusRegain);
}
function onFocusRegain(e) {
	stage.removeChild(lostFocusScreen);
	GameUnit.superPause=false;
	lostFocusScreen.removeEventListener(MouseEvent.CLICK, onFocusRegain);
}


function cancelActionHandler(e) {

}

function cheatCodeHandler(e) {
	switch (e.keyCode) {
		case "1".charCodeAt(0) :
			cheatCode+="1";
			break;
		case "2".charCodeAt(0) :
			cheatCode+="2";
			break;
		case "3".charCodeAt(0) :
			cheatCode+="3";
			break;
		case "4".charCodeAt(0) :
			cheatCode+="4";
			break;
		case "5".charCodeAt(0) :
			cheatCode+="5";
			break;
		case "6".charCodeAt(0) :
			cheatCode+="6";
			break;
		case "7".charCodeAt(0) :
			cheatCode+="7";
			break;
		case "8".charCodeAt(0) :
			cheatCode+="8";
			break;
		case "9".charCodeAt(0) :
			cheatCode+="9";
			break;
		case "0".charCodeAt(0) :
			cheatCode+="0";
			break;
		case 20 ://Backspace
			var display=CheatCodeDatabase.useCheatCode(cheatCode);
			if (display!=null) {
				var ccDisplay=new CheatCodeDisplay(display);
				stage.addChild(ccDisplay);
			}
			cheatCode="";
			break;
	}

}