/*
Eyelash Batting is an ability only available to CK.
It has a 50% chance of stunning Male Enemies and certain Female Enemies.
*/
package abilities{

	import flash.events.*;
	import flash.display.MovieClip;
	import flash.ui.Keyboard;

	import actors.*;
	import attacks.*;

	public class CK_EyelashBatting extends Ability {

		public function CK_EyelashBatting() {
			super();
			Name="Eyelash Batting";
			description="Stun certain enemies at 50% chance.";
			index = 3;
			EP=0;
			SP=5;
			cooldown=0;
			maxCooldown=6*FPS;
			uses=1;
			maxUses=1;
			canHotkey=true;

			ranger=1;
		}
		override public function activate(xpos, ypos) {
			if (uses>0) {
				trace(EP + " " + SP);
				uses--;
				cooldown=maxCooldown;
				var px=Unit.currentUnit.parent.mouseX;
				var py=Unit.currentUnit.parent.mouseY;

				var radian=Math.atan2(py-ypos,px-xpos);
				var degree = (radian*180/Math.PI);

				var b1=new CK_ElecShot(SP*Math.cos(radian),SP*Math.sin(radian),EP,"PC",Unit.tileMap);
				b1.x=xpos+Unit.currentUnit.width*Math.cos(radian)/2;
				b1.y=ypos+Unit.currentUnit.height*Math.sin(radian)/2;

				b1.rotation=degree;
				Unit.currentUnit.parent.addChild(b1);
				Unit.currentUnit.parent.setChildIndex(b1, 0);

				addEventListener(Event.ENTER_FRAME, cooldownHandler);
			} else {
				return false;
			}
		}
	}
}