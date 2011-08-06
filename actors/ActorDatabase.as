package actors{

	import abilities.*;
	import xml.*;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.xml.*;

	/**
	 * Holds Actor information and maybe dispatches events to signal when loading is complete.
	 */
	public class ActorDatabase extends EventDispatcher {

		public var xmlLoader:URLLoader = new URLLoader();

		public const actorsURL:String="xml/Actors.xml";

		public var actorInfo:Array = new Array();

		public static var names = new Array();
		public static var hp=new Array();
		public static var dmg=new Array();
		public static var armor=new Array();
		public static var speed=new Array();

		public static var hpChange=new Array();
		public static var dmgChange=new Array();
		public static var speedChange=new Array();

		public static var weapons=new Array();
		public static var ffNames=new Array("Angelic Finale","Angelic Finale","WHAT YOU WANT","WHAT YOU WANT");
		public static var ffDescriptions=new Array("Shower the field with celestial forces and holy lasers.",
		 "Shower the field with celestial forces and holy lasers.",
		 "MAGICAL SHIT HAPPENS",
		 "MAGICAL SHIT HAPPENS");
		//this whole Current Unit Bonus thing is also optional. I don't know. 
		//I want additional bonuses though besides just the attack. 
		//It could also apply to both units instead of the one you're controlling (current).
		public static var ffBonuses=new Array("If C. Kata is the Current Unit, she gets 1.5x AP.",
		"If Cia M. is the Current Unit, she gets 1.5x Speed",
		"If Charles Y. is the Current Unit, WHAT YOU WANT",
		"If Nate M. is the Current Unit, WHAT YOU WANT");
		public static var basicAbilities = new Array();

		public static var existingUnits = new Array();

		public function ActorDatabase() {

		}

		public function loadData() {
			this.loadObject(actorsURL, handleLoadedActors);
			/*
			var xmlLoader:URLLoader = new URLLoader();
			
			xmlLoader.addEventListener(Event.COMPLETE, LoadXML);
			xmlLoader.load(new URLRequest("xml/Actors.xml"));*/


		}

		public function loadObject(url:String, handleFunction:Function):void {
			var request:URLRequest=new URLRequest(url);
			xmlLoader.addEventListener(Event.COMPLETE, handleFunction);
			xmlLoader.load(request);
		}

		/**
		 * Loads the Actors/Units. :)
		 */
		public function handleLoadedActors(e:Event):void {
			xmlLoader.removeEventListener(Event.COMPLETE, handleLoadedActors);
			var xmlData=new XML(e.target.data);
			parseActorData(xmlData);
		}
		public function parseActorData(input:XML):void {
			for each (var actorElement:XML in input.Actor) {
				var actor = new Unit();

				var health=separate(actorElement.Health);
				var attack = separate(actorElement.Attack);
				var defense = separate(actorElement.Defense);
				var sp = separate(actorElement.Speed);
				actor.name=actorElement.Name;

				actor.maxHP=actor.HP=health[0];
				actor.AP=attack[0]
				actor.DP=defense[0];
				actor.speed=sp[0];
				actor.weapon=actorElement.Weapon;

				actorInfo.push(actor);
			}

			for each (var nameElement:XML in input.Actor.Name) {
				names.push(nameElement);
			}
			for each (var healthElement:XML in input.Actor.Health) {
				health=separate(healthElement);
				hp.push(health[0]);
				hpChange.push(health[1]);
			}
			for each (var attackElement:XML in input.Actor.Attack) {
				attack=separate(attackElement);
				dmg.push(attack[0]);
				dmgChange.push(attack[1]);
			}
			for each (var defenseElement:XML in input.Actor.Defense) {
				armor.push(defenseElement);
			}
			for each (var speedElement:XML in input.Actor.Speed) {
				sp=separate(speedElement);
				speed.push(int(sp[0]));
				speedChange.push(sp[1]);
			}
			for each (var weaponElement:XML in input.Actor.Weapon) {
				weapons.push(weaponElement);
			}

		}

		public function separate(statChange) {
			var s = new Array();
			var sep=statChange.indexOf("+");

			s.push(parseFloat(statChange.substring(0,sep)));
			if (sep!=-1) {
				s.push(parseFloat(statChange.substring(sep, statChange.toString().length)));
			} else {
				s.push(0);
			}
			return s;
		}

		public static function getName(id:int):String {
			return names[id];
		}
		public static function getHP(id:int):int {
			return hp[id];
		}
		public static function getDmg(id:int):int {
			return dmg[id];
		}
		public static function getArmor(id:int):int {
			return armor[id];
		}
		public static function getSpeed(id:int):Number {
			return speed[id];
		}
		public static function getHPChange(id:int):int {
			return hpChange[id];
		}
		public static function getDmgChange(id:int):int {
			return dmgChange[id];
		}
		public static function getSpeedChange(id:int):Number {
			return speedChange[id];
		}

		public static function getWeapon(id:int):String {
			return weapons[id];
		}
		public static function getFFName(id:int):String {
			return ffNames[id];
		}
		public static function getFFDescription(id:int):String {
			return ffDescriptions[id];
		}
		public static function getFFBonus(id:int):String {
			return ffBonuses[id];
		}

		public static function getBasicAbilities(id:int):Array {
			return basicAbilities[id];
		}
		public static function getExistingUnits(id:int):Array {
			var units=[];
			for(var i = 0; i < existingUnits.length; i+2){;
			if (existingUnits[i].id==id) {
				units.push(existingUnits[i]);
				units.push(existingUnits[i+1]);
				return units;
			}
		}
		return units;
	}
}
}