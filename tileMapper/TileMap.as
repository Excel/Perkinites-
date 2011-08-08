package tileMapper{
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.utils.getDefinitionByName;
	import com.*;
	import util.*;
	public class TileMap {

		public static var map:Array;
		public static var TILE_SIZE:Number;
		public static var MAX_IN_2880:Number;
		public static var MAX_BMP_SIZE:Number;
		public static var ROWS:Number, COLS:Number;
		static var tileSet:Array;
		static var tileTypes:Array;
		static var tileClings:Array;

		static var interTiles:Array;
		static var prefix:String;

		public static var theBitmaps:Array;
		public static var theData:Array;

		public static function createTileMap(m:String, tileSize:Number, types:Array, cling:Array, pref:String) {
			TILE_SIZE=tileSize;
			tileTypes=types;
			tileClings=cling;
			prefix=pref;

			MAX_IN_2880=Math.floor(2880/TILE_SIZE);
			MAX_BMP_SIZE=MAX_IN_2880*TILE_SIZE;

			tileSet=new Array(tileTypes.length);
			for (var a = 0; a < tileTypes.length; a++) {
				if (tileTypes[a].length>1) {
					var TileType=getDefinitionByName(tileTypes[a]);
				} else {
					TileType=getDefinitionByName(prefix+a);
					tileSet[a] = new TileType();
				}
			}

			initMap(m);
		}
		static function initMap(mapData:String) {
			//row:col:data
			var firstSep=mapData.indexOf(":");
			var secSep=mapData.indexOf(":",firstSep+1);

			ROWS=parseInt(mapData.substring(0,firstSep));
			COLS=parseInt(mapData.substring(firstSep+1,secSep));

			var rowSpace=ROWS*TILE_SIZE;

			var r=0;
			theData=new Array(Math.ceil(ROWS/MAX_IN_2880));
			theBitmaps=new Array(Math.ceil(ROWS/MAX_IN_2880));
			while (rowSpace > 0) {
				theData[r]=new Array(Math.ceil(COLS/MAX_IN_2880));
				theBitmaps[r]=new Array(Math.ceil(COLS/MAX_IN_2880));
				var colSpace=COLS*TILE_SIZE;

				var c=0;
				while (colSpace > 0) {
					//theData[r][c].dispose();
					var allotedWidth=Math.min(MAX_BMP_SIZE,COLS*TILE_SIZE);
					var allotedHeight=Math.min(MAX_BMP_SIZE,ROWS*TILE_SIZE);

					theData[r][c]=new BitmapData(allotedWidth,allotedHeight,true,0xFFFFFF);

					theBitmaps[r][c]=new Bitmap(theData[r][c]);

					theBitmaps[r][c].x=c*MAX_IN_2880*TILE_SIZE;
					theBitmaps[r][c].y=r*MAX_IN_2880*TILE_SIZE;

					colSpace-=allotedWidth;
					c++;
				}
				rowSpace-=allotedHeight;
				r++;
			}

			var nextSep,lastSep,points;
			interTiles=new Array(ROWS);

			map=new Array(ROWS);

			for (var a = 0; a < ROWS; a++) {
				//row
				interTiles[a]=new Array(COLS);

				map[a]=new Array(COLS);
				for (var b = 0; b < COLS; b++) {
					//column

					updateTile(a, b, mapData);
				}
			}
		}
		public static function addTiles(mc:MovieClip) {
			for (var a = 0; a < ROWS / MAX_IN_2880; a++) {
			for (var b = 0; b < COLS / MAX_IN_2880; b++) {
			mc.addChild(theBitmaps[a][b]);
			}
			}
/*			for (var a = 0; a < ROWS; a++) {
				for (var b = 0; b < COLS; b++) {
					//var t=tileSet[map[a][b]];
					var ClassReference=getDefinitionByName("Tile"+map[a][b]) as Class;
					var t = new ClassReference();

					t.gotoAndStop(1);
					mc.addChild(t);
					t.x = b*32;
					t.y = a*32;

					var bitmapData:BitmapData=new BitmapData(32,32);
					bitmapData.draw(t);
					var bitmap:Bitmap=new Bitmap(bitmapData);
					
					mc.addChild(bitmap);

					bitmap.x=b*32;
					bitmap.y=a*32;


				}
			}*/
		}
		public static function removeTiles(mc:MovieClip) {
			for (var a = 0; a < ROWS / MAX_IN_2880; a++) {
				for (var b = 0; b < COLS / MAX_IN_2880; b++) {
					if (theBitmaps[a][b].parent==mc) {
						mc.removeChild(theBitmaps[a][b]);
					}
				}
			}
		}
		public static function changeTile(a, b, c) {
			map[a][b]=c;
		}
		public static function updateTile(a, b, mapData) {
			var mat = new Matrix();

			var num=COLS*a+b+mapData.lastIndexOf(":")+1;

			var mnum=parseInt(mapData.charAt(num));
			map[a][b]=mnum;
			var alphabet="ABCDEFGHIJKLMNOPQRSTUVWXYZ";
			if (alphabet.indexOf(mnum)!=-1) {
				mnum=alphabet.indexOf(mnum)+10;
			}

			var t=tileSet[mnum];
			if (tileTypes[mnum].length!=1) {
				var IATile=getDefinitionByName(tileTypes[mnum]);
				//var IATile = getDefinitionByName("com.Door");
				//trace("com." + wallBools[mnum]);
				var i=new IATile(a,b);
				InteractiveTile.addTile(i);
				interTiles[a][b]=i;
			}

			if (tileClings[mnum]) {
				//wall
				var bin=0;
				//top
				bin += (a == 0) ? 0 : getCling(mnum, 0, mapData.charAt(num - COLS));
				//right
				bin += (b == COLS - 1) ? 0 : getCling(mnum, 1, mapData.charAt(parseInt(num) + 1));
				//bottom
				bin += (a == ROWS - 1) ? 0 : getCling(mnum, 2, mapData.charAt(parseInt(num) + COLS));
				//left
				bin += (b == 0) ? 0 : getCling(mnum, 3, mapData.charAt(num - 1));
				t.gotoAndStop(bin + 1);
			}
			if (t!=undefined) {
				var c=Math.floor(b/MAX_IN_2880);
				var r=Math.floor(a/MAX_IN_2880);
				mat.translate((b % MAX_IN_2880) * TILE_SIZE, (a % MAX_IN_2880) * TILE_SIZE);
				var b=theData[r][c];
				b.draw(t, mat, undefined, "normal");
			}
		}
		static function getCling(t:Number, b:Number, m:String) {
			var n=parseInt(m);
			return (n != t) ? 0 : (1 << b);
		}
		public static function hitWall(ox, oy) {
			return getTile(ox, oy) == "w";
		}
		public static function hitNonpass(ox, oy) {
			return getTile(ox, oy) == "n" || getTile(ox, oy) == "w";
		}
		public static function hitTile(ox, oy) {
			var xPos=Math.floor(ox/TILE_SIZE);
			var yPos=Math.floor(oy/TILE_SIZE);

			if (yPos<0||yPos>=interTiles.length||xPos<0||xPos>=interTiles[yPos].length) {
				return;
			}

			var iTile=interTiles[yPos][xPos];
			if (iTile!=undefined) {
				iTile.hit();
			}
		}

		public static function getTile(ox, oy) {
			var xPos=Math.floor(ox/TILE_SIZE);
			var yPos=Math.floor(oy/TILE_SIZE);
			if (xPos<0||yPos<0||xPos>=COLS||yPos>=ROWS) {
				return "a";
			}

			var iTile=interTiles[yPos][xPos];
			if (iTile!=null&&iTile!=undefined) {
				var v=iTile.getValue();
				if (v!="") {
					return v;
				}
			}

			return tileTypes[map[yPos][xPos]];
		}
		public static function activate(ox, oy) {
			var xPos=Math.floor(ox/TILE_SIZE);
			var yPos=Math.floor(oy/TILE_SIZE);
			interTiles[yPos][xPos].activate();
		}

		public static function walkable(sTile, eTile, speed:Number = 2, bound:Number = 8) {
			var sPoint=new Point(sTile.x*32+16,sTile.y*32+16);
			var ePoint=new Point(eTile.x*32+16,eTile.y*32+16);

			var dist=0;
			var totalDist=Math.sqrt(Math.pow(ePoint.y-sPoint.y,2)+Math.pow(ePoint.x-sPoint.x,2));

			var radian=Math.atan2(ePoint.y-sPoint.y,ePoint.x-sPoint.x);
			var degree = (radian*180/Math.PI);

			while (dist < totalDist) {

				if (TileMap.hitWall(sPoint.x,sPoint.y) ||
				TileMap.hitWall(sPoint.x-bound, sPoint.y) ||
				TileMap.hitWall(sPoint.x+bound, sPoint.y) ||
				TileMap.hitWall(sPoint.x, sPoint.y-bound) ||
				TileMap.hitWall(sPoint.x, sPoint.y+bound) ||
				
				TileMap.hitWall(sPoint.x-bound/Math.sqrt(2), sPoint.y-bound/Math.sqrt(2)) ||
				TileMap.hitWall(sPoint.x-bound/Math.sqrt(2), sPoint.y+bound/Math.sqrt(2)) ||
				TileMap.hitWall(sPoint.x+bound/Math.sqrt(2), sPoint.y-bound/Math.sqrt(2)) ||
				TileMap.hitWall(sPoint.x+bound/Math.sqrt(2), sPoint.y+bound/Math.sqrt(2))) {
					return false;
				}
				sPoint.x=sPoint.x+speed*Math.cos(radian);
				sPoint.y=sPoint.y+speed*Math.sin(radian);
				dist+=speed;
			}
			return true;
		}

		public static function findPath(mainMap:Array, startP:Point, endP:Point, diagonal:Boolean, diagonalWall:Boolean) {
			var startx=startP.x;
			var starty=startP.y;
			var endx=endP.x;
			var endy=endP.y;

			var map:Array = new Array();
			for (var j=0; j<mainMap.length; j++) {
				map[j] = new Array();
				for (var i=0; i<mainMap[0].length; i++) {
					map[j][i]=mainMap[j][i];
				}
			}
			var tiles:Array=[startx,starty];
			var ts:Number=0;
			var te:Number=tiles.length;
			var found:Boolean=false;

			var ROWS=map.length;
			var COLS=map[0].length;

			while (ts != te) {
				for (i=ts+1; i<te; i += 2) {
					if (tiles[i]==endy&&tiles[i-1]==endx) {
						found=true;
						break;
					}
					if (tiles[i-1]<COLS&&map[tiles[i]][tiles[i-1]+1]==0) {
						map[tiles[i]][tiles[i-1]+1]={y:tiles[i],x:tiles[i-1]};
						tiles.push(tiles[i-1]+1, tiles[i]);
					}
					if (tiles[i-1]>0&&map[tiles[i]][tiles[i-1]-1]==0) {
						map[tiles[i]][tiles[i-1]-1]={y:tiles[i],x:tiles[i-1]};
						tiles.push(tiles[i-1]-1, tiles[i]);
					}
					if (tiles[i]<ROWS&&map[tiles[i]+1][tiles[i-1]]==0) {
						map[tiles[i]+1][tiles[i-1]]={y:tiles[i],x:tiles[i-1]};
						tiles.push(tiles[i-1], tiles[i]+1);
					}
					if (tiles[i]>0&&map[tiles[i]-1][tiles[i-1]]==0) {
						map[tiles[i]-1][tiles[i-1]]={y:tiles[i],x:tiles[i-1]};
						tiles.push(tiles[i-1], tiles[i]-1);
					}
					if (diagonal==true) {
						if (tiles[i]>0&&tiles[i-1]>0&&map[tiles[i]-1][tiles[i-1]-1]==0) {
							if (diagonalWall) {
								if (map[tiles[i]][tiles[i-1]-1]!=1&&map[tiles[i]-1][tiles[i-1]]!=1) {
									map[tiles[i]-1][tiles[i-1]-1]={y:tiles[i],x:tiles[i-1]};
									tiles.push(tiles[i-1]-1, tiles[i]-1);
								}
							} else {
								map[tiles[i]-1][tiles[i-1]-1]={y:tiles[i],x:tiles[i-1]};
								tiles.push(tiles[i-1]-1, tiles[i]-1);
							}
						}
						if (tiles[i]<ROWS&&tiles[i-1]<COLS&&map[tiles[i]+1][tiles[i-1]+1]==0) {
							if (diagonalWall) {
								if (map[tiles[i]][tiles[i-1]+1]!=1&&map[tiles[i]+1][tiles[i-1]]!=1) {
									map[tiles[i]+1][tiles[i-1]+1]={y:tiles[i],x:tiles[i-1]};
									tiles.push(tiles[i-1]+1, tiles[i]+1);
								}
							} else {
								map[tiles[i]+1][tiles[i-1]+1]={y:tiles[i],x:tiles[i-1]};
								tiles.push(tiles[i-1]+1, tiles[i]+1);
							}
						}
						if (tiles[i]<ROWS&&tiles[i-1]>0&&map[tiles[i]+1][tiles[i-1]-1]==0) {
							if (diagonalWall) {
								if (map[tiles[i]][tiles[i-1]-1]!=1&&map[tiles[i]+1][tiles[i-1]]!=1) {
									map[tiles[i]+1][tiles[i-1]-1]={y:tiles[i],x:tiles[i-1]};
									tiles.push(tiles[i-1]-1, tiles[i]+1);
								}
							} else {
								map[tiles[i]+1][tiles[i-1]-1]={y:tiles[i],x:tiles[i-1]};
								tiles.push(tiles[i-1]-1, tiles[i]+1);
							}
						}
						if (tiles[i]>0&&tiles[i-1]<COLS&&map[tiles[i]-1][tiles[i-1]+1]==0) {
							if (diagonalWall) {
								if (map[tiles[i]][tiles[i-1]+1]!=1&&map[tiles[i]-1][tiles[i-1]]!=1) {
									map[tiles[i]-1][tiles[i-1]+1]={y:tiles[i],x:tiles[i-1]};
									tiles.push(tiles[i-1]+1, tiles[i]-1);
								}
							} else {
								map[tiles[i]-1][tiles[i-1]+1]={y:tiles[i],x:tiles[i-1]};
								tiles.push(tiles[i-1]+1, tiles[i]-1);
							}
						}
					}
				}
				ts=te;
				if (found!=true) {
					te=tiles.length;
				}
			}
			var path:Array=[new Point(endx,endy)];
			var px:Number=endx;
			var py:Number=endy;
			if (TileMap.getTile(endx*32,endy*32)=="p") {
				while (px != startx || py != starty) {
					path.unshift(new Point(map[py][px].x, map[py][px].y));
					px=path[0].x;
					py=path[0].y;
				}
			} else {
				path = new Array();
			}
			return path;
		}
	}
}