/*
An Enemy is something that the PC will attack. Obviously. 
*/
package enemies{
	import actors.*;
	import attacks.*;
	import effects.*;
	import game.*;
	import levels.*;
	import ui.*;
	import util.*;

	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.*;
	import flash.ui.*;

	import flash.utils.Timer;
	import flash.events.TimerEvent;
	public class Enemy extends Action {

		static public var list:Array=[];
		public var Name;
		public var eHealth;
		public var maxHealth;
		public var barrier;
		public var maxBarrier;
		public var AP;
		public var xspeed;
		public var yspeed;
		//public var speed;
		public var attackDelay;
		public var collideCountC;
		public var collideCountP;
		/*public var pxpos;
		public var pypos;

		public var moveArray:Array;
		public var prevMoveCount;
		public var moveCount;
		public var waitCount;
		public var maxWaitCount;
*/
		/**
		 * Statuses!
		 * Stun
		 * Shock (same thing really) 
		 * Poison
		 **/
		public var stunTimes=0;
		public var shockTimes=0;
		public var poisonTimes=0;
		public var stunTimer:Timer;
		public var shockTimer:Timer;
		public var poisonTimer:Timer;

		public var level;

		//static public var tileMap;

		public function Enemy() {
			//super
			//super();

			//Enemy
			Name=":D";
			eHealth=1000;
			maxHealth=1000;
			barrier=0;
			maxBarrier=50;
			AP=1;
			speed=5;
			xspeed=speed;
			yspeed=speed;
			collideCountC=0;
			collideCountP=0;
			/*pxpos=0;
			pypos=0;

			moveArray=[];
			prevMoveCount=0;
			moveCount=1;
			waitCount=0;
			maxWaitCount=24*0;
*/
			pauseAction=false;

			switch (SuperLevel.diff) {
				case 0 :
					attackDelay=10;
					break;
				case 1 :
					attackDelay=7;
					break;
				case 2 :
					attackDelay=4;
					break;
			}
			list.push(this);
			addEventListener(Event.ENTER_FRAME, collideHandler);

		}
		public function begin() {


		}
		public function end() {

		}

		override public function gameHandler(e) {
		}
		public function collideHandler(e) {
			if (!superPause) {
				if (this.hitTestObject(Unit.currentUnit)) {
					if (collideCountC%3==0) {
						Unit.currentUnit.updateHP(1);
						collideCountC=1;
					}

					collideCountC++;
				}
				if (this.hitTestObject(Unit.partnerUnit)) {
					if (collideCountP%3==0) {
						Unit.partnerUnit.updateHP(1);
						collideCountP=1;
					}

					collideCountP++;
				}
			}
		}
		public function kill() {
			end();
			this.parent.removeChild(this);
			list.splice(list.indexOf(this),1);
		}

		public function updateHP(damage) {

		}

		//Status moves

		public function shock(times) {
			if (shockTimes<=0) {
				shockTimes=times;
				shockTimer=new Timer(500,0);
				shockTimer.addEventListener("timer", shockTime);
				shockTimer.start();
				pauseAction = true;

			}
		}
		public function shockTime(e) {
			updateHP(Math.floor(Math.random()*3+1));
			shockTimes--;
			if (shockTimes==0) {
				shockTimer.stop();
				shockTimer.removeEventListener("timer", shockTime);
				pauseAction = false;
			}

		}
		//All possible non-time moves
		public function changeWait(mwc) {
			maxWaitCount=mwc;
		}
		/*
		//All possible sequential moves
		public function moveLeft() {
			if (prevMoveCount!=moveCount) {
				prevMoveCount=moveCount;
				pxpos=x-32;
				pypos=y;
				addEventListener(Event.ENTER_FRAME, moveHandler);
			}
		}
		public function moveDown() {
			if (prevMoveCount!=moveCount) {
				prevMoveCount=moveCount;
				pxpos=x;
				pypos=y+32;
				addEventListener(Event.ENTER_FRAME, moveHandler);
			}
		}
		public function moveUp() {
			if (prevMoveCount!=moveCount) {
				prevMoveCount=moveCount;
				pxpos=x;
				pypos=y-32;
				addEventListener(Event.ENTER_FRAME, moveHandler);
			}
		}
		public function moveRight() {
			if (prevMoveCount!=moveCount) {
				prevMoveCount=moveCount;
				pxpos=x+32;
				pypos=y;
				addEventListener(Event.ENTER_FRAME, moveHandler);
			}
		}
		public function moveRandom() {
			if (prevMoveCount!=moveCount) {
				prevMoveCount=moveCount;
				pxpos=x+Math.floor(Math.random()*64-32);
				pypos=y+Math.floor(Math.random()*64-32);
				addEventListener(Event.ENTER_FRAME, moveHandler);
			}
		}
		public function moveBy(dx, dy) {
			if (prevMoveCount!=moveCount) {
				prevMoveCount=moveCount;
				pxpos=x+dx;
				pypos=y+dy;
				addEventListener(Event.ENTER_FRAME, moveHandler);
			}
		}
		public function moveTo(px, py) {
			if (prevMoveCount!=moveCount) {
				prevMoveCount=moveCount;
				pxpos=px;
				pypos=py;
				addEventListener(Event.ENTER_FRAME, moveHandler);
			}
		}
		public function waitHandler(e) {
			if (waitCount<maxWaitCount) {
				waitCount++;
			} else {
				prevMoveCount=moveCount;
				moveCount++;
				waitCount=0;
				addEventListener(Event.ENTER_FRAME, gameHandler);
				removeEventListener(Event.ENTER_FRAME, waitHandler);
			}
		}
		public function moveHandler(e) {
			if (! pauseMovement) {
				if (pxpos<0) {
					pxpos=0;
				}
				if (pypos<0) {
					pypos=0;
				}
				var pxtile=Math.floor(pxpos/SuperLevel.tileWidth);
				var pytile=Math.floor(pypos/SuperLevel.tileHeight);
				var xtile=Math.floor(x/SuperLevel.tileWidth);
				var ytile=Math.floor(y/SuperLevel.tileHeight);
				if (! tileMap["t_"+pytile+"_"+pxtile].walkable) {
					if (! tileMap["t_"+ytile+"_"+pxtile].walkable) {
						while (! tileMap["t_"+ytile+"_"+pxtile].walkable) {
							trace("ahhh");
							if (pxpos>x) {
								pxtile--;
							} else if (x > pxpos) {
								pxtile++;
							}
						}
						if (pxpos>x) {
							pxpos=(pxtile+1)*SuperLevel.tileWidth-1;//-w_collision.x+width/2-4;
						} else if (x > pxpos) {
							pxpos=(pxtile)*SuperLevel.tileWidth;
						}
					}
					if (! tileMap["t_"+pytile+"_"+pxtile].walkable) {
						while (! tileMap["t_"+pytile+"_"+pxtile].walkable) {
							if (pypos>y) {
								pytile--;
							} else if (y > pypos) {
								pytile++;
							}
						}
						if (pypos>y) {
							//prevent bouncing
							pypos=(pytile+1)*SuperLevel.tileHeight-1;
						} else if (y > pypos) {
							pypos=(pytile)*SuperLevel.tileHeight;
						}
					}



				} else {
					if (Math.sqrt(Math.pow(pxpos-x,2)+Math.pow(pypos-y,2))>speed) {
						var radian=Math.atan2(pypos-y,pxpos-x);
						var degree = Math.round((radian*180/Math.PI));
						var px=x+speed*Math.cos(radian);
						var py=y+speed*Math.sin(radian);

						pxtile=Math.floor(px/SuperLevel.tileWidth);
						pytile=Math.floor(py/SuperLevel.tileHeight);
						if (! tileMap["t_"+pytile+"_"+pxtile].walkable) {
							if (! tileMap["t_"+ytile+"_"+pxtile].walkable) {
								while (! tileMap["t_"+ytile+"_"+pxtile].walkable) {
									if (px>x) {
										pxtile--;
									} else if (x > px) {
										pxtile++;
									}
								}
								if (px>x) {
									px=(pxtile)*SuperLevel.tileWidth;//-w_collision.x+width/2-4;
								} else if (x > px) {
									px=(pxtile)*SuperLevel.tileWidth;
								}

								x=px;
								y=py;

							} else if (! tileMap["t_"+pytile+"_"+xtile].walkable) {
								while (! tileMap["t_"+pytile+"_"+xtile].walkable) {
									if (py>y) {
										pytile--;
									} else if (y > py) {
										pytile++;
									}
								}
								if (py>y) {
									//prevent bouncing
									py=(pytile+1)*SuperLevel.tileHeight-1;//-w_collision.y+height/2-4;
								} else if (y > py) {
									py=(pytile)*SuperLevel.tileHeight;
								}
								x=px;
								y=py;
							} else {
								x=px;
								y=py;
							}
						} else {
							x=px;
							y=py;
						}
					} else {
						x=pxpos;
						y=pypos;
						removeEventListener(Event.ENTER_FRAME, moveHandler);
						addEventListener(Event.ENTER_FRAME, waitHandler);
					}
				}
			}
		}
		*/
		
		
		
	}
}