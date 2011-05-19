package actors{
	public class ActorDatabase {
		public static const names = new Array("C. Kata", "Cia M.", "Charles Y.", "Nate M.");
		public static const hp	= new Array(75, 90, 60, 100);
		public static const dmg	= new Array(3, 3, 3, 3);
		public static const armor = new Array(0, 0, 0, 0);
		public static const speed = new Array(32, 20, 32, 32);
		
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
	}
}