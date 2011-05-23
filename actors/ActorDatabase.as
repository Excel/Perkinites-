package actors{
	public class ActorDatabase {
		public static const names=new Array("C. Kata","Cia M.","Charles Y.","Nate M.");
		public static const hp=new Array(75,90,60,100);
		public static const dmg=new Array(3,3,3,3);
		public static const armor=new Array(0,0,0,0);
		public static const speed=new Array(16,16,16,16);
		public static const carry=new Array(10,10,10,10);

		//this is just a slight change. we can remove this later if needed. i just wanted to see what it would look like.
		public static const weapons=new Array("Railgun","Magic Wand","Shinai","Claws");
		public static const ffNames=new Array("Angelic Finale","Angelic Finale","WHAT YOU WANT","WHAT YOU WANT");
		public static const ffDescriptions=new Array("Shower the field with celestial forces and holy lasers.",
													 "Shower the field with celestial forces and holy lasers.",
													 "MAGICAL SHIT HAPPENS",
													 "MAGICAL SHIT HAPPENS");
		//this whole Current Unit Bonus thing is also optional. I don't know. 
		//I want additional bonuses though besides just the attack. 
		//It could also apply to both units instead of the one you're controlling (current).
		public static const ffBonuses=new Array("If C. Kata is the Current Unit, she gets 1.5x AP.",
												"If Cia M. is the Current Unit, she gets 1.5x Speed",
												"If Charles Y. is the Current Unit, WHAT YOU WANT",
												"If Nate M. is the Current Unit, WHAT YOU WANT");
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
		public static function getSpeed(id:int):int {
			return speed[id];
		}
		public static function getCarry(id:int):int {
			return carry[id];
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
	}
}