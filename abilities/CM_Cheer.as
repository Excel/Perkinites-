/*
Cheer is a passive ability only available to CM.
It heals CK by 2 HP every 5 seconds.
*/
package abilities{

	import flash.events.*;
	import flash.display.MovieClip;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	import flash.events.TimerEvent;

	import actors.*;

	public class CM_Cheer extends Ability {

		static var CKName = "C. Kata";
		var healTimer:Timer;

		public function CM_Cheer() {
			super();
			Name="Update";
			description="Restores a small amount of HP to Christina every five seconds.";
			EP=0;
			cooldown=0;
			maxCooldown=0;
			uses=0;
			maxUses=0;
			canHotkey=false;
			healTimer=new Timer(5000,0);
			healTimer.addEventListener("timer", heal);
			healTimer.start();

		}

		public function heal(e) {
			var CK;
			if (Unit.currentUnit.Name==CKName) {
				CK=Unit.currentUnit;
			} else if (Unit.partnerUnit.Name == CKName) {
				CK=Unit.partnerUnit;
			}
			var healing=-1*Math.ceil(CK.maxHP/25);
			CK.updateHP(healing);
		}

		override public function enable(switchOn) {
			if (switchOn) {
				healTimer.start();
			} else {
				healTimer.stop();
			}

		}

	}
}