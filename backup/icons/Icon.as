/*
The PowerUp class will create a powerup at an interval defined in the LevelManager (every 10 seconds)
*/

package icons{

	import flash.display.*;
	import flash.events.*;

	import actors.*;
	import attacks.*;
	import enemies.*;
	public class Icon extends MovieClip {
		//each power up will have an x velocity and a y velocity
		public var xv:Number;
		public var yv:Number;
		//each power up will randomly decide when it's created what kind it is: SHIELD, NUKE, or HEALTH
		public var friend:String;
		public var friendList:Array;

		public function Icon(level) {
			//when a powe up is created (from the powerup timer in the level manager) position it to the right of the stage
			x=690;
			//position it at a random height
			y = Math.floor(Math.random()*(430)+25);
			//add an ENTER_FRAME event so we can do some logic at frame rate
			addEventListener(Event.ENTER_FRAME, gameHandler);
			//cacheAsBitmap = true;
			//set its x velocity
			xv=15;
			//now have it decide what type of power up it's going to be
			friend=defineFriend(level);
			firstLetter.text=friend.substring(0,1);

		}

		//this method will randomly decide what type of power up it's going to be
		public function defineFriend(level) {
			switch (level.setLevel) {
				case 1 :
					friendList=new Array("Chloe","Veronica","Patrick","Kevin","Sophie");
					break;
				case 2 :
					break;
				case 3 :
					break;
				case 4 :
					break;
				case 5 :
					break;
				case 6 :
					friendList=new Array("Jixuan","Lobsang");
					break;
				case 7 :
					break;
			}
			return friendList[Math.floor(Math.random()*friendList.length)];
		}

		//do this at frame rate
		public function gameHandler(e:Event) {
			//rotate the graphic for fun
			//rotation-=2;
			//update its position, move it from right to left
			x-=xv;
			//if it's reached the left end of the stage, kill it
			if (-50>x) {
				kill();
				return;
			}

			if (this.hitTestObject(Unit.list[0])) {

				var sound = new se_charge00();
				sound.play();
				awardFriend();
				kill();
				return;
			}
			//if the heor ship is not dead
			/*if (Game.main.ship!=null) {
			//if the hero ship hits this powerup
			if (this.hitTestObject(Game.main.ship.hitRect)) {
			//award the power up to the ship
			awardPowerup();
			//show a point display with text that labels what powerup you've just gotten
			var d=new PointDisplay(x,y,powerType,1);
			//add that point display to stage
			Game.main.spriteClip.addChild(d);
			//kill this power up graphic
			kill();
			}
			}*/
		}

		//this method caries out the reward
		public function awardFriend() {
			switch (friend) {
				case "Chloe" :
					Unit.health+=2;
					if (Unit.health>Unit.maxHealth) {
						Unit.health=Unit.maxHealth;
					}
					break;
				case "Veronica" :
					var a=new BurpBullet(25,0,20,"PC");
					a.x=this.x;
					a.y=this.y;
					if (stage!=null) {
						stage.addChild(a);
					}
					break;
				case "Patrick" :
					break;
				case "Kevin" :
					break;
				case "Sophie" :
					var list=Enemy.list;
					for (var i = 0; i < list.length; i++) {
						if (640>=list[i].x) {
							list[i].eHealth-=10;
							list[i].eHP.text=list[i].eHealth;
						}
					}



					break;
			}
		}

		//this method kills the powerup
		public function kill() {
			removeEventListener(Event.ENTER_FRAME, gameHandler);
			if (stage!=null) {
				stage.removeChild(this);
			}
			//add a sound effect
			//var s = new SoundPower();
			//s.play();

		}
	}
}