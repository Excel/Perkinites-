/*
Sharp Shooter is an ability only available to CK.
It increases Ranger attacks and speeds.
*/
package abilities{

	import flash.events.*;
	import flash.display.MovieClip;
	import flash.ui.Keyboard;

	import actors.*;

	public class CK_SharpShooter extends Ability {

		public function CK_SharpShooter() {
			super();
			Name="Sharp Shooter";
			description="Increase your team's attack speeds and attack power for Ranger-type Abilities for fifteen seconds.";
			index=4;
			EP=0;
			cooldown=0;
			maxCooldown=20*FPS;
			uses=1;
			maxUses=1;
			canHotkey=true;
		}
		override public function activate(xpos, ypos) {
			if (uses>0) {
				trace("Sharp Shooter");
				uses--;
				cooldown=maxCooldown;

				var u1=Unit.currentUnit;
				var u2=Unit.partnerUnit;
				var i;

				if (u1.HP>0) {
					for (i = 0; i < u1.commands.length; i++) {
						if (u1.commands[i]!=this&&u1.commands[i].ranger==1) {
							u1.commands[i].EP*=2;
							u1.commands[i].EP+=5;
							u1.commands[i].SP*=1.5;

						}
					}
				}
				if (u2.HP>0) {
					for (i = 0; i < u2.commands.length; i++) {
						if (u2.commands[i]!=this&&u2.commands[i].ranger==1) {
							u2.commands[i].EP*=2;
							u2.commands[i].EP+=5;
							u2.commands[i].SP*=1.5;
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
			if (cooldown==5*FPS) {
				var u1=Unit.currentUnit;
				var u2=Unit.partnerUnit;
				var i;

				if (u1.HP>0) {
					for (i = 0; i < u1.commands.length; i++) {
						if (u1.commands[i]!=this&&u1.commands[i].ranger==1) {
							u1.commands[i].EP-=5;
							u1.commands[i].EP/=2;
							u1.commands[i].SP/=1.5;
						}
					}
				}
				if (u2.HP>0) {
					for (i = 0; i < u2.commands.length; i++) {
						if (u2.commands[i]!=this&&u2.commands[i].ranger==1) {
							u2.commands[i].EP-=5;
							u2.commands[i].EP/=2;
							u2.commands[i].SP/=1.5;
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