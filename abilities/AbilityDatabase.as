package abilities {
	import maps.*;
	import ui.*;
	import ui.screens.*;
	import util.FunctionUtils;
	import xml.*;

	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.ui.*;
	import flash.xml.*;
	
	public class AbilityDatabase extends EventDispatcher{


		public var xmlLoader:URLLoader = new URLLoader();

		public const abilitiesURL:String="xml/Abilities.xml";
		public const aEffectsURL:String="xml/Abilities2.xml";

		public static var abilityInfo:Array = new Array();
		public static var minAbilityInfo:Array = new Array();
		public static var abilityAmounts:Array = new Array();
		public static var itemAmounts:Array = new Array();
		
		public static var basicAbilityCutoff:int = -1;

		public function AbilityDatabase() {
			
		}
		public function loadData() {
			this.loadObject(abilitiesURL, handleLoadedAbilities);
			this.addEventListener(AbilityDataEvent.ABILITIES_LOADED, loadEffects);
		}

		public function loadObject(url:String, handleFunction:Function):void {
			var request:URLRequest=new URLRequest(url);
			xmlLoader.addEventListener(Event.COMPLETE, handleFunction);
			xmlLoader.load(request);
		}
		
		public function handleLoadedAbilities(e:Event):void {
			xmlLoader.removeEventListener(Event.COMPLETE, handleLoadedAbilities);
			var xmlData=new XML(e.target.data);
			parseAbilityData(xmlData);
		}
		
		public function loadEffects(e:AbilityDataEvent):void {
			loadObject(aEffectsURL, this.handleLoadedEffects);
		}
		public function handleLoadedEffects(e:Event):void {
			xmlLoader.removeEventListener(Event.COMPLETE, handleLoadedEffects);
			var xmlData=new XML(e.target.data);
			parseAbilityEffectData(xmlData);
		}		
		public function separate(statChange) {
			var s = new Array();
			if (statChange.toString() == "-1") {
				s = new Array( -1, 0);
			} else if (statChange.length() != 0) {
				var sep=statChange.indexOf("+");
				if (sep==-1) {
					sep=statChange.toString().indexOf('-');
				}

				if (sep!=-1) {
					s.push(parseFloat(statChange.substring(0,sep)));
					s.push(parseFloat(statChange.substring(sep, statChange.toString().length)));
				} else {
					s.push(parseFloat(statChange));
					s.push(0);
				}				
			}
			else {
				s = new Array(0, 0);
			}
			return s;
		}
		public function parseAbilityData(input:XML):void {
			
			var id = 0;
			for each (var abilityElement:XML in input.Ability) {
				var a = new Ability();
				var ma = new Ability();
				a.Name = abilityElement.Name;
				a.description = abilityElement.Description;
				a.ID = id;
				a.index = id + 2;
				a.availability = abilityElement.Availability;

				if (basicAbilityCutoff == -1 &&(a.availability == "All Girls" || a.availability == "All Boys" || a.availability == "All Perkinites")) {
					basicAbilityCutoff = id;
				}
				
				a.spec = abilityElement.Spec;
				a.aoe = abilityElement.AOE;
				a.uses = abilityElement.Uses;
				a.activation = abilityElement.Activation;
				
				if (a.activation == 0) {
					a.active = false;
				}
				else {
					a.active = true;
				}
				
				a.value = abilityElement.Value;
				a.stand = abilityElement.Stand;
				a.exist = abilityElement.Exist;
				a.min = abilityElement.Min;
				a.max = abilityElement.Max;
				var range = separate(abilityElement.Range);
				a.range = range[0];
				a.rangeMod = range[1];
				var cd = separate(abilityElement.Cooldown);
				a.maxCooldown = a.cooldown = cd[0];
				a.cooldownMod = cd[1];

				a.correct = parseInt(abilityElement.Correct);
				
				a.allowCustom = abilityElement.AllowCustom;
				a.wait = parseInt(abilityElement.Wait);
				a.cast = abilityElement.Cast;
				a.moveForward = parseFloat(abilityElement.Float);
				
				var damage = separate(abilityElement.Damage);
				a.damage = damage[0];
				a.damageMod = damage[1];

				a.equipStatBuff = abilityElement.EquipStatBuff.toString();
				var bonusDuration = separate(abilityElement.BonusDuration);
				a.bonusDuration = bonusDuration[0];
				a.bonusDurationMod = bonusDuration[1];
				
				var healthLump = separate(abilityElement.HPLump);
				a.healthLump = healthLump[0];
				a.healthLumpMod = healthLump[1];
				
				var healthPerc = separate(abilityElement.HPPerc);
				a.healthPerc = healthPerc[0];
				a.healthPercMod = healthPerc[1];				
				
				var attackLump = separate(abilityElement.APLump);
				a.attackLump = attackLump[0];
				a.attackLumpMod = attackLump[1];
				
				var attackPerc = separate(abilityElement.APPerc);
				a.attackPerc = attackPerc[0];
				a.attackPercMod = attackPerc[1];

				var defenseLump = separate(abilityElement.DPLump);
				a.defenseLump = defenseLump[0];
				a.defenseLumpMod = defenseLump[1];
				
				var defensePerc = separate(abilityElement.DPPerc);
				a.defensePerc = defensePerc[0];
				a.defensePercMod = defensePerc[1];	
				
				var speedLump = separate(abilityElement.SPLump);
				a.speedLump = speedLump[0];
				a.speedLumpMod = speedLump[1];
				
				var speedPerc = separate(abilityElement.SPPerc);
				a.speedPerc = speedPerc[0];
				a.speedPercMod = speedPerc[1];		

				var rangeLump = separate(abilityElement.RangeLump);
				a.rangeLump = rangeLump[0];
				a.rangeLumpMod = rangeLump[1];
				
				var rangePerc = separate(abilityElement.RangePerc);
				a.rangePerc = rangePerc[0];
				a.rangePercMod = rangePerc[1];						

				var cooldownLump = separate(abilityElement.CDLump);
				a.cooldownLump = cooldownLump[0];
				a.cooldownLumpMod = cooldownLump[1];
				
				var cooldownPerc = separate(abilityElement.CDPerc);
				a.cooldownPerc = cooldownPerc[0];
				a.cooldownPercMod = cooldownPerc[1];	
				
				a.equipDebuff = abilityElement.EquipDebuff.toString();					
				
				var stunDuration = separate(abilityElement.StunDuration);
				a.stunDuration = stunDuration[0];
				a.stunDurationMod = stunDuration[1];
				
				var slowDuration = separate(abilityElement.SlowDuration);
				a.slowDuration = slowDuration[0];
				a.slowDurationMod = slowDuration[1];

				var slowPerc = separate(abilityElement.SlowPerc);
				a.slowPerc = slowPerc[0];
				a.slowPercMod = slowPerc[1];
				
				var sickDuration = separate(abilityElement.SickDuration);
				a.sickDuration = sickDuration[0];
				a.sickDurationMod = sickDuration[1];
				
				var sickPerc = separate(abilityElement.SickPerc);
				a.sickPerc = sickPerc[0];
				a.sickPercMod = sickPerc[1];
				
				var sickTime = separate(abilityElement.SickTime);
				a.sickTime = sickTime[0];
				a.sickTimeMod = sickTime[1];				
				
				var exhaustDuration = separate(abilityElement.ExhaustDuration);
				a.exhaustDuration = exhaustDuration[0];
				a.exhaustDurationMod = exhaustDuration[1];

				var regenDuration = separate(abilityElement.RegenDuration);
				a.regenDuration = regenDuration[0];
				a.regenDurationMod = regenDuration[1];
				
				var regenLump = separate(abilityElement.RegenLump);
				a.regenLump = regenLump[0];
				a.regenLumpMod = regenLump[1];
				
				var regenPerc = separate(abilityElement.RegenPerc);
				a.regenPerc = regenPerc[0];
				a.regenPercMod = regenPerc[1];
				
				var regenTime = separate(abilityElement.RegenTime);
				a.regenTime = regenTime[0];
				a.regenTimeMod = regenTime[1];					
				
				ma.Name = abilityElement.Name;
				ma.description = abilityElement.Description;
				ma.ID = id;
				ma.index = id + 2;
				ma.availability = abilityElement.Availability;

				ma.spec = abilityElement.Spec;
				ma.aoe = abilityElement.AOE;
				ma.uses = abilityElement.Uses;
				ma.activation = abilityElement.Activation;
				
				if (a.activation == 0) {
					ma.active = false;
				}
				else {
					ma.active = true;
				}
				
				ma.value = abilityElement.Value;
				ma.stand = abilityElement.Stand;
				ma.exist = abilityElement.Exist;
				ma.min = abilityElement.Min;
				ma.max = abilityElement.Max;
				
				ma.range = range[0];
				ma.rangeMod = range[1];
				ma.range = range[0];
				ma.rangeMod = range[1];
				
				ma.maxCooldown = ma.cooldown = cd[0];
				ma.cooldownMod = cd[1];

				ma.correct = parseInt(abilityElement.Correct);
				
				ma.allowCustom = abilityElement.AllowCustom;
				ma.wait = parseInt(abilityElement.Wait);
				ma.cast = abilityElement.Cast;
				ma.moveForward = parseFloat(abilityElement.Float);
				
				ma.damage = damage[0];
				ma.damageMod = damage[1];
				ma.equipStatBuff = abilityElement.EquipStatBuff.toString();
				ma.bonusDuration = bonusDuration[0];
				ma.bonusDurationMod = bonusDuration[1];
				ma.healthLump = healthLump[0];
				ma.healthLumpMod = healthLump[1];
				ma.healthPerc = healthPerc[0];
				ma.healthPercMod = healthPerc[1];				
				ma.attackLump = attackLump[0];
				ma.attackLumpMod = attackLump[1];
				ma.attackPerc = attackPerc[0];
				ma.attackPercMod = attackPerc[1];
				ma.defenseLump = defenseLump[0];
				ma.defenseLumpMod = defenseLump[1];
				ma.defensePerc = defensePerc[0];
				ma.defensePercMod = defensePerc[1];	
				ma.speedLump = speedLump[0];
				ma.speedLumpMod = speedLump[1];
				ma.speedPerc = speedPerc[0];
				ma.speedPercMod = speedPerc[1];		
				ma.rangeLump = rangeLump[0];
				ma.rangeLumpMod = rangeLump[1];
				ma.rangePerc = rangePerc[0];
				ma.rangePercMod = rangePerc[1];						
				ma.cooldownLump = cooldownLump[0];
				ma.cooldownLumpMod = cooldownLump[1];
				ma.cooldownPerc = cooldownPerc[0];
				ma.cooldownPercMod = cooldownPerc[1];	
				
				ma.equipDebuff = abilityElement.EquipDebuff.toString();				
				ma.stunDuration = stunDuration[0];
				ma.stunDurationMod = stunDuration[1];
				ma.slowDuration = slowDuration[0];
				ma.slowDurationMod = slowDuration[1];
				ma.slowPerc = slowPerc[0];
				ma.slowPercMod = slowPerc[1];
				ma.sickDuration = sickDuration[0];
				ma.sickDurationMod = sickDuration[1];
				ma.sickPerc = sickPerc[0];
				ma.sickPercMod = sickPerc[1];
				ma.sickTime = sickTime[0];
				ma.sickTimeMod = sickTime[1];				
				ma.exhaustDuration = exhaustDuration[0];
				ma.exhaustDurationMod = exhaustDuration[1];
				ma.regenDuration = regenDuration[0];
				ma.regenDurationMod = regenDuration[1];
				ma.regenLump = regenLump[0];
				ma.regenLumpMod = regenLump[1];				
				ma.regenPerc = regenPerc[0];
				ma.regenPercMod = regenPerc[1];
				ma.regenTime = regenTime[0];
				ma.regenTimeMod = regenTime[1];		
				
				abilityInfo.push(a);
				minAbilityInfo.push(ma);
				abilityAmounts.push(0);
				itemAmounts.push(0);
				id++;
			}

			this.dispatchEvent(new AbilityDataEvent(AbilityDataEvent.ABILITIES_LOADED, true));			
		}
		
		public function parseAbilityEffectData(input:XML):void {
			var id = 0;
			for each (var abilityElement:XML in input.Ability) {
				if (abilityElement.Name == abilityInfo[id].Name) {
					var action;
					
					if (abilityElement.OnActivation.length() == 0
						&& abilityElement.OnMove.length() == 0
						&& abilityElement.OnDefend.length() == 0
						&& abilityElement.OnHit.length() == 0
						&& abilityElement.OnRemove.length() == 0) {
							generateBasicMovement(abilityInfo[id], minAbilityInfo[id]);
					} else {
						for each (var onActivationElement:XML in abilityElement.OnActivation.children()) {
							action = MapObjectParser.parseCommand(abilityInfo[id], onActivationElement);
							abilityInfo[id].onActivation.push(action);
							action = MapObjectParser.parseCommand(minAbilityInfo[id], onActivationElement);
							minAbilityInfo[id].onActivation.push(action);
						}
						for each (var onMoveElement:XML in abilityElement.OnMove.children()) {
							action = onMoveElement;
							//action=MapObjectParser.parseCommand(a,onMoveElement);
							abilityInfo[id].onMove.push(action);
							minAbilityInfo[id].onMove.push(action);
						}
						for each (var onDefendElement:XML in abilityElement.OnDefend.children()) {
							action = onDefendElement;
							//action=MapObjectParser.parseCommand(a,onDefendElement);
							abilityInfo[id].onDefend.push(action);
							minAbilityInfo[id].onDefend.push(action);
						}
						for each (var onHitElement:XML in abilityElement.OnHit.children()) {
							action = onHitElement;
							//action=MapObjectParser.parseCommand(a,onHitElement);
							abilityInfo[id].onHit.push(action);
							minAbilityInfo[id].onHit.push(action);
						}
						for each (var onRemoveElement:XML in abilityElement.OnRemove.children()) {
							action=MapObjectParser.parseCommand(abilityInfo[id],onRemoveElement);
							abilityInfo[id].onRemove.push(action);
							action=MapObjectParser.parseCommand(minAbilityInfo[id],onRemoveElement);
							minAbilityInfo[id].onRemove.push(action);
						}			
					}
					id++;	
				}
			}
		}		
		
		public static function getAbility(id:int):Ability {
			return abilityInfo[id];
		}
		public static function getMinAbility(id:int):Ability {
			return minAbilityInfo[id];
		}
		public static function getAbilityStats(a:Ability, id:int) {
			
				a.Name = abilityInfo[id].Name;
				a.description = abilityInfo[id].description;
				a.index = id + 2;
				
				a.availability = abilityInfo[id].availability;
				a.spec = abilityInfo[id].spec;
				a.aoe = abilityInfo[id].aoe;
				a.uses = abilityInfo[id].uses;
				a.activation = abilityInfo[id].activation;
				
				if (a.activation == 0) {
					a.active = false;
				}
				else {
					a.active = true;
				}
				
				a.value = abilityInfo[id].value;
				a.stand = abilityInfo[id].stand;
				a.exist = abilityInfo[id].exist;
				a.min = abilityInfo[id].min;
				a.max = abilityInfo[id].max;
				a.range = abilityInfo[id].range;
				a.maxCooldown = a.cooldown = abilityInfo[id].cooldown;
				
				a.damage = abilityInfo[id].damage;
				a.healthLump = abilityInfo[id].healthLump;
				a.healthPerc = abilityInfo[id].healthPerc;
				a.attackLump = abilityInfo[id].attackLump;
				a.attackPerc = abilityInfo[id].attackPerc;
				a.defenseLump = abilityInfo[id].defenseLump;
				a.defensePerc = abilityInfo[id].defensePerc;
				a.speedLump = abilityInfo[id].speedLump;
				a.speedPerc = abilityInfo[id].speedPerc;
				a.rangeLump = abilityInfo[id].rangeLump;
				a.rangePerc = abilityInfo[id].rangePerc;
				a.cooldownLump = abilityInfo[id].cooldownLump;
				a.cooldownPerc = abilityInfo[id].cooldownPerc;
				a.stunDuration = abilityInfo[id].stunDuration;
				a.slowDuration = abilityInfo[id].slowDuration;
				a.slowPerc = abilityInfo[id].slowPerc;
				a.sickDuration = abilityInfo[id].sickDuration;
				a.sickPerc = abilityInfo[id].sickPerc;
				a.sickTime = abilityInfo[id].sickTime;
				a.exhaustDuration = abilityInfo[id].exhaustDuration;
				a.regenDuration = abilityInfo[id].regenDuration;
				a.regenPerc = abilityInfo[id].regenPerc;
				a.regenTime = abilityInfo[id].regenTime;
				
				a.onActivation = abilityInfo[id].onActivation;
				a.onMove = abilityInfo[id].onMove;
				a.onDefend = abilityInfo[id].onDefend;
				a.onHit = abilityInfo[id].onHit;
				a.onRemove = abilityInfo[id].onRemove;	
		}

		public static function generateBasicMovement(a:Ability, ma:Ability) {
			var action;
			if (a.activation > 0) {
				a.onActivation.push(FunctionUtils.thunkify(a.waitFor, 2));
				ma.onActivation.push(FunctionUtils.thunkify(ma.waitFor, 2));
				a.onActivation.push(FunctionUtils.thunkify(a.castAttack, 1, 0, "Line", 40, 8, 12, "Invis"));
				ma.onActivation.push(FunctionUtils.thunkify(ma.castAttack, 1, 0, "Line", 40, 8, 12, "Invis"));
				for each (var onMoveElement:XML in abilityInfo[0].onMove) {
					action = onMoveElement;
					a.onMove.push(action);
					ma.onMove.push(action);
				}
				for each (var onHitElement:XML in abilityInfo[0].onHit) {
					action = onHitElement;
					a.onHit.push(action);
					ma.onHit.push(action);
				}
			}
		}
		public static function getBasicAbilities(name:String):Array {
			var commands = new Array();
			for(var i = 0; i < abilityInfo.length; i++){;
				if (abilityInfo[i].availability==name) {
					commands.push(abilityInfo[i]);
				}
			}
		return commands;
		}
		
		public static function isBasicAbility(id:int):Boolean {
			if (id < basicAbilityCutoff) {
				return true;
			}
			return false;
		}
	
}
}