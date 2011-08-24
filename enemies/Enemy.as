/*
An Enemy is something that the Unit will attack. Obviously. 
*/
package enemies{
	import actors.*;
	import attacks.*;
	import effects.*;
	import game.*;
	import ui.*;
	import ui.hud.*;
	import util.*;

	import flash.text.TextField;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.*;
	import flash.ui.*;
	import flash.display.Sprite;

	import flash.utils.Timer;
	import flash.events.TimerEvent;
	public class Enemy extends GameUnit {

		static public var list:Array=[];
		public var Name;
		public var id;
		public var HP;
		public var maxHP;
		public var barrier;
		public var maxBarrier;
		public var AP;
		public var DP;
		public var EXP;
		public var Value;
		public var HUDOn;
		static public var enemyHUD = HUDManager.getEnemyHUD();

		public var xspeed;
		public var yspeed;
		//public var speed;
		public var attackDelay;/*
		public var collideCountC;
		public var collideCountP;*/
		public var eHPBar;

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

		public function Enemy(id:int) {
			//super
			//super();

			this.id=id;
			Name=EnemyDatabase.getName(id);
			maxHP=HP=EnemyDatabase.getHP(id);
			AP=EnemyDatabase.getDmg(id);
			DP=EnemyDatabase.getArmor(id);
			speed=EnemyDatabase.getSpeed(id);
			barrier=0;
			maxBarrier=EnemyDatabase.getBarrier(id);
/*			collideCountC=0;
			collideCountP=0;*/
			EXP=200;
			Value=100.50;
			HUDOn=false;

			pauseAction=false;

			switch (GameVariables.difficulty) {
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
			//addEventListener(Event.ENTER_FRAME, collideHandler);

			mouseChildren=false;

			eHPBar=new HealthBar(HP,maxHP,this);
			addChild(eHPBar);
			eHPBar.x=x-32;
			eHPBar.y=y-height/2-20;
			
			addEventListener(MouseEvent.CLICK, clickHandler);
			addEventListener(Event.ENTER_FRAME, detectHandler);

		}
		public function begin() {


		}
		public function end() {

		}
		public function clickHandler(e:MouseEvent):void {
			if (this == GameVariables.attackTarget.enemyRef) {
				GameVariables.attackTarget.changeEnemy();
			}else{
				GameVariables.attackTarget.changeEnemy(this);			
			}
		}

		override public function gameHandler(e) {
		}
		
		override public function detectHandler(e:Event):void {
			if(this.hitTestPoint(GameVariables.stageRef.mouseX, GameVariables.stageRef.mouseY) && parent != null){
				GameVariables.mouseEnemy = true;
			}
			else{
				GameVariables.mouseEnemy = false;
			}
		}		

		/*public function collideHandler(e) {
			if (! superPause&&! menuPause) {
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
		}*/
		public function kill() {
			end();
			this.parent.removeChild(this);
			list.splice(list.indexOf(this),1);
			Unit.updateEXP(EXP);
			Unit.flexPoints += Value;
			if (this == GameVariables.attackTarget.enemyRef) {
				GameVariables.attackTarget.changeEnemy();
			}
		}

		public function updateHP(damage, popup) {
			if (popup == "Yes") {
				var p;
				if (damage >= 0) {
					p = new PopUp(1, Math.abs(damage));
					p.x = this.x + Math.random() * 20 - 10;
					p.y = this.y;
					GameVariables.stageRef.addChild(p);
				}
				else {
					p = new PopUp(3, Math.abs(damage));
					p.x = this.x + Math.random() * 20-10;
					p.y = this.y;					
					GameVariables.stageRef.addChild(p);
				}
			}						
			if (barrier>0) {
				barrier-=damage;
			} else {
				HP-=damage;
			}
			if (0>=HP) {
				kill();
			}
			if (barrier>0) {
				//eHP.text=barrier;
			} else {
				//eHP.text=HP;
			}
			if (HUDOn) {
				enemyHUD.updateHP(HP, maxHP);
			} else {
				eHPBar.update(HP, maxHP);
			}
		}

		//Status moves

		public function shock(times) {
			if (shockTimes<=0) {
				shockTimes=times;
				shockTimer=new Timer(500,0);
				shockTimer.addEventListener("timer", shockTime);
				shockTimer.start();
				pauseAction=true;

			}
		}
		
		public function updateTarget(enemy){
			
		}
		public function shockTime(e) {
			//updateHP(Math.floor(Math.random()*3+1));
			shockTimes--;
			if (shockTimes==0) {
				shockTimer.stop();
				shockTimer.removeEventListener("timer", shockTime);
				pauseAction=false;
			}

		}
		//All possible non-time moves
		public function changeWait(mwc) {
			wait=mwc;
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