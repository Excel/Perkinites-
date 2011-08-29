package game{

	import actors.Unit;
	import enemies.Enemy;
	import game.GameVariables;
	import tileMapper.ScreenRect;
	import tileMapper.TileMap;
	
	
	import flash.events.Event;
	import flash.geom.Point;
	
   
	import flash.display.MovieClip;
	
	/**
     * Handles the movement for all GameUnits.
     */
	
    public class MovementManager extends MovieClip {
		 

		/**
		 * 
		 * Teleports the passed GameUnit to its destination.
		 * @param	object
		 * @param	targetX
		 * @param	targetY
		 */
		public static function teleportObject(object:GameUnit, targetX:Number, targetY:Number):void {
			
		}
		/**
		 * 
		 * Moves the passed GameUnit to its destination.
		 * 
		 * @param	object
		 * @param	targetX
		 * @param	targetY
		 */
		 public static function moveObject(object:GameUnit, targetX:Number, targetY:Number):void {
			var path = new Array();
			object.startAnimation(object.dir);
			object.mxpos = targetX;
			object.mypos = targetY;			
			
			//really big bug to fix - hitting nonpassable tiles causes crappy movement.
			//hackhackhack
			if (TileMap.hitNonpass(targetX, targetY)) {
				teleportObject(object, targetX, targetY);
			} else{
				path = TileMap.findPath(TileMap.map, new Point(Math.floor(object.x/32), Math.floor(object.y/32)),
				  new Point(Math.floor(object.mxpos/32), Math.floor(object.mypos/32)), 
				  false, true);
				path = smoothPath(path);
				
				object.path = path;
				object.addEventListener(Event.ENTER_FRAME, moveHandler);
			}
        }
		
		/**
		 * 
		 * Ignores some of the intermediate tile destinations for more realistic movement.
		 * @param	path - the path to modify
		 * @return the smoothed path
		 */
		
		public static function smoothPath(path:Array):Array {
			if (path.length>0) {
				var newPath=new Array(path[0]);

				var currentIndex=0;
				var pushIndex=0;
				var nextIndex=1;

				if (path[0]==path[path.length-1]) {
					return newPath;
				}
				if (TileMap.walkable(path[0],path[path.length-1])) {
					newPath=new Array(path[0],path[path.length-1]);
					return newPath;

				}
				while (nextIndex < path.length) {

					if (TileMap.walkable(path[nextIndex],path[path.length-1])) {
						newPath.push(path[nextIndex]);
						newPath.push(path[path.length-1]);
						return newPath;
					} else if (TileMap.walkable(path[currentIndex],path[nextIndex])) {
						pushIndex=nextIndex;
					} else {
						if (currentIndex!=pushIndex) {
							newPath.push(path[pushIndex]);
						}
						currentIndex=pushIndex;
					}
					nextIndex++;
				}
				newPath.push(path[path.length-1]);
				return newPath;
			} else {
				return new Array();
			}
		}
		
		/**
		 * 
		 * the movement handler. 
		 * @param	e - Event.ENTER_FRAME
		 */
		public static function moveHandler(e:Event):void {
			var object = e.target;
			if (object.path.length > 0) {
				var dist=Math.sqrt(Math.pow(object.mxpos-object.x,2)+Math.pow(object.mypos-object.y,2));
				object.checkLoop();
				if (dist>0&&dist>object.range) {
					var xtile=Math.floor(object.x/32);
					var ytile=Math.floor(object.y/32);
					if (xtile==object.path[0].x&&ytile==object.path[0].y) {
						object.path.splice(0, 1);

						if (object.path.length>0) {
							var xdest=object.path[0].x*32+16;
							var ydest=object.path[0].y*32+16;
							object.radian=Math.atan2(ydest-object.y,xdest-object.x);
							object.faceDirection(object.radian);
						}
					}
					if (object.path.length>0) {
						object.moving=true;
						var speed;
						if (object is Unit || object is Enemy) {
							speed = object.getSpeed();
						}
						else {
							speed = object.speed;
						}
						object.x+=speed*Math.cos(object.radian)/24;
						object.y+=speed*Math.sin(object.radian)/24;

					} else {
						object.moving=false;
					}
				}				
			} else {
				object.moving=false;
			}
			if (! object.moving && object.range == 0) {
				object.x=object.mxpos;
				object.y=object.mypos;
				object.stopAnimation();
				object.removeEventListener(Event.ENTER_FRAME, moveHandler);
			}
		}		
		
		
    }
}