/*
*/
package game{


	import levels.*;
	import util.*;

	import flash.events.*;
	import flash.display.MovieClip;
	import flash.ui.Keyboard;

	public class GameUnit extends MovieClip {

		/**
		 * How to activate the GameUnit
		 * 0 - Click on it/press C
		 * 1 - Run over it
		 * 2 - Automatically activates
		 * 3 - Runs in parallel
		 */
		public var activate:int;

		/**
		 * Move route of the GameUnit
		 * prevMoveCount - helps track when a new move has begun
		 * moveCount - current index of move
		 * waitCount - current time after a move has finished
		 * maxWaitCount - time between moves
		 * tileMap - area of Action to move around in
		 * pauseAction - pause the movement of the Action
		 * overridePause - used for cutscenes and shit
		 * superPause - pauses everything for like menus and stuff - doesn't conflict with pauseAction
		 */
		public var moveArray:Array;
		public var prevMoveCount:int;
		public var moveCount:int;
		public var waitCount:int;
		public var maxWaitCount:int;
		public var pauseAction:Boolean;
		public var overridePause:Boolean;//don't know if this needs to be used
		static public var superPause:Boolean;
		static public var tileMap;

		/**
		 * Potential movement area
		 */
		public var pxpos:Number;
		public var pypos:Number;
		public var speed:Number;

		/**
		 *
		 * dir - direction of Action
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


		public function Action() {
			activate=0;

			moveArray=[];
			prevMoveCount=-1;
			moveCount=0;
			waitCount=0;
			maxWaitCount=24*0;

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
					x = (r+0.5) * SuperLevel.tileHeight;
					y = (c+0.5) * SuperLevel.tileWidth;
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
				x = (r+0.5) * SuperLevel.tileHeight;
				y = (c+0.5) * SuperLevel.tileWidth;
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
			if (! pauseAction && !superPause) {
				if (moveCount>=moveArray.length) {
					prevMoveCount=-1;
					moveCount=0;
				}
				moveArray[moveCount]();
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
			if (! pauseAction && !superPause) {
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




	}
}