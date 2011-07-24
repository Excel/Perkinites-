﻿package actors{

	import abilities.*;
	import xml.*;

	import flash.events.*;
	import flash.xml.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	public class ActorDatabase {

		public static var xmlData:XML = new XML();

		public static var names = new Array();//=new Array("C. Kata","Cia M.","Charles Y.","Nate M.");
		public static var hp=new Array();//new Array(75,90,60,100);
		public static var dmg=new Array();//new Array(3,3,3,3);
		public static var armor=new Array();//new Array(0,0,0,0);
		public static var speed=new Array();//new Array(16,16,16,16);

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

		public static function loadData() {
			var xmlLoader:URLLoader = new URLLoader();

			xmlLoader.addEventListener(Event.COMPLETE, LoadXML);
			xmlLoader.load(new URLRequest("xml/Actors.xml"));


		}

		public static function LoadXML(e:Event):void {
			xmlData=new XML(e.target.data);
			parseData(xmlData);
		}
		public static function separate(statChange) {
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
		public static function parseData(input:XML):void {
			for each (var nameElement:XML in input.Actor.Name) {
				names.push(nameElement);
			}
			for each (var healthElement:XML in input.Actor.Health) {
				var health=separate(healthElement);
				hp.push(health[0]);
				hpChange.push(health[1]);
			}
			for each (var attackElement:XML in input.Actor.Attack) {
				var attack = separate(attackElement);
				dmg.push(attack[0]);
				dmgChange.push(attack[1]);
			}
			for each (var defenseElement:XML in input.Actor.Defense) {
				armor.push(defenseElement);
			}
			for each (var speedElement:XML in input.Actor.Speed) {
				var sp = separate(speedElement);
				speed.push(int(sp[0]));
				speedChange.push(sp[1]);
			}
			for each (var weaponElement:XML in input.Actor.Weapon) {
				weapons.push(weaponElement);
			}
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
		public static function getExistingUnits(id:int):Array{
			var units = [];
			for(var i = 0; i < existingUnits.length; i+2){
				if(existingUnits[i].id == id){
					units.push(existingUnits[i]);
					units.push(existingUnits[i+1]);
					return units;
				}
			}
			return units;
		}		
	}
}