import flash.events.Event;
import flash.display.Stage;

import actors.*;
import attacks.*;
import enemies.*;
import game.*;
import icons.*;
import levels.*;
import ui.*;
import ui.screens.*;
import util.*;

//Screens

var titleScreen = new TitleScreen();
var lostFocusScreen = new LostFocusScreen();
var level=new Level1B();
stage.addChild(level);

stage.addChild(titleScreen);
var Z_KEY="Z".charCodeAt(0);
var X_KEY="X".charCodeAt(0);
var C_KEY="C".charCodeAt(0);

var cheatCode="";

var WIDTH=640;
var HEIGHT=480;
var count=0;
KeyDown.init(stage);


Unit.currentUnit=new Unit(0);
Unit.partnerUnit=new Unit(0);
var guide = new Guide();
stage.addEventListener(Event.ENTER_FRAME, countHandler);
stage.addEventListener(Event.ENTER_FRAME,setUp);
stage.addEventListener(MouseEvent.MOUSE_DOWN, moveHandler);

stage.addEventListener(MouseEvent.MOUSE_WHEEL,cancelActionHandler);
stage.addEventListener(KeyboardEvent.KEY_UP, cheatCodeHandler);

stage.addEventListener(Event.DEACTIVATE, onLostFocus);
function countHandler(e) {
	count++;
	/*guide.x=Unit.currentUnit.x-ScreenRect.getX();
	guide.y=Unit.currentUnit.y-ScreenRect.getY();
	var q = Math.sqrt( 
	Math.pow(guide.x - this.parent.mouseX, 2) + 
	Math.pow(guide.y - this.parent.mouseY, 2));
	var radian=Math.atan2(this.parent.mouseY-guide.y,this.parent.mouseX-guide.x);
	var degree = Math.round((radian*180/Math.PI));
	guide.width = q * Math.cos(radian);
	guide.height = q * Math.sin(radian);
	guide.rotation=degree;
	*/
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
	count++;
	Unit.currentUnit.mxpos=this.parent.mouseX+ScreenRect.getX();
	Unit.currentUnit.mypos=this.parent.mouseY+ScreenRect.getY();

	Unit.partnerUnit.mxpos=this.parent.mouseX+ScreenRect.getX();//+Math.floor(Math.random()*64-32);
	Unit.partnerUnit.mypos=this.parent.mouseY+ScreenRect.getY()+Math.floor(Math.random()*64-32);
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

uHUD.visible=false;
eHUD.visible=false;
friendshipBar.visible=false;

//var stageSelect=new StageSelect(1,stage);
//Hide objects

roundDisplay.visible=false;

function setUp(e) {
	if (ActionConstants.startLevel) {
		transition.alpha=1;
		transition.visible=false;


		stage.addChild(SuperLevel.mapClip);

		ScreenRect.createScreenRect(new Array(SuperLevel.mapClip),640,480);
		level.mapSetup();


		stage.addChild(uHUD);
		stage.addChild(eHUD);
		stage.addChild(friendshipBar);

		Mouse.hide();
		stage.addChild(new Cursor());
		guide = new Guide();
		stage.addChild(guide);

		uHUD.visible=true;
		eHUD.visible=true;
		friendshipBar.visible=true;
		stage.removeEventListener(Event.ENTER_FRAME,setUp);
	}

}