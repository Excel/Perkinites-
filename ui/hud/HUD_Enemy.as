package ui.hud{
	import actors.*;
	import enemies.*;
	import util.*;

	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.*;
	import flash.ui.*;

	public class HUD_Enemy extends MovieClip {
		public var currentEnemy;
		public var eHPBar;
		public var healthUnits:Array;

		function HUD_Enemy() {
			x=79;
			y=2;
			this.visible=false;
			addEventListener(Event.ENTER_FRAME, collideHandler);
		}

		public function collideHandler(e) {
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
		public function updateTarget(enemy:Enemy = null) {
			currentEnemy=enemy;
			if (enemy!=null) {

				eHPBar=new HealthBar(enemy.HP,enemy.maxHP,enemy,400,true);
				addChild(eHPBar);
				eHPBar.x=85.5;
				eHPBar.y=19;
				enemyName.text=currentEnemy.Name;
				this.visible=true;
				updateHP(enemy.HP, enemy.maxHP);


			} else {
				this.visible=false;
			}
		}
		public function updateHP(HP:int, maxHP:int) {
			eHPBar.update(HP, maxHP);
			HPDisplay.text=HP+"";
		}

		public function collide() {


		}
	}


}