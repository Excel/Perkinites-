package ui.hud{
	import flash.text.TextField;
	import actors.*;
	import abilities.*;
	import items.*;
	import util.*;

	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.*;
	import flash.ui.*;

	public class HUD_Unit extends MovieClip {
		var currentHP;
		var partnerHP;
		
		var currentScore;
		function HUD_Unit() {
			x=0;
			y=385;
			currentHP=-1;
			partnerHP=-1;
			currentScore=0;


			hotkeyHolder.qIcon.gotoAndStop(1);
			hotkeyHolder.wIcon.gotoAndStop(1);
			hotkeyHolder.eIcon.gotoAndStop(1);
			hotkeyHolder.aIcon.gotoAndStop(1);
			hotkeyHolder.sIcon.gotoAndStop(1);
			hotkeyHolder.dIcon.gotoAndStop(1);
			hotkeyHolder.fIcon.gotoAndStop(1);
			
			ffIcon.gotoAndStop(1);

			/*healthBar1=new HealthBar(Unit.currentUnit.HP,Unit.currentUnit.maxHP);
			healthBar2=new HealthBar(Unit.partnerUnit.HP,Unit.partnerUnit.maxHP);
			healthBar1.x=32;
			healthBar1.y=16+64+2;
			healthBar2.x=144;
			healthBar2.y=16+64+2;
			addChild(healthBar1);
			addChild(healthBar2);
			*/
			addEventListener(Event.ENTER_FRAME, gameHandler);
		}

		public function gameHandler(e) {
			collide();
			updateHP();
			updateName();
			//updateScore();

			updateHKeys();
			//updateProfile();
		}

		public function updateHKeys() {
			/*var index;
			if (Unit.currentUnit.hk1!=null) {
			var hk1=Unit.currentUnit.hk1;
			if (hk1 is Item) {
			index=ItemDatabase.getDatabaseIndex(hk1.Name);
			qIcon.useCount.text=ItemDatabase.getUses(index)+"";
			} else if (hk1 is Ability) {
			qIcon.useCount.text=hk1.uses;
			}
			qIcon.gotoAndStop(hk1.index);
			qIcon.useCount.visible=true;
			
			} else {
			qIcon.gotoAndStop(1);
			qIcon.useCount.visible=false;
			}
			
			
			if (Unit.currentUnit.hk2!=null) {
			var hk2=Unit.currentUnit.hk2;
			if (hk2 is Item) {
			index=ItemDatabase.getDatabaseIndex(hk2.Name);
			wIcon.useCount.text=ItemDatabase.getUses(index)+"";
			} else if (hk2 is Ability) {
			wIcon.useCount.text=hk2.uses;
			}
			wIcon.gotoAndStop(hk2.index);
			wIcon.useCount.visible=true;
			
			} else {
			wIcon.gotoAndStop(1);
			wIcon.useCount.visible=false;
			}
			
			if (Unit.currentUnit.hk3!=null) {
			var hk3=Unit.currentUnit.hk3;
			if (hk3 is Item) {
			index=ItemDatabase.getDatabaseIndex(hk3.Name);
			eIcon.useCount.text=ItemDatabase.getUses(index)+"";
			} else if (hk3 is Ability) {
			eIcon.useCount.text=hk3.uses;
			}
			eIcon.gotoAndStop(hk3.index);
			eIcon.useCount.visible=true;
			
			} else {
			eIcon.gotoAndStop(1);
			eIcon.useCount.visible=false;
			}
			
			
			if (Unit.currentUnit.hk4!=null) {
			var hk4=Unit.currentUnit.hk4;
			if (hk4 is Item) {
			index=ItemDatabase.getDatabaseIndex(hk4.Name);
			aIcon.useCount.text=ItemDatabase.getUses(index)+"";
			} else if (hk4 is Ability) {
			aIcon.useCount.text=hk4.uses;
			}
			aIcon.gotoAndStop(hk4.index);
			aIcon.useCount.visible=true;
			
			} else {
			aIcon.gotoAndStop(1);
			aIcon.useCount.visible=false;
			}
			
			
			if (Unit.currentUnit.hk5!=null) {
			var hk5=Unit.currentUnit.hk5;
			if (hk5 is Item) {
			index=ItemDatabase.getDatabaseIndex(hk5.Name);
			sIcon.useCount.text=ItemDatabase.getUses(index)+"";
			} else if (hk5 is Ability) {
			sIcon.useCount.text=hk5.uses;
			}
			sIcon.gotoAndStop(hk5.index);
			sIcon.useCount.visible=true;
			
			} else {
			sIcon.gotoAndStop(1);
			sIcon.useCount.visible=false;
			}
			if (Unit.currentUnit.hk6!=null) {
			var hk6=Unit.currentUnit.hk6;
			if (hk6 is Item) {
			index=ItemDatabase.getDatabaseIndex(hk6.Name);
			dIcon.useCount.text=ItemDatabase.getUses(index)+"";
			} else if (hk6 is Ability) {
			dIcon.useCount.text=hk6.uses;
			}
			dIcon.gotoAndStop(hk6.index);
			dIcon.useCount.visible=true;
			
			} else {
			dIcon.gotoAndStop(1);
			dIcon.useCount.visible=false;
			}
			*/
		}
		public function updateHP() {

			if (Unit.currentUnit!=null&&Unit.currentUnit.id!=-1) {
				var u1=Unit.currentUnit;
				currentHP=u1.HP;
				if (currentHP<=0) {
					HPDisplay1.text="000";
				} else if (currentHP<10) {
					HPDisplay1.text="00"+currentHP;
				} else if (currentHP < 100) {
					HPDisplay1.text="0"+currentHP;
				} else {
					HPDisplay1.text=currentHP;
				}
				//healthBar1.update(Unit.currentUnit.HP, Unit.currentUnit.maxHP);
			}
			if (Unit.partnerUnit!=null&&Unit.partnerUnit.id!=-1) {
				var u2=Unit.partnerUnit;
				partnerHP=u2.HP;
				if (partnerHP<=0) {
					HPDisplay2.text="000";
				} else if (partnerHP<10) {
					HPDisplay2.text="00"+partnerHP;
				} else if (partnerHP < 100) {
					HPDisplay2.text="0"+partnerHP;
				} else {
					HPDisplay2.text=partnerHP;
				}
				//healthBar2.update(Unit.partnerUnit.HP, Unit.partnerUnit.maxHP);
			}


			/*var u1;
			var u2;
			if (autoUpdate) {
			if (Unit.currentUnit!=null&&Unit.currentUnit.id!=-1) {
			u1=Unit.currentUnit;
			currentHP=u1.HP;
			
			hpbar.HP.width=maxHPWidth*currentHP/u1.maxHP;
			if (currentHP<=0) {
			HPDisplay1.text="000";
			} else if (currentHP<10) {
			HPDisplay1.text="00"+currentHP;
			} else if (currentHP < 100) {
			HPDisplay1.text="0"+currentHP;
			} else {
			HPDisplay1.text=currentHP;
			}
			
			}
			if (Unit.partnerUnit!=null&&Unit.partnerUnit.id!=-1) {
			u2=Unit.partnerUnit;
			partnerHP=u2.HP;
			
			}
			if (partnerHP<=0) {
			HPDisplay2.text="000";
			} else if (partnerHP<10) {
			HPDisplay2.text="00"+partnerHP;
			} else if (partnerHP < 100) {
			HPDisplay2.text="0"+partnerHP;
			} else {
			HPDisplay2.text=partnerHP;
			}
			autoUpdate=false;
			} else {
			if (Unit.currentUnit!=null&&Unit.currentUnit.id!=-1) {
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
			HPDisplay1.text="000";
			} else if (currentHP<10) {
			HPDisplay1.text="00"+currentHP;
			} else if (currentHP < 100) {
			HPDisplay1.text="0"+currentHP;
			} else {
			HPDisplay1.text=currentHP;
			}
			
			}
			if (Unit.partnerUnit!=null&&Unit.partnerUnit.id!=-1) {
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
			HPDisplay2.text="000";
			} else if (partnerHP<10) {
			HPDisplay2.text="00"+partnerHP;
			} else if (partnerHP < 100) {
			HPDisplay2.text="0"+partnerHP;
			} else {
			HPDisplay2.text=partnerHP;
			}
			}
			*/
		}

		public function updateName() {
			if (currentHP>=0) {
				unitName1.text=Unit.currentUnit.Name;
			}
			if (partnerHP>=0) {
				unitName2.text=Unit.partnerUnit.Name;
			}
		}
		/*public function updateScore() {
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
		*/
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