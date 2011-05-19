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

	public class CM extends Unit {
		
		public function CM() {
			super();
			Name="Cia M.";
			HP=60;
			maxHP=60;
			AP=3;
			DP=0;
			LP=1;
			speed=20;
			dashSpeed=32;
			xtile=Math.floor(x/SuperLevel.tileWidth);
			ytile=Math.floor(y/SuperLevel.tileHeight);
			dir=8;
			commands=[];
			commands.push(new CM_Cheer());
			//commands.push(new CM_MagicalSiphoning());
			//commands.push(new CM_Starpulse());
			//commands.push(new CM_Punk Magus());
			
			commands.push(Unit.Items[0]);
			hk3 = commands[1];
			gotoAndStop(4);
		}





		
	}
}






