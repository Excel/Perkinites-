package ui.screens{

	import flash.text.TextField;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.*;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;

	import game.*;
	import levels.*;
	public class StageSelect extends BaseScreen {

		public var level:int;
		static public var maxLevel:int;
		public var diff:int;
		static public var Ananya:Boolean=false;

		static public var selectedArea:String="";

		public var decide:Boolean;
		public var stageArray:Array;
		public var difficultyArray:Array;

		public var arrowGlowFilters:Array;
		function StageSelect(level:int, diff:int, stageRef:Stage) {
			this.level=level;
			this.diff=diff;
			if (this.diff==-1) {
				this.diff=1;
			}
			this.stageRef=stageRef;

			maxLevel=GameVariables.maxStageLevel;

			decide=false;
			
			stageArray=new Array("Perkins Hall","Josiah's","Sharpe Refectory","Watson Center (CIT)","Sciences Library","???","???");
/*			difficultyArray = new Array([1, 4, 7, 19],
			  [1, 4, 7, 10],
			  [1, 5, 7, 10],
			  [1, 5, 8, 10],
			  [2, 6, 9, 10],
			  [3, 7, 10, 11],
			  [4, 7, 10, 11]);*/
			difficultyArray = new Array([1, 4, 7, 19],
			  [2, 5, 8, 11],
			  [3, 6, 9, 12],
			  [4, 7, 11, 14],
			  [5, 8, 12, 15],
			  [6, 9, 14, 16],
			  [7, 10, 15, 18]);
			arrowGlowFilters=[];

			if(selectedArea == ""){
				selectedArea=stageArray[0];
			}
			difficultyIcon.gotoAndStop(1);
			updateText();
			updateDifficulty();
			updateMarkers();

			addEventListener(MouseEvent.MOUSE_DOWN, dragMap);
			stageRef.addEventListener(Event.MOUSE_LEAVE, mouseLeaveHandler);

			load();

		}

		override public function keyHandler(e:KeyboardEvent):void {
			var sound;
			if (decide) {
			} else {
				if (e.keyCode==Keyboard.DOWN||e.keyCode=="S".charCodeAt(0)) {
					diff++;
					if (Ananya&&diff>3) {
						diff=0;
					} else if (!Ananya && diff>2) {
						diff=0;
					}
					sound = new se_timeout();
					sound.play();
				} else if (e.keyCode == Keyboard.UP || e.keyCode == "W".charCodeAt(0)) {
					diff--;
					if (diff<0) {
						if (Ananya) {
							diff=3;
						} else {
							diff=2;
						}
					}
					sound = new se_timeout();
					sound.play();
				} else if (e.keyCode == "X".charCodeAt(0)) {
					sound = new se_timeout();
					sound.play();
				} else if (e.keyCode == Keyboard.SPACE) {
					if (selectedArea!="") {
						sound = new se_chargeup();
						sound.play();
						GameVariables.setLevel=level;
						GameVariables.difficulty=diff;
						unload(new PlayerSelect(stageRef));
					} else {

					}
				}

				updateDifficulty();
				updateText();

			}
		}

		public function selectHandler(e) {
			var sound = new se_chargeup();
			sound.play();
			GameVariables.setLevel=level;
			GameVariables.difficulty=diff;
			unload(new PlayerSelect(stageRef));
		}

		public function updateDifficulty() {
			difficultyIcon.gotoAndStop(diff+1);
			if(difficultyArray[level-1][diff] > 15){
				difficultyIcon.diffLevel.text = "!!!!";
			}
			else{
			difficultyIcon.diffLevel.text=difficultyArray[level-1][diff];
		}
		}


		public function updateText() {
			if (selectedArea!="") {
				stageNumber.text=stageArray.indexOf(selectedArea)+1+"";
				stageName.text=selectedArea;
			} else {
				stageNumber.text="";
				stageName.text="";
			}

			switch (diff) {
				case 0 :
					difficultyDescription.text="Units deal 1.5x damage.\n\nEnemies deal 1x damage.\n\nEnemies are average.";
					break;
				case 1 :
					difficultyDescription.text="Units deal 1x damage.\n\nEnemies deal 1x damage.\n\nEnemies are tricky.";
					break;
				case 2 :
					difficultyDescription.text="Units deal 1x damage.\n\nEnemies deal 2x damage.\n\nEnemies are advanced.";
					break;
				case 3 :
					difficultyDescription.text="Units deal 1x damage.\n\nEnemies deal 3x damage.\n\nEnemies take after Ananya. AKA, they will f**king destroy you.";
					break;
			}
		}

		public function updateMarkers() {
			var areaMarkers=new Array(map.perkins,map.josiah,map.ratty,map.cit,map.scili,map.xx,map.yy);

			for (var i = 0; i < maxLevel; i++) {
				areaMarkers[i].stageNumber=i+1;
				areaMarkers[i].addEventListener(MouseEvent.MOUSE_DOWN, setStageHandler);
			}
			for (i = i; i < 7; i++) {
				areaMarkers[i].visible=false;
			}
		}

		public function setStageHandler(e) {
			var obj=e.target;
			selectedArea=stageArray[obj.stageNumber-1];
			level = obj.stageNumber;

			/*switch(obj.stageNumber){
			case 1: 
			break;
			}*/
			updateText();
			updateDifficulty();
		}

		public function dragMap(e) {
			map.startDrag(false, new Rectangle(-370,-610,150,500));
			addEventListener(MouseEvent.MOUSE_UP, releaseMap);
		}
		public function releaseMap(e) {
			map.stopDrag();
			stageRef.focus=null;
			removeEventListener(MouseEvent.MOUSE_UP, releaseMap);
		}
		private function mouseLeaveHandler(e:Event):void {
			map.stopDrag();
			stageRef.addEventListener(MouseEvent.MOUSE_MOVE, mouseReturnHandler);
		}

		private function mouseReturnHandler(e:Event):void {
			map.stopDrag();
			stageRef.removeEventListener(MouseEvent.MOUSE_MOVE, mouseReturnHandler);
		}
	}
}