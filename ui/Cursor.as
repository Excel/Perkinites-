package ui{

	import game.*;
	
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.*;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.ui.Mouse;


	public class Cursor extends MovieClip {

		private var stageRef:Stage;
		private var p:Point = new Point();//keeps up with last known mouse position

		private var enemyFilter=new GlowFilter(0xFF0000,250,3,3,3,10,false,false);
		private var moveFilter=new GlowFilter(0x00FFCB,250,3,3,3,10,false,false);
		private var unitFilter=new GlowFilter(0x330066,250,3,3,3,10,false,false);
		private var talkFilter=new GlowFilter(0x00FF00,250,3,3,3,10,false,false);

		public function Cursor(stageRef:Stage) {
			Mouse.hide();//make the mouse disappear
			mouseEnabled=false;
			mouseChildren=false;

			this.stageRef=stageRef;
			x=stageRef.mouseX;
			y=stageRef.mouseY;
			gotoAndStop(1);
			this.filters=[moveFilter];
			stageRef.addEventListener(MouseEvent.MOUSE_MOVE, updateMouse);
			stageRef.addEventListener(Event.MOUSE_LEAVE, mouseLeaveHandler);
			stageRef.addEventListener(Event.ADDED, updateStack);
			stageRef.addEventListener(Event.ENTER_FRAME, changeMouseType);
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
			if (GameUnit.menuPause) {
				visible=false;
				Mouse.show();
			}
			else{
				visible=true;
				Mouse.hide();//in case of right click
				removeEventListener(MouseEvent.MOUSE_MOVE, mouseReturnHandler);
			}
		}

		private function updateMouse(e:MouseEvent):void {
			/*x=Math.floor(stageRef.mouseX/32)*32+16;
			y=Math.floor(stageRef.mouseY/32)*32+16;*/
			x=stageRef.mouseX;
			y=stageRef.mouseY;

			p.x=x;
			p.y=y;

			e.updateAfterEvent();
		}

		public function changeMouseType(e:Event):void {
			if (GameUnit.menuPause) {
				this.filters = [];
				this.type1.text = "Menu";
				visible=false;
				Mouse.show();
			}
			else {
				visible=true;
				Mouse.hide();
				if (GameUnit.objectPause || GameUnit.superPause) {
					this.filters = [];
					this.type1.text = "";
				}
				else if (GameVariables.mouseEnemy) {
					this.filters=[enemyFilter];
					this.type1.text = "Enemy";
				} else if (GameVariables.mouseAttack){
					this.filters=[enemyFilter];
					this.type1.text = "Warning";
				}else if (GameVariables.mouseMapObject) {
					this.filters=[talkFilter];
					this.type1.text = "Talk";
				} else if (GameVariables.mouseUnit) {
					this.filters=[unitFilter];
					this.type1.text = "Unit";
				} else {
					this.filters=[moveFilter];
					this.type1.text = "Move";
				}
			}
			
		}

	}
}