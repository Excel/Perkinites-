package ui.hud{
	import actors.*;
	import util.*;

	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.*;
	import flash.ui.*;

	public class HUD_Unit extends MovieClip {
		static var maxHPWidth;
		static var currentHP;
		static var partnerHP;

		static public var autoUpdate;
		var currentScore;
		function HUD_Unit() {
			currentHP=-1;
			partnerHP=-1;
			autoUpdate=false;
			currentScore=0;
			maxHPWidth=hpbar.HP.width;

			qIcon.gotoAndStop(1);
			wIcon.gotoAndStop(1);
			eIcon.gotoAndStop(1);
			aIcon.gotoAndStop(1);
			sIcon.gotoAndStop(1);
			dIcon.gotoAndStop(1);

			addEventListener(Event.ENTER_FRAME, gameHandler);
		}

		public function gameHandler(e) {
			collide();
			updateHP();
			updateName();
			updateScore();
			
			updateHKeys();
			//updateProfile();
		}

		public function updateHKeys() {
			if (Unit.currentUnit.additional) {
				if (Unit.currentUnit.ahk1!=null) {
					aIcon.gotoAndStop(Unit.currentUnit.ahk1.index);
					aCount.visible=true;
					aCount.text=Unit.currentUnit.ahk1.uses;
				} else {
					aIcon.gotoAndStop(1);
					aCount.visible=false;
				}
				if (Unit.currentUnit.ahk2!=null) {
					sIcon.gotoAndStop(Unit.currentUnit.ahk2.index);
					sCount.visible=true;
					sCount.text=Unit.currentUnit.ahk2.uses;
				} else {
					sIcon.gotoAndStop(1);
					sCount.visible=false;
				}
				if (Unit.currentUnit.ahk3!=null) {
					dIcon.gotoAndStop(Unit.currentUnit.ahk3.index);
					dCount.visible=true;
					dCount.text=Unit.currentUnit.ahk3.uses;
				} else {
					dIcon.gotoAndStop(1);
					dCount.visible=false;

				}


			} else {
				if (Unit.currentUnit.hk1!=null) {
					aIcon.gotoAndStop(Unit.currentUnit.hk1.index);
					aCount.visible=true;
					aCount.text=Unit.currentUnit.hk1.uses;
				} else {
					aIcon.gotoAndStop(1);
					aCount.visible=false;
				}
				if (Unit.currentUnit.hk2!=null) {
					sIcon.gotoAndStop(Unit.currentUnit.hk2.index);
					sCount.visible=true;
					sCount.text=Unit.currentUnit.hk2.uses;
				} else {
					sIcon.gotoAndStop(1);
					sCount.visible=false;
				}
				if (Unit.currentUnit.hk3!=null) {
					dIcon.gotoAndStop(Unit.currentUnit.hk3.index);
					dCount.visible=true;
					dCount.text=Unit.currentUnit.hk3.uses;
				} else {
					dIcon.gotoAndStop(1);
					dCount.visible=false;
				}
			}

		}
		public function updateHP() {
			var u1;
			var u2;
			if (autoUpdate) {
				if (Unit.currentUnit!=null) {
					u1=Unit.currentUnit;
					currentHP=u1.HP;

					hpbar.HP.width=maxHPWidth*currentHP/u1.maxHP;
					if (currentHP<=0) {
						hpbar.HPCount.text="000";
					} else if (currentHP<10) {
						hpbar.HPCount.text="00"+currentHP;
					} else if (currentHP < 100) {
						hpbar.HPCount.text="0"+currentHP;
					} else {
						hpbar.HPCount.text=currentHP;
					}

				}
				if (Unit.partnerUnit!=null) {
					u2=Unit.partnerUnit;
					partnerHP=u2.HP;

				}
				if (partnerHP<=0) {
					hpbar.HPCount2.text="000";
				} else if (partnerHP<10) {
					hpbar.HPCount2.text="00"+partnerHP;
				} else if (partnerHP < 100) {
					hpbar.HPCount2.text="0"+partnerHP;
				} else {
					hpbar.HPCount2.text=partnerHP;
				}
				autoUpdate=false;
			} else {
				if (Unit.currentUnit!=null) {
					u1=Unit.currentUnit;
					if (currentHP==-1) {
						currentHP=u1.HP;
					}
					if (currentHP<u1.HP) {
						currentHP++;
					} else if (currentHP > u1.HP) {
						currentHP--;
					}

					hpbar.HP.width=maxHPWidth*currentHP/u1.maxHP;
					if (currentHP<=0) {
						hpbar.HPCount.text="000";
					} else if (currentHP<10) {
						hpbar.HPCount.text="00"+currentHP;
					} else if (currentHP < 100) {
						hpbar.HPCount.text="0"+currentHP;
					} else {
						hpbar.HPCount.text=currentHP;
					}

				}
				if (Unit.partnerUnit!=null) {
					u2=Unit.partnerUnit;
					if (partnerHP==-1) {
						partnerHP=u2.HP;
					}
					if (partnerHP<u2.HP) {
						partnerHP++;
					} else if (partnerHP > u2.HP) {
						partnerHP--;
					}
				}
				if (partnerHP<=0) {
					hpbar.HPCount2.text="000";
				} else if (partnerHP<10) {
					hpbar.HPCount2.text="00"+partnerHP;
				} else if (partnerHP < 100) {
					hpbar.HPCount2.text="0"+partnerHP;
				} else {
					hpbar.HPCount2.text=partnerHP;
				}
			}
		}
		public function updateName() {
			if (currentHP>=0) {
				unitName1.text=Unit.currentUnit.Name;
			}
			if (partnerHP>=0) {
				unitName2.text=Unit.partnerUnit.Name;
			}
		}
		public function updateScore() {
			var i=0;
			var limit=0;
			score.text="";
			if (currentScore<Unit.score) {
				currentScore+=100+Math.floor(Math.random()*2);
				for (i = 0; i < 10; i++) {
					if (Math.floor(currentScore/Math.pow(10,i+1))==0) {
						limit=9-i;
						break;
					}
				}
				for (i = 0; i < limit; i++) {
					score.appendText("0");
				}
				score.appendText(currentScore);
			} else if (Unit.score == 0) {
				currentScore=0;
				for (i = 0; i < limit; i++) {
					score.appendText("0");
				}
			}
			if (currentScore>=Unit.score) {
				currentScore=Unit.score;
				for (i = 0; i < 10; i++) {
					if (Math.floor(currentScore/Math.pow(10,i+1))==0) {
						limit=9-i;
						break;
					}
				}
				for (i = 0; i < limit; i++) {
					score.appendText("0");
				}
				score.appendText(currentScore);
			}


		}
		public function collide() {
			var u1;
			var u2;
			if (Unit.currentUnit!=null) {
				u1=Unit.currentUnit;
			}
			if (Unit.partnerUnit!=null) {
				u2=Unit.partnerUnit;
			}

			if (this.hitTestObject(u1)||this.hitTestObject(u2)) {
				if (alpha>0.5) {
					alpha-=0.1;
				}
			} else {
				if (alpha<1) {
					alpha+=0.1;
				}
			}
		}


	}


}