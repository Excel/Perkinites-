/*
*/
package actors{

	import flash.events.*;
	import flash.display.MovieClip;
	import flash.ui.Keyboard;

	import abilities.*;
	import attacks.*;
	import enemies.*;
	import levels.*;
	import util.*;

	public class CY extends Unit {

		public function CY() {
			super();
			Name="Charles Y.";
			HP=75;
			maxHP=75;
			AP=3;
			DP=0;
			LP=1;
			speed=32;
			dashSpeed=32;
			xtile=Math.floor(x/SuperLevel.tileWidth);
			ytile=Math.floor(y/SuperLevel.tileHeight);
			dir=8;
			commands=[];
			commands.push(new CY_Upgrade());
			//commands.push(new CY_Teleport());
			commands.push(new CK_SharpShooter());
			
			hk1 = commands[0];
			hk2 = commands[1];
			gotoAndStop(4);
		}






	}
}