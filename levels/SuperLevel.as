package levels{
	import actors.*;
	import collects.*;
	import enemies.*;
	import util.*;

	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.*;
	import flash.ui.*;
	import flash.utils.Timer;
	import flash.events.TimerEvent;

	public class SuperLevel extends MovieClip {
		public static var mapClip = new MovieClip();


		public var happyTimer:Timer;

		public static var tileWidth=32;
		public static var tileHeight=32;
		public var names=[];
		public var messages=[];
		public static var diff=-1;
		public static var setLevel=0;
		public var myMap=[];
		public var tileMap=[];
		public var doors=[];
		public var charDisplay=0;
		public var messagebox = new MessageBox();
		public var mbx=34;
		public var mby=302-64;
		public var dialogueIndex=0;
		public var fastforward=false;

		public function makeHappiness() {
			happyTimer=new Timer(2500,0);
			happyTimer.addEventListener("timer", happy);
			happyTimer.start();
		}


		public function happy(e:TimerEvent) {

			var mapWidth=myMap[0].length;
			var mapHeight=myMap.length;
			var r=Math.floor(Math.random()*mapHeight);
			var c=Math.floor(Math.random()*mapWidth);

			var limit=Math.floor(Math.random()*2+2);
			for (var i = 0; i < limit; i++) {
				r=Math.floor(Math.random()*mapHeight);
				c=Math.floor(Math.random()*mapWidth);
				var h = new HappyOrb();
				var hold=false;
				while (true) {
					hold=false;
					h.x=tileMap["t_"+r+"_"+c].x+tileWidth/2;
					h.y=tileMap["t_"+r+"_"+c].y+tileHeight/2;
					for (var j = 0; j < HappyOrb.list.length; j++) {
						if (HappyOrb.list[j]!=h&&HappyOrb.list[j].hitTestObject(h)) {
							hold=true;
						}
					}
					if (tileMap["t_"+r+"_"+c].walkable==false||hold) {
						c++;
						if (c>=mapWidth) {
							r++;
							c=0;
						}
						if (r>=mapHeight) {
							r=0;
						}
					} else {
						break;
					}
				}

				mapClip.addChild(h);
			}
		}
		public static function setDifficulty(difficulty) {
			diff=difficulty;
		}

		public function mapSetup() {
			showMap();
			buildEvents();
			addEventListener(Event.ENTER_FRAME, depthSortHandler);
		}

		public function buildMap() {
			var tileMap=[];
			var mapWidth=myMap[0].length;
			var mapHeight=myMap.length;
			for (var r = 0; r < mapHeight; r++) {
				for (var c = 0; c < mapWidth; c++) {
					var tile;
					if (myMap[r][c]==1) {
						tile = new Tile1();
						tile.walkable=false;
						if ( (r - 1 >= 0 && myMap[r-1][c] == 0)
						|| (r + 1 < mapHeight && myMap[r+1][c] == 0)
						|| (c - 1 >= 0 && myMap[r][c-1] == 0)
						|| (c + 1 < mapWidth && myMap[r][c+1] == 0)) {
							tile.nextToWalkable=true;
						} else {
							tile.nextToWalkable=false;
						}

					} else if (myMap[r][c] == 2) {
						tile = new Tile2();
						tile.walkable=true;
						tile.nextToWalkable=true;
					} else if (myMap[r][c] == 0) {
						tile = new Tile0();
						tile.walkable=true;
						tile.nextToWalkable=true;
					}

					tile.x =(c*tileWidth);
					tile.y =(r*tileHeight);
					tileMap["t_"+r+"_"+c]=tile;
				}
			}
			return tileMap;
		}
		public function buildEvents() {

		}
		public function buildDoors() {
			//for (var i = 0; i < doors.length; doors++) {
			//tileMap["t_"+r+"_"+c].addEventListener(Event.ENTER_FRAME, doorHandler);
			//}
		}

		public function doorHandler(e) {

		}

		public function clearMap() {
			for (var i = 0; i < mapClip.numChildren; i++) {
				mapClip.removeChild(mapClip.getChildAt(0));
			}

		}
		public function showMap() {
			var mapWidth=myMap[0].length;
			var mapHeight=myMap.length;
			for (var r = 0; r < mapHeight; r++) {
				for (var c = 0; c < mapWidth; c++) {
					mapClip.addChild(this.tileMap["t_"+r+"_"+c]);
				}
			}
		}

		public function startEnemies() {
			for (var i = 0; i < Enemy.list.length; i++) {
				Enemy.list[i].begin();
			}
		}
		public function talking(index, fastforward) {
			if (names.length>0) {
				messagebox.nameDisplay.text=names[index];
			}
			messagebox.messageDisplay.text=messages[index].substr(0,charDisplay);
			if (charDisplay==0) {
				messagebox.x=mbx;
				messagebox.y=mby;
				stage.addChild(messagebox);

			}

			if (charDisplay==messages[index].length||fastforward) {
				messagebox.messageDisplay.text=messages[index];
				charDisplay=messages[index].length;
			} else if (charDisplay<messages[index].length) {
				charDisplay++;
			}
		}

		public function depthSortHandler(e) {
			var depthArray:Array = new Array();
			for (var i:int = 0; i < mapClip.numChildren; i++) {
				if ( ! (mapClip.getChildAt(i) is Tile0)) {
					if (mapClip.getChildAt(i) is Tile1) {
						if (mapClip.getChildAt(i).nextToWalkable==true) {
							depthArray.push(mapClip.getChildAt(i));
						}
					}
					else{
						depthArray.push(mapClip.getChildAt(i));
					}
				}
			}
			depthArray.sortOn("y", Array.NUMERIC);
			i=depthArray.length;
			while (i--) {
				if (mapClip.getChildIndex(depthArray[i])!=i) {
					mapClip.setChildIndex(depthArray[i], i);
				}
			}
		}
		public function VCamHandler(e) {
			if (e.keyCode==Keyboard.SPACE) {
				ScreenRect.setX(Unit.currentUnit.x - 640 / 2);
				ScreenRect.setY(Math.max(Unit.currentUnit.y - 480/2,0));
				//ScreenRect.easeScreen(new Point(Unit.xpos - WIDTH / 2, Unit.ypos - HEIGHT));
				if (ScreenRect.getX()<0) {
					ScreenRect.setX(0);
				}
				if (ScreenRect.getY()<0) {
					ScreenRect.setY(0);
				}
				var mapWidth=myMap[0].length;
				var mapHeight=myMap.length;
				if (ScreenRect.getX()+640 > (mapWidth)*32) {
					ScreenRect.setX( (mapWidth)*32 - 640);
				}
				if (ScreenRect.getY()+480 > (mapHeight)*32) {
					ScreenRect.setY( (mapHeight)*32 - 480);
				}
			}

		}

	}

}