package util{

	import flash.display.MovieClip;
	import flash.events.*;
	import flash.ui.*;
	public class PopUp extends MovieClip {

		var duration:int;
		var fadeSpeed:Number;
		var fadeDir:int;
		var delay:int;
		function PopUp(type:int, d:int) {
			duration=24;
			fadeSpeed=0.5;
			fadeDir=1;
			if (type==1) {
				//Enemy Damage
				damage.text=String(d);
				stop();
			} else if (type == 2) {
				//Player Damage
				gotoAndStop(2);
				damage.text=String(d);
			} else if (type == 3) {
				//Healing Damage
				gotoAndStop(3);
			} else if (type == 4) {
				//Level Up!
				gotoAndStop(4);
			}

			addEventListener(Event.ENTER_FRAME, gameHandler);
			alpha=0;
			delay=24;
		}
		function gameHandler(e) {

			//increase the alpha by the fadeSpeed
			alpha+=fadeSpeed*fadeDir;
			if (fadeDir<0) {
				y-=2;
			}
			//if it fading in and reaches solid state
			if (fadeDir==1&&alpha>=1) {
				//reverse it's fade direction so it will start to fade out
				fadeDir*=-1;
				fadeSpeed/=duration;
			}
			duration-=1;
			//if the duration runs out, or the display is now totally transparent
			if (duration<=0||alpha<=0) {
				removeEventListener(Event.ENTER_FRAME, gameHandler);
				this.parent.removeChild(this);
			}






		}
	}
}