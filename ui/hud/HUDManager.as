﻿package ui.hud{

	import actors.*;
	import enemies.*;
	import game.*;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.*;
	import flash.ui.*;
	import flash.utils.Timer;

	public class HUDManager extends MovieClip {

		static public var unitHUD = new HUD_Unit();
		static public var enemyHUD = new HUD_Enemy();

		static public function construct(stageRef:Stage) {
			stageRef.addChild(unitHUD);
			stageRef.addChild(enemyHUD);
		}
		static public function deconstruct(stageRef:Stage){
			stageRef.removeChild(unitHUD);
			stageRef.removeChild(enemyHUD);
		}
		static public function toggleUnitHUD(showHUD:Boolean) {
			if (showHUD) {
				unitHUD.visible = true;
			} else {
				unitHUD.visible = false;
			}
		}
		static public function toggleEnemyHUD(showHUD:Boolean) {
			if (showHUD) {
				enemyHUD.visible = true;
			} else {
				enemyHUD.visible = false;
			}

		}
		static public function getUnitHUD(){
			return unitHUD;
		}
		static public function getEnemyHUD(){
			return enemyHUD;
		}
	}
}