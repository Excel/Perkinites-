package tileMapper{
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	public class ScreenRect{
		public static var screen:Rectangle = new Rectangle();
		
		static var clips:Array;
		public static var STAGE_WIDTH;
		public static var STAGE_HEIGHT;
		
		public static function createScreenRect(c, w, h){
			
			clips = c;
			STAGE_WIDTH = w;
			STAGE_HEIGHT = h;
		}
		public static function easeScreen(p){
			if(screen == null)
				screen = new Rectangle(p.x, p.y, STAGE_WIDTH, STAGE_HEIGHT);
			else
				screen = new Rectangle(p.x * .2 + screen.x * .8, p.y * .2 + screen.y * .8, STAGE_WIDTH, STAGE_HEIGHT);
			for(var a in clips){
				clips[a].scrollRect = screen;
			}
		}
		public static function getX(){
			return screen.x;
		}
		public static function getY(){
			return screen.y;
		}
		
		public static function setX(ox){
			screen = new Rectangle(ox, screen.y, STAGE_WIDTH, STAGE_HEIGHT);
			for(var a in clips){
				clips[a].scrollRect = screen;
			}
		}
		public static function setY(oy){
			screen = new Rectangle(screen.x, oy, STAGE_WIDTH, STAGE_HEIGHT);
			for(var a in clips){
				clips[a].scrollRect = screen;
			}
		}
		
		public static function inBounds(obj){
			return obj.x >= screen.x && obj.y >= screen.y && obj.x <= screen.x+STAGE_WIDTH && obj.y <= screen.y + STAGE_HEIGHT;
		}
	}
}