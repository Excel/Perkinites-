/*
An Enemy is something that the PC will attack. Obviously. 
*/
package enemies{
	
	import flash.text.TextField;
	import actors.*;
	import attacks.*;
	import effects.*;
	import util.*;

	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.*;
	import flash.ui.*;

	import flash.utils.Timer;
	import flash.events.TimerEvent;
	public class CL extends Enemy {

		public var count;
		public var pattern;

		public var trans;
		public var moveDisplay;

		public var middleX;

		//this timer controls a shooting interval
		public var waitTimer:Timer;
		public var shootTimer:Timer;
		public var shadowDancerTimer:Timer;

		public function CL() {
			//super
			super(6);

			this.eHP.text=this.HP;

			count=0;
			pattern=1;
			sword1.visible = false;
			sword2.visible = false;
			middleX=320;


			//boss ship will shoot every 2 seconds
			var interval:int=2500;
			//create a timer instance to control it
			waitTimer=new Timer(interval,0);
			waitTimer.addEventListener("timer", wait);

			//boss ship will shoot every 2 seconds
			interval=attackDelay*100;
			//create a timer instance to control it
			shootTimer=new Timer(interval,0);
			shootTimer.addEventListener("timer", shoot);

			//boss ship will shoot every 2 seconds
			interval=1000;
			//create a timer instance to control it
			shadowDancerTimer=new Timer(interval,0);
			shadowDancerTimer.addEventListener("timer", dance);

		}

		public function showSwords(){
			var sound = new se_slash();
			sound.play();
			sword1.visible = true;
			sword2.visible = true;
			sword1.gotoAndStop(1);
						sword2.gotoAndStop(1);
			sword1.addEventListener(Event.ENTER_FRAME, swordHandler);
		}
		
		public function swordHandler(e){
			if(sword1.currentFrame < 5){
				sword1.gotoAndStop(sword1.currentFrame+1);
				sword2.gotoAndStop(sword2.currentFrame+1);
			}
		}
		override public function updateHP(damage) {
			if (barrier>0) {
				barrier-=damage;
			} else {
				HP-=damage;
			}
			if (0>=HP) {
				kill();
			}
			if (barrier>0) {
				eHP.text=barrier;
			} else {
				eHP.text=HP;
			}
		}

		override public function begin() {
			if (pattern==1||pattern==3||pattern==5) {
				addEventListener(Event.ENTER_FRAME,move1);
				shootTimer.start();
			}
			if (pattern==2||pattern==6) {
				addEventListener(Event.ENTER_FRAME,move2);
			}


		}
		override public function end() {
			removeEventListener(Event.ENTER_FRAME,move1);
			removeEventListener(Event.ENTER_FRAME,move2);
			removeEventListener(Event.ENTER_FRAME,move3);
			removeEventListener(Event.ENTER_FRAME,move4);
		}

		public function move1(e) {
			x+=xspeed;
			if (x>480||100>x) {
				xspeed*=-1;
			}
			if (x==320) {
				removeEventListener(Event.ENTER_FRAME,move1);
				shootTimer.stop();
				waitTimer.start();
			}
		}

		public function move2(e) {
			

			var b;

			if (y+yspeed>416) {
				yspeed*=-1;
			}
			y+=yspeed;
			if (count%attackDelay==0) {
				b=new CLBullet(-20,0,AP,"Enemy", level.tileMap);
				b.x=this.x;
				b.y=this.y;
				this.parent.addChild(b);
				b=new CLBullet(20,0,AP,"Enemy", level.tileMap);
				b.x=this.x;
				b.y=this.y;
				this.parent.addChild(b);
			}
			if (y<280&&yspeed<0) {
				if (count%(attackDelay*2)==0) {
					for (var i=0; i<360; i+=15) {
						b=new CLBullet(15*Math.cos(i*Math.PI/180),15*Math.sin(i*Math.PI/180),1,"Enemy", level.tileMap);
						b.x=this.x;
						b.y=this.y;
						this.parent.addChild(b);
					}
				}
			}
			if (y==120) {
				if (pattern==6) {
					removeEventListener(Event.ENTER_FRAME,move2);
					trans=new TransitionScreen();
					trans.seconds=2;
					trans.alphaMax=.5;
					this.parent.addChild(trans);
					var sound = new se_timestop0();
					sound.play();
					var interval=3000;
					waitTimer=new Timer(interval,0);
					waitTimer.addEventListener("timer", wait);
					waitTimer.start();
				} else {
					removeEventListener(Event.ENTER_FRAME,move2);
					addEventListener(Event.ENTER_FRAME, move1);
					shootTimer.start();
					pattern++;
				}
				count=0;

			}

			count++;
		}

		public function move3(e) {
						this.rotation +=24;
			var b;
			count++;
			if (x+xspeed>544||96>x+xspeed) {
				xspeed*=-1;
			}
			if (y+yspeed>416||128>y+yspeed) {
				yspeed*=-1;
			}
			x+=xspeed;
			y+=yspeed;

			if (count%(attackDelay*4)==0) {
				for (var i=0; i<360; i+=30) {
					b=new CLBullet(20*Math.cos(i*Math.PI/180),20*Math.sin(i*Math.PI/180),1,"Enemy", level.tileMap);
					b.x=this.x;
					b.y=this.y;
					this.parent.addChild(b);
				}
			}
			if (count>120) {
				rotation = 0;
				x=320;
				y=120;
				removeEventListener(Event.ENTER_FRAME,move3);
				count=0;
				waitTimer.start();

			}

		}

		public function move4(e) {
			count++;
			if (count==60) {
				moveDisplay.seconds=1;
				moveDisplay.fadeIn=false;

			}
		}

		public function wait(e:TimerEvent) {
			if (pattern==1||pattern==5) {
				pattern++;
				waitTimer.stop();
				yspeed=10;
				count = 0;
				addEventListener(Event.ENTER_FRAME,move2);
			} else if (pattern == 3 || pattern == 7) {
				pattern++;
				waitTimer.stop();
				xspeed=Math.random()*5+10;
				yspeed=Math.random()*5+10;
				if (Math.random()*2<1) {
					xspeed*=-1;
				}
				addEventListener(Event.ENTER_FRAME,move3);
			} else if (pattern == 4 || pattern == 8) {
				if (pattern==8) {
					pattern=0;
				}
				pattern++;
				xspeed=5;
				yspeed=5;
				waitTimer.stop();
				addEventListener(Event.ENTER_FRAME,move1);
				shootTimer.start();
			} else if (pattern == 6) {
				pattern++;
				xspeed=5;
				yspeed=5;
				waitTimer.stop();
				trans.seconds=0.5;
				trans.fadeIn=false;
				addEventListener(Event.ENTER_FRAME,move4);

				var sound = new se_kira00();
				sound.play();

				moveDisplay=new AttackText("Ballroom Dance of DESTROY");
				moveDisplay.y=201;
				moveDisplay.seconds=0.2;
				this.parent.addChild(moveDisplay);
				shootTimer.start();
				shadowDancerTimer.start();
			}

		}

		public function shoot(e:TimerEvent) {
			//create three bullets for every shot
			if (stage!=null) {
				for (var i = -3; i < 4; i+=3) {
					var b=new CLBullet(i,15,AP,"Enemy", level.tileMap);
					b.x=this.x;
					b.y=this.y;

					this.parent.addChild(b);
				}
			}
		}

		public function dance(e:TimerEvent) {
			if (stage!=null) {
				var dir=Math.floor(Math.random()*4)*2+2;

				var sd=new ShadowDancer(AP,dir,level.tileMap);
				switch (dir) {
					case 2 :
						sd.x=Unit.currentUnit.xpos;
						sd.y=Unit.currentUnit.ypos-72;
						break;
					case 4 :
						sd.x=Unit.currentUnit.xpos+72;
						sd.y=Unit.currentUnit.ypos;
						break;
					case 6 :
						sd.x=Unit.currentUnit.xpos-72;
						sd.y=Unit.currentUnit.ypos;
						break;
					case 8 :
						sd.x=Unit.currentUnit.xpos;
						sd.y=Unit.currentUnit.ypos+72;
						break;
				}
				this.parent.addChild(sd);
			}
		}

	}
}