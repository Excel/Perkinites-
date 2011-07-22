package maps{

	import actors.*;

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
		public static var mapClip=new MovieClip  ;
		public static var stageRef:Stage;
		public static var mapCode:String;
		public static var mapName:String;
		
		public static var mapWidth;
		public static var mapHeight;

		public static var tileTypes=new Array("p","n","p","w","w","w");
		public static var tileClings=new Array(false,false,false,true,true,false);

		public static function loadMap(mapNumber:int) {
			InteractiveTile.resetTiles();
			loadMapData(mapNumber);
			setHeroPosition();
			setGameUnits();
			setEnemies();

			stageRef.addChild(mapClip);
			ScreenRect.createScreenRect(new Array(mapClip),640,480);
			stageRef.addEventListener(Event.ENTER_FRAME, VCamHandler);

		}

		public static function loadMapData(mapNumber:int) {
			var mapData=MapDatabase.getMapData(mapNumber);
			mapCode = mapData[0];
			mapName = mapData[1];
			TileMap.removeTiles(mapClip);
			TileMap.createTileMap(mapCode,32,tileTypes,tileClings,"Tile");
			TileMap.addTiles(mapClip);
			var firstSep=mapCode.indexOf(":");
			var secSep=mapCode.indexOf(":",firstSep+1);


			mapWidth=parseInt(mapCode.substring(firstSep+1,secSep));
			mapHeight=parseInt(mapCode.substring(0,firstSep));			
		}
		public static function setHeroPosition() {
			var ind1=mapCode.indexOf("(")+1;
			var ind2=mapCode.indexOf(",",ind1);
			var startX=parseInt(mapCode.substring(ind1,ind2));
			ind1=ind2+1;
			ind2=mapCode.indexOf(")");
			var startY=parseInt(mapCode.substring(ind1,ind2));

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
		
		public static function setGameUnits(){
			
		}
		public static function setEnemies(){
			
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
	}
}