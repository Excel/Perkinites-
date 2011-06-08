package com{
	import flash.geom.Point;
	public class EnemySetup extends Point{
		public var type:Number
		function EnemySetup(ox:Number, oy:Number, t:Number){
			super(ox, oy);
			
			type = t;
		}
	}
}