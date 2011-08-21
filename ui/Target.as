package ui{

	import enemies.*;
	import game.*;

	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.*;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.ui.Mouse;


	public class Target extends MovieClip {

		public var enemyRef;

		private var filter1=new GlowFilter(0xFF0000,250,3,3,3,10,false,false);
		private var filter2=new GlowFilter(0x00FFCB,250,3,3,3,10,false,false);
		private var filter3=new GlowFilter(0x330066,250,3,3,3,10,false,false);
		private var filter4=new GlowFilter(0x00FF00,250,3,3,3,10,false,false);

		public function Target(enemyRef = null) {
			mouseEnabled=false;
			mouseChildren=false;

			this.filters=[filter1];
			alpha = 0.75;
			
			if(enemyRef != null){
				this.enemyRef=enemyRef;
				enemyRef.addChild(this);
			}
		}

		public function changeEnemy(enemyRef = null) {
			if(parent != null){
				parent.removeChild(this);
			}
			this.enemyRef=enemyRef;
			if(enemyRef != null){
				enemyRef.addChild(this);
			}
		}
	}
}