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
		public static var areas = new Array();
		public static var stands = new Array();
		public static var ranges = new  Array();
		public static var uses = new Array();
		public static var amounts = new Array();



		public static var activations = new Array();
		public static var availabilities = new Array();
		public static var basics = new Array();
		public static var specs = new Array();
		public static var values = new Array();
		public static var delays = new Array();
		public static var mins = new Array();
		public static var maxes = new Array();
		public static var actives = new Array();
		public static const activationLabels = new Array("Passive",  
		 "Hotkey",
		 "Hotkey -> L-Click",
		 "Hotkey -> Select Unit",
		 "Hold Down Hotkey");
		public static var index=new Array();

		public static var cooldown = new Array();
		public static var cooldownChange = new Array();		
		public static var damage = new Array();
		public static var damageChange = new Array();
		public static var atkSpeed = new Array();
		public static var atkSpeedChange = new Array();

		public static var stunDurations=new Array();
		public static var stunDurationChange = new Array();
		public static var slowDurations=new Array();
		public static var slowDurationChange = new Array();
		public static var sickDurations=new Array();
		public static var sickDurationChange = new Array();
		public static var exhaustDurations=new Array();
		public static var exhaustDurationChange = new Array();
		public static var regenDurations=new Array();
		public static var regenDurationChange = new Array();

		public static var slowPercents=new Array();
		public static var slowPercentChange = new Array();
		public static var sickPercents=new Array();
		public static var sickPercentChange = new Array();
		public static var regenPercents=new Array();
		public static var regenPercentChange = new Array();

		public static var hpPerc=new Array();
		public static var hpLump=new Array();
		public static var hpPercChange=new Array();
		public static var hpLumpChange=new Array();

		public static var atkDmgPerc=new Array();
		public static var atkDmgLump=new Array();
		public static var atkDmgPercChange=new Array();
		public static var atkDmgLumpChange=new Array();
		
		public static var cdPerc=new Array();		
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
			if (sep!=-1) {
				sep=statChange.indexOf("-");
			}

			if (sep!=-1) {
				s.push(parseFloat(statChange.substring(0,sep)));
				s.push(parseFloat(statChange.substring(sep, statChange.toString().length)));
			} else {
				s.push(parseFloat(statChange));
				s.push(0);
			}
			return s;
		}
		public static function parseData(input:XML):void {
			var sd;
			var sp;

			var count=2;
			for each (var nameElement:XML in input.Ability.Name) {
				names.push(nameElement);
				index.push(count);
				count++;
			}
			for each (var availabilityElement:XML in input.Ability.Availability) {
				availabilities.push(availabilityElement);
				if (availabilityElement=="All Girls"||availabilityElement=="All Perkinites") {
					basics.push(false);
				} else {
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
			for each (var standElement:XML in input.Ability.Stand) {
				stands.push(standElement);
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


			//Requires leveling up

			for each (var cooldownElement:XML in input.Ability.Cooldown) {
				var c = separate(cooldownElement);
				cooldown.push(c[0]);
				cooldownChange.push(c[1]);
			}
			for each (var damageElement:XML in input.Ability.Damage) {
				var d=separate(damageElement);

				damage.push(d[0]);
				damageChange.push(d[1]);
			}
			for each (var speedElement:XML in input.Ability.Speed) {
				var s=separate(speedElement);
				atkSpeed.push(s[0]);
				atkSpeedChange.push(s[1]);
			}

			for each (var stunDurElement:XML in input.Ability.StunDur) {
				sd=separate(stunDurElement);
				stunDurations.push(sd[0]);
				stunDurationChange.push(sd[1]);
			}
			for each (var slowDurElement:XML in input.Ability.SlowDur) {
				sd=separate(stunDurElement);
				slowDurations.push(sd[0]);
				slowDurationChange.push(sd[1]);
			}
			for each (var sickDurElement:XML in input.Ability.SickDur) {
				sd=separate(sickDurElement);
				sickDurations.push(sd[0]);
				sickDurationChange.push(sd[1]);
			}
			for each (var exhaustDurElement:XML in input.Ability.ExhaustDur) {
				var ed=separate(exhaustDurElement);
				exhaustDurations.push(ed[0]);
				exhaustDurationChange.push(ed[1]);
			}
			for each (var regenDurElement:XML in input.Ability.RegenDur) {
				var rd=separate(regenDurElement);
				regenDurations.push(rd[0]);
				regenDurationChange.push(rd[1]);
			}
			for each (var slowPercElement:XML in input.Ability.SlowPerc) {
				sp=separate(slowPercElement);
				slowPercents.push(sp[0]);
				slowPercentChange.push(sp[1]);
			}
			for each (var sickPercElement:XML in input.Ability.SickPerc) {
				sp=separate(sickPercElement);
				sickPercents.push(sp[0]);
				sickPercentChange.push(sp[1]);
			}
			for each (var regenPercElement:XML in input.Ability.RegenPerc) {
				var rp=separate(regenPercElement);
				regenPercents.push(rp[0]);
				regenPercentChange.push(rp[1]);
			}

			for each (var hpPercElement:XML in input.Ability.HPPerc) {
				var hpp = separate(hpPercElement);
				hpPerc.push(hpp[0]);
				hpPercChange.push(hpp[1]);
			}
			for each (var hpLumpElement:XML in input.Ability.HPLump) {
				var hpl = separate(hpLumpElement);
				hpLump.push(hpl[0]);
				hpLumpChange.push(hpl[1]);
			}

			for each (var apPercElement:XML in input.Ability.APPerc) {
				var app = separate(apPercElement);
				atkDmgPerc.push(app[0]);
				atkDmgPercChange.push(app[1]);	
			}
			for each (var apLumpElement:XML in input.Ability.APLump) {
				var apl = separate(apLumpElement);
				atkDmgLump.push(apl[0]);
				atkDmgLumpChange.push(apl[1]);				
			}

			for each (var cdPercElement:XML in input.Ability.CDPerc) {
				var cdp = separate(cdPercElement);
				cdPerc.push(cdp[0]);				
				cdPercChange.push(cdp[1]);
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
		public static function getAOE(id:int):String {
			return areas[id];
		}
		public static function getRange(id:int):int {
			return ranges[id];
		}
		public static function getUses(id:int):int {
			return uses[id];
		}

		public static function getActivation(id:int):String {
			return activationLabels[activations[id]];
		}
		public static function getAvailability(id:int):String {
			return availabilities[id];
		}
		public static function isBasicAbility(id:int):Boolean {
			return basics[id];
		}
		public static function getSpec(id:int):String {
			return specs[id];
		}
		public static function getValue(id:int):Number {
			return values[id];
		}
		public static function getStand(id:int):int{
			return stands[id];
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

		public static function getCooldown(id:int):int {
			return cooldown[id];
		}
		public static function getCooldownChange(id:int):Number {
			return cooldownChange[id];
		}		
		public static function getDamage(id:int):int {
			return damage[id];
		}
		public static function getDamageChange(id:int):Number {
			return damageChange[id];
		}		
		public static function getAtkSpeed(id:int):int {
			return atkSpeed[id];
		}
		public static function getAtkSpeedChange(id:int):Number {
			return atkSpeedChange[id];
		}		
		public static function getHPPerc(id:int):int {
			return hpPerc[id];
		}
		public static function getHPLump(id:int):int {
			return hpLump[id];
		}		
		public static function getHPPercChange(id:int):Number {
			return hpPercChange[id];
		}
		public static function getHPLumpChange(id:int):Number {
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
		public static function getCDPerc(id:int):int {
			return cdPerc[id];
		}		
		public static function getCDPercChange(id:int):Number {
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
			spec="Healing + "+hpLump[id];
		} else if (spec == "Healing%") {
			spec="Healing % "+hpPerc[id]+"%";
		}
		spec=spec+"\n"+getActivation(id);
		return spec;
	}
}
}