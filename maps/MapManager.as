package maps{

	import actors.*;
	import game.GameVariables;

	import util.*;
	import com.*;
	import tileMapper.*;

	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.*;
	import flash.ui.*;
	import flash.utils.Timer;
	import flash.events.TimerEvent;

	public class MapManager extends MovieClip {
		public static var mapClip=new MovieClip();
		public static var stageRef:Stage;
		public static var mapCode:String;
		public static var mapName:String;

		public static var mapWidth;
		public static var mapHeight;

		public static var scrollDir=0;
		public static var speed=0;
		public static var distance=0;
		public static var totalDistance=0;
		public static var scrollX = 0;
		public static var scrollY = 0;

		public static var tileClings=new Array(false,false,false,true,true,false);

		public static function loadMap(mapNumber:int) {
			InteractiveTile.resetTiles();
			loadMapData(mapNumber);
			setHeroPosition();
			setMapObjects(mapNumber);
			setEnemies();

			ScreenRect.createScreenRect(new Array(mapClip),640,480);
			stageRef.addEventListener(Event.ENTER_FRAME, VCamHandler);
			//stageRef.addEventListener(Event.ENTER_FRAME, depthSortHandler);
			return mapClip;

		}
		public static function depthSortHandler(e) {
			var depthArray:Array = new Array();
			for (var i:int = 0; i < mapClip.numChildren; i++) {
				var child=mapClip.getChildAt(i);
				if ( ! (mapClip.getChildAt(i) is Tile0)) {//&& ScreenRect.inBounds(mapClip.getChildAt(i))) {
					depthArray.push(mapClip.getChildAt(i));
				}
			}
			depthArray.sortOn("y", Array.NUMERIC);
			var t=mapClip.numChildren;
			i=depthArray.length;
			while (i--) {
				t--;
				if (mapClip.getChildIndex(depthArray[i])!=t) {
					mapClip.setChildIndex(depthArray[i], t);
				}

			}
		}
		public static function loadMapData(mapNumber:int) {
			stopScrolling();
			TileMap.removeTiles(mapClip);
			var map=MapDatabase.getMap(mapNumber);
			mapCode=map.mapCode;
			mapName=map.mapName;
			TileMap.removeTiles(mapClip);
			var tileset=MapDatabase.getTileset(map.tilesetID);
			var tileTypes=tileset.tileTypes;
			TileMap.createTileMap(mapCode,32,tileTypes,tileClings,"Tile");
			TileMap.addTiles(mapClip);

			var firstSep=mapCode.indexOf(":");
			var secSep=mapCode.indexOf(":",firstSep+1);

			mapWidth=parseInt(mapCode.substring(firstSep+1,secSep));
			mapHeight=parseInt(mapCode.substring(0,firstSep));
		}
		public static function setHeroPosition() {
			var startX=GameVariables.xTile;
			var startY=GameVariables.yTile;
			if (startX==-1&&startY==-1) {
				var ind1=mapCode.indexOf("(")+1;
				var ind2=mapCode.indexOf(",",ind1);
				startX=parseInt(mapCode.substring(ind1,ind2));
				ind1=ind2+1;
				ind2=mapCode.indexOf(")");
				startY=parseInt(mapCode.substring(ind1,ind2));
			}

			Unit.currentUnit.mxpos=Unit.partnerUnit.mxpos=startX*TileMap.TILE_SIZE+16;//+.5*TileMap.TILE_SIZE;
			Unit.currentUnit.mypos=Unit.partnerUnit.mypos=startY*TileMap.TILE_SIZE+16;//+.5*TileMap.TILE_SIZE;
			Unit.currentUnit.x=startX*TileMap.TILE_SIZE+16;//startX+.5*TileMap.TILE_SIZE;
			Unit.currentUnit.y=startY*TileMap.TILE_SIZE+16;//startY+.5*TileMap.TILE_SIZE;
			Unit.partnerUnit.x=startX*TileMap.TILE_SIZE+16;//startX+.5*TileMap.TILE_SIZE;
			Unit.partnerUnit.y=startY*TileMap.TILE_SIZE+16;//startY+.5*TileMap.TILE_SIZE;

			mapClip.addChild(Unit.currentUnit);
			mapClip.addChild(Unit.partnerUnit);

			Unit.currentUnit.begin();
			Unit.partnerUnit.begin();

		}

		public static function setMapObjects(mapNumber:int) {
			var mapObjects=MapDatabase.getMapObjects(mapNumber);
			for (var i = 0; i < mapObjects.length; i++) {
				mapClip.addChild(mapObjects[i]);
			}
		}
		public static function setEnemies() {

		}


		public static function startScrolling(scrollDir, numTiles, speed) {
			MapManager.scrollDir=scrollDir;
			MapManager.distance=0;
			MapManager.totalDistance=numTiles*32;
			MapManager.speed=speed;
			MapManager.scrollX = Unit.currentUnit.x;
			MapManager.scrollY = Unit.currentUnit.y;
			stageRef.removeEventListener(Event.ENTER_FRAME, VCamHandler);
			stageRef.addEventListener(Event.ENTER_FRAME, VCamScrollHandler);
		}

		public static function stopScrolling() {
			MapManager.scrollDir=0;
			MapManager.distance=0;
			MapManager.totalDistance=0;
			MapManager.speed=0;
			MapManager.scrollX = 0;
			MapManager.scrollY = 0;
			stageRef.removeEventListener(Event.ENTER_FRAME, VCamScrollHandler);
			stageRef.addEventListener(Event.ENTER_FRAME, VCamHandler);
		}
		public static function VCamHandler(e) {
			ScreenRect.setX(Unit.currentUnit.x-640/2);
			ScreenRect.setY(Math.max(Unit.currentUnit.y-480/2,0));
			//ScreenRect.easeScreen(new Point(Unit.xpos - WIDTH / 2, Unit.ypos - HEIGHT));
			if (ScreenRect.getX()<0) {
				ScreenRect.setX(0);
			}
			if (ScreenRect.getY()<0) {
				ScreenRect.setY(0);
			}
			if (ScreenRect.getX()+640>mapWidth*32) {
				ScreenRect.setX(mapWidth*32-640);
			}
			if (ScreenRect.getY()+480>mapHeight*32) {
				ScreenRect.setY(mapHeight*32-480);
			}

		}

		public static function VCamScrollHandler(e) {
			if (distance<totalDistance) {

				var xdist=0;
				var ydist=0;
				switch (scrollDir) {
					case 2 :
						ydist=speed;
						break;
					case 4 :
						xdist=-1*speed;
						break;
					case 6 :
						xdist=speed;
						break;
					case 8 :
						ydist=-1*speed;
						break;
				}
				scrollX += xdist;
				scrollY +=ydist;
				ScreenRect.setX(scrollX-640/2);
				ScreenRect.setY(Math.max(scrollY-480/2,0));
				if (ScreenRect.getX()<0) {
					ScreenRect.setX(0);
				}
				if (ScreenRect.getY()<0) {
					ScreenRect.setY(0);
				}
				if (ScreenRect.getX()+640>mapWidth*32) {
					ScreenRect.setX(mapWidth*32-640);
				}
				if (ScreenRect.getY()+480>mapHeight*32) {
					ScreenRect.setY(mapHeight*32-480);
				}
				distance+=Math.sqrt(Math.pow(xdist,2)+Math.pow(ydist,2));

			}

		}
	}
}