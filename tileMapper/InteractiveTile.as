package tileMapper{
	import flash.geom.*;
	import flash.events.*;
	import flash.ui.*;
	import com.*;
	import util.*;
	import flash.display.MovieClip;
	public class InteractiveTile extends MovieClip{
		public static var tileContainer = new MovieClip();
		static var setTile;
		static var stage;
		static var tiles:Array = new Array();
		public function InteractiveTile(row, col){
			//super();
			//super(ox * TileMap.TILE_SIZE, oy * TileMap.TILE_SIZE);
			x = col * TileMap.TILE_SIZE;
			y = row * TileMap.TILE_SIZE;
		}
		public function hit(){
			//do nothing
		}
		public function activate(){
			
		}
		public function getValue():String{
			return "";
		}
		public static function addTile(t:MovieClip){
			tileContainer.addChild(t);
			tiles.push(t);
		}
		public function reset(){
			gotoAndStop(1);
			//do nothing
		}
		public static function resetTiles(){
			for(var a = 0; a < tiles.length; a++){
				tiles[a].reset();
			}
		}
		public static function removeTiles(){
			for(var a = 0; a < tiles.length; a++){
				tileContainer.removeChild(tiles[a]);
			}
			tiles = new Array();
		}
	}
}