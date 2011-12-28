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

var current;

optionsList.visible = false;
inputList.visible = false;
optionsList.exit.addEventListener(MouseEvent.CLICK, exitOptionsList);

var cond = new MovieClip();
var comd = new MovieClip();

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
	if(cond.parent == this){
		removeChild(cond);
	}
	cond = new MovieClip();
	addChild(cond);
	cond.mask=condmask;
	cond.addChild(editorClip);
	
	for(var i = 0; i < conditionsArray.length; i++){
		var conditional = new ConditionOption();
		conditional.command.text = conditionsArray[i].name();
		conditional.command2.text = conditionsArray[i];
		cond.addChild(conditional);
		conditional.x = 55.05;
		conditional.y = 275.15+i*13;
		conditional.i = i;
		
		conditional.command.addEventListener(MouseEvent.CLICK, insertConditionHandler);
		conditional.command2.addEventListener(MouseEvent.CLICK, editConditionHandler);
	}
}
function setupCommands(){
	if(comd.parent == this){
		removeChild(comd);
	}
	comd = new MovieClip();
	addChild(comd);
	comd.mask=comdmask;
	comd.addChild(editorClip);
	
	for(var i = 0; i < commandsArray.length; i++){
		var com = new CommandOption();
		com.command.text = commandsArray[i].name();
		com.command2.text = commandsArray[i];
		comd.addChild(com);
		com.x = 230;
		com.y = 131+i*13;
		com.i = i;
		
		com.command.addEventListener(MouseEvent.CLICK, insertCommandHandler);
		com.command2.addEventListener(MouseEvent.CLICK, editCommandHandler);
	}
}
function saveObjectHandler(e){
	var object = eventArray[objectID];
	object.graphic = flashclassbox.text;
	object.dir = directionbox.text;
	
	object.conditions = new Array();
	for(var i = 0; i < conditionsArray.length; i++){
		object.conditions.push(conditionsArray[i]);
	}

	object.movement = movementbox.text;
	object.speed = speedbox.text;
	object.wait = waitbox.text;
	object.moveWait = object.wait; //differentiate and fix
	
	object.xTile = xbox.text;
	object.yTile = ybox.text;
	
	object.aTrigger = triggerbox.text;
	object.range = rangebox.text;
	
	object.commands = new Array();
	for(i = 0; i < commandsArray.length; i++){
		object.commands.push(commandsArray[i]);
	}
	/*object.graphic = flashClass;
	object.dir = dir;
	
	object.conditions = new Array();
	for(var i = 0; i < conditionsArray.length; i++){
		object.conditions.push(conditionsArray[i]);
	}

	object.movement = objectMove;
	object.speed = objectSpeed;
	object.wait = objectWait;
	object.moveWait = object.wait; //differentiate and fix
	
	object.xTile = objectX;
	object.yTile = objectY;
	
	object.aTrigger = objectTrigger;
	object.range = objectRange;
	
	object.commands = new Array();
	for(i = 0; i < commandsArray.length; i++){
		object.commands.push(commandsArray[i]);
	}*/
	
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
		availableOptions[i].addEventListener(MouseEvent.CLICK, addConditionHandler);  
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
		availableOptions[i].addEventListener(MouseEvent.CLICK, addCommandHandler); 
		availableOptions[i].text = availableCommands[i];
	}	
}
function editConditionHandler(e){
	current = e.target.parent.i;
	inputList.visible = true;
	inputList.updateInputs(e.target.parent.command.text, e.target.text);

	inputList.okayButton.addEventListener(MouseEvent.CLICK, exitInputList);
	inputList.cancelButton.addEventListener(MouseEvent.CLICK, exitOptionsList);
	inputList.deleteButton.visible = true;
	inputList.deleteButton.addEventListener(MouseEvent.CLICK, deleteCondition);
}
function editCommandHandler(e){
	current = e.target.parent.i;
	inputList.visible = true;
	inputList.updateInputs(e.target.parent.command.text, e.target.text);
	
	inputList.okayButton.addEventListener(MouseEvent.CLICK, exitInputList);
	inputList.cancelButton.addEventListener(MouseEvent.CLICK, exitOptionsList);
	inputList.deleteButton.visible = true;
	inputList.deleteButton.addEventListener(MouseEvent.CLICK, deleteCommand);
}
function addConditionHandler(e){
	inputList.visible = true;
	inputList.updateInputs(e.target.text, "");

	inputList.okayButton.addEventListener(MouseEvent.CLICK, exitInputList);
	inputList.cancelButton.addEventListener(MouseEvent.CLICK, exitOptionsList);
	inputList.deleteButton.visible = false;
}
function addCommandHandler(e){
	inputList.visible = true;
	inputList.updateInputs(e.target.text, "");
	
	inputList.okayButton.addEventListener(MouseEvent.CLICK, exitInputList);
	inputList.cancelButton.addEventListener(MouseEvent.CLICK, exitOptionsList);
	inputList.deleteButton.visible = false;
}
function exitInputList(e){
	inputList.turnOff();
	inputList.visible = false;
}
function exitOptionsList(e){
	inputList.turnOff();
	for(var i = 0; i < availableOptions.length; i++){
		availableOptions[i].visible = false;
		availableOptions[i].removeEventListener(MouseEvent.CLICK, exitOptionsList);
	}
	optionsList.visible = false;
	inputList.visible = false;
	insert = false;	
}
function deleteCondition(e){
	conditionsArray.splice(current, 1);
	setupConditions();
	
	inputList.turnOff();
	for(var i = 0; i < availableOptions.length; i++){
		availableOptions[i].visible = false;
		availableOptions[i].removeEventListener(MouseEvent.CLICK, exitOptionsList);
	}
	optionsList.visible = false;
	inputList.visible = false;
	insert = false;	
}
function deleteCommand(e){
	commandsArray.splice(current, 1);
	setupCommands();
	inputList.turnOff();
	for(var i = 0; i < availableOptions.length; i++){
		availableOptions[i].visible = false;
		availableOptions[i].removeEventListener(MouseEvent.CLICK, exitOptionsList);
	}
	optionsList.visible = false;
	inputList.visible = false;
	insert = false;	
}
function exitHandler(e){
	removeChild(cond);
	removeChild(comd);
	gotoAndStop("editor");
}