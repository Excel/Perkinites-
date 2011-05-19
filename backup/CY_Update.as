/*
Update is an ability only available to CY.
It reduces cooldown times and increases dash speeds.
*/
package abilities{

	import flash.events.*;
	import flash.display.MovieClip;
	import flash.ui.Keyboard;

	import actors.*;

	public class CY_Update extends Ability {

		public function CY_Update() {
			super();
			Name="Update";
			description="Increase your team's dash speeds and reduce your team's cooldown times.";
			EP=0;
			cooldown=0;
			maxCooldown=30*FPS;
			uses=1;
			maxUses=1;
			canHotkey=true;
		}
		override public function activate(xpos, ypos) {
			if (uses>0) {
				uses--;
				cooldown=maxCooldown;

				var u1=Unit.currentUnit;
				var u2=Unit.partnerUnit;
				var i;
				u1.speed+=5;
				u1.dashSpeed+=10;
				u2.speed+=5;
				u2.dashSpeed+=10;

				if (u1.HP>0) {
					for (i = 0; i < u1.commands.length; i++) {
						if (u1.commands[i]!=this) {
							u1.commands[i].cooldown-=5*FPS;
							u1.commands[i].maxCooldown-=5*FPS;
						}
					}
				}
				if (u2.HP>0) {
					for (i = 0; i < u2.commands.length; i++) {
						if (u2.commands[i]!=this) {
							u2.commands[i].cooldown-=5*FPS;
							u2.commands[i].maxCooldown-=5*FPS;
						}
					}
				}
				addEventListener(Event.ENTER_FRAME, cooldownHandler);
			} else {
				return false;
			}
		}
		override public function cooldownHandler(e) {
			cooldown--;
			if (cooldown==15*FPS) {
				trace("okay");
				var u1=Unit.currentUnit;
				var u2=Unit.partnerUnit;
				var i;
				u1.speed-=5;
				u1.dashSpeed-=10;
				u2.speed-=5;
				u2.dashSpeed-=10;

				if (u1.HP>0) {
					for (i = 0; i < u1.commands.length; i++) {
						if (u1.commands[i]!=this) {
							u1.commands[i].maxCooldown+=5*FPS;
						}
					}
				}
				if (u2.HP>0) {
					for (i = 0; i < u2.commands.length; i++) {
						if (u2.commands[i]!=this) {
							u2.commands[i].maxCooldown+=5*FPS;
						}
					}
				}
			}
			if (cooldown<=0) {
				removeEventListener(Event.ENTER_FRAME, cooldownHandler);
				cooldown=0;
				uses=maxUses;
			}
		}

	}
}