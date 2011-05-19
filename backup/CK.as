/*
*/
package actors{

	import flash.events.*;
	import flash.display.MovieClip;
	import flash.ui.Keyboard;

	import abilities.*;
	import attacks.*;
	import enemies.*;
	import items.*;
	import levels.*;
	import util.*;

	public class CK extends Unit {

		public function CK() {
			super();
			Name="C. Kata";
			HP=90;
			maxHP=90;
			AP=3;
			DP=0;
			LP=1;
			speed=32;
			dashSpeed=32;
			xtile=Math.floor(x/SuperLevel.tileWidth);
			ytile=Math.floor(y/SuperLevel.tileHeight);
			dir=8;
			commands=[];
			commands.push(new CK_EyelashBatting());
			//commands.push(new CK_ShoeThrowing());
			commands.push(new CK_SharpShooter());
			commands.push(Unit.Items[0]);
			hk1 = commands[0];
			hk2 = commands[1];
			hk3 = commands[2];
			gotoAndStop(4);
		}






	}
}