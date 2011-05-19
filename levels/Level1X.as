package levels{
	import actors.*;
	import attacks.*;
	import enemies.*;
	import util.*;

	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.*;
	import flash.ui.*;

	import flash.utils.Timer;
	import flash.events.TimerEvent;

	public class Level1X extends SuperLevel {

		public var numberOnTimer:Timer;
		public var numberOffTimer:Timer;

		function Level1X() {
			mapClip = new MovieClip();
			setLevel=1;
			//Dialogue goes here
			names=[];
			messages=[];
			names.push("HV");
			messages.push("You'll never get away with this, evil lady! My friends will be here to kick the crap outta you!");
			names.push("Unknown Invader");
			messages.push("Be quiet. By the royal Legrangian order, I hereby imprison your soul to the eternal prison from beyond."); 
			names.push("HV");
			messages.push("NOOOOOOOOOOOOOO!");
			names.push("NM");
			messages.push("WOAAAHHH. What are you doing with THE GIRL!?");
			names.push("HV");
			messages.push("Yay! You guys came to save me! :)");
			names.push("Unknown Invader");
			messages.push("Curses. I see you have gotten past my defenses.");
			names.push("CY");
			messages.push("Drunk people aren't really much of a defense...");
			names.push("CM");
			messages.push("Who are you anyway!?");
			names.push("Unknown Invader");
			messages.push("Well then, allow me to formally introduce myself. I wouldn't expect lowly children to know of my high ranking.");
			names.push("Clarissa");
			messages.push("I am Clarissa Legrange, the Third and Only, who is the rightful heir to the royal Legrangian throne.");
			names.push("Clarissa");
			messages.push("We have designated this girl and this shoddy building as part of our property.");
			names.push("NM");
			messages.push("Let her go man, she's OUR property!");
			names.push("HV");
			messages.push("Wait WTF man.");
			names.push("Clarissa");
			messages.push("You really think you're in a position to order me around? Hahahahaha-");
			names.push("CK");
			messages.push("Bitch, I'm giving you 'til the count of one hundred and twenty five to let go of the girl, or shit's gonna fly.");
			names.push("HV");
			messages.push("AHHHHHHHHHHHHHH!");
			names.push("NM");
			messages.push("Quit distracting us! We're trying to rescue you!");
			names.push("Clarissa");
			messages.push("I do not need this pointless bickering from the commoners. We shall settle this with a duel!");
			names.push("NM");
			messages.push("Game on, bitch!");


			myMap=[
			   [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
			   [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
			   [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
			   [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
			   [1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1],
			   [1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1],
			   [1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1],
			   [1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1],
			   [1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1],
			   [1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1],
			   [1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1],
			   [1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1],
			   [1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1],
			   [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
			   [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]];
			this.tileMap=buildMap();
			doors["t_"+0+"_"+0]=new Level1A();

			numberOnTimer=new Timer(5000,0);
			numberOnTimer.addEventListener("timer",numberOn);

			numberOffTimer=new Timer(2500,0);
			numberOffTimer.addEventListener("timer",numberOff);
		}

		override public function buildEvents() {
			//set up Hero
			var u=new Unit  ;
			Unit.level=this;
			Unit.tileMap= this.tileMap;
			u.x=200;
			u.y=200;
			mapClip.addChild(u);
			u.begin();
			//set up Enemies
			var c=new CL();
			c.x=320;
			c.y=230;
			c.level = this;
			mapClip.addChild(c);

			addEventListener(Event.ENTER_FRAME,talkingHandler);
			stage.addEventListener(KeyboardEvent.KEY_DOWN,talkingConfirmHandler);
			stage.addEventListener(Event.ENTER_FRAME, VCamHandler);
			//stage.addEventListener(Event.ENTER_FRAME, gameHandler);
			//c.begin();
			//numberOnTimer.start();
		}

		public function talkingHandler(e) {
			if (dialogueIndex>=messages.length) {
				if (messages.length>0) {
					Enemy.list[0].begin();
					Enemy.list[0].showSwords();
				}
				dialogueIndex=0;
				names=[];
				messages=[];
				//removeEventListener(Event.ENTER_FRAME,talkingHandler);
				removeEventListener(KeyboardEvent.KEY_DOWN,talkingConfirmHandler);


			} else {
				talking(dialogueIndex,fastforward);
			}
		}

		public function talkingConfirmHandler(e) {
			if (messages.length>0) {
				if (e.keyCode==Keyboard.ENTER) {
					if (! fastforward) {
						fastforward=true;
					} else {
						if (messagebox.parent==stage) {
							stage.removeChild(messagebox);
						}
						charDisplay=0;
						dialogueIndex++;
						fastforward=false;
					}

				}
			}
		}
		public function numberOn(e:TimerEvent) {
			/*var choices=[];
			var damage=15;
			var numbers=[];
			var min=99;
			var index=0;
			var i;

			for (i=0; i<=9; i++) {
				choices.push(i);
			}
			for (i=0; i<4; i++) {
				var rand=choices.splice(Math.floor(Math.random()*choices.length),1);
				trace(rand);

				numbers[i]=rand;
				if (min>numbers[i]) {
					min=numbers[i];
					index=i;
				}
			}
			var glyphs=NumberGlyph.create(numbers,index);
			for (i=0; i<4; i++) {
				mapClip.addChild(glyphs[i]);
			}
			numberOnTimer.stop();
			numberOffTimer.start();
*/
		}
		public function numberOff(e:TimerEvent) {
			/*var list=NumberGlyph.totalNumbers;
			for (var i=0; i<list.length; i++) {
				list[i].kill();
			}
			list=[];
			numberOffTimer.stop();
			numberOnTimer.start();*/
		}


	}
}