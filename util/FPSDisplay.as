package util{
	import flash.display.*;
	import flash.text.*;
	import flash.utils.*;
	import flash.events.*;
	public class FPSDisplay extends Sprite {

		private var frameR:int=0;
		private var count:int=-1;
		private var textBx:TextField = new TextField();
		private var textFm:TextFormat=new TextFormat("Arial",12);

		public function FPSDisplay(stage:Object, xx:int, yy:int):void {

			var timer:Timer=new Timer(1000,0);
			timer.addEventListener(TimerEvent.TIMER, addCount);
			stage.addEventListener(Event.ENTER_FRAME , addFrame);

			this.graphics.lineStyle(1,0,1);
			this.graphics.beginFill(0xFFFFFF,1);
			this.graphics.drawRect(xx,yy,48,16);

			addChild(textBx);
			textBx.x=xx;
			textBx.y=yy;
			textBx.width=48;
			textBx.height=16;
			timer.start();
		}
		private function addCount(TimerEvent):void {
			frameR=count;
			count=-1;
			
			textBx.text="FPS "+String(frameR);
			textBx.setTextFormat(textFm);
		}
		private function addFrame(Event):void {
			count++;
		}
	}
}