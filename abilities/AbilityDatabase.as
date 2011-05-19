package game{
	import ui.*;
	import ui.screens.*;

	import flash.display.MovieClip;
	import flash.events.*;
	import flash.ui.*;
	import flash.display.Stage;
	
	public class AbilityDatabase {
		
		public static const names = new Array("Eyelash Batting", "Sharp Shooter", "Update", "Cheer", ":]", ":]", ":]");
		public static const descriptions = new Array("Stun certain enemies.",
				"Increase your team's attack speeds and attack power for Ranger-type Abilities for fifteen seconds.",
				"Increase your team's dash speeds and reduce your team's cooldown times.",
				"Restores a small amount of HP to Christina every five seconds.",
				":O", ":O", ":O");
		
		// icon frame in fla
		public static const index = new Array(1, 1, 1, 1, 1, 1, 1);
		
		public static const uses = new Array(1, 1, 1, 1, 1, 1, 1, 1);
		public static const cooldown = new Array(10, 10, 10, 10, 10, 10, 10, 10);
		public static const delay = new Array(10, 10, 10, 10, 10, 10, 10, 10);
		
		public static const hpPercChange = new Array(0, 0, 0, 25, 0, 0, 0, 0);
		public static const hpLumpChange = new Array(0, 0, 0, 0, 0, 0, 0, 0);
		public static const atkSpeedPerc = new Array(0, 20, 0, 0, 0, 0, 0, 0);
		public static const mvSpeedPerc = new Array(0, 0, 0, 0, 0, 0, 0, 0);
		public static const atkDmgPerc = new Array(0, 10, 0, 0, 0, 0, 0, 0);
		public static const atkDmgLump = new Array(0, 0, 0, 0, 0, 0, 0, 0);
		public static const cdPercChange = new Array(0, 0, 0, 0, 0, 0, 0, 0);
		
		public static const stunDurations = new Array(40, 0, 0, 0, 0, 0, 0);
		public static const slowDurations = new Array(0, 0, 0, 0, 0, 0, 0);
		public static const slowPercents = new Array(0, 0, 0, 0, 0, 0, 0, 0);
		
		public static function getName(id:int):String {
			return names[id];
		}
		public static function getDescription(id:int):String {
			return descriptions[id];
		}
		public static function getIndex(id:int):int {
			return index[id];
		}
		
		public static function getHPPercChange(id:int):int {
			return hpPercChange[id];
		}
		public static function getHPLumpChange(id:int):int {
			return hpLumpChange[id];
		}
		public static function getAtkSpeedPerc(id:int):int {
			return atkSpeedPerc[id];
		}
		public static function getMvSpeedPerc(id:int):int {
			return mvSpeedPerc[id];
		}
		public static function getAtkDmgPerc(id:int):int {
			return atkDmgPerc[id];
		}
		public static function getAtkDmgLump(id:int):int {
			return atkDmgLump[id];
		}
		public static function getCDPercChange(id:int):int {
			return cdPercChange[id];
		}
		
		public static function getStunDuration(id:int):int {
			return stunDurations[id];
		}
		public static function getSlowDuration(id:int):int {
			return slowDurations[id];
		}
		public static function getSlowPercent(id:int):int {
			return slowPercents[id];
		}
		
		static public function useCheatCode(cheatCode) {
			switch (cheatCode) {
					//Ananya
				case "114114251" :
					StageSelect.Ananya=! StageSelect.Ananya;
					var display="Ananya Difficulty Off";
					if (StageSelect.Ananya) {
						display="Ananya Difficulty On";
					}
					return display;
					break;
					//Huong
				case "82115147" :
					return "H Mode 1 - Normal";
					break;
					//Sausage
				case "1912119175" :
					return "H Mode 2 - Sausage";
					break;
					//Bean
				case "25114" :
					return "H Mode 3 - Bean";
					break;
				default :
					return null;
					break;
			}
		}
	}
}