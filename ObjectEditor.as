import util.*;
import tileMapper.*;

import maps.MapDataEvent;
import flash.display.MovieClip;

saveButton.addEventListener(MouseEvent.CLICK, saveObjectHandler);
exitButton.addEventListener(MouseEvent.CLICK, exitHandler);


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
function exitHandler(e){
	gotoAndStop("editor");
}