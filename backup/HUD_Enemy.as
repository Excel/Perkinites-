package ui.hud{
	import actors.*;
	import util.*;

	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.*;
	import flash.ui.*;

	public class HUD_Enemy extends MovieClip {
		var maxHPWidth;
		static var currentHP;
		static var currentEnemy;

		function HUD_Enemy() {
			currentHP=-1;
			maxHPWidth=ehpbar.HP.width;

			addEventListener(Event.ENTER_FRAME, gameHandler);
		}

		public function gameHandler(e) {
			collide();
			/*updateHP();
			updateName();
			*/
		}
		public static function updateTarget(enemy) {
			if (currentEnemy!=enemy) {
				currentEnemy=enemy;
				currentHP=enemy.maxHP;
			}
		}
		public function updateHP() {
			if (currentHP>=0) {
				ehpbar.HPDisplay.text=currentEnemy.HP;
				if (currentHP<currentEnemy.HP) {
					currentHP++;
				} else if (currentHP > currentEnemy.HP) {
					currentHP--;
				}
				ehpbar.HP.x = 86.5 + maxHPWidth*(currentEnemy.maxHP-currentHP)/currentEnemy.maxHP;
				ehpbar.HP.width=maxHPWidth*currentHP/currentEnemy.maxHP;
			} else {
				ehpbar.HPDisplay.text="000";
			}
		}
		public function updateName() {
			if (currentHP>=0) {
				enemyName.text=currentEnemy.Name;
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