import util.*;
import tileMapper.*;

import maps.MapDataEvent;
import flash.display.MovieClip;

var availableOptions = new Array(optionsList.command0, optionsList.command1, optionsList.command2, optionsList.command3,
								 optionsList.command4, optionsList.command5, optionsList.command6, optionsList.command7,
								 optionsList.command8, optionsList.command9, optionsList.command10, optionsList.command11,
								 optionsList.command12, optionsList.command13, optionsList.command14, optionsList.command15,
								 optionsList.command16,  optionsList.command17, optionsList.command18);
var availableConditions = new Array("Unit", "Switch", "Variable");
var availableCommands = new Array("Message", "Choices",	"Wait",	"Conditional",
								  "EraseObject", "JumpTo", "Switch", "Variable",
								  "ChangeFlexPoints", "ChangeStat",	"GetPrize", "Teleport",
								  "ChangeObjectPosition", "ScrollMap",	"PlayBGM",	"StopBGM",
								  "Shop", "StartCutscene", "EndCutscene");

optionsList.visible = false;
optionsList.exit.addEventListener(MouseEvent.CLICK, exitOptionsList);
var cond:MovieClip = new MovieClip();
addChild(cond);
cond.mask=condmask;
cond.addChild(editorClip);

var comd:MovieClip = new MovieClip();
addChild(comd);
comd.mask=comdmask;
comd.addChild(editorClip);

var insert = false;

setupObject();
setupConditions();
setupCommands();


saveButton.addEventListener(MouseEvent.CLICK, saveObjectHandler);
exitButton.addEventListener(MouseEvent.CLICK, exitHandler);

function setupObject(){
	objectIDLabel.text = objectID;
	flashclassbox.text = flashClass;
	directionbox.text = dir;
	xbox.text = objectX;
	ybox.text = objectY;

//	conditionsbox.text = conditionsArray = object.conditions;
	
	movementbox.text = objectMove;
	speedbox.text = objectSpeed;
	waitbox.text = objectWait;
	triggerbox.text = objectTrigger;
	rangebox.text = objectRange;
//	commandsArray = object.commands;
}
function setupConditions(){
	for(var i = 0; i < conditionsArray.length; i++){
		var conditional = new ConditionOption();
		conditional.command.text = conditionsArray[i].name();
		conditional.command2.text = conditionsArray[i];
		cond.addChild(conditional);
		conditional.x = 55.05;
		conditional.y = 275.15+i*13;
		
		conditional.command.addEventListener(MouseEvent.CLICK, insertConditionHandler);
		conditional.command2.addEventListener(MouseEvent.CLICK, editConditionHandler);
	}
}
function setupCommands(){
	for(var i = 0; i < commandsArray.length; i++){
		var com = new CommandOption();
		com.command.text = commandsArray[i].name();
		com.command2.text = commandsArray[i];
		comd.addChild(com);
		com.x = 230;
		com.y = 131+i*13;
		
		com.command.addEventListener(MouseEvent.CLICK, insertCommandHandler);
		com.command2.addEventListener(MouseEvent.CLICK, editCommandHandler);
	}
}
function saveObjectHandler(e){
	var object = eventArray[objectID];
	object.graphic = flashClass;
	object.dir = dir;
	
	object.conditions = conditionsArray;
	
	object.movement = objectMove;
	object.speed = objectSpeed;
	object.wait = objectWait;
	object.moveWait = object.wait; //differentiate and fix
	
	object.xTile = objectX;
	object.yTile = objectY;
	
	object.aTrigger = objectTrigger;
	object.range = objectRange;
	
	object.commands = commandsArray;
	
	eventArray[objectID] = object;
}
function insertConditionHandler(e){
	insert = true;
	for(var i = 0; i < availableOptions.length; i++){
		availableOptions[i].visible = false;
	}
	optionsList.visible = true;
	
	for(var i = 0; i < availableConditions.length; i++){
		availableOptions[i].visible = true;
		availableOptions[i].addEventListener(MouseEvent.CLICK, exitOptionsList);  //gotta change this
		availableOptions[i].text = availableConditions[i];
	}
	
}
function insertCommandHandler(e){
	insert = true;
	for(var i = 0; i < availableOptions.length; i++){
		availableOptions[i].visible = false;
	}
	optionsList.visible = true;
	
	for(var i = 0; i < availableCommands.length; i++){
		availableOptions[i].visible = true;
		availableOptions[i].addEventListener(MouseEvent.CLICK, exitOptionsList);  //gotta change this
		availableOptions[i].text = availableCommands[i];
	}	
}
function editConditionHandler(e){
	
}
function editCommandHandler(e){
	
}
function exitOptionsList(e){
	for(var i = 0; i < availableOptions.length; i++){
		availableOptions[i].visible = false;
		availableOptions[i].removeEventListener(MouseEvent.CLICK, exitOptionsList);
	}
	optionsList.visible = false;
	insert = false;	
}
function exitHandler(e){
	removeChild(cond);
	removeChild(comd);
	gotoAndStop("editor");
}