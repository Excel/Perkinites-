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

	public class NM extends Unit {

		public function NM() {
			super();
			Name="Nate M.";
			HP=100;
			maxHP=100;
			AP=3;
			DP=0;
			LP=1;
			speed=32;
			dashSpeed=32;
			xtile=Math.floor(x/SuperLevel.tileWidth);
			ytile=Math.floor(y/SuperLevel.tileHeight);
			dir=8;
			commands=[];
			commands.push(new NM_EyelashBatting());
			//commands.push(new CK_ShoeThrowing());
			commands.push(new NM_SharpShooter());
			
			hk1 = commands[0];
			hk2 = commands[1];
			gotoAndStop(4);
		}






	}
}