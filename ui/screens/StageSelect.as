package ui.screens{

	import flash.text.TextField;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.*;
	import flash.filters.GlowFilter;
	import flash.ui.Keyboard;

	import game.*;
	import levels.*;
	public class StageSelect extends BaseScreen {

		public var level:int;
		static public var maxLevel:int;
		public var diff:int;
		static public var Ananya:Boolean=false;

		public var decide:Boolean;
		public var stageArray:Array;
		public var bossArray:Array;
		public var difficultyArray:Array;

		public var arrowGlowFilters:Array;
		function StageSelect(level:int, diff:int, stageRef:Stage) {
			this.level=level;
			this.diff=diff;
			if (this.diff==-1) {
				this.diff=0;
			}
			this.stageRef=stageRef;

			maxLevel=GameVariables.maxStageLevel;

			decide=false;

			stageArray=new Array("Perkins Hall","KK","CIT","JWW","Sciences Library","???","???");
			bossArray=new Array("Unknown Intruder","DH","UN","KA","???","Helix D.","???");
			difficultyArray = new Array([1, 4, 7, 9],
			  [1, 4, 7, 10],
			  [1, 5, 7, 10],
			  [1, 5, 8, 10],
			  [2, 6, 9, 10],
			  [3, 7, 10, 11],
			  [4, 7, 10, 11]);

			arrowGlowFilters=[];

			displayIcon1.gotoAndStop(1);
			displayIcon2.gotoAndStop(1);
			displayIcon3.gotoAndStop(1);

			displayIcon2.addEventListener(MouseEvent.CLICK, selectHandler);

			arrow1.addEventListener(MouseEvent.MOUSE_DOWN, downHandler1);
			arrow1.addEventListener(MouseEvent.MOUSE_UP, upHandler1);
			arrow2.addEventListener(MouseEvent.MOUSE_DOWN, downHandler2);
			arrow2.addEventListener(MouseEvent.MOUSE_UP, upHandler2);

			difficultyIcon.gotoAndStop(1);
			updateText();
			updateDifficulty();
			updateIcons();
			
			load();

		}
		public function downHandler1(e) {
			/*var gf1=new GlowFilter(0xFFFFFF,100,3,3,5,15,false,false);
			var gf2=new GlowFilter(0x000000,100,2,2,5,15,false,false);
			arrow1.filters = [gf2, gf1];
			*/
			arrow1.x=210.3;
			arrow1.y=201.5;
			arrow1.scaleX=0.75;
			arrow1.scaleY=0.75;

			level--;
			if (level<=0) {
				level=maxLevel;
			}
			var sound = new se_timeout();
			sound.play();

			updateDifficulty();
			updateText();
			updateIcons();
		}
		public function upHandler1(e) {
			arrow1.x=206;
			arrow1.y=198.5;
			arrow1.scaleX=1;
			arrow1.scaleY=1;

		}
		public function downHandler2(e) {
			arrow2.x=429.5;
			arrow2.y=219.3;
			arrow2.scaleX=0.75;
			arrow2.scaleY=0.75;

			level++;
			if (level>maxLevel) {
				level=1;
			}
			var sound = new se_timeout();
			sound.play();

			updateDifficulty();
			updateText();
			updateIcons();
		}
		public function upHandler2(e) {
			arrow2.x=433.8;
			arrow2.y=222.3;
			arrow2.scaleX=1;
			arrow2.scaleY=1;
		}

		override public function keyHandler(e:KeyboardEvent):void {
			var sound;
			if (decide) {
			} else {
				if (e.keyCode==Keyboard.LEFT||e.keyCode=="A".charCodeAt(0)) {
					level--;
					if (level<=0) {
						level=maxLevel;
					}
					sound = new se_timeout();
					sound.play();

				} else if (e.keyCode == Keyboard.RIGHT || e.keyCode == "D".charCodeAt(0)) {
					level++;
					if (level>maxLevel) {
						level=1;
					}
					sound = new se_timeout();
					sound.play();

				} else if (e.keyCode == Keyboard.DOWN || e.keyCode == "S".charCodeAt(0)) {
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
					sound = new se_chargeup();
					sound.play();
					SuperLevel.setLevel=level;
					SuperLevel.diff=diff;//change this
					GameVariables.difficulty=diff;
					unload(new PlayerSelect(stageRef));

				}

				updateDifficulty();
				updateText();
				updateIcons();

			}
		}

		public function selectHandler(e) {
			var sound = new se_chargeup();
			sound.play();
			SuperLevel.setLevel=level;
			SuperLevel.diff=diff;
			GameVariables.difficulty=diff;
			unload(new PlayerSelect(stageRef));
		}

		public function updateDifficulty() {
			difficultyIcon.gotoAndStop(diff+1);
			difficultyIcon.diffLevel.text=difficultyArray[level-1][diff];
		}


		public function updateText() {
			stageNumber.text=level+"";
			stageName.text=stageArray[level-1];
			bossName.text=bossArray[level-1];

			switch (diff) {
				case 0 :
					difficultyDescription.text="Units deal 1.5x damage.\n\nEnemies deal 1x damage.";
					break;
				case 1 :
					difficultyDescription.text="Units deal 1x damage.\n\nEnemies deal 1x damage.";
					break;
				case 2 :
					difficultyDescription.text="Units deal 1x damage.\n\nEnemies deal 2x damage.";
					break;
				case 3 :
					difficultyDescription.text="Units deal 1x damage.\n\nEnemies deal 3x damage.";
					break;
			}
		}
		public function updateIcons() {
			displayIcon2.gotoAndStop(level);
			if (level-1<=0) {
				displayIcon1.gotoAndStop(maxLevel);
			} else {
				displayIcon1.gotoAndStop(level-1);
			}
			if (level+1>maxLevel) {
				displayIcon3.gotoAndStop(0);

			} else {
				displayIcon3.gotoAndStop(level+1);
			}

		}
	}
}