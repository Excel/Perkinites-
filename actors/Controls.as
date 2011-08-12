package actors{

	import game.Game;
	import game.GameUnit;
	import game.GameVariables;
	import tileMapper.TileMap;
	import tileMapper.ScreenRect;
	import ui.screens.Menu;
	import util.KeyDown;

	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class Controls {

		public var mouseIsDown=false;

		public var mainGame:Game;
		public var stageRef:Stage;

		public var menu:Menu;

		public var lockableKeys:Array=new Array(72,88);
		public var lockedKeys:Array = new Array();
		public var disabledKeys:Array = new Array();



		/**
		 * @param game The game's <code>Game</code> object.
		 * @param movementHandler The game's <code>MovementHandler</code> object.
		 * @param inputHandler The game's <code>InputHandler</code> object.
		 */

		public function Controls(mainGame:Game, stageRef:Stage) {
			this.mainGame=mainGame;
			this.stageRef=stageRef;
		}

		/**
		 * 
		 * Starts listening for keystrokes.
		 * 
		 */

		public function enable():void {
			stageRef.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			stageRef.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			stageRef.addEventListener(Event.ENTER_FRAME, moveHandler);
			stageRef.addEventListener(Event.ENTER_FRAME, handleKeyControls);
			//this._inputHandler.addEventListener(KeyEvent.KEYS_DOWN, this.handleKeyDown);
		}
		public function disable():void {
			stageRef.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			stageRef.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			stageRef.removeEventListener(Event.ENTER_FRAME, moveHandler);
			stageRef.removeEventListener(Event.ENTER_FRAME, handleKeyControls);
			//this._inputHandler.addEventListener(KeyEvent.KEYS_DOWN, this.handleKeyDown);
		}
		public function disableHotkeys():void {
			//this._inputHandler.addEventListener(KeyEvent.KEYS_DOWN, this.handleKeyDown);
		}

		protected function handleKeyControls(e:Event):void {

			// 88 = x
			if (KeyDown.keyIsDown(88)&&! lockedKeys[88]&&! GameUnit.objectPause) {
				if (GameUnit.menuPause) {
					for (var i = 0; i < stageRef.numChildren; i++) {
						if (stageRef.getChildAt(i) is Menu) {
							Menu(stageRef.getChildAt(i)).exit();
							break;
						}
					}
				} else {
					menu=new Menu(stageRef);
				}
			}

			for each (var key:int in lockableKeys) {
				if (KeyDown.keyIsDown(key)) {
					lockedKeys[key]=true;
				} else if (lockedKeys[key]) {
					delete lockedKeys[key];
				}
			}


		}


		public function mouseDownHandler(e:MouseEvent):void {
			mouseIsDown=true;
		}
		public function mouseUpHandler(e:MouseEvent):void {
			mouseIsDown=false;
		}
		public function moveHandler(e:Event):void {
			if (GameVariables.mouseEnemy) {

			} else if (GameVariables.mouseMapObject) {

			} else {
				
				Unit.currentUnit.startAnimation(Unit.currentUnit.dir);
				Unit.partnerUnit.startAnimation(Unit.partnerUnit.dir);				
				if (! GameUnit.superPause&&! GameUnit.menuPause&&! GameUnit.objectPause&&mouseIsDown) {
					Unit.currentUnit.mxpos=Math.floor( (stageRef.mouseX+ScreenRect.getX())/32)*32 + 16;
					Unit.currentUnit.mypos=Math.floor( (stageRef.mouseY+ScreenRect.getY())/32)*32 + 16;
					Unit.currentUnit.range=0;
					Unit.currentUnit.path = TileMap.findPath(TileMap.map, new Point(Math.floor(Unit.currentUnit.x/32), Math.floor(Unit.currentUnit.y/32)),
					  new Point(Math.floor(Unit.currentUnit.mxpos/32), Math.floor(Unit.currentUnit.mypos/32)), 
					  false, true);
					Unit.currentUnit.path=Unit.currentUnit.smoothPath();
					if (Unit.currentUnit.path.length==0) {
						Unit.currentUnit.mxpos=Unit.currentUnit.x;
						Unit.currentUnit.mypos=Unit.currentUnit.y;

					}//this.parent.

					Unit.partnerUnit.mxpos=Math.floor((stageRef.mouseX+ScreenRect.getX())/32)*32 + 16;//+Math.floor(Math.random()*64-32);
					Unit.partnerUnit.mypos=Math.floor((stageRef.mouseY+ScreenRect.getY())/32)*32 + 16;//+Math.floor(Math.random()*64-32);

					Unit.partnerUnit.range=0;

					Unit.partnerUnit.path = TileMap.findPath(TileMap.map, new Point(Math.floor(Unit.partnerUnit.x/32), Math.floor(Unit.partnerUnit.y/32)),
					  new Point(Math.floor(Unit.partnerUnit.mxpos/32), Math.floor(Unit.partnerUnit.mypos/32)), 
					  false, true);
					Unit.partnerUnit.path=Unit.partnerUnit.smoothPath();

					if (Unit.partnerUnit.path.length==0) {
						Unit.partnerUnit.mxpos=Unit.partnerUnit.x;
						Unit.partnerUnit.mypos=Unit.partnerUnit.y;
					}
				}
			}

		}

	}
}