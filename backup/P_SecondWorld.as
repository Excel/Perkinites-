/*
Second World is an ability that is available to all Perkinites.
When the Unit is KOed, this ability is automatically used and restores the Unit to full HP.
This can only be used once per runthrough.
It's number of uses is restored when exiting a level/getting a gameover.
There is no cooldown.
*/
package abilities{

	import flash.events.*;
	import flash.display.MovieClip;
	import flash.ui.Keyboard;

	import actors.*;

	public class P_SecondWorld extends Ability {

		public function P_SecondWorld() {
			super();
			Name="Second World";
			EP=0;
			cooldown=0;
			maxCooldown=0;
			uses=1;
			maxUses=1;
			canHotkey=false;
		}
		override public function activate(xpos, ypos) {
			if (uses>0) {
				uses--;
				return true;
			}
			else{
				return false;
			}
		}

	}
}