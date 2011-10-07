
import maps.MapDataEvent;
import flash.display.MovieClip;

stop();

var STAGE_WIDTH=1000;
var STAGE_HEIGHT=700;

var sObj=SharedObject.getLocal("PERKINITESEDITOR");

if (! sObj.data.savedLevels||sObj.data.savedLevels.length==0) {
	sObj.data.savedLevels = new Array();
}

var savedLevels= new Array();
var emDatabase = new ExternalMapDatabase();
ExternalMapDatabase.tilesetInfo = new Array();
ExternalMapDatabase.mapInfo = new Array();
ExternalMapDatabase.mapObjectInfo = new Array();
emDatabase.addEventListener(MapDataEvent.MAPOBJECTS_LOADED, startSomething);
emDatabase.loadData();
var btnLevels = new Array();
var editingNum:Number=0;

var cont:MovieClip = new MovieClip();
addChild(cont);
cont.mask=levelmask;

addEventListener(Event.ENTER_FRAME, scroller);

function startSomething(e) {
	savedLevels = new Array();
	savedLevels = ExternalMapDatabase.mapInfo;
	if (ExternalMapDatabase.mapInfo.length<=ExternalMapDatabase.mapObjectInfo.length) {

		for (a = 0; a < savedLevels.length; a++) {

			var b = new BtnLevel();
			//465
			b.x=154;
			b.y=130+60*a;
			b.id=a;
			b.mapName.text=savedLevels[a].mapName;

			b.btncopy.addEventListener(MouseEvent.CLICK, bCopyHandler);
			b.btnedit.addEventListener(MouseEvent.CLICK, bEditHandler);
			b.btndelete.addEventListener(MouseEvent.CLICK, bDeleteHandler);
			cont.addChild(b);
			btnLevels.push(b);
		}
	}
}
function scroller(e) {
	if (mouseX<300&&mouseY>90) {
		if (mouseY<140) {
			cont.y += (140 - mouseY) / 2;
		}
		if (mouseY>420) {
			cont.y -= (mouseY - 420) / 2;
		}
	}

	cont.y=Math.min(Math.max(cont.y,570-savedLevels.length*60),0);
}



function bEditHandler(e) {
	var btn=e.target.parent;
	
	tilesetID=savedLevels[btn.id].tilesetID;
	mapName=savedLevels[btn.id].mapName;
	BGM=savedLevels[btn.id].BGM;
	BGS=savedLevels[btn.id].BGS;
	ID = btn.id;
	
	edited(editorCode = savedLevels[btn.id].mapCode);
	editingNum=btn.id;
}
function bCopyHandler(e) {
	var btn = e.target.parent;
	
	tilesetboxX.text = savedLevels[btn.id].tilesetID;
	var editorCode = savedLevels[btn.id].mapCode;
	rowsboxX.text = editorCode.substring(0, editorCode.indexOf(":"));
	var index = editorCode.indexOf(":");
	colsboxX.text = editorCode.substring(index+1, editorCode.indexOf(":", index+1))
	nameboxX.text = savedLevels[btn.id].mapName;
	BGMboxX.text = savedLevels[btn.id].BGM;
	BGSboxX.text = savedLevels[btn.id].BGS; 

}
function bDeleteHandler(e) {
	var btn=e.target.parent;

	removeBtn(btn);
	btnLevels.splice(btn.id, 1);
	savedLevels.splice(btn.id, 1);
	for (a = 0; a < savedLevels.length; a++) {
		var b = btnLevels[a];
		b.x=154;
		b.y=130+60*a;
		b.id=a;
	}

	sObj.data.savedLevels=savedLevels;
	sObj.flush();

}

var ROWS;
var COLS;
var mapName;
var tilesetID;
var BGM;
var BGS;
var ID;

var editorCode;

var editorEnemies = new Array();
var sMarker = new StartMarker();
sMarker.x=0;
sMarker.y=0;

btncreate.addEventListener(MouseEvent.CLICK, clicked);
btnsave.addEventListener(MouseEvent.CLICK, saveClicked);

function clicked(e) {
	tilesetID=parseInt(tilesetbox.text);
	ROWS=parseInt(rowsbox.text);
	COLS=parseInt(colsbox.text);
	mapName=namebox.text;
	BGM=BGMbox.text;
	BGS=BGSbox.text;
	

	
	ID = savedLevels.length;
	editorCode=ROWS+":"+COLS+":";
	for (a = 0; a < ROWS; a++) {
		editorCode+="0";
		for (var b = 0; b < COLS; b++) {
			editorCode+="0";
		}
	}

	editingNum=savedLevels.length;
	showEditor();
}
function edited(editorCode) {
	var ind1=editorCode.indexOf("(")+1;
	var ind2=editorCode.indexOf(",",ind1);
	var sx=parseInt(editorCode.substring(ind1,ind2));
	ind1=ind2+1;
	ind2=editorCode.indexOf(")");
	var sy=parseInt(editorCode.substring(ind1,ind2));
	sMarker.x=sx*20;
	sMarker.y=sy*20;

	ind1=editorCode.indexOf(";");
	while (ind1 != -1) {
		ind2=editorCode.indexOf(",",ind1+1);

		var type=parseInt(editorCode.substring(ind1+1,ind2));

		ind1=ind2;
		ind2=editorCode.indexOf(",",ind1+1);
		var ox=parseInt(editorCode.substring(ind1+1,ind2));

		ind1=ind2;
		ind2=editorCode.indexOf(";",ind1+1);
		var oy=parseInt(editorCode.substring(ind1+1,Math.max(ind2,editorCode.length)));

		ind1=ind2;

	}

	ind1=editorCode.indexOf(":");
	ROWS=editorCode.substring(0,ind1);

	ind2=editorCode.indexOf(":",ind1+1);
	COLS=editorCode.substring(ind1+1,ind2);

	showEditor();
}
function removeBtn(b) {
	b.btncopy.removeEventListener(MouseEvent.CLICK, bCopyHandler);
	b.btnedit.removeEventListener(MouseEvent.CLICK, bEditHandler);
	b.btndelete.removeEventListener(MouseEvent.CLICK, bDeleteHandler);

	cont.removeChild(b);
}
function clearCustomMenu() {
	for (var a = 0; a < btnLevels.length; a++) {
		var b=btnLevels[a];

		removeBtn(b);
	}
	btnLevels = new Array();

	btncreate.removeEventListener(MouseEvent.CLICK, clicked);
	removeEventListener(Event.ENTER_FRAME, scroller);
}
function showEditor() {
	clearCustomMenu();
	gotoAndStop("editor");
}
function saveClicked(e){
	var xml:XML = 
		<Maps>
		</Maps>;
	for(var i = 0; i < savedLevels.length; i++){
		var mapXML:XML = 
			<Map>
				<ID>{i}</ID>
				<MapCode>{savedLevels[i].mapCode}</MapCode>
				<MapName>{savedLevels[i].mapName}</MapName>
				<TilesetID>{savedLevels[i].tilesetID}</TilesetID>
				<BGM>{savedLevels[i].BGM}</BGM>
				<BGS>{savedLevels[i].BGS}</BGS>
			</Map>
		xml.appendChild(mapXML);
		
	}
	System.setClipboard(xml.toXMLString());

	trace("Saved! Please re-copy the xml string into the xml. :)");
}
