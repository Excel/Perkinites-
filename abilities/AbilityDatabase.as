﻿package abilities{
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
		public static var areas = new Array();
		public static var ranges = new  Array();
		public static var uses = new Array();
		public static var amounts = new Array();
		public static var cooldowns = new Array();


		public static var activations = new Array();
		public static var availabilities = new Array();
		public static var basics = new Array();
		public static var specs = new Array();
		public static var values = new Array();
		public static var delays = new Array();
		public static var mins = new Array();
		public static var maxes = new Array();
		public static var actives = new Array();
		public static const activationLabels = new Array("Automatic",  
		 "Hotkey",
		 "Hotkey -> L-Click",
		 "Hotkey -> Select Unit",
		 "Hold Down Hotkey");
		public static var index=new Array();

		public static var damage = new Array();
		public static var atkSpeed = new Array();

		public static var stunDurations=new Array();
		public static var slowDurations=new Array();
		public static var sickDurations=new Array();
		public static var exhaustDurations=new Array();
		public static var regenDurations=new Array();

		public static var slowPercents=new Array();
		public static var sickPercents=new Array();
		public static var regenPercents=new Array();
		
		public static var hpPercChange=new Array();
		public static var hpLumpChange=new Array();

		public static var atkDmgPerc=new Array();
		public static var atkDmgLump=new Array();
		public static var cdPercChange=new Array();
		
		
		public static var moveToTarget = new Array();
		public static var bulletNumbers = new Array();

		public static const mvSpeedPerc=new Array(0,0,0,0,0,0,0,0);


		public static function loadData() {
			var xmlLoader:URLLoader = new URLLoader();

			xmlLoader.addEventListener(Event.COMPLETE, LoadXML);
			xmlLoader.load(new URLRequest("xml/Abilities.xml"));
		}

		public static function LoadXML(e:Event):void {
			xmlData=new XML(e.target.data);
			parseData(xmlData);
		}
		public static function separate(statChange) {
			var s = new Array();
			var sep=statChange.indexOf("+");
			if(sep!=-1){
				sep = statChange.indexOf("-");
			}

			s.push(parseFloat(statChange.substring(0,sep)));
			if (sep!=-1) {
				s.push(parseFloat(statChange.substring(sep, statChange.toString().length)));
			} else {
				s.push(0);
			}
			return s;
		}		
		public static function parseData(input:XML):void {

			var count=2;
			for each (var nameElement:XML in input.Ability.Name) {
				names.push(nameElement);
				index.push(count);
				count++;
			}
			for each (var availabilityElement:XML in input.Ability.Availability) {
				availabilities.push(availabilityElement);
				if(availabilityElement == "All Girls" || availabilityElement == "All Perkinites"){
					basics.push(false);
				}
				else{
					basics.push(true);
				}
			}
			for each (var specElement:XML in input.Ability.Spec) {
				specs.push(specElement);
			}
			for each (var areaElement:XML in input.Ability.Area) {
				areas.push(areaElement);
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
				if (activateElement=="0") {
					actives.push(false);
				} else {
					actives.push(true);
				}
			}
			for each (var valueElement:XML in input.Ability.Value) {
				values.push(valueElement);
			}
			for each (var delayElement:XML in input.Ability.Delay) {
				delays.push(delayElement);
			}
			for each (var minElement:XML in input.Ability.Min) {
				mins.push(minElement);
			}
			for each (var maxElement:XML in input.Ability.Max) {
				maxes.push(maxElement);
			}
			for each (var damageElement:XML in input.Ability.Damage) {
				damage.push(damageElement);
			}
			for each (var speedElement:XML in input.Ability.Speed) {
				atkSpeed.push(speedElement);
			}

			for each (var stunDurElement:XML in input.Ability.StunDur) {
				stunDurations.push(stunDurElement);
			}
			for each (var slowDurElement:XML in input.Ability.SlowDur) {
				slowDurations.push(slowDurElement);
			}
			for each (var sickDurElement:XML in input.Ability.SickDur) {
				sickDurations.push(sickDurElement);
			}
			for each (var exhaustDurElement:XML in input.Ability.ExhaustDur) {
				exhaustDurations.push(exhaustDurElement);
			}
			for each (var regenDurElement:XML in input.Ability.RegenDur) {
				regenDurations.push(regenDurElement);
			}
			for each (var slowPercElement:XML in input.Ability.SlowPerc) {
				slowPercents.push(slowPercElement);
			}
			for each (var sickPercElement:XML in input.Ability.SickPerc) {
				sickPercents.push(sickPercElement);
			}
			for each (var regenPercElement:XML in input.Ability.RegenPerc) {
				regenPercents.push(regenPercElement);
			}
			
			for each (var hpPercElement:XML in input.Ability.HPPerc) {
				hpPercChange.push(hpPercElement);
			}
			for each (var hpLumpElement:XML in input.Ability.HPLump) {
				hpLumpChange.push(hpLumpElement);
			}

			for each (var apPercElement:XML in input.Ability.APPerc) {
				atkDmgPerc.push(apPercElement);
			}
			for each (var apLumpElement:XML in input.Ability.APLump) {
				atkDmgLump.push(apLumpElement);
			}
			
			for each (var cdPercElement:XML in input.Ability.CDPerc) {
				cdPercChange.push(cdPercElement);
			}
			
			for each (var moveElement:XML in input.Ability.Move) {
				moveToTarget.push(moveElement);
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
		public static function getAOE(id:int):String{
			return "Aura";
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
		public static function isBasicAbility(id:int):Boolean{
			return basics[id];
		}
		public static function getSpec(id:int):String {
			return specs[id];
		}
		public static function getValue(id:int):Number {
			return values[id];
		}
		public static function getDelay(id:int):int {
			return delays[id];
		}
		public static function getMin(id:int):int {
			return mins[id];
		}
		public static function getMax(id:int):int {
			return maxes[id];
		}

		public static function getDamage(id:int):int {
			return damage[id];
		}
		public static function getAtkSpeed(id:int):int {
			return atkSpeed[id];
		}		
		public static function getHPPercChange(id:int):int {
			return hpPercChange[id];
		}
		public static function getHPLumpChange(id:int):int {
			return hpLumpChange[id];
		}
		public static function getSpeed(id:int):int {
			return atkSpeed[id];
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

		public static function getMoveToTarget(id:int):int {
			return moveToTarget[id];
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

		public static function getBasicAbilities(name:String):Array {
			var commands = new Array();
			for(var i = 0; i < availabilities.length; i++){;
			if (availabilities[i]==name) {
				commands.push(new Ability(i, 1));
			}
		}
		return commands;
	}

	public static function getSpecInfo(id:int):String {
		var spec=specs[id];
		if (spec=="Damage") {
			spec="Damage = "+damage[id];
		} else if (spec == "Healing+") {
			spec="Healing + "+hpLumpChange[id];
		} else if (spec == "Healing%") {
			spec="Healing % "+hpPercChange[id]+"%";
		}
		spec=spec+"\n"+getActivation(id);
		return spec;
	}
}
}