package actors{

	import flash.display.MovieClip;
	import flash.events.*;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	import flash.geom.Point;

	import abilities.*;
	import attacks.*;
	import enemies.*;
	import game.*;
	import items.*;
	import maps.*;
	import tileMapper.*;
	import ui.*;
	import ui.hud.*;
	import ui.screens.*;
	import util.*;

    /**
     * Units are the general heroes. Units that are currentUnit/partnerUnit are controllable. Others are NPCs.
     */
	public class Unit extends GameUnit {

		/**
		 * The team currently fighting
		 */
		static public var currentUnit;
		static public var partnerUnit;
		static public var decoyUnit;

		/**
		 * Key Commands
		 */
		static public var attackKey="C".charCodeAt(0);
		static public var hotKey1="Q".charCodeAt(0);
		static public var hotKey2="W".charCodeAt(0);
		static public var hotKey3="E".charCodeAt(0);
		static public var hotKey4="A".charCodeAt(0);
		static public var hotKey5="S".charCodeAt(0);
		static public var hotKey6="D".charCodeAt(0);
		static public var hotKey7="F".charCodeAt(0);
		static public var friendshipKey=Keyboard.SPACE;
		/**
		 * Delays
		 */

		public var attackDelay=0;
		public var hk1Delay=0;
		public var hk2Delay=0;
		public var hk3Delay=0;
		public var hk4Delay=0;
		public var hk5Delay=0;
		public var hk6Delay=0;
		public var hk7Delay=0;
		/**
		 * Numerical Stats for the Units
		 * FP - Friendship Points (max 10000)
		 * flexPoints - How many flexpoints they have
		 */
		static public var FP=0;
		static public var flexPoints=0;

		/**
		 * Name - Name of the Unit
		 * id - index of the Unit in the ActorDatabase
		 */
		public var Name;
		public var id;

		/**
		 * Numerical Stats of the Unit
		 * HP/maxHP - health/max health
		 * AP - attack 
		 * DP - defense (usually 0 unless barrier or some other crazy shit)
		 * EXP - EXP
		 * maxLP - level
		 */
		public var HP;
		public var maxHP;
		public var AP;
		public var DP;
		public var weapon:String;
		static public var EXP=0;
		static public var nextEXP=200;
		static public var maxLP=1;
		static public var unitHUD=HUDManager.getUnitHUD();

		public var path = new Array();
		public var radian;

		/**
		 * Commands of the Unit
		 */
		static public var hk1;
		static public var hk2;
		static public var hk3;
		static public var hk4;
		static public var hk5;
		static public var hk6;
		static public var hk7;
		static public var finale;

		public var basicAbilities:Array;//the initial abilities
		//public var commands:Array;

		static public var abilityAmounts:Array=AbilityDatabase.amounts;
		//work on implementing this
		static public var itemAmounts:Array=ItemDatabase.uses;


		public var passiveItems:Array;
		public var passiveAbilities:Array;
		/**
		 * Position of the Unit
		 */
		public var mxpos=0;
		public var mypos=0;
		//public var range=0;
		static public var level;

		/**
		 * Unit Booleans
		 */

		public var canAttack:Boolean;
		public var canOpenMenu:Boolean;
		public var canUseHotkeys:Array;


		public var attacking:Boolean=false;
		public var moving:Boolean=false;
		public static var disableHotkeys:Boolean=false;



		public var animate=0;
		public var pauseMovement:Boolean;

		public var HPBar;

		public var knockout:int;
		public var powerpoints;
		public var hotkeySet:Array;
		
		public function Unit(id:int = -1) {
			super();

			this.id=id;
			if (id!=-1) {
				Name=ActorDatabase.getName(id);
				maxHP=HP=ActorDatabase.getHP(id);
				AP=ActorDatabase.getDmg(id);
				DP=ActorDatabase.getArmor(id);
				speed=ActorDatabase.getSpeed(id);
				weapon = ActorDatabase.getWeapon(id);
				dir=2;
				//commands=[];

				passiveItems=[];
				passiveAbilities=[];

				canAttack=true;
				canOpenMenu=true;
				canUseHotkeys=new Array(true,true,true,true,true,true);

				attacking=false;
				moving=false;
				//gotoAndStop(1);

				HPBar=new HealthBar(HP,maxHP,this,48);

				basicAbilities=AbilityDatabase.getBasicAbilities(Name);
				hotkeySet=new Array(basicAbilities[0],null);

				powerpoints=1;
				knockout=24*30;
				addEventListener(Event.ENTER_FRAME, detectHandler);
				
			}
		}

		static public function setHotkey(id:int, a:Ability, basicIndex:int = -1) {
			switch (id) {
				case 1 :
					hk1=a;
					break;
				case 2 :
					hk2=a;
					break;
				case 3 :
					hk3=a;
					break;
				case 4 :
					hk4=a;
					break;
				case 5 :
					hk5=a;
					break;
				case 6 :
					hk6=a;
					break;
				case 7 :
					hk7=a;
					break;
			}
		}

		public function begin() {
			startAnimation(dir, true);
			addEventListener(Event.ENTER_FRAME, gameHandler);
/*			if (this == Unit.currentUnit) {
			mxpos=Unit.partnerUnit.mxpos;
			mypos=Unit.partnerUnit.mypos;
			} else if (this == Unit.partnerUnit) {
			mxpos=Unit.currentUnit.mxpos;
			mypos=Unit.currentUnit.mypos;
			}*/
			moving = false;
			range = 0;

			unitHUD.updateHP();
			knockout=24*5;

			if (Unit.currentUnit==this) {
				Unit.setHotkey(4, hotkeySet[0]);
				Unit.setHotkey(5, hotkeySet[1]);
			} else if (Unit.partnerUnit == this) {
				Unit.setHotkey(6, hotkeySet[0]);
				Unit.setHotkey(7, hotkeySet[1]);
			}

		}
		public function end() {
			removeEventListener(Event.ENTER_FRAME,gameHandler);
		}

		override public function detectHandler(e:Event):void{
			if(this.hitTestPoint(GameVariables.stageRef.mouseX, GameVariables.stageRef.mouseY)  && parent != null){
				GameVariables.mouseUnit = true;
			}
			else{
				GameVariables.mouseUnit = false;
			}
		}
		override public function gameHandler(e) {
			if (FP>10000) {
				FP=10000;
			}
			if (! pauseAction && ! superPause && ! menuPause) {
				if (Unit.currentUnit==this&&Unit.currentUnit.parent!=null) {
					useComboAttack();

					movePlayer();
					//moveDirection();
					if (! disableHotkeys) {
						useHotKey1();
						useHotKey2();
						useHotKey3();
						useHotKey4();
						useHotKey5();
						useHotKey6();
						useHotKey7();
						updateDelays();
					}

				}
				if (Unit.partnerUnit==this&&Unit.partnerUnit.parent!=null) {
					if (Unit.currentUnit.x!=pxpos&&Unit.currentUnit.y!=pypos) {
						movePlayer();
					}
				}

				if (KeyDown.keyIsDown(friendshipKey)) {
					if (unitHUD.percentage>=10000) {
						FP=0;
						unitHUD.updateFP();
						//Friendship Finale!
					}

				}
			}else {
				gotoAndStop(currentFrame);
			}
		}

		public function updateDelays() {
			attackDelay++;
			hk1Delay++;
			hk2Delay++;
			hk3Delay++;
			hk4Delay++;
			hk5Delay++;
			hk6Delay++;
			hk7Delay++;
		}

		public function switchUnits() {
			var temp=Unit.currentUnit;
			Unit.currentUnit=Unit.partnerUnit;
			Unit.partnerUnit=temp;

		}

		public function useHotKey1() {
			if (KeyDown.keyIsDown(hotKey1)&&hk1!=null&&hk1Delay>=0) {
				hk1Delay=-1*hk1.delay;
				hk1.activate(x, y, this);
			}
		}

		public function useHotKey2() {
			if (KeyDown.keyIsDown(hotKey2)&&hk2!=null&&hk2Delay>=0) {
				hk2Delay=-1*hk2.delay;
				hk2.activate(x, y, this);
			}
		}
		public function useHotKey3() {
			if (KeyDown.keyIsDown(hotKey3)&&hk3!=null&&hk3Delay>=0) {
				hk3Delay=-1*hk3.delay;
				hk3.activate(x, y, this);
			}
		}

		public function useHotKey4() {
			if (KeyDown.keyIsDown(hotKey4)&&hk4!=null&&hk4Delay>=0) {
				hk4Delay=-1*hk4.delay;
				hk4.activate(x, y, Unit.currentUnit);
			}
		}

		public function useHotKey5() {
			if (KeyDown.keyIsDown(hotKey5)&&hk5!=null&&hk5Delay>=0) {
				hk5Delay=-1*hk5.delay;
				hk5.activate(x, y, Unit.currentUnit);
			}
		}
		public function useHotKey6() {
			if (KeyDown.keyIsDown(hotKey6)&&hk6!=null&&hk6Delay>=0) {
				hk6Delay=-1*hk6.delay;
				hk6.activate(x, y, Unit.partnerUnit);
			}
		}
		public function useHotKey7() {
			if (KeyDown.keyIsDown(hotKey7)&&hk7!=null&&hk7Delay>=0) {
				hk7Delay=-1*hk7.delay;
				hk7.activate(x, y, Unit.partnerUnit);
			}
		}


		public function useComboAttack() {
			if (KeyDown.keyIsDown(attackKey)&&! KeyDown.keyIsDown(friendshipKey)&&attackDelay>=0) {
				Unit.FP+=1000;
				unitHUD.updateFP();
				attackDelay=-5;
				/*var ax=this.parent.mouseX;
				var ay=this.parent.mouseY;
				
				for (var i = -1; i < 2; i++) {
				var radian=Math.atan2(ay-this.y,ax-this.x);
				
				var degree = (radian*180/Math.PI);
				degree+=5*i;
				radian=degree*Math.PI/180;
				var bxspeed=20;
				var byspeed=20;
				
				var a=new Attack(bxspeed*Math.cos(radian),byspeed*Math.sin(radian),5,"PC");
				a.x=x+width*Math.cos(radian)/2;
				a.y=y+height*Math.sin(radian)/2;
				
				a.scaleX=0.40;
				a.rotation=90+degree;
				this.parent.addChild(a);
				//this.parent.setChildIndex(a, 0);
				}*/
			}
		}
		public function updateHP(damage) {
			damage=Math.floor(damage);
			if (HP>0) {
				HP-=damage;
				if (HP>maxHP) {
					HP=maxHP;
				}
				if (HP<0) {
					HP=0;
				}
				HPBar.update(HP, maxHP);
				if (0>=HP) {
					KO();
				}
			}
			unitHUD.updateHP();
		}

		static public function updateEXP(gain) {
			Unit.EXP+=gain;
			if (Unit.EXP>=Unit.nextEXP) {
				Unit.maxLP+=1;
				Unit.nextEXP+=Unit.maxLP*200;
				updateEXP(0);

				for (var i = 0; i < Menu.sliderValueArray.length; i++) {
					Menu.sliderValueArray[i]+=1;
				}
				//change stats here
			}
		}
		/*public function toggleAbilities(switchOn) {
		for (var i = 0; i < commands.length; i++) {
		commands[i].enable(switchOn);
		}
		}*/
		public function KO() {
			if (Unit.currentUnit.HP<=0&&Unit.partnerUnit.HP<=0) {
				var gameover=new GameOverScreen(stage);
				Unit.currentUnit.end();
				Unit.partnerUnit.end();
			} else if (Unit.currentUnit.HP<=0) {
				Unit.currentUnit.end();
				Unit.currentUnit.startAnimation(Unit.currentUnit.moveDir, false, true);
				Unit.currentUnit.addEventListener(Event.ENTER_FRAME, reviveHandler);
				//this.parent.removeChild(Unit.currentUnit);
			} else if (Unit.partnerUnit.HP<=0) {
				Unit.partnerUnit.end();
				Unit.partnerUnit.startAnimation(Unit.partnerUnit.moveDir, false,true);
				Unit.partnerUnit.addEventListener(Event.ENTER_FRAME, reviveHandler);
			}//this.parent.removeChild(Unit.partnerUnit);
		}

		public function reviveHandler(e) {
			if (! pauseAction && ! superPause && ! menuPause) {
				checkStop();
				knockout--;
				if (knockout<=0) {
					HP=Math.floor(maxHP/2);
					updateHP(0);
					begin();
					removeEventListener(Event.ENTER_FRAME,reviveHandler);					
				}
			}
		}

		function faceMouse() {
			var radian=Math.atan2(this.parent.mouseY+ScreenRect.getY()-y,this.parent.mouseX+ScreenRect.getX()-x);
			var degree = Math.round((radian*180/Math.PI));
			if (degree>-45&&45>=degree) {
				dir=6;
				//gotoAndStop(3);
			} else if (degree > -135 && -45 >= degree) {
				dir=8;
				//gotoAndStop(4);
			} else if (degree > 45 && 135 >= degree) {
				dir=2;
				//gotoAndStop(1);
			} else if ((degree > 135 && 180 >= degree) || (degree >=-180 && -135 >= degree)) {
				dir=4;
				//gotoAndStop(2);
			}
		}

		function faceDirection(radian) {
			var degree = Math.round((radian*180/Math.PI));
			if (degree>-45&&45>=degree) {
				startAnimation(6);
				//gotoAndStop(3);
			} else if (degree > -135 && -45 >= degree) {
				startAnimation(8);
				//gotoAndStop(4);
			} else if (degree > 45 && 135 >= degree) {
				startAnimation(2);
				//gotoAndStop(1);
			} else if ((degree > 135 && 180 >= degree) || (degree >=-180 && -135 >= degree)) {
				startAnimation(4);
				//gotoAndStop(2);
			}
		}
		
		public function checkDistance(tx:int, ty:int) {
			return Math.sqrt(Math.pow(tx-this.x,2)+Math.pow(ty-this.y,2));
		}

		public function movePlayer() {
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
				stopAnimation();
			}
		
		}

		public function smoothPath() {
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
	}
}