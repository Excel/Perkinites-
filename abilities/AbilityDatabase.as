package abilities{
	import ui.*;
	import ui.screens.*;
	import xml.*;

	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.ui.*;
	import flash.xml.*;

	public class AbilityDatabase {


		public static var xmlData:XML = new XML();
		public static var names = new Array();
		public static var descriptions = new Array();
		public static var ranges = new  Array();
		public static var uses = new Array();
		public static var amounts = new Array();
		public static var cooldowns = new Array();


		public static var activations = new Array();
		public static var availabilities = new Array();
		public static var specs = new Array();
		public static var values = new Array();
		public static var delays = new Array();
		public static var actives = new Array();
		public static const activationLabels = new Array("Automatic",  
		 "Hotkey",
		 "Hotkey -> L-Click",
		 "Hotkey -> Select Unit");
		public static const index=new Array(3,4,1,1,1,1,1);

		public static const damage=new Array(0,0,0,0,0,0,0);
		public static const hpPercChange=new Array(0,0,0,25,0,0,0,0);
		public static const hpLumpChange=new Array(0,0,0,0,0,0,0,0);
		public static const atkSpeedPerc=new Array(0,20,0,0,0,0,0,0);
		public static const mvSpeedPerc=new Array(0,0,0,0,0,0,0,0);
		public static const atkDmgPerc=new Array(0,10,0,0,0,0,0,0);
		public static const atkDmgLump=new Array(0,0,0,0,0,0,0,0);
		public static const cdPercChange=new Array(0,0,0,0,0,0,0,0);

		public static const stunDurations=new Array(40,0,0,0,0,0,0);
		public static const slowDurations=new Array(0,0,0,0,0,0,0);
		public static const slowPercents=new Array(0,0,0,0,0,0,0,0);

		/*public static const names=new Array("Eyelash Batting","Sharp Shooter","Update","Cheer",":]",":]",":]");
		public static const descriptions = new Array("Stun certain enemies.",
		"Increase your team's attack speeds and attack power for Ranger-type Abilities for fifteen seconds.",
		"Increase your team's dash speeds and reduce your team's cooldown times.",
		"Restores a small amount of HP to Christina every five seconds.",
		":O", ":O", ":O");
		
		// icon frame in fla
		
		public static const ranges=new Array(0,600,0,0,0,0,0);
		
		public static const uses=new Array(1,1,1,1,1,1,1,1);
		public static const amounts=new Array(0,0,0,0,0,0,0,0);
		public static const cooldowns=new Array(10,60,10,10,10,10,10,10);
		
		//actual availability will be defined for each unit, saying what skills they can actually equip :)
		//this is just the message that shows up in the menu
		public static const activations=new Array(0,1,0,0,0,0,0);
		public static const activationLabels = new Array("Automatic",
		 "Hotkey",
		 "Hotkey -> L-Click",
		 "Hotkey -> Select Unit");
		public static const availabilities=new Array("C. Kata","C. Kata","Charles Y.","Cia M.","","","");
		public static const specs=new Array("Damage","Passive","Support","Passive","","","");
		public static const values=new Array(0,0,0,0,0,0,0);
		public static const delays=new Array(10,10,10,10,10,10,10,10);
		
		
		public static const damage=new Array(0,0,0,0,0,0,0);
		public static const hpPercChange=new Array(0,0,0,25,0,0,0,0);
		public static const hpLumpChange=new Array(0,0,0,0,0,0,0,0);
		public static const atkSpeedPerc=new Array(0,20,0,0,0,0,0,0);
		public static const mvSpeedPerc=new Array(0,0,0,0,0,0,0,0);
		public static const atkDmgPerc=new Array(0,10,0,0,0,0,0,0);
		public static const atkDmgLump=new Array(0,0,0,0,0,0,0,0);
		public static const cdPercChange=new Array(0,0,0,0,0,0,0,0);
		
		public static const stunDurations=new Array(40,0,0,0,0,0,0);
		public static const slowDurations=new Array(0,0,0,0,0,0,0);
		public static const slowPercents=new Array(0,0,0,0,0,0,0,0);
		
		public static const actives=new Array(false,true,true,true,true,true,true,true);
		*/


		public static function loadData() {
			var xmlLoader:URLLoader = new URLLoader();

			xmlLoader.addEventListener(Event.COMPLETE, LoadXML);
			xmlLoader.load(new URLRequest("xml/Abilities.xml"));
		}

		public static function LoadXML(e:Event):void {
			xmlData=new XML(e.target.data);
			parseData(xmlData);
		}
		public static function parseData(input:XML):void {
			for each (var nameElement:XML in input.Ability.Name) {
				names.push(nameElement);
			}
			for each (var availabilityElement:XML in input.Ability.Availability) {
				availabilities.push(availabilityElement);
			}
			for each (var specElement:XML in input.Ability.Spec) {
				specs.push(specElement);
			}
			for each (var rangeElement:XML in input.Ability.Range) {
				ranges.push(rangeElement);
			}
			for each (var cooldownElement:XML in input.Ability.Cooldown) {
				cooldowns.push(cooldownElement);
			}
			for each (var useElement:XML in input.Ability.Uses) {
				uses.push(useElement);
				amounts.push(0);
			}
			for each (var activateElement:XML in input.Ability.Activate) {
				activations.push(activateElement);
				switch (activateElement) {
					case 0 :
						actives.push(false);
						break;
					default :
						actives.push(true);
						break;
				}
			}
			for each (var valueElement:XML in input.Ability.Value) {
				values.push(valueElement);
			}
			for each (var delayElement:XML in input.Ability.Delay) {
				delays.push(delayElement);
			}
			for each (var descriptionElement:XML in input.Ability.Description) {
				descriptions.push(descriptionElement);
			}

		}

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
		public static function getActivation(id:int):String {
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


		public static function getDamage(id:int):int {
			return damage[id];
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