import util.*;
import tileMapper.*;

import flash.xml.XMLDocument;
import flash.geom.Point;

var shortCuts = "1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ";

//----------------TILES-----------------
var editorTiles = new Array("Water", "Impassable", "One-way", "Passable",
							"Invisible", "Locked Door");
var editorTiles2 = new Array("f", "f", "f", "f", "f", "f");
var clings = new Array(false, false, false, false, false, false, false, false, false, false, false, false);
//---------------ENEMIES-------------
var editorETypes = new Array();//new Array("Chip", "Key", "Goal", "Swimming Fish", "Up-Down Spike", "Shark", "Skeleton", 
							 //"Jellyfish", "Blowfish", "Hot Volcano", "Volcano", "Delete Enemy");
//---------------DOODADS----------------
var editorDTypes = new Array();//new Array("Clamshell", "Grass", "Coral Tree");

//objectEditor.visible = false;
var changedTiles = new Array();
var mouseIsDown = false;

drawModeBox.text = drawMode;
editModeBox.text = editMode;
var point1 = new Point(-1, -1);

var editorClip = new MovieClip();
TileMap.createTileMap(editorCode, 32, editorTiles2, clings, "com.EditorTile");
trace(editorCode);

tilesetbox2.text = tilesetID;
rowsbox2.text = ROWS;
colsbox2.text = COLS;
namebox2.text = mapName;
BGMbox2.text = BGM;
BGSbox2.text = BGS; 
editorClip.x = 245;
editorClip.y = 115;
editorClip.scaleX = 0.5;
editorClip.scaleY = 0.5;
TileMap.addTiles(editorClip);
//addChild(editorClip);

var cont2:MovieClip = new MovieClip();
addChild(cont2);
cont2.mask=mapmask;
cont2.addChild(editorClip);

editorClip.addChild(sMarker);

//ScreenRect.createScreenRect(new Array(editorClip), STAGE_WIDTH, STAGE_HEIGHT);
addEventListener(Event.ENTER_FRAME, editorHandler);
addEventListener(Event.ENTER_FRAME, clickHandler);
addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
editorClip.addEventListener(MouseEvent.MOUSE_UP, clickHandler);
stage.addEventListener(KeyboardEvent.KEY_DOWN, keyHandler);
savebtn.addEventListener(MouseEvent.CLICK, saveHandler);
saveObjectsbtn.addEventListener(MouseEvent.CLICK, saveMapObjects);
custommenubtn.addEventListener(MouseEvent.CLICK, customReturnHandler);
btnmodify.addEventListener(MouseEvent.CLICK, modify);

addEventListener(Event.ENTER_FRAME, mapScroller);
resume();
function resume(){
pencilbutton.gotoAndStop(1);
rectbutton.gotoAndStop(1);
fillbutton.gotoAndStop(1);
selectbutton.gotoAndStop(1);
pencilbutton.drawMode = "Pencil";
rectbutton.drawMode = "Rect";
fillbutton.drawMode = "Fill";
pencilbutton.mouseChildren = false;
rectbutton.mouseChildren = false;
fillbutton.mouseChildren = false;
selectbutton.mouseChildren = false;
pencilbutton.addEventListener(MouseEvent.CLICK, setMode);
rectbutton.addEventListener(MouseEvent.CLICK, setMode);
fillbutton.addEventListener(MouseEvent.CLICK, setMode);

if(drawMode == "Pencil"){
	pencilbutton.gotoAndStop(2);
}
else if (drawMode == "Rect"){
	rectbutton.gotoAndStop(2);
}
else if(drawMode == "Fill"){
	fillbutton.gotoAndStop(2);
}
l1button.gotoAndStop(1);
l2button.gotoAndStop(1);
l3button.gotoAndStop(1);
mapobjectbutton.gotoAndStop(1);
l1button.mouseChildren = false;
l2button.mouseChildren = false;
l3button.mouseChildren = false;
mapobjectbutton.mouseChildren = false;
l1button.editMode = "Layer 1";
l2button.editMode = "Layer 2";
l3button.editMode = "Layer 3";
mapobjectbutton.editMode = "Map Object";
l1button.addEventListener(MouseEvent.CLICK, setEdit);
l2button.addEventListener(MouseEvent.CLICK, setEdit);
l3button.addEventListener(MouseEvent.CLICK, setEdit);
mapobjectbutton.addEventListener(MouseEvent.CLICK, setEdit);

if(editMode == "Layer 1"){
	l1button.gotoAndStop(2);
}
else if (editMode == "Layer 2"){
	l2button.gotoAndStop(2);
}
else if (editMode == "Layer 3"){
	l3button.gotoAndStop(2);
}
else if(editMode == "Map Object"){
	mapobjectbutton.gotoAndStop(2);
}
	if(editMode == "Map Object"){
		for(var i = 0;i < eventArray.length; i++){
			editorClip.addChild(eventArray[i]);
			eventArray[i].x=eventArray[i].xTile*32+16;
			eventArray[i].y=eventArray[i].yTile*32+16;
			eventArray[i].addEventListener(MouseEvent.CLICK, openObjectEditor);
		}
	}


mag1.magnifier.text = "1x";
mag15.magnifier.text = "1.5x";
mag2.magnifier.text = "2x";
mag1.mouseChildren = false;
mag15.mouseChildren = false;
mag2.mouseChildren = false;
mag1.addEventListener(MouseEvent.CLICK, changeZoom);
mag15.addEventListener(MouseEvent.CLICK, changeZoom);
mag2.addEventListener(MouseEvent.CLICK, changeZoom);

mag1.gotoAndStop(1);
mag15.gotoAndStop(1);
mag2.gotoAndStop(1);
	if(mag == 0.5){
		mag1.gotoAndStop(2);
	}
	else if(mag == 0.75){
		mag15.gotoAndStop(2);
	}
	else if(mag == 1){
		mag2.gotoAndStop(2);
	}
	editorClip.scaleX = mag;
	editorClip.scaleY = mag;	
	
	cont2.x = contX;
	cont2.y = contY;
}
function changeZoom(e){
	if(e.target.magnifier.text == "1x"){
		mag = 0.5;
	} else if (e.target.magnifier.text == "1.5x"){
		mag = 0.75;
	} else if (e.target.magnifier.text == "2x"){
		mag = 1;
	}
	editorClip.scaleX = mag;
	editorClip.scaleY = mag;				
	mag1.gotoAndStop(1);
	mag15.gotoAndStop(1);
	mag2.gotoAndStop(1);
	e.target.gotoAndStop(2);
}


function setMode(e){
	drawMode = e.target.drawMode;
	drawModeBox.text = drawMode;
	if(drawMode == "Rect"){
		point1 = new Point(-1, -1);
	}
	pencilbutton.gotoAndStop(1);
	rectbutton.gotoAndStop(1);
	fillbutton.gotoAndStop(1);
	e.target.gotoAndStop(2);
}

function setEdit(e){
	var i;

	l1button.gotoAndStop(1);
	l2button.gotoAndStop(1);
	l3button.gotoAndStop(1);
	mapobjectbutton.gotoAndStop(1);
	e.target.gotoAndStop(2);
	
	if(e.target.editMode == "Map Object" && editMode != "Map Object"){
		for(i = 0;i < eventArray.length; i++){
			editorClip.addChild(eventArray[i]);
			eventArray[i].x=eventArray[i].xTile*32+16;
			eventArray[i].y=eventArray[i].yTile*32+16;
			eventArray[i].addEventListener(MouseEvent.CLICK, openObjectEditor);
		}
	}
	else if(editMode == "Map Object" && e.target.editMode != "Map Object"){
		for(i = 0;i < eventArray.length; i++){
			editorClip.removeChild(eventArray[i]);
		}
	}
	editMode= e.target.editMode;
	editModeBox.text = editMode;

}


function mouseDownHandler(e){
	mouseIsDown = true;
}
function mouseUpHandler(e){
	mouseIsDown = false;
}

function openObjectEditor(e){
	clearEditor();
	var objectID = eventArray.indexOf(e.target);
/*	var flashClass = "";
	var dir = 2;
	var objectX = 0;
	var objectY = 0;
	var conditionsArray = new Array();
	var objectMove = "None";
	var objectSpeed = 0;
	var objectWait = 0;
	var objectTrigger = "None";
	var objectRange = 0;
	var commandsArray = new Array();*/
	
	for(var i = 0; i < eventArray.length; i++){
		editorClip.removeChild(eventArray[i]);
	}
	
	contX = cont2.x;
	contY = cont2.y;
	gotoAndStop("object_editor");
}

function mapScroller(e) {
	if (mouseX<245+480 && mouseX> 245 && mouseY>115 && mouseY < 115+480) {
		if (mouseY<115+32) {
			cont2.y += 32;//(115+32 - mouseY) / 2;
		}
		if (mouseY>115+480-32) {
			cont2.y -= 32;//(mouseY - (115+480-32)) / 2;
		}
		if (mouseX<245+32) {
			cont2.x += 32;//(245+32 - mouseX) / 2;
		}
		if (mouseX>245+480-32) {
			cont2.x -= 32;//(mouseX - (245+480-32)) / 2;
		}
	}
	if(mag == 0.5){
		cont2.x=Math.min(Math.max(cont2.x,-COLS*16+16*30),0);
		cont2.y=Math.min(Math.max(cont2.y,-ROWS*16+16*30),0);
	} else if (mag == 0.75){
		cont2.x=Math.min(Math.max(cont2.x,-COLS*24+24*20),0);
		cont2.y=Math.min(Math.max(cont2.y,-ROWS*24+24*20),0);
	} else if (mag == 1){
		cont2.x=Math.min(Math.max(cont2.x,-COLS*32+32*15),0);
		cont2.y=Math.min(Math.max(cont2.y,-ROWS*32+32*15),0);
	}
}
function modify(e) {
	var ROWS2 = parseInt(rowsbox2.text); 
	var COLS2 = parseInt(colsbox2.text);
	var dr = ROWS2 - ROWS;
	var dc = COLS2 - COLS;
	
	var count = 0;
	var newCode= "";
	if(dr != 0 || dc != 0){
		newCode = ROWS2 + ":" + COLS2 + ":";
		count = (ROWS+":"+COLS+":").length; 
		for(var r = 0; r < Math.min(ROWS, ROWS2); r++){
			newCode+=editorCode.substring(count, count + Math.min(COLS, COLS2));
			count+=Math.min(COLS, COLS2);

			if(dc < 0){
				editorCode = editorCode.substring(0, count) + editorCode.substring(count+dc*-1, editorCode.length);
			} else if (dc > 0){
				for(var c = 0; c < dc; c++){
					newCode+= "0";
				}
			}
		}
		if(dr > 0){
			for(r = 0; r < dr; r++){
				for(c = 0; c < Math.min(COLS, COLS2); c++){
					newCode+="0";
				}
			}
		}
	
		//trace(editorCode);
		trace(newCode);
		cont2.removeChild(editorClip);
		cont2.mask = mapmask;
		
		TileMap.removeTiles(editorClip);
		var sx = editorClip.scaleX;
		var sy = editorClip.scaleY;
		editorClip = new MovieClip();
		editorClip.x = 245;
		editorClip.y = 115;
		editorClip.scaleX = sx;
		editorClip.scaleY = sy;
		TileMap.createTileMap(newCode, 32, editorTiles2, clings, "com.EditorTile");
		TileMap.addTiles(editorClip);
		cont2.addChild(editorClip);
		editorClip.addChild(sMarker);		
		editorCode = newCode;
	}
	tilesetID = parseInt(tilesetbox2.text);
	ROWS=ROWS2;
	COLS=COLS2;
	mapName=namebox2.text;
	BGM=BGMbox2.text;
	BGS=BGSbox2.text;
}

var tileSize = 32;

var buildType = 0;
var selectType = -1;
var rowBtns = new Array();
var typeBtns = new Array(4);
for(var a = 0; a < 4; a++){
	typeBtns[a] = new Array();
}
for(a in editorEnemies){
	var es = editorEnemies[a];
	var EnemyClass = getDefinitionByName("EnemyMarker" + es.type);
	
	var em = new EnemyClass();
	em.x = es.x * TileMap.TILE_SIZE;
	em.y = es.y * TileMap.TILE_SIZE;
	em.id = es.type;
	em.gotoAndStop(es.type + 1);
	
	editorEnemies[a] = em;
	
	editorClip.addChild(em);
}

function createTypeButton(ind, ox, oy, num, t){
	var w = new walltype();
	w.x = ox;
	w.y = oy;
	w.num = num;
	w.type.text = t;
	
	w.buttonMode = true;
	w.mouseChildren = false;
	w.addEventListener(MouseEvent.CLICK, typeClicked);
	
	addChild(w);
	typeBtns[ind].push(w);
}
function typeClicked(e){
	var t = e.target;
	/*if(t.num >= 10)
		t.num += 6;
	trace(t.num);*/
	buildType = t.num;
}
function clickHandler(e){
	if(editMode == "Map Object"){
		
		
		
	} else{
			if(drawMode == "Pencil"){
		if(mouseIsDown){
				var xp = Math.floor((mouseX + cont2.x*-1 - 245) / (32*mag));
				var yp = Math.floor((mouseY + cont2.y*-1 - 115) / (32*mag));
				if(xp < 0 || yp < 0 || xp >= COLS || yp >= ROWS)
					return;
				
				if(buildType == -2){
					//start point
					sMarker.x = xp * tileSize;
					sMarker.y = yp * tileSize;
					return;
				}
				
				if(buildType >= editorTiles.length && buildType < editorTiles.length + editorETypes.length - 1){
					//enemies
					var EnemyClass = getDefinitionByName("EnemyMarker" + (buildType - editorTiles.length));
					var e = new EnemyClass();
					e.x = xp * tileSize;
					e.y = yp * tileSize;
					e.id = buildType - editorTiles.length;
					editorEnemies.push(e);
					editorClip.addChild(e);
					return;
				}
				if(buildType == editorTiles.length + editorETypes.length - 1){
					//delete enemy
					for(var a = 0; a < editorEnemies.length; a++){
						e = editorEnemies[a];
						var ex = e.x / tileSize;
						var ey = e.y / tileSize;
						if(xp == ex && yp == ey){
							//delete
							editorEnemies.splice(a, 1);
							editorClip.removeChild(e);
							break;
						}
					}
					return;
				}
				if(buildType < 0 || buildType >= editorTiles.length){
					return;
				}
				
				var ind = editorCode.lastIndexOf(":") + xp + yp * COLS + 1;
				editorCode = editorCode.substr(0, ind) + buildType + editorCode.substr(ind + 1, editorCode.length);
				
				TileMap.updateTile(yp, xp, editorCode);
				//editorClip.addChild(new Bitmap(TileMap.theBitmap));		
		}		
	} else if (drawMode == "Rect"){
		if(mouseIsDown){
				var xp = Math.floor((mouseX + cont2.x*-1 - 245) / (32*mag));
				var yp = Math.floor((mouseY + cont2.y*-1 - 115) / (32*mag));
				if(xp < 0 || yp < 0 || xp >= COLS || yp >= ROWS)
					return;

				if(point1.x == -1 && point1.y == -1){
					point1 = new Point(xp, yp);
				} else {
					if(xp != point1.x && yp != point1.y){
						for(var i = Math.min(point1.x, xp); i <= Math.max(point1.x, xp); i++){
							for(var j = Math.min(point1.y, yp); j <= Math.max(point1.y, yp); j++){
								trace(i + " " + j);
								var ind = editorCode.lastIndexOf(":") + i + j * COLS + 1;
								editorCode = editorCode.substr(0, ind) + buildType + editorCode.substr(ind + 1, editorCode.length);
								TileMap.updateTile(j, i, editorCode);
							}
						}
						point1 = new Point(-1, -1);
						drawMode = "Pencil";
						drawModeBox.text = drawMode;
						pencilbutton.gotoAndStop(2);
						rectbutton.gotoAndStop(1);
						fillbutton.gotoAndStop(1);
						return;
					}
				}	

		}		
		
	} else if (drawMode == "Fill"){
		if(mouseIsDown){
				var xp = Math.floor((mouseX + cont2.x*-1 - 245) / (32*mag));
				var yp = Math.floor((mouseY + cont2.y*-1 - 115) / (32*mag));
				if(xp < 0 || yp < 0 || xp >= COLS || yp >= ROWS)
					return;
				
				if(buildType == -2){
					//start point
					sMarker.x = xp * tileSize;
					sMarker.y = yp * tileSize;
					return;
				}
				
				if(buildType >= editorTiles.length && buildType < editorTiles.length + editorETypes.length - 1){
					//enemies
					var EnemyClass = getDefinitionByName("EnemyMarker" + (buildType - editorTiles.length));
					var e = new EnemyClass();
					e.x = xp * tileSize;
					e.y = yp * tileSize;
					e.id = buildType - editorTiles.length;
					editorEnemies.push(e);
					editorClip.addChild(e);
					return;
				}
				if(buildType == editorTiles.length + editorETypes.length - 1){
					//delete enemy
					for(var a = 0; a < editorEnemies.length; a++){
						e = editorEnemies[a];
						var ex = e.x / tileSize;
						var ey = e.y / tileSize;
						if(xp == ex && yp == ey){
							//delete
							editorEnemies.splice(a, 1);
							editorClip.removeChild(e);
							break;
						}
					}
					return;
				}
				if(buildType < 0 || buildType >= editorTiles.length){
					
					return;
				}
				
				var tileValue = TileMap.map[yp][xp];				
				trace(buildType);
				floodFill(tileValue, buildType, yp, xp);
				

			
				for(i = 0; i < changedTiles.length; i++){
					var tile = changedTiles[i];
					//trace(changedTiles[i]);
					var ind = editorCode.lastIndexOf(":") + tile.x + tile.y * COLS + 1;
					editorCode = editorCode.substr(0, ind) + buildType + editorCode.substr(ind + 1, editorCode.length);
				
					TileMap.updateTile(tile.y, tile.x, editorCode);
					
				}
				
				/*for(var r = 0; r < TileMap.ROWS; r++){
					for(var c = 0; c < TileMap.COLS; c++){
						trace("okay");
					}
					trace("\n");
				}*/
				trace(editorCode);
				changedTiles = new Array();
		}				
	}
	}
}

function floodFill(tileValue, buildType, yp, xp){
	if(TileMap.map[yp][xp] != tileValue){
		return;
	}
	
	for(var i = 0; i < changedTiles.length; i++){
		var tile = changedTiles[i];
		if(tile.x == xp && tile.y == yp){
			return;
		}
	}
	
	TileMap.map[yp][xp] = buildType;
	changedTiles.push(new Point(xp, yp));
	
	if(yp - 1 >= 0){
		floodFill(tileValue, buildType, yp-1, xp);
	}
	if(yp + 1 < ROWS){
		floodFill(tileValue, buildType, yp+1, xp);		
	}
	if(xp - 1 >= 0){
		floodFill(tileValue, buildType, yp, xp-1);		
	}
	if (xp + 1 < COLS){
		floodFill(tileValue, buildType, yp, xp+1);		
	}
}

function editorHandler(e){
	//ScreenRect.easeScreen(new Point((mouseX / STAGE_WIDTH) * (COLS * tileSize) - STAGE_WIDTH / 2, (mouseY / STAGE_HEIGHT) * (ROWS * tileSize) - STAGE_HEIGHT / 2));
	
	if(mouseX < STAGE_WIDTH - 150)
		selectType = -1;
	
	for(var a = 0; a < 3; a++){
		var btn = this["btnside" + a];
		if(btn.hitTestPoint(mouseX, mouseY))
			selectType = a;
		
		for(var b = 0; b < typeBtns[a].length; b++){
			var sbtn = typeBtns[a][b];
			if(selectType == a){
				//show them
				if(sbtn.x > STAGE_WIDTH - 85)
					sbtn.x -= 15;
			}
			else{
				//hide them
				if(sbtn.x < STAGE_WIDTH + 100)
					sbtn.x += 15;
			}
		}
	}
}
function changeHandler(e){
	var row = e.target.id;
	
	for(var a = 0; a < COLS; a++){
		var ind = editorCode.lastIndexOf(":") + a + row * COLS + 1;
		editorCode = editorCode.substr(0, ind) + buildType + editorCode.substr(ind + 1, editorCode.length);
		
		TileMap.updateTile(row, a, editorCode);
	}
}
function colChangeHandler(e){
	var col = e.target.id;
	
	for(var a = 0; a < ROWS; a++){
		var ind = editorCode.lastIndexOf(":") + a * COLS + col + 1;
		editorCode = editorCode.substr(0, ind) + buildType + editorCode.substr(ind + 1, editorCode.length);
		
		TileMap.updateTile(a, col, editorCode);
	}
}
function keyHandler(e){
	var num = e.keyCode - 49;
	if(num == -1)
		num += 10;
	if(num > 10)
		num -= 6;
	//10+ = a+
	buildType = num;
}
function clearEditor(){
	for(var a = 0; a < this.rowBtns.length; a++){
		var r = this.rowBtns[a];
		
		if(r.rotation == 0){
			r.removeEventListener(MouseEvent.MOUSE_UP, changeHandler);
		}else{
			r.removeEventListener(MouseEvent.MOUSE_UP, colChangeHandler);
		}
		this.removeChild(r);
	}
	for(var b = 0; b < 3; b++){
		for(a = 0; a < this.typeBtns[b].length; a++){
			r = this.typeBtns[b][a];
			
			r.removeEventListener(MouseEvent.CLICK, typeClicked);
			this.removeChild(r);
		}
	}
	this.rowBtns = new Array();
	this.typeBtns = new Array();
	
	removeChild(cont2);
	
	removeEventListener(Event.ENTER_FRAME, editorHandler);
	removeEventListener(MouseEvent.MOUSE_UP, clickHandler);
	stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyHandler);
	this.savebtn.removeEventListener(MouseEvent.CLICK, saveHandler);
	this.custommenubtn.removeEventListener(MouseEvent.CLICK, customReturnHandler);
	removeEventListener(Event.ENTER_FRAME, mapScroller);	
}
function saveHandler(e){
	var sx = (sMarker.x) / tileSize;
	var sy = (sMarker.y) / tileSize;
	
	var enemyCode = "";
	for(var a = 0; a < editorEnemies.length; a++){
		var e = editorEnemies[a];
		var ex = e.x / tileSize;
		var ey = e.y / tileSize;
		enemyCode += ";" + e.id + "," + ex + "," + ey;
	}
	
	var ind = Math.min(editorCode.indexOf(";"), editorCode.indexOf("("));
	if(ind != -1)
		editorCode = editorCode.substring(0, ind);
	
	var allCode = editorCode + enemyCode + "(" + sx + "," + sy + ")";
	/*savedLevels[editingNum].mapCode = allCode;
	sObj.data.savedLevels = savedLevels;
	sObj.flush();
	
	trace(allCode);*/
	saveMap(allCode);
}

function saveMap(allCode){
	var xml:XML = 
		<Maps>
		</Maps>;
	for(var i = 0; i < savedLevels.length; i++){
		var mapXML:XML;
		if(i == ID){
			mapXML = 
				<Map>
					<ID>{i}</ID>
					<MapCode>{allCode}</MapCode>
					<MapName>{mapName}</MapName>
					<TilesetID>{tilesetID}</TilesetID>
					<BGM>{BGM}</BGM>
					<BGS>{BGS}</BGS>
				</Map>		
		} else{
			mapXML = 
				<Map>
					<ID>{i}</ID>
					<MapCode>{savedLevels[i].mapCode}</MapCode>
					<MapName>{savedLevels[i].mapName}</MapName>
					<TilesetID>{savedLevels[i].tilesetID}</TilesetID>
					<BGM>{savedLevels[i].BGM}</BGM>
					<BGS>{savedLevels[i].BGS}</BGS>
				</Map>
		}
		xml.appendChild(mapXML);
		
	}
	System.setClipboard(xml.toXMLString());

	trace("Saved! Please re-copy the xml string into the xml. :)");
}


//for(a in editorTiles){
//	createTypeButton(0, STAGE_WIDTH + 100, 25 * a + YCOORD, a, shortCuts.charAt(a) + " - " + editorTiles[a]);
//}
//for(a in editorETypes){
//	createTypeButton(1, STAGE_WIDTH + 100, 25 * (a /*+ editorTiles.length*/) + /*45*/ YCOORD,
//					 a + editorTiles.length,
//					 shortCuts.charAt(a + editorTiles.length) + " - " + editorETypes[a]);
//}
//for(a in editorDTypes){
//	createTypeButton(2, STAGE_WIDTH + 100, 25 * (a /*+ editorTiles.length*/) + /*45*/ YCOORD,
//					 a + editorTiles.length + editorETypes.length,
//					 shortCuts.charAt(a + editorTiles.length + editorETypes.length) + " - " + editorDTypes[a]);
//}


/*for(a = 0; a < ROWS; a++){
	var r = new RowChanger();
	r.y = a * 10 + 10;
	r.id = a;
	r.addEventListener(MouseEvent.MOUSE_UP, changeHandler);
	addChild(r);
	rowBtns.push(r);
}
for(a = 0; a < COLS; a++){
	r = new RowChanger();
	r.rotation = 90;
	r.x = a * 10 + 20;
	r.id = a;
	r.addEventListener(MouseEvent.MOUSE_UP, colChangeHandler);
	addChild(r);
	rowBtns.push(r);
}

var YCOORD = 100;

createTypeButton(3, STAGE_WIDTH - 85, 70, -2, "Start Point");*/


function saveMapObjects(e){
	var xml:XML = 
		<Maps>
		</Maps>;
	for(var i = 0; i < savedLevels.length; i++){
		var mapXML:XML;
		if(i == ID){
			mapXML = 
				<Map>
					<ID>{i}</ID>
					<MapCode>111</MapCode>
					<MapName>{mapName}</MapName>
					<TilesetID>{tilesetID}</TilesetID>
					<BGM>{BGM}</BGM>
					<BGS>{BGS}</BGS>
				</Map>		
		} else{
			mapXML = 
				<Map>
					<ID>{i}</ID>
					<MapCode>{savedLevels[i].mapCode}</MapCode>
					<MapName>{savedLevels[i].mapName}</MapName>
					<TilesetID>{savedLevels[i].tilesetID}</TilesetID>
					<BGM>{savedLevels[i].BGM}</BGM>
					<BGS>{savedLevels[i].BGS}</BGS>
				</Map>
		}
		xml.appendChild(mapXML);
		
	}
	System.setClipboard(xml.toXMLString());

	trace("Saved! Please re-copy the xml string into the xml. :)");
	
}
function customReturnHandler(e){
	clearEditor();
	editorMode = false;
	gotoAndStop(1);
}



