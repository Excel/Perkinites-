package items{
	import ui.*;
	import ui.screens.*;

	import flash.display.MovieClip;
	import flash.events.*;
	import flash.ui.*;
	import flash.display.Stage;

	public class ItemDatabase {

		public static const names=new Array("Drink","Drank","Drunk","Dronk","Shopping Cart",":]",":]");
		public static const descriptions = new Array("Restores some of one Unit's HP.",
		"Restores some of one Unit's HP.",
		"Restores some of one Unit's HP.",
		"Restores 55% of the Current Unit's HP.",
		"Charge through enemies while dashing to inflict damage.Units cannot switch or use attacks/abilities WHILE THE SHOPPING CART IS IN USE.", 
		":O", ":O");

		// icon frame in fla
		public static const index=new Array(2,3,4,5,6,7,8);
		public static const ranges=new Array(0,0,0,0,0,0,0);

		public static const uses=new Array(0,0,0,0,0,0,0);
		public static var maxUses=new Array(9,9,9,9,9,9,9);
		public static const cooldowns=new Array(5,5,5,5,5,5,5,5);
		public static const activations = new Array(0,1,2,3,0,0,0);
		public static const activationLabels = new Array("Automatic",
														 "Hotkey",
														 "Hotkey -> L-Click",
														 "Hotkey -> Select Unit");
		public static const availabilities = new Array("All Perkinites",
		   "All Perkinites",
		   "All Perkinites",
		   "All Perkinites","","","");
		public static const specs=new Array("Healing%", "Healing%", "Healing%", "Healing%","","","");


		public static const values=new Array(0,0,0,0,0,0,0);
		public static const delays=new Array(10,10,10,10,10,10,10,10);

		public static const damage = new Array(0,0,0,0,0,0,0);
		public static const hpPercChange=new Array(25,35,45,55,0,0,0,0);
		public static const hpLumpChange=new Array(0,0,0,0,0,0,0,0);
		public static const atkSpeedPerc=new Array(0,20,0,0,0,0,0,0);
		public static const mvSpeedPerc=new Array(0,0,0,0,0,0,0,0);
		public static const atkDmgPerc=new Array(0,10,0,0,0,0,0,0);
		public static const atkDmgLump=new Array(0,0,0,0,0,0,0,0);
		public static const cdPercChange=new Array(0,0,0,0,0,0,0,0);

		public static const stunDurations=new Array(40,0,0,0,0,0,0);
		public static const slowDurations=new Array(0,0,0,0,0,0,0);
		public static const slowPercents=new Array(0,0,0,0,0,0,0,0);

		public static const actives=new Array(true,true,false,false,true,true,true,true);

		public static function getName(id:int):String {
			return names[id];
		}
		public static function getDescription(id:int):String {
			return descriptions[id];
		}
		public static function getIndex(id:int):int {
			return index[id];
		}
		public static function getRange(id:int):int {
			return ranges[id];
		}
		public static function getUses(id:int):int {
			return uses[id];
		}
		public static function getCooldown(id:int):int {
			return cooldowns[id];
		}
		
		public static function getActivation(id:int):String{
			return activationLabels[activations[id]];
		}
		public static function getAvailability(id:int):String {
			return availabilities[id];
		}
		public static function getSpec(id:int):String {
			return specs[id];
		}
		public static function getDelay(id:int):int {
			return delays[id];
		}

		public static function getDamage(id:int):int{
			return damage[id];
		}
		public static function getMaxUses(id:int):int {
			return maxUses[id];
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

		public static function getActive(id:int):Boolean {
			return actives[id];
		}

		public static function getDatabaseIndex(name:String):int {
			return names.indexOf(name);
		}


	}
}