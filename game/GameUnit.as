/*
*/
package game{


	import actors.*;
	import abilities.*;
	import maps.*;
	import tileMapper.*;
	import ui.*;
	import ui.hud.HUDManager;
	import ui.screens.ShopScreen;
	import util.*;

	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.geom.*;
	import flash.events.*;


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
		 * Animation.
		 */
		public var requiredLabels:Array = new Array();
		public var lengths:Array = new Array();
		public var currentAnimLabel:String = "_walkDown";


		/**
		 * Move route of the GameUnit
		 * prevMoveCount - helps track when a new move has begun
		 * moveCount - current index of move
		 * waitCount - current time after a move has finished
		 * wait - time between commands
		 * moveWait - time between actual movement
		 * moveWaitCount - current time after finishing one movement of a tile
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
		
		public var moveWait:int;
		public var moveWaitCount:int;
		public var pauseAction:Boolean;
		public var overridePause:Boolean;//don't know if this needs to be used
		static public var superPause:Boolean;
		static public var menuPause:Boolean=false;
		static public var objectPause:Boolean=false;

		/**
		 * Potential movement area
		 */
		public var mxpos:Number;
		public var mypos:Number;
		public var speed:Number;
		public var path = new Array();
		public var radian;		
		public var moving:Boolean = false;

		var rad;
		public static var allAreas = new Array();
		/**
		 *
		 * dir - direction of GameUnit
		 * moveDir - direction of GameUnit when moving
		 */
		public var dir:int;
		public var moveDir:int;

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

		public var aTrigger:String;


		public function GameUnit() {
			commands=[];
			prevMoveCount=-1;
			moveCount=0;
			waitCount=0;
			wait = 0;
			moveWaitCount = 0;
			moveWait = 0;

			mxpos=0;
			mypos=0;
			speed=8;

			dir = 0;
			moveDir = 0;

			names=[];
			messages=[];
			messageModes=[];
			mbx=34;
			mby = 302;//302-64;
			messagebox = new MessageBox();
			fastforward=false;
			dialogueIndex=0;
			charIndex=0;

			aTrigger="None";
			pauseAction=false;

			allAreas.push(this);
			rad = Math.pow(width >> 1, 2);
			
			setLengths();
			
		}

		/**
		 * 
		 * Teleports the passed GameUnit to its destination.
		 * @param	object
		 * @param	targetX
		 * @param	targetY
		 */
		public function teleportObject(targetX:Number, targetY:Number):void {
			
		}
		/**
		 * 
		 * Moves the passed GameUnit to its destination.
		 * 
		 * @param	object
		 * @param	targetX
		 * @param	targetY
		 */
		 public function moveObject(targetX:Number, targetY:Number):void {
			var p = new Array();
			startAnimation(dir);
			mxpos = targetX;
			mypos = targetY;			
			
			//really big bug to fix - hitting nonpassable tiles causes crappy movement.
			//hackhackhack
			if (TileMap.hitNonpass(targetX, targetY)) {
				//teleportObject(object, targetX, targetY);
			} else{
				p = TileMap.findPath(TileMap.map, new Point(Math.floor(x/32), Math.floor(y/32)),
				  new Point(Math.floor(mxpos/32), Math.floor(mypos/32)), 
				  false, true);
				p = smoothPath(path);
				
				path = p;
				//object.addEventListener(Event.ENTER_FRAME, moveHandler);
			}
        }
		
		/**
		 * 
		 * Ignores some of the intermediate tile destinations for more realistic movement.
		 * @param	path - the path to modify
		 * @return the smoothed path
		 */
		
		public function smoothPath(path:Array):Array {
			if (path.length>0) {
				var newPath=new Array(path[0]);

				var currentIndex=0;
				var pushIndex=0;
				var nextIndex=1;

				if (path[0]==path[path.length-1]) {
					return newPath;
				}
				if (TileMap.walkable(path[0],path[path.length-1])) {
					newPath=new Array(path[0],path[path.length-1]);
					return newPath;

				}
				while (nextIndex < path.length) {

					if (TileMap.walkable(path[nextIndex],path[path.length-1])) {
						newPath.push(path[nextIndex]);
						newPath.push(path[path.length-1]);
						return newPath;
					} else if (TileMap.walkable(path[currentIndex],path[nextIndex])) {
						pushIndex=nextIndex;
					} else {
						if (currentIndex!=pushIndex) {
							newPath.push(path[pushIndex]);
						}
						currentIndex=pushIndex;
					}
					nextIndex++;
				}
				newPath.push(path[path.length-1]);
				return newPath;
			} else {
				return new Array();
			}
		}
		
		/**
		 * 
		 * the movement handler. 
		 * @param	e - Event.ENTER_FRAME
		 */
		public function moveHandler(e:Event):void {
			if (path.length > 0) {
				var dist=Math.sqrt(Math.pow(mxpos-x,2)+Math.pow(mypos-y,2));
				checkLoop();
				if (dist>0&&dist>range) {
					var xtile=Math.floor(x/32);
					var ytile=Math.floor(y/32);
					if (xtile==path[0].x&&ytile==path[0].y) {
						path.splice(0, 1);

						if (path.length>0) {
							var xdest=path[0].x*32+16;
							var ydest=path[0].y*32+16;
							radian=Math.atan2(ydest-y,xdest-x);
							faceDirection(radian);
						}
					}
					if (path.length>0) {
						moving=true;
						var speed;
						/*if (this is Unit || this is Enemy) {
							speed = getSpeed();
						}
						else {
							speed = speed;
						}*/
						speed = getSpeed();
						
						x+=speed*Math.cos(radian)/24;
						y+=speed*Math.sin(radian)/24;

					} else {
						moving=false;
					}
				}				
			} else {
				moving=false;
			}
			if (! moving && range == 0) {
				x=mxpos;
				y=mypos;
				//object.stopAnimation();
				//object.removeEventListener(Event.ENTER_FRAME, moveHandler);
			}
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

		public function detectHandler(e:Event):void {

		}
		
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

		public function getFrameNumber(label:String):int {
			for each (var frameLabel:FrameLabel in this.currentLabels) {
				if (frameLabel.name==label) {
					return frameLabel.frame;
				}
			}
			return -1;
		}

		public function setLengths():void {
			for (var i = 0; i < this.currentLabels.length; i++) {
				if (this.currentLabels[i+1]) {
					lengths[this.currentLabels[i].name] = this.currentLabels[i + 1].frame-this.currentLabels[i].frame;
				} else {
					lengths[this.currentLabels[i].name]=this.totalFrames-this.currentLabels[i].frame;
				}
			}
		}

		public function checkLoop():void {
			gotoAndStop(currentFrame + 1);
            var labelFrame:int = getFrameNumber(currentAnimLabel);
			if(labelFrame != -1){
				if (currentFrame == totalFrames) {
					 gotoAndStop(labelFrame);
				}
				if(currentFrame == labelFrame + lengths[currentAnimLabel]) {
					gotoAndStop(labelFrame);
				}
			}
        }		
		public function checkStop():void {	
            var labelFrame:int = getFrameNumber(currentAnimLabel);
			if (labelFrame != -1) {
				if(currentFrame != labelFrame + lengths[currentAnimLabel]-1) {
					gotoAndStop(currentFrame+1);
				}
			}
		}
		/**
		 * Gets the animation label for the direction and action.
		 */
		public function getAnimLabel(moveDir:int, KO:Boolean):String { 
			var label = "";
			if (KO) {
				label = "_KO";
			}
			else {
				switch(moveDir) {
					case 2: 
						label =  "_walkDown";
					break;
					case 4: 
						label =  "_walkLeft";
					break;
					case 6:
						label =  "_walkRight";
					break;
					case 8: 
						label = "_walkUp";
					break;	
				}				
			}

			return label;
		}		
        /**
         * Starts the animation based on direction.
		 * 
         */
		public function startAnimation(moveDir:int, auto:Boolean = false, KO:Boolean = false):void {
			if(this.moveDir != moveDir || auto || KO){
				var animLabel:String = this.getAnimLabel(moveDir, KO);
				this.currentAnimLabel = animLabel;
                this.gotoAndStop(this.getFrameNumber(animLabel));
				this.dir = moveDir;
				this.moveDir = moveDir;
			}
		}
        /**
         * Stops the current animation. It's pretty simple enough. :|
         */		
		public function stopAnimation():void {
            this.gotoAndStop(getFrameNumber(currentAnimLabel));
			moveDir = 0;
		}

		
		public function swapActions(prevMoveCount:int, moveCount:int, commands:Array) {
			this.prevMoveCount = prevMoveCount;
			this.moveCount = moveCount;
			this.commands = commands;
			addEventListener(Event.ENTER_FRAME, gameHandler);
			
		}
		public static function forceAction(action, f) {
			action.prevMoveCount--;
			action[f]();
			action.moveCount--;
		}
		//All possible sequential moves

		public function teleportToMap(mapID:int, xTile:int, yTile:int, dir:int, transition:String) {
			if (prevMoveCount!=moveCount) {
				prevMoveCount=moveCount;
				GameVariables.nextMapID=mapID;
				GameVariables.xTile=xTile;
				GameVariables.yTile=yTile;
				GameVariables.stageRef.dispatchEvent(new GameDataEvent(GameDataEvent.CHANGE_MAP, true));
				moveCount++;
			}
		}
		public function teleportToCoord(xpos, ypos) {
			if (prevMoveCount!=moveCount) {
				prevMoveCount=moveCount;
				x=xpos;
				y = ypos;
				moveCount++;
			}

		}
		public function eraseObject() {
			if (aTrigger == "Auto") {
				GameUnit.superPause = false;
			}
			GameUnit.objectPause=false;
			parent.removeChild(this);
			removeEventListener(Event.ENTER_FRAME, detectHandler);
			this.removeEventListener(Event.ENTER_FRAME, gameHandler);
			this.removeEventListener(Event.ENTER_FRAME, waitHandler);
		}
		public function jumpTo(commandIndex:int) {
			if (prevMoveCount != moveCount) {
				moveCount=commandIndex;
				prevMoveCount = moveCount - 1;
			}
		}
		public function changeObjectPosition(eventID:int, xTile:int, yTile:int, dir:int) {
			if (prevMoveCount!=moveCount) {
				prevMoveCount=moveCount;
				if (eventID==-1) {
					x = (xTile+0.5) * 32;
					y = (yTile+0.5) * 32;
					if (dir!=0) {
						this.dir=dir;
					}
				} else {
					var mapObjects=MapDatabase.getMapObjects(GameVariables.nextMapID);
					mapObjects[eventID].x = (xTile+0.5) * 32;
					mapObjects[eventID].y = (yTile+0.5) * 32;
					if (dir!=0) {
						mapObjects[eventID].dir=dir;
					}
				}
				moveCount++;
			}
		}

		public function changeFlexPoints(changeType:String, changeValue:Number) {
			if (prevMoveCount!=moveCount) {
				prevMoveCount=moveCount;
				if (changeType=="Increase") {
					Unit.flexPoints+=changeValue;
					if (Unit.flexPoints>999999) {//what should the upper limit be?
						Unit.flexPoints=999999;
					}
				} else if (changeType == "Decrease") {
					Unit.flexPoints-=changeValue;
					if (Unit.flexPoints<0) {
						Unit.flexPoints=0;
					}
				} else if (changeType == "Set") {
					Unit.flexPoints=changeValue;
					if (Unit.flexPoints<0) {
						Unit.flexPoints=0;
					}
					if (Unit.flexPoints>999999) {
						Unit.flexPoints=999999;
					}
				}
				moveCount++;
			}
		}
		public function changeStat(unitType:String, statType:String, stat:String, popup:String) {
			if (prevMoveCount!=moveCount) {
				prevMoveCount = moveCount;
				
				var newStat = parseInt(stat);
				if (statType=="Health") {
					if (unitType=="Current") {
						Unit.currentUnit.updateHP(newStat-Unit.currentUnit.HP, popup);
					} else if (unitType == "Partner") {
						Unit.partnerUnit.updateHP(newStat-Unit.partnerUnit.HP, popup);
					}
				} else if (statType=="Health+") {
					if (unitType=="Current") {
						Unit.currentUnit.updateHP(-1*newStat, popup);
					} else if (unitType == "Partner") {
						Unit.partnerUnit.updateHP(-1*newStat, popup);
					}
				} 	else if (statType=="Health-") {
					if (unitType=="Current") {
						Unit.currentUnit.updateHP(newStat, popup);
					} else if (unitType == "Partner") {
						Unit.partnerUnit.updateHP(newStat, popup);
					}
				} else if (statType == "MaxHealth") {
					if (unitType=="Current") {
						Unit.currentUnit.maxHP=newStat;
						Unit.currentUnit.updateHP(0, "No");
					} else if (unitType == "Partner") {
						Unit.partnerUnit.maxHP=newStat;
						Unit.partnerUnit.updateHP(0, "No");
					}
				} else if (statType == "Attack") {
					if (unitType=="Current") {
						Unit.currentUnit.AP=newStat;
					} else if (unitType == "Partner") {
						Unit.partnerUnit.AP=newStat;
					}
				} else if (statType == "Defense") {
					if (unitType=="Current") {
						Unit.currentUnit.DP=newStat;
					} else if (unitType == "Partner") {
						Unit.partnerUnit.DP=newStat;
					}
				} else if (statType == "Speed") {
					if (unitType=="Current") {
						Unit.currentUnit.speed=newStat;
					} else if (unitType == "Partner") {
						Unit.partnerUnit.speed=newStat;
					}
				}
				moveCount++;
			}
		}
		public function getPrize(type:String, prizeID:int, amount:int, displayMode:String) {
			if (prevMoveCount!=moveCount) {
				prevMoveCount=moveCount;
				var addUses;
				if (displayMode=="Simple"||displayMode=="Cutscene") {
					var getDisplay=new GetDisplay(prizeID,amount,type,displayMode);
					GameVariables.stageRef.addChild(getDisplay);
				}
				if (type == "Item") {
					var maxUses = 9;
					addUses=Unit.itemAmounts[prizeID]+amount;
					if (addUses<maxUses) {
						Unit.itemAmounts[prizeID]=addUses;
					} else {
						Unit.itemAmounts[prizeID]=maxUses;
					}
				} else if (type == "Ability") {
					addUses=Unit.abilityAmounts[prizeID]+amount;
					if (addUses<9) {
						Unit.abilityAmounts[prizeID]=addUses;
					} else {
						Unit.abilityAmounts[prizeID]=9;
					}
				}
				addEventListener(Event.ENTER_FRAME, waitHandler);
			}
		}
		public function scrollMap(scrollDir:int,numTiles:int,speed:int) {
			if (prevMoveCount!=moveCount) {
				prevMoveCount=moveCount;
				MapManager.startScrolling(scrollDir, numTiles, speed);
				addEventListener(Event.ENTER_FRAME, waitHandler);
			}
		}
		public function waitFor(wait:int) {
			this.wait = wait-1;
			addEventListener(Event.ENTER_FRAME, waitHandler);
			
		}
		public function startCutscene() {
			if (prevMoveCount != moveCount) {
				prevMoveCount = moveCount;
				HUDManager.toggleUnitHUD(false);
				HUDManager.toggleEnemyHUD(false);				
				moveCount++;
			}
		}
		public function endCutscene() {			
			if (prevMoveCount != moveCount) {
				prevMoveCount = moveCount;
				HUDManager.toggleUnitHUD(true);
				moveCount++;
			}
		}
		public function displayMessage(nameString:String = null, messageString:String = null, portrait = null, faceIcon = null, withChoices:String = "No") {
			if (prevMoveCount != moveCount) {
				prevMoveCount = moveCount;
				var pattern:RegExp = /COLON/g; 
				messageString = messageString.replace(pattern, ":");
				pattern = /NEWSPACE/g; 
				messageString = messageString.replace(pattern, '\n');
				pattern = /LESSTHANTHREE/g; 
				messageString = messageString.replace(pattern, '<3');				
				talking(nameString, messageString, portrait, faceIcon, fastforward);
				//addEventListener(Event.ENTER_FRAME,talkingHandler);
				stage.addEventListener(KeyboardEvent.KEY_DOWN,talkingConfirmHandler);
			}
		}
		public function displayChoices(answersArray:Array, commandsArray:Array) {
			if (prevMoveCount != moveCount) {
				prevMoveCount = moveCount;
				var decisionDisplay = new DecisionDisplay(GameVariables.stageRef,answersArray,commandsArray,this);
			}			
		}
		
		public function createShop(itemsArray:Array, abilitiesArray:Array, amountsArray:Array, priceMod:Number) {
			if(prevMoveCount != moveCount){
				prevMoveCount = moveCount;
				var itemArray = new Array(new Ability(0, 5));
				var abilityArray = new Array(new Ability(0, 9), new Ability(1, 9), new Ability(2, 9));
				var shopScreen = new ShopScreen(null, itemArray, abilityArray, GameVariables.stageRef, this);
			}
		}
		
		public function changeSwitch(ID:int, binary:String) {
			if (prevMoveCount != moveCount) {
				prevMoveCount = moveCount;
				if (binary == "TRUE") {
					GameVariables.switchesArray[ID] = true;
				} else if (binary == "FALSE") {
					GameVariables.switchesArray[ID] = false;
				}
				moveCount++;
			}
 		}

		public function changeVariable(ID:int, operation:String, value:int) {
			if (prevMoveCount != moveCount) {
				prevMoveCount = moveCount;
				var tempValue = GameVariables.variablesArray[ID];

				if (operation == "=") {
					tempValue = value;
				} else if (operation == "+") {
					tempValue += value;
				} else if (operation == "*") {
					tempValue *= value;
				}else if (operation == "/") {
					if (value == 0) { //... don't divide by 0 anyway. I don't actually want to use this mod. >.>
						tempValue = 0;
					}
					else{
						tempValue /= value;
					}
				}else if (operation == "RAND") {
					tempValue = Math.floor(Math.random() * value);
				}
				GameVariables.variablesArray[ID] = tempValue;
				moveCount++;
			}
 		}
		
		public function playBGM(BGM:String) {
			if (prevMoveCount != moveCount) {
				prevMoveCount = moveCount;
				GameClient.playBGM(BGM);
				moveCount++;
			}
		}
		public function stopBGM() {
			if (prevMoveCount != moveCount) {
				prevMoveCount = moveCount;
				GameClient.stopBGM();
				moveCount++;
			}
		}
		
		public function useConditional(conditionsArray:Array, passArray:Array, failArray:Array) {
			var check = MapObjectConditionChecker.checkCondition(this, conditionsArray);
			var tempPrevMoveCount = prevMoveCount;
			var tempMoveCount = moveCount+1;
			var tempCommands = commands;
			
			if (check) {
				swapActions(-1, 0, passArray);
			}
			else {
				swapActions(-1, 0, failArray);
			}
			var func = FunctionUtils.thunkify(swapActions, tempPrevMoveCount, tempMoveCount, tempCommands);
			commands.push(func);
		}

		public function talking(nameString, messageString, portrait, faceIcon, fastforward) {
			if (nameString!=null) {
				messagebox.nameDisplay.text=nameString;
			}
			if (messageString!=null) {
				messagebox.messageDisplay.text=messageString;//.substr(0,charIndex);
			}
			if (charIndex==0) {
				messagebox.x=mbx;
				messagebox.y=mby;
				stage.addChild(messagebox);
				//addEventListener(Event.ENTER_FRAME,talkingHandler);
				stage.addEventListener(KeyboardEvent.KEY_DOWN,talkingConfirmHandler);
			}

			if (charIndex==messageString.length||fastforward) {
				messagebox.messageDisplay.text=messageString;
				charIndex=messageString.length;
			} else if (charIndex<messageString.length) {
				charIndex++;
			}
		}


		//non-sequential moves

		public function advanceMove() {
			moveCount++;
			if (moveCount < commands.length) {
				commands[moveCount]();
			}		
		}
		public function decreaseMove() {
			prevMoveCount--;
			moveCount--;
		}

		public function toggleUHUD(showOn) {
			if (prevMoveCount != moveCount) {
				prevMoveCount = moveCount;
				HUDManager.toggleUnitHUD(showOn);
				moveCount++;
			}
		}
		public function toggleEHUD(showOn) {
			if (prevMoveCount != moveCount) {
				prevMoveCount = moveCount;
				HUDManager.toggleEnemyHUD(showOn);
				moveCount++;
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
			if (! pauseAction && ! superPause && ! menuPause) {
				if (commands.length!=0&&moveCount<commands.length) {
					commands[moveCount]();
				}
				if (moveCount>=commands.length) {
					prevMoveCount=-1;
					moveCount = 0;
					if (aTrigger == "Click" || aTrigger == "Collide" || aTrigger == "None") {
						GameUnit.objectPause=false;
						removeEventListener(Event.ENTER_FRAME, detectHandler);
						removeEventListener(Event.ENTER_FRAME, gameHandler);
						Unit.currentUnit.range = 0;
						Unit.partnerUnit.range = 0;
					}
				}
			}
		}
		public function waitHandler(e) {
			if (! pauseAction && ! superPause && ! menuPause) {			
				if (waitCount<wait) {
					waitCount++;			
				} else {
					prevMoveCount = moveCount;
					moveCount++;
					waitCount = 0;
					wait = 0;
					addEventListener(Event.ENTER_FRAME, gameHandler);
					removeEventListener(Event.ENTER_FRAME, waitHandler);
				}
			}
		}
		/*public function talkingHandler(e) {
		if (dialogueIndex>=messages.length) {
		dialogueIndex=0;
		charIndex=0;
		removeEventListener(Event.ENTER_FRAME,talkingHandler);
		stage.removeEventListener(KeyboardEvent.KEY_DOWN,talkingConfirmHandler);
		addEventListener(Event.ENTER_FRAME, waitHandler);
		} else {
		talking(dialogueIndex,fastforward);
		}
		}*/
		public function talkingConfirmHandler(e) {
			if (e.keyCode==Keyboard.ENTER || 
			e.keyCode == "C".charCodeAt(0) || 
			e.keyCode == Keyboard.SPACE) {
				if (! fastforward) {
					fastforward=true;
				} else {
					if (messagebox.parent==stage) {
						stage.removeChild(messagebox);
						//removeEventListener(Event.ENTER_FRAME,talkingHandler);
						stage.removeEventListener(KeyboardEvent.KEY_DOWN,talkingConfirmHandler);
						moveCount++;
					}
					charIndex=0;
					//dialogueIndex++;
					fastforward=false;
				}

			}
		}
		
		public function talkingConfirmWithChoicesHandler(e) {
			if (e.keyCode==Keyboard.ENTER || 
			e.keyCode == "C".charCodeAt(0) || 
			e.keyCode == Keyboard.SPACE) {
				stage.removeEventListener(KeyboardEvent.KEY_DOWN,talkingConfirmWithChoicesHandler);
				moveCount++;
				charIndex=0;
				//dialogueIndex++;
				}
		}		
	}
}