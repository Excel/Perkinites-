import com.EnemySetup;
import flash.display.MovieClip;

stop();

var STAGE_WIDTH = 700;
var STAGE_HEIGHT = 500;

var sObj = SharedObject.getLocal("PERKINITESEDITOR");

if(!sObj.data.savedLevels || sObj.data.savedLevels.length == 0) {
	//sObj.data.savedLevels = new Array("20:20:111111111111111111111555555555555555555115555555555555555551155555555444555555511000000000000011111110000000000000000001100000000000000000011000000000000000000110000000000000000001100000000000000000011666000000000000000110070000000000000001166600000000000000011000000000000000000110000000000000000001166660000620002600011000000006600066000110000000066333660001100000000666666600011111111111111111111100000000000000000000;0,12,15;0,12,14;0,12,13;0,2,11;0,1,11;1,7,18;4,19,15;4,19,8;4,1,6;6,1,13;6,13,8;0,3,14;0,4,14;0,2,14;0,2,7;0,2,5;3,5,4;3,5,6;0,7,18;0,6,18;2,17,3;5,11,11(1,18)Charles' Level");
	sObj.data.savedLevels = new Array();
	sObj.data.namedLevels = new Array();
}
var savedLevels = sObj.data.savedLevels;
var namedLevels = sObj.data.namedLevels;
var btnLevels = new Array();
var editingNum:Number = 0;

var cont:MovieClip = new MovieClip();
addChild(cont);
cont.mask = levelmask;

addEventListener(Event.ENTER_FRAME, scroller);
function scroller(e) {
	if (mouseX < 300 && mouseY > 90) {
		if (mouseY < 140) {
			cont.y += (140 - mouseY) / 2;
		}
		if (mouseY > 420) {
			cont.y -= (mouseY - 420) / 2;
		}
	}
	
	cont.y = Math.min(Math.max(cont.y, 570 - savedLevels.length * 60 ), 0);
}

for(a = 0; a < savedLevels.length; a++){
	
	var b = new BtnLevel();
	//465
	b.x = 154;
	b.y = 130 + 60 * a;
	b.id = a;
	b.mapName.text = namedLevels[a];
	
	b.btncopy.addEventListener(MouseEvent.CLICK, bCopyHandler);
	b.btnedit.addEventListener(MouseEvent.CLICK, bEditHandler);
	b.btndelete.addEventListener(MouseEvent.CLICK, bDeleteHandler);
	cont.addChild(b);
	btnLevels.push(b);
}

function bEditHandler(e){
	var btn = e.target.parent;
	edited(editorCode = savedLevels[btn.id]);
	editingNum = btn.id;
}
function bCopyHandler(e){
	var btn = e.target.parent;
	System.setClipboard(savedLevels[btn.id]);
}
function bDeleteHandler(e){
	var btn = e.target.parent;
	
	removeBtn(btn);
	btnLevels.splice(btn.id, 1);
	savedLevels.splice(btn.id, 1);
	namedLevels.splice(btn.id, 1);
	
	sObj.data.savedLevels = savedLevels;
	sObj.data.namedLevels = namedLevels;
	sObj.flush();
	
	for(var a = btn.id; a < btnLevels.length; a++){
		btnLevels[a].y -= 75;
	}
}

var ROWS;
var COLS;
var mapName;

var editorCode;

var editorEnemies = new Array();
var sMarker = new StartMarker();
sMarker.x = 0;
sMarker.y = 0;

btncreate.addEventListener(MouseEvent.CLICK, clicked);
btnedit.addEventListener(MouseEvent.CLICK, editClicked);
function editClicked(e){
	editingNum = savedLevels.length;
	editorCode = editThis.text;
	edited(editThis.text);
}
function clicked(e){
	ROWS = parseInt(rowsbox.text);
	COLS = parseInt(colsbox.text);
	mapName = namebox.text;
	
	editorCode = ROWS + ":" + COLS + ":";
	for(a = 0; a < ROWS; a++){
		editorCode += "0";
		for(var b = 0; b < COLS; b++){
			editorCode += "0";
		}
	}
	
	editingNum = savedLevels.length;
	showEditor();
}
function edited(editorCode){
	
	var ind1 = editorCode.indexOf("(") + 1;
	var ind2 = editorCode.indexOf(",", ind1);
	var sx = parseInt(editorCode.substring(ind1, ind2));
	ind1 = ind2 + 1;
	ind2 = editorCode.indexOf(")");
	var sy = parseInt(editorCode.substring(ind1, ind2));
	sMarker.x = sx * 20;
	sMarker.y = sy * 20;
	
	editorEnemies = new Array();
	ind1 = editorCode.indexOf(";");
	while(ind1 != -1){
		ind2 = editorCode.indexOf(",", ind1 + 1);
		
		var type = parseInt(editorCode.substring(ind1 + 1, ind2));
		
		ind1 = ind2;
		ind2 = editorCode.indexOf(",", ind1 + 1);
		var ox = parseInt(editorCode.substring(ind1 + 1, ind2));
		
		ind1 = ind2;
		ind2 = editorCode.indexOf(";", ind1 + 1);
		var oy = parseInt(editorCode.substring(ind1 + 1, Math.max(ind2, editorCode.length)));
		
		ind1 = ind2;
		
		editorEnemies.push(new EnemySetup(ox, oy, type));
	}
	
	ind1 = editorCode.indexOf(":");
	ROWS = editorCode.substring(0, ind1);
	
	ind2 = editorCode.indexOf(":", ind1 + 1);
	COLS = editorCode.substring(ind1 + 1, ind2);
	
	mapName = namebox.text;
	
	showEditor();
}
function removeBtn(b){
	b.btncopy.removeEventListener(MouseEvent.CLICK, bCopyHandler);
	b.btnedit.removeEventListener(MouseEvent.CLICK, bEditHandler);
	b.btndelete.removeEventListener(MouseEvent.CLICK, bDeleteHandler);
	
	cont.removeChild(b);
}
function clearCustomMenu(){
	for(var a = 0; a < btnLevels.length; a++){
		var b = btnLevels[a];
		
		removeBtn(b);
	}
	btnLevels = new Array();
	
	btncreate.removeEventListener(MouseEvent.CLICK, clicked);
	removeEventListener(Event.ENTER_FRAME, scroller);
}
function showEditor(){
	clearCustomMenu();
	gotoAndStop("editor");
}