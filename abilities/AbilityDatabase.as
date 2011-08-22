package abilities {
	import maps.*;
	import ui.*;
	import ui.screens.*;
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

				
				var power1 = separate(abilityElement.Power);
				var power2 = separate(abilityElement.Power2);
				var power3 = separate(abilityElement.Power3);
				a.power = power1[0];
				a.powerMod = power1[1];
				a.power2 = power2[0];
				a.power2Mod = power3[1];
				a.power3 = power3[0];
				a.power3Mod = power3[1];
				
				a.correct = parseInt(abilityElement.Correct);
				
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
				
				ma.power = power1[0];
				ma.powerMod = power1[1];
				ma.power2 = power2[0];
				ma.power2Mod = power3[1];
				ma.power3 = power3[0];
				ma.power3Mod = power3[1];
				
				ma.correct = parseInt(abilityElement.Correct);
				
				/*var action;
				for each (var onActivationElement:XML in abilityElement.OnActivation.children()) {
					action=MapObjectParser.parseCommand(a,onActivationElement);
					a.onActivation.push(action);
					ma.onActivation.push(action);
				}
				for each (var onMoveElement:XML in abilityElement.OnMove.children()) {
					action = onMoveElement;
					//action=MapObjectParser.parseCommand(a,onMoveElement);
					a.onMove.push(action);
					ma.onMove.push(action);
				}
				for each (var onDefendElement:XML in abilityElement.OnDefend.children()) {
					action = onDefendElement;
					//action=MapObjectParser.parseCommand(a,onDefendElement);
					a.onDefend.push(action);
					ma.onDefend.push(action);
				}
				for each (var onHitElement:XML in abilityElement.OnHit.children()) {
					action = onHitElement;
					//action=MapObjectParser.parseCommand(a,onHitElement);
					a.onHit.push(action);
					ma.onHit.push(action);
				}
				for each (var onRemoveElement:XML in abilityElement.OnRemove.children()) {
					action=MapObjectParser.parseCommand(a,onRemoveElement);
					a.onRemove.push(action);
					ma.onRemove.push(action);
				}			*/
				
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
				a.power = abilityInfo[id].power;
				a.power2 = abilityInfo[id].power2;
				a.power3 = abilityInfo[id].power3;
				
				a.onActivation = abilityInfo[id].onActivation;
				a.onMove = abilityInfo[id].onMove;
				a.onDefend = abilityInfo[id].onDefend;
				a.onHit = abilityInfo[id].onHit;
				a.onRemove = abilityInfo[id].onRemove;	
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