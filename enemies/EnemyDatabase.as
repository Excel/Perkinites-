package enemies{
	public class EnemyDatabase {
		public static const names=new Array(":D","Bulleter",":D",":D","Engineer","Drunk Guy","Clarissa");
		public static const hp=new Array(10,30,1,1,50,725,700);
		public static const dmg=new Array(3,3,3,3,3,3,3);
		public static const armor=new Array(0,0,0,0,0,0,0);
		public static const speed=new Array(16,16,16,16,16,2,16);
		public static const barrier = new Array(0,0,0,0,0,0,100);

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
		public static function getBarrier(id:int):int {
			return barrier[id];
		}

	}
}