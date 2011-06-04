package ui{

	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.*;
	import flash.geom.Point;
	import flash.ui.Mouse;


	public class Cursor extends MovieClip {

		private var stageRef:Stage;
		private var p:Point = new Point();//keeps up with last known mouse position

		public function Cursor(stageRef:Stage) {
			Mouse.hide();//make the mouse disappear
			mouseEnabled=false;
			mouseChildren=false;

			this.stageRef=stageRef;
			x=stageRef.mouseX;
			y=stageRef.mouseY;
			gotoAndStop(1);

			stageRef.addEventListener(MouseEvent.MOUSE_MOVE, updateMouse);
			stageRef.addEventListener(Event.MOUSE_LEAVE, mouseLeaveHandler);
			stageRef.addEventListener(Event.ADDED, updateStack);
		}

		private function updateStack(e:Event):void {
			stageRef.addChild(this);
		}

		private function mouseLeaveHandler(e:Event):void {
			visible=false;
			Mouse.show();//in case of right click
			stageRef.addEventListener(MouseEvent.MOUSE_MOVE, mouseReturnHandler);
		}

		private function mouseReturnHandler(e:Event):void {
			visible=true;
			Mouse.hide();//in case of right click
			removeEventListener(MouseEvent.MOUSE_MOVE, mouseReturnHandler);
		}

		private function updateMouse(e:MouseEvent):void {
			x=stageRef.mouseX;
			y=stageRef.mouseY;

			p.x=x;
			p.y=y;

			e.updateAfterEvent();
		}

	}
}