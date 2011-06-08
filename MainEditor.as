import util.*;
import tileMapper.*;

var shortCuts = "1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ";

//----------------TILES-----------------
var editorTiles = new Array("Water", "Impassable", "One-way", "Passable",
							"Invisible", "Locked Door");
var editorTiles2 = new Array("f", "f", "f", "f", "f", "f");
var clings = new Array(false, false, false, false, false, false, false, false, false, false, false, false);
//---------------ENEMIES-------------
var editorETypes = new Array("Chip", "Key", "Goal", "Swimming Fish", "Up-Down Spike", "Shark", "Skeleton", 
							 "Jellyfish", "Blowfish", "Hot Volcano", "Volcano", "Delete Enemy");
//---------------DOODADS----------------
var editorDTypes = new Array("Clamshell", "Grass", "Coral Tree");
TileMap.createTileMap(editorCode, 20, editorTiles2, clings, "com.EditorTile");

var editorClip = new MovieClip();
TileMap.addTiles(editorClip);
addChild(editorClip);

editorClip.addChild(sMarker);

ScreenRect.createScreenRect(new Array(editorClip), STAGE_WIDTH, STAGE_HEIGHT);
addEventListener(Event.ENTER_FRAME, editorHandler);
addEventListener(MouseEvent.MOUSE_UP, clickHandler);
stage.addEventListener(KeyboardEvent.KEY_DOWN, keyHandler);
savebtn.addEventListener(MouseEvent.CLICK, saveHandler);
//testbtn.addEventListener(MouseEvent.CLICK, testHandler);
custommenubtn.addEventListener(MouseEvent.CLICK, customReturnHandler);

var buildType = 0;
var selectType = -1;
var rowBtns = new Array();
var typeBtns = new Array(4);
for(var a = 0; a < 4; a++)
	typeBtns[a] = new Array();

for(a = 0; a < ROWS; a++){
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
for(a in editorTiles){
	createTypeButton(0, STAGE_WIDTH + 100, 25 * a + YCOORD, a, shortCuts.charAt(a) + " - " + editorTiles[a]);
}
for(a in editorETypes){
	createTypeButton(1, STAGE_WIDTH + 100, 25 * (a /*+ editorTiles.length*/) + /*45*/ YCOORD,
					 a + editorTiles.length,
					 shortCuts.charAt(a + editorTiles.length) + " - " + editorETypes[a]);
}
for(a in editorDTypes){
	createTypeButton(2, STAGE_WIDTH + 100, 25 * (a /*+ editorTiles.length*/) + /*45*/ YCOORD,
					 a + editorTiles.length + editorETypes.length,
					 shortCuts.charAt(a + editorTiles.length + editorETypes.length) + " - " + editorDTypes[a]);
}
createTypeButton(3, STAGE_WIDTH - 85, 70, -2, "Start Point");

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
	var xp = Math.floor((mouseX + ScreenRect.getX()) / 20);
	var yp = Math.floor((mouseY + ScreenRect.getY()) / 20);
	if(xp < 0 || yp < 0 || xp >= COLS || yp >= ROWS)
		return;
	
	if(buildType == -2){
		//start point
		sMarker.x = xp * 20;
		sMarker.y = yp * 20;
		return;
	}
	
	if(buildType >= editorTiles.length && buildType < editorTiles.length + editorETypes.length - 1){
		//enemies
		var EnemyClass = getDefinitionByName("EnemyMarker" + (buildType - editorTiles.length));
		var e = new EnemyClass();
		e.x = xp * 20;
		e.y = yp * 20;
		e.id = buildType - editorTiles.length;
		editorEnemies.push(e);
		editorClip.addChild(e);
		return;
	}
	if(buildType == editorTiles.length + editorETypes.length - 1){
		//delete enemy
		for(var a = 0; a < editorEnemies.length; a++){
			e = editorEnemies[a];
			var ex = e.x / 20;
			var ey = e.y / 20;
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
function editorHandler(e){
	ScreenRect.easeScreen(new Point((mouseX / STAGE_WIDTH) * (COLS * 20) - STAGE_WIDTH / 2, (mouseY / STAGE_HEIGHT) * (ROWS * 20) - STAGE_HEIGHT / 2));
	
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
		var ind = editorCode.lastIndexOf(":") + a * ROWS + col + 1;
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
		
		if(r.rotation == 0)
			r.removeEventListener(MouseEvent.MOUSE_UP, changeHandler);
		else
			r.removeEventListener(MouseEvent.MOUSE_UP, colChangeHandler);
		
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
	
	removeChild(this.editorClip);
	
	removeEventListener(Event.ENTER_FRAME, editorHandler);
	removeEventListener(MouseEvent.MOUSE_UP, clickHandler);
	stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyHandler);
	this.savebtn.removeEventListener(MouseEvent.CLICK, saveHandler);
	this.custommenubtn.removeEventListener(MouseEvent.CLICK, customReturnHandler);
}
function saveHandler(e){
	var sx = (sMarker.x) / 20;
	var sy = (sMarker.y) / 20;
	
	var enemyCode = "";
	for(var a = 0; a < editorEnemies.length; a++){
		var e = editorEnemies[a];
		var ex = e.x / 20;
		var ey = e.y / 20;
		enemyCode += ";" + e.id + "," + ex + "," + ey;
	}
	
	var ind = Math.min(editorCode.indexOf(";"), editorCode.indexOf("("));
	if(ind != -1)
		editorCode = editorCode.substring(0, ind);
	
	var allCode = editorCode + enemyCode + "(" + sx + "," + sy + ")";
	savedLevels[editingNum] = allCode;
	sObj.data.savedLevels = savedLevels;
	sObj.flush();
}
function customReturnHandler(e){
	clearEditor();
	gotoAndStop(1);
}