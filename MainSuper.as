import flash.events.Event;
import flash.display.Stage;

import abilities.*;
import actors.*;
import attacks.*;
import enemies.*;
import game.*;
import levels.*;
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
//ItemDatabase.loadData();

stage.stageFocusRect=false;

//var cursor = new Cursor(stage);
var lostFocusScreen = new LostFocusScreen();
//var level=new Level1B();
//stage.addChild(level);
var titleScreen=new TitleScreen(stage);

var mouseIsDown = false;
var FPS=new FPSDisplay(stage,0,0);
var Z_KEY="Z".charCodeAt(0);
var X_KEY="X".charCodeAt(0);
var C_KEY="C".charCodeAt(0);

var cheatCode="";

var WIDTH=640;
var HEIGHT=480;
var count=0;
KeyDown.init(stage);


Unit.currentUnit=new Unit(-1);
Unit.partnerUnit=new Unit(-1);
stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
stage.addEventListener(Event.ENTER_FRAME, countHandler);
stage.addEventListener(Event.ENTER_FRAME,setUp);

stage.addEventListener(MouseEvent.MOUSE_WHEEL,cancelActionHandler);
stage.addEventListener(KeyboardEvent.KEY_UP, cheatCodeHandler);

stage.addEventListener(Event.DEACTIVATE, onLostFocus);
function countHandler(e) {


}

function mouseDownHandler(e){
	mouseIsDown = true;
}
function mouseUpHandler(e){
	mouseIsDown = false;
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
	if (! GameUnit.superPause&&! GameUnit.menuPause && mouseIsDown) {
		Unit.currentUnit.mxpos=this.parent.mouseX+ScreenRect.getX();
		Unit.currentUnit.mypos=this.parent.mouseY+ScreenRect.getY();

		Unit.partnerUnit.mxpos=this.parent.mouseX+ScreenRect.getX();//+Math.floor(Math.random()*64-32);
		Unit.partnerUnit.mypos=this.parent.mouseY+ScreenRect.getY();/*+Math.floor(Math.random()*64-32);
		Unit.currentUnit.teleportToCoord(Unit.currentUnit.mxpos, Unit.currentUnit.mypos);
		Unit.partnerUnit.teleportToCoord(Unit.partnerUnit.mxpos, Unit.partnerUnit.mypos);
		Unit.currentUnit.mover(Unit.currentUnit.mxpos, Unit.currentUnit.mypos);
		Unit.partnerUnit.mover(Unit.partnerUnit.mxpos, Unit.partnerUnit.mypos);*/
		//trace(TileMap.getTile(Unit.currentUnit.mxpos, Unit.currentUnit.mypos));
		Unit.path = TileMap.findPath(TileMap.map, new Point(Math.floor(Unit.currentUnit.x/32), Math.floor(Unit.currentUnit.y/32)),
		  new Point(Math.floor(Unit.currentUnit.mxpos/32), Math.floor(Unit.currentUnit.mypos/32)), 
		  true, true);
		if (Unit.path.length==0) {
			Unit.currentUnit.mxpos=Unit.currentUnit.x;
			Unit.currentUnit.mypos=Unit.currentUnit.y;
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

//var stageSelect=new StageSelect(1,stage);
//Hide objects

roundDisplay.visible=false;

function setUp(e) {
	if (GameVariables.startLevel) {
		transition.alpha=1;
		transition.visible=false;

		LevelManager.stageRef=stage;
		LevelManager.loadLevel();
		stage.addEventListener(Event.ENTER_FRAME, moveHandler);
		//stage.addChild(SuperLevel.mapClip);

		//ScreenRect.createScreenRect(new Array(SuperLevel.mapClip),640,480);
		//level.mapSetup();


		HUDManager.setup(stage);
		HUDManager.toggleUnitHUD(true);
		HUDManager.toggleEnemyHUD(true);


		stage.removeEventListener(Event.ENTER_FRAME,setUp);
	}

}