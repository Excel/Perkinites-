import flash.events.Event;
import flash.display.Stage;

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

//Screens

//Load all XML Data
//Loading abilities must go first. :(
AbilityDatabase.loadData();
ActorDatabase.loadData();
//EnemyDatabase.loadData();

GameVariables.stageRef = stage;
stage.stageFocusRect=false;

//var cursor = new Cursor(stage);
var lostFocusScreen = new LostFocusScreen();
var titleScreen=new TitleScreen(stage);

var mouseIsDown=false;
var FPS=new FPSDisplay(stage,0,0);

var cheatCode="";

var WIDTH=640;
var HEIGHT=480;
var count=0;
KeyDown.init(stage);


Unit.currentUnit=new Unit(-1);
Unit.partnerUnit=new Unit(-1);
stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
stage.addEventListener(Event.ENTER_FRAME,setUp);

stage.addEventListener(MouseEvent.MOUSE_WHEEL,cancelActionHandler);
stage.addEventListener(KeyboardEvent.KEY_UP, cheatCodeHandler);

stage.addEventListener(Event.DEACTIVATE, onLostFocus);

function mouseDownHandler(e) {
	mouseIsDown=true;
}
function mouseUpHandler(e) {
	mouseIsDown=false;
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
function moveHandler(e) {
	if (! GameUnit.superPause&&! GameUnit.menuPause&&mouseIsDown) {

		Unit.currentUnit.mxpos=Math.floor( (this.parent.mouseX+ScreenRect.getX())/32)*32 + 16;
		Unit.currentUnit.mypos=Math.floor( (this.parent.mouseY+ScreenRect.getY())/32)*32 + 16;
		Unit.currentUnit.range=0;
		Unit.currentUnit.path = TileMap.findPath(TileMap.map, new Point(Math.floor(Unit.currentUnit.x/32), Math.floor(Unit.currentUnit.y/32)),
		  new Point(Math.floor(Unit.currentUnit.mxpos/32), Math.floor(Unit.currentUnit.mypos/32)), 
		  false, true);
		Unit.currentUnit.path=Unit.currentUnit.smoothPath();

		if (Unit.currentUnit.path.length==0) {
			Unit.currentUnit.mxpos=Unit.currentUnit.x;
			Unit.currentUnit.mypos=Unit.currentUnit.y;

		}

		Unit.partnerUnit.mxpos=Math.floor((this.parent.mouseX+ScreenRect.getX())/32)*32 + 16;//+Math.floor(Math.random()*64-32);
		Unit.partnerUnit.mypos=Math.floor((this.parent.mouseY+ScreenRect.getY())/32)*32 + 16;//+Math.floor(Math.random()*64-32);

		Unit.partnerUnit.range=0;
		
		Unit.partnerUnit.path = TileMap.findPath(TileMap.map, new Point(Math.floor(Unit.partnerUnit.x/32), Math.floor(Unit.partnerUnit.y/32)),
		  new Point(Math.floor(Unit.partnerUnit.mxpos/32), Math.floor(Unit.partnerUnit.mypos/32)), 
		  false, true);
		Unit.partnerUnit.path=Unit.partnerUnit.smoothPath();

		if (Unit.partnerUnit.path.length==0) {
			Unit.partnerUnit.mxpos=Unit.partnerUnit.x;
			Unit.partnerUnit.mypos=Unit.partnerUnit.y;
		}


	}
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

function setUp(e) {
	if (GameVariables.startLevel) {
		MapManager.stageRef=stage;
		MapManager.loadMap(1);
		stage.addEventListener(Event.ENTER_FRAME, moveHandler);

		HUDManager.setup(stage);
		HUDManager.toggleUnitHUD(true);
		HUDManager.toggleEnemyHUD(false);

		stage.removeEventListener(Event.ENTER_FRAME,setUp);
	}

}