/**
 * Buffs range from stat bonuses granted from abilities/items to debuffs that inflict exhaust/sick/whatever.
 * Generally if it's a specific debuff, it'll be named "Exhaust" or "Sick" or whatever. 
 * If it's a stat bonus from an ability, it should be labeled the name of that ability.
 */

package abilities{
	import game.GameUnit;

	public class Buff {

		/**
		 * Name - Name of the Buff
		 * duration - how long the buff lasts (0 lasts indefinitely)
		 * maxNumber - how many times this buff can be stacked
		 */
		
		public var Name:String;
		public var duration:int;
		public var maxNumber:int;
		public var debuffType:String;
		public var target;
		
		/**
		 * More fields can be added here when the time comes, like life-stealing/siphoning, critical strikes/lucky shots, or w/e.
		 */
		
		public var attackLump;
		public var attackPerc;
		public var defenseLump;
		public var defensePerc;
		public var speedLump;
		public var speedPerc;
		public var rangeLump;
		public var rangePerc;
		public var cooldownLump;
		public var cooldownPerc;
		
		public var slowPerc;
		public var sickPerc;
		public var sickTime;
		public var regenLump;
		public var regenPerc;
		public var regenTime;
		

		public function Buff(ability:Ability, debuffType:String, target) {
			
			this.Name = ability.Name;
			this.duration = ability.bonusDuration;
			this.maxNumber = 9;
			this.debuffType = debuffType;
			this.target = target;
			
			this.attackLump = 0;
			this.attackPerc = 0;
			this.defenseLump = 0;
			this.defensePerc = 0;
			this.speedLump = 0;
			this.speedPerc = 0;
			this.rangeLump = 0;
			this.rangePerc = 0;
			this.cooldownLump = 0;
			this.slowPerc = 0;
			this.sickPerc = 0;
			this.sickTime = 0;
			this.regenLump = 0;
			this.regenPerc = 0;
			this.regenTime = 0;
		
			if (debuffType == "Ability") {
				this.attackLump = ability.attackLump;
				this.attackPerc = ability.attackPerc;
				this.defenseLump = ability.defenseLump;
				this.defensePerc = ability.defensePerc;
				this.speedLump = ability.speedLump;
				this.speedPerc = ability.speedPerc;
				this.rangeLump = ability.rangeLump;
				this.rangePerc = ability.rangePerc;
				this.cooldownLump = ability.cooldownLump;
				this.cooldownPerc = ability.cooldownPerc;				
			} else {		
				switch(debuffType) {
					case "Stun":
						this.duration = ability.stunDuration;					
					break;
					case "Slow":
						this.duration = ability.slowDuration;	
						this.slowPerc = ability.slowPerc;							
					break;
					case "Sick":
						this.duration = ability.sickDuration;
						this.sickPerc = ability.sickPerc;
						this.sickTime = ability.sickTime;
					break;
					case "Exhaust":
						this.duration = ability.exhaustDuration;			
					break;
					case "Regen":
						this.duration = ability.regenDuration;	
						this.regenLump = ability.regenLump;
						this.regenPerc = ability.regenPerc;
						this.regenTime = ability.regenTime;
					break;
					
				}
			}
		}
		
		public function tick() {
			this.duration--;
			var healthBonus;
			if (this.debuffType == "Sick" && Math.abs(this.duration) % this.sickTime == 0) {
				healthBonus = target.maxHP * (this.sickPerc / 100);
				target.updateHP(healthBonus, "Yes");
			} else if (this.debuffType == "Regen" && Math.abs(this.duration) % this.regenTime == 0) {
				healthBonus = target.maxHP * (this.regenPerc / 100) + this.regenLump;
				target.updateHP( -1 * healthBonus, "Yes");
			}
		}
	}
}