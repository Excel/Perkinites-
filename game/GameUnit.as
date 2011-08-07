/*
*/
package game{


	import maps.*;
	import tileMapper.*;
	import util.*;

	import flash.geom.*;
	import flash.events.*;
    import flash.display.MovieClip;


	import flash.ui.Keyboard;

    /**
     * The basic unit in the game. Can be a Unit, Enemy, NPC, Event, etc.
     */
	public class GameUnit extends MovieClip {



		public var xTile:int;
		public var yTile:int;
		public var objectWidth:Number;
		public var objectHeight:Number;
		
		public var range:int;

		/**
		 * Move route of the GameUnit
		 * prevMoveCount - helps track when a new move has begun
		 * moveCount - current index of move
		 * waitCount - current time after a move has finished
		 * wait - time between moves
		 * pauseAction - pause the movement of the GameUnit
		 * overridePause - used for cutscenes and shit
		 * superPause - pauses everything for like, special custcene attacks or something - doesn't conflict with pauseAction
		 * menuPause - pauses everything for like menus and stuff
		 */
		public var commands:Array;
		public var prevMoveCount:int;
		public var moveCount:int;
		public var waitCount:int;
		public var wait:int;
		public var pauseAction:Boolean;
		public var overridePause:Boolean;//don't know if this needs to be used
		static public var superPause:Boolean;
		static public var menuPause:Boolean=false;
		static public var tileMap;

		/**
		 * Potential movement area
		 */
		public var pxpos:Number;
		public var pypos:Number;
		public var speed:Number;
		var rad;

		public static var allAreas = new Array();
		/**
		 *
		 * dir - direction of GameUnit
		 */
		public var dir:int;

		/**
		 * Dialogue system
		 * names - Dialogue yo
		 * messages - Dialogue yo
		 * messageMode 
		 * 0 - Normal
		 * 1 - Cellphone
		 * 2 - Speakers
		 * messageBox - thing to display
		 * fastForward - skip the letter-by-letter system
		 * dialogueIndex - position in arrays
		 * charIndex - letter position in message
		 */
		public var names:Array;
		public var messages:Array;
		public var messageModes:Array;
		public var mbx;
		public var mby;
		public var messagebox;
		public var fastforward:Boolean;
		public var dialogueIndex:int;
		public var charIndex:int;


		public function GameUnit() {
			commands=[];
			prevMoveCount=-1;
			moveCount=0;
			waitCount=0;
			wait=24*0;

			pxpos=0;
			pypos=0;
			speed=8;

			dir=2;

			names=[];
			messages=[];
			messageModes=[];
			mbx=34;
			mby=302-64;
			messagebox = new MessageBox();
			fastforward=false;
			dialogueIndex=0;
			charIndex=0;


			pauseAction=false;

			allAreas.push(this);
			rad=Math.pow(width>>1,2);

			addEventListener(Event.ENTER_FRAME, gameHandler);
		}


		/**
		 * All Possible Commands
		 *
		 *
		 * forceAction
		 * eraseAction
		 * moveLeft
		 * moveDown
		 * moveUp
		 * moveRight
		 * moveRandom
		 * moveRandomAndFace
		 * moveBy
		 * moveTo
		 * teleportToCoord
		 * teleportToTile
		 * displayMessage
		 *
		 *
		 *
		 *
		 *
		 */



		public function mover(ox:Number, oy:Number) {
			var speedAdjust = (ox != 0 && oy != 0) ? (speed * Math.SQRT2 / 2) : speed;
			var nx=x+ox*speedAdjust;
			var ny=y+oy*speedAdjust;

			var ox=x;
			var oy=y;

			x=nx;
			y=ny;
			if (TileMap.hitWall(nx,ny)||hitAreas()) {
				trace(TileMap.hitWall(nx, ny) + " " + hitAreas());
				x=ox;
				y=oy;
			}
		}
		//creates units in a circle around the original unit (u)
		public function spaceAround(u:GameUnit) {
			var radRoot=Math.sqrt(u.rad)+20;
			var addPi=Math.PI/4;

			for (var a = 0; a < 2 * Math.PI; a += addPi) {
				x=radRoot*Math.cos(a)+u.x;
				y=radRoot*Math.sin(a)+u.y;
				if (! hitAreas()&&! TileMap.hitWall(x,y)) {
					return;
				}
			}
			trace("couldn't find space");
		}
		public function getMyRect() {
			return new Rectangle(x, y, width, height);
		}
		public function pointHitAreas(ox, oy):GameUnit {
			var p=new Point(ox,oy);

			for (var a in allAreas) {
				var mc=allAreas[a];
				if (mc==this) {
					continue;
				}

				if ((mc.getRect()).containsPoint(p)) {
					return mc;
				}
			}
			return null;
		}
		public function hitAreas() {
			for (var a in allAreas) {
				var mc=allAreas[a];
				if (mc==this) {
					continue;
				}

				var dist=Math.pow(mc.x-x,2)+Math.pow(mc.y-y,2);
				if (dist<rad+mc.rad) {
					return true;
				}
			}
			return false;
		}
		public function hitWhat() {
			var arr = new Array();
			for (var a in allAreas.length) {
				var mc=allAreas[a];
				if (mc==this) {
					continue;
				}

				var dist=Math.pow(mc.x-x,2)+Math.pow(mc.y-y,2);
				if (dist<rad+mc.rad) {
					arr.push(mc);
				}
			}
			return arr;
		}




		public function forceAction(action, f) {
			f();
			action.decreaseMove();
			advanceMove();
		}

		public function eraseAction() {
			removeEventListener(Event.ENTER_FRAME, gameHandler);
			if (this.parent!=null) {
				this.parent.removeChild(this);
			}
		}
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

		public function moveRandomAndFace() {
			if (prevMoveCount!=moveCount) {
				prevMoveCount=moveCount;
				pxpos=x+Math.floor(Math.random()*64-32);
				pypos=y+Math.floor(Math.random()*64-32);
				facePotentialDir();
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
		public function teleportToCoord(xpos, ypos) {
			if (prevMoveCount!=moveCount) {
				prevMoveCount=moveCount;
				x=xpos;
				y=ypos;
				addEventListener(Event.ENTER_FRAME, waitHandler);
			}

		}
		public function teleportToTile(r, c) {
			if (prevMoveCount!=moveCount) {
				prevMoveCount=moveCount;
				var mapWidth=tileMap[0].length;
				var mapHeight=tileMap.length;
				if (r>=0&&r<mapHeight&&c>=0&&c<mapWidth) {
					x = (r+0.5) * 32;
					y = (c+0.5) * 32;
				}
				addEventListener(Event.ENTER_FRAME, waitHandler);
			}
		}

		public function displayMessage() {
			if (prevMoveCount!=moveCount) {
				prevMoveCount=moveCount;
				talking(dialogueIndex, fastforward);
				addEventListener(Event.ENTER_FRAME,talkingHandler);
				stage.addEventListener(KeyboardEvent.KEY_DOWN,talkingConfirmHandler);
			}
		}

		public function talking(index, fastforward) {
			if (index<names.length) {
				messagebox.nameDisplay.text=names[index];
				messagebox.messageDisplay.text=messages[index].substr(0,charIndex);
				if (charIndex==0) {
					messagebox.x=mbx;
					messagebox.y=mby;
					stage.addChild(messagebox);
					addEventListener(Event.ENTER_FRAME,talkingHandler);
					stage.addEventListener(KeyboardEvent.KEY_DOWN,talkingConfirmHandler);
				}

				if (charIndex==messages[index].length||fastforward) {
					messagebox.messageDisplay.text=messages[index];
					charIndex=messages[index].length;
				} else if (charIndex<messages[index].length) {
					charIndex++;
				}
			}
		}


		//non-sequential moves

		public function advanceMove() {
			prevMoveCount++;
			moveCount++;
		}
		public function decreaseMove() {
			prevMoveCount--;
			moveCount--;
		}

		public function toggleUHUD(showOn) {
			if (showOn) {

			} else {

			}
		}
		public function toggleEHUD(showOn) {
			if (showOn) {

			} else {

			}
		}
		public function toggleFBar(showOn) {
			if (showOn) {

			} else {

			}
		}
		public function setPositionByCoord(xpos, ypos) {
			x=xpos;
			y=ypos;
		}
		public function setPositionByTile(r, c) {
			var mapWidth=tileMap[0].length;
			var mapHeight=tileMap.length;
			if (r>=0&&r<mapHeight&&c>=0&&c<mapWidth) {
				x = (r+0.5) * 32;
				y = (c+0.5) * 32;
			}
		}

		public function turn() {
			gotoAndStop(dir/2);
			prevMoveCount=moveCount;
			moveCount++;
		}
		public function faceDir(dir) {
			//chances are dir will be 2,4,6,8
			this.dir=dir;
			turn();
		}

		public function facePotentialDir() {
			var radian=Math.atan2(pypos-y,pxpos-x);
			var degree = Math.round((radian*180/Math.PI));
			if (degree>-45&&45>=degree) {
				dir=6;
			} else if (degree > -135 && -45 >= degree) {
				dir=8;
			} else if (degree > 45 && 135 >= degree) {
				dir=2;
			} else if ((degree > 135 && 180 >= degree) || (degree >=-180 && -135 >= degree)) {
				dir=4;
			}

			turn();
		}

		public function turnLeft() {
			switch (dir) {
				case 2 :
					dir=6;
					break;
				case 4 :
					dir=2;
					break;
				case 6 :
					dir=8;
					break;
				case 8 :
					dir=4;
					break;
			}

			turn();
		}
		public function turnRight() {
			switch (dir) {
				case 2 :
					dir=4;
					break;
				case 4 :
					dir=8;
					break;
				case 6 :
					dir=2;
					break;
				case 8 :
					dir=6;
					break;
			}
			turn();
		}

		public function faceRandom() {
			this.dir=2*Math.floor(Math.random()*4+1);

			turn();
		}

		/**
		 * Handlers take care of this shit.
		 */

		public function gameHandler(e) {
			if (! pauseAction&&! superPause&&! menuPause) {
				if (moveCount>=commands.length) {
					prevMoveCount=-1;
					moveCount=0;
				}
				if(commands.length != 0){
				//commands[moveCount]();
				}
			}
		}
		public function waitHandler(e) {
			if (waitCount<wait) {
				waitCount++;
			} else {
				prevMoveCount=moveCount;
				moveCount++;
				waitCount=0;
				addEventListener(Event.ENTER_FRAME, gameHandler);
				removeEventListener(Event.ENTER_FRAME, waitHandler);
			}
		}
		public function talkingHandler(e) {
			if (dialogueIndex>=messages.length) {
				dialogueIndex=0;
				charIndex=0;
				removeEventListener(Event.ENTER_FRAME,talkingHandler);
				stage.removeEventListener(KeyboardEvent.KEY_DOWN,talkingConfirmHandler);
				addEventListener(Event.ENTER_FRAME, waitHandler);
			} else {
				talking(dialogueIndex,fastforward);
			}
		}
		public function talkingConfirmHandler(e) {
			if (e.keyCode==Keyboard.ENTER || 
			e.keyCode == "C".charCodeAt(0) || 
			e.keyCode == Keyboard.SPACE) {
				if (! fastforward) {
					fastforward=true;
				} else {
					if (messagebox.parent==stage) {
						stage.removeChild(messagebox);
						removeEventListener(Event.ENTER_FRAME,talkingHandler);
						stage.removeEventListener(KeyboardEvent.KEY_DOWN,talkingConfirmHandler);
						addEventListener(Event.ENTER_FRAME, waitHandler);
					}
					charIndex=0;
					dialogueIndex++;
					fastforward=false;
				}

			}
		}

		public function moveHandler(e) {
			if (! pauseAction&&! superPause&&! menuPause) {
				if (pxpos<0) {
					pxpos=0;
				}
				if (pypos<0) {
					pypos=0;
				}
				var pxtile=Math.floor(pxpos/32);
				var pytile=Math.floor(pypos/32);
				var xtile=Math.floor(x/32);
				var ytile=Math.floor(y/32);
				if (! tileMap["t_"+pytile+"_"+pxtile].walkable) {
					if (! tileMap["t_"+ytile+"_"+pxtile].walkable) {
						while (! tileMap["t_"+ytile+"_"+pxtile].walkable) {
							if (pxpos>x) {
								pxtile--;
							} else if (x > pxpos) {
								pxtile++;
							}
						}
						if (pxpos>x) {
							pxpos=(pxtile+1)*32-1;//-w_collision.x+width/2-4;
						} else if (x > pxpos) {
							pxpos=(pxtile)*32;
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
							pypos=(pytile+1)*32-1;
						} else if (y > pypos) {
							pypos=(pytile)*32;
						}
					}



				} else {
					if (Math.sqrt(Math.pow(pxpos-x,2)+Math.pow(pypos-y,2))>speed) {
						var radian=Math.atan2(pypos-y,pxpos-x);
						var degree = Math.round((radian*180/Math.PI));
						var px=x+speed*Math.cos(radian);
						var py=y+speed*Math.sin(radian);

						pxtile=Math.floor(px/32);
						pytile=Math.floor(py/32);
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
									px=(pxtile)*32;//-w_collision.x+width/2-4;
								} else if (x > px) {
									px=(pxtile)*32;
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
									py=(pytile+1)*32-1;//-w_collision.y+height/2-4;
								} else if (y > py) {
									py=(pytile)*32;
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




	}
}