package util{
	import util.*;
	import flash.geom.*;
	import flash.display.MovieClip;
	public class Unit extends MovieClip{
		var MOVE_SPEED;
		var rad;
		
		public static var allAreas = new Array();
		public function Unit(s){
			super();
			MOVE_SPEED = s;
			allAreas.push(this);
			rad = Math.pow(width >> 1, 2);
		}
		public function mover(ox:Number, oy:Number){
			var speedAdjust = (ox != 0 && oy != 0) ? (MOVE_SPEED * Math.SQRT2 / 2) : MOVE_SPEED;
			var nx = x + ox * speedAdjust;
			var ny = y + oy * speedAdjust;
			
			var ox = x;
			var oy = y;
			
			x = nx;
			y = ny;
			if(TileMap.hitWall(nx, ny) || hitAreas()){
				x = ox;
				y = oy;
			}
		}
		//creates units in a circle around the original unit (u)
		public function spaceAround(u:Unit){
			var radRoot = Math.sqrt(u.rad) + 20;
			var addPi = Math.PI / 4;
			
			for(var a = 0; a < 2 * Math.PI; a += addPi){
				x = radRoot * Math.cos(a) + u.x;
				y = radRoot * Math.sin(a) + u.y;
				if(!hitAreas() && !TileMap.hitWall(x, y))
					return;
			}
			trace("couldn't find space");
		}
		public function getMyRect(){
			return new Rectangle(x, y, width, height);
		}
		public function pointHitAreas(ox, oy):Unit{
			var p = new Point(ox, oy);
			
			for(var a in allAreas){
				var mc = allAreas[a];
				if(mc == this)
					continue;
				
				if((mc.getRect()).containsPoint(p)){
					return mc;
				}
			}
			return null;
		}
		public function hitAreas(){
			for(var a in allAreas){
				var mc = allAreas[a];
				if(mc == this)
					continue;
				
				var dist = Math.pow(mc.x - x, 2) + Math.pow(mc.y - y, 2);
				if(dist < rad + mc.rad){
					return true;
				}
			}
			return false;
		}
		public function hitWhat(){
			var arr = new Array();
			for(var a in allAreas.length){
				var mc = allAreas[a];
				if(mc == this)
					continue;
				
				var dist = Math.pow(mc.x - x, 2) + Math.pow(mc.y - y, 2);
				if(dist < rad + mc.rad)
					arr.push(mc);
			}
			return arr;
		}
	}
}