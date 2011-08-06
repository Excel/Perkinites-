/*
Break Time is an ability available to all Perkinites.
It freezes everything for three seconds except your team.
*/
package abilities{

	import flash.events.*;
	import flash.display.MovieClip;
	import flash.ui.Keyboard;

	import actors.*;
	import enemies.*;

	public class P_BreakTime extends Ability {

		public function P_BreakTime() {
			super();
			Name="Break Time";
			description="Freezes all enemies and attacks for three seconds.";
			index = 5;
			EP=0;
			cooldown=0;
			maxCooldown=30*FPS;
			uses=1;
			maxUses=1;
			canHotkey=true;
		}
		override public function activate(xpos, ypos) {
			if (uses>0) {
				trace("Sharp Shooter");
				uses--;
				cooldown=maxCooldown;

				var i;
				for (i = 0; i < Enemy.list.length; i++) {
					Enemy.list[i].pauseAction=true;
				}
				addEventListener(Event.ENTER_FRAME, cooldownHandler);
			} else {
				return false;
			}
		}
	}
}