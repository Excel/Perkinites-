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
			updateHP();
			updateName();
		}
		public static function updateTarget(enemy) {
			if (currentEnemy!=enemy) {
				currentEnemy=enemy;
				currentHP=enemy.maxHealth;
			}
		}
		public function updateHP() {
			if (currentHP>=0) {
				ehpbar.HPCount.text=currentEnemy.eHealth;
				if (currentHP<currentEnemy.eHealth) {
					currentHP++;
				} else if (currentHP > currentEnemy.eHealth) {
					currentHP--;
				}
				ehpbar.HP.x = 54.8 + maxHPWidth*(currentEnemy.maxHealth-currentHP)/currentEnemy.maxHealth;
				ehpbar.HP.width=maxHPWidth*currentHP/currentEnemy.maxHealth;
			} else {
				ehpbar.HPCount.text="000";
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