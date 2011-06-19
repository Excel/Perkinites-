package ui{

	import flash.text.TextField;
	import actors.*;

	import flash.display.MovieClip;
	import flash.events.*;
	import flash.ui.*;
	import flash.filters.GlowFilter;

	public class RangeInfo extends MovieClip{
		
		public var unitRef:Unit;
		function RangeInfo(unitRef:Unit = null, range:int = 0) {

			this.unitRef=unitRef;
			unitRef.addChildAt(this, 0);
			width = range;
			height = range;
			trace(range);
		}
	}
}