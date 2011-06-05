/*
Units are the general heroes.
*/
package actors{

	import flash.display.MovieClip;
	import flash.events.*;
	import flash.ui.Keyboard;
	import flash.utils.Timer;

	import abilities.*;
	import attacks.*;
	import enemies.*;
	import game.*;
	import items.*;
	import levels.*;
	import ui.*;
	import ui.hud.*;
	import ui.screens.*;
	import util.*;

	public class Unit extends GameUnit {

		/**
		 * The team currently fighting
		 */
		static public var currentUnit;
		static public var partnerUnit;

		/**
		 * Key Commands
		 */
		static public var switchKey="R".charCodeAt(0);
		static public var attackKey="C".charCodeAt(0);
		static public var hotKey1="Q".charCodeAt(0);
		static public var hotKey2="W".charCodeAt(0);
		static public var hotKey3="E".charCodeAt(0);
		static public var hotKey4="A".charCodeAt(0);
		static public var hotKey5="S".charCodeAt(0);
		static public var hotKey6="D".charCodeAt(0);
		static public var friendshipKey="Z".charCodeAt(0);
		static public var menuKey="X".charCodeAt(0);
		/**
		 * Delays
		 */

		static public var switchDelay=0;
		static public var menuDelay=0;
		public var attackDelay=0;
		public var hk1Delay=0;
		public var hk2Delay=0;
		public var hk3Delay=0;
		public var hk4Delay=0;
		public var hk5Delay=0;
		public var hk6Delay=0;
		/**
		 * Numerical Stats for the Units
		 * FP - Friendship Points (max 10000)
		 * Score - The score on each stage
		 * flexPoints - How many flexpoints they have
		 */
		static public var FP=0;
		static public var score=0;
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
		static public var EXP=0;
		static public var nextEXP=200;
		static public var maxLP=1;
		static public var unitHUD;//= HUDManager.getUnitHUD();

		/**
		 * Commands of the Unit
		 */
		public var hk1;
		public var hk2;
		public var hk3;
		public var hk4;
		public var hk5;
		public var hk6;
		public var finale;
		public var commands;

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
		static public var level;

		/**
		 * Speed of the Unit
		 */
		//public var speed;

		/**
		 * Unit Booleans
		 */

		public var canAttack:Boolean;
		public var canSwitch:Boolean;
		public var canOpenMenu:Boolean;
		public var canUseHotkeys:Array;

		public var attacking:Boolean;
		public var moving:Boolean;


		static public var tileMap;
		public var xtile,ytile;
		//public var dir;

		public var animate=0;
		public var pauseMovement:Boolean;

		public var HPBar;

		public function Unit(id:int) {
			/*if (id==undefined) {
			id=0;
			}*/

			this.id=id;
			if (id!=-1) {
				Name=ActorDatabase.getName(id);
				maxHP=HP=ActorDatabase.getHP(id);
				AP=ActorDatabase.getDmg(id);
				DP=ActorDatabase.getArmor(id);
				speed=ActorDatabase.getSpeed(id);
				xtile=0;//Math.floor(x/SuperLevel.tileWidth);
				ytile=0;//Math.floor(y/SuperLevel.tileHeight);
				dir=8;
				commands=[];

				passiveItems=[];
				passiveAbilities=[];

				canAttack=true;
				canSwitch=true;
				canOpenMenu=true;
				canUseHotkeys=new Array(true,true,true,true,true,true);

				attacking=false;
				moving=false;
				gotoAndStop(4);

				HPBar=new HealthBar(HP,maxHP,this,48);
			}
		}

		public function setHotkey(id:int, a) {
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
			}
		}
		public function begin() {
			addEventListener(Event.ENTER_FRAME,gameHandler);
			mxpos=x;
			mypos=y;

			xtile=Math.floor(x/SuperLevel.tileWidth);
			ytile=Math.floor(y/SuperLevel.tileHeight);
		}
		public function end() {
			removeEventListener(Event.ENTER_FRAME,gameHandler);
		}


		override public function gameHandler(e) {
			if (FP>10000) {
				FP=10000;
			}
			if (! pauseAction&&! superPause&&! menuPause) {
				if (Unit.currentUnit==this&&Unit.currentUnit.parent!=null) {
					movePlayer();
					switchUnits(false);
					useHotKey1();
					useHotKey2();
					useHotKey3();
					useHotKey4();
					useHotKey5();
					useHotKey6();
					useComboAttack();
					openMenu();

					updateDelays();
				}
				if (Unit.partnerUnit==this&&Unit.partnerUnit.parent!=null) {
					if (Unit.currentUnit.x!=pxpos&&Unit.currentUnit.y!=pypos) {
						movePlayer();
					}
				}
				if (this.parent!=null) {
					faceMouse();
				}

				if (KeyDown.keyIsDown("Z".charCodeAt(0))&&KeyDown.keyIsDown("C".charCodeAt(0))) {
					if (FriendshipBar.percentage>=10000) {
						FP=0;
						//Friendship Finale!
					}

				}
			}
		}

		public function updateDelays() {
			switchDelay++;
			attackDelay++;
			hk1Delay++;
			hk2Delay++;
			hk3Delay++;
			hk4Delay++;
			hk5Delay++;
			hk6Delay++;
			menuDelay++;
		}
		public function openMenu() {
			if (KeyDown.keyIsDown(menuKey)&&menuDelay>=0) {
				var menu=new Menu(stage);
				GameUnit.menuPause=true;
			}
		}
		public function switchUnits(bypass) {
			var temp;
			if (bypass) {
				end();
				temp=Unit.currentUnit;
				Unit.currentUnit=Unit.partnerUnit;
				Unit.partnerUnit=temp;
				HUD_Unit.autoUpdate=true;
				begin();
			} else {
				if (KeyDown.keyIsDown(switchKey)&&switchDelay>=0&&Unit.partnerUnit.HP>0) {
					switchDelay=-5;
					end();
					temp=Unit.currentUnit;
					Unit.currentUnit=Unit.partnerUnit;
					Unit.partnerUnit=temp;
					HUD_Unit.autoUpdate=true;
					begin();
				}
			}
		}

		public function useHotKey1() {
			if (KeyDown.keyIsDown(hotKey1)&&hk1!=null&&hk1Delay>=0) {
				hk1Delay=-1*hk1.delay;
				hk1.activate(x, y);
			}
		}

		public function useHotKey2() {
			if (KeyDown.keyIsDown(hotKey2)&&hk2!=null&&hk2Delay>=0) {
				hk2Delay=-1*hk2.delay;
				hk2.activate(x, y);
			}
		}
		public function useHotKey3() {
			if (KeyDown.keyIsDown(hotKey3)&&hk3!=null&&hk3Delay>=0) {
				hk3Delay=-1*hk3.delay;
				hk3.activate(x, y);
			}
		}

		public function useHotKey4() {
			if (KeyDown.keyIsDown(hotKey4)&&hk4!=null&&hk4Delay>=0) {
				hk4Delay=-1*hk4.delay;
				hk4.activate(x, y);
			}
		}

		public function useHotKey5() {
			if (KeyDown.keyIsDown(hotKey5)&&hk5!=null&&hk5Delay>=0) {
				hk5Delay=-1*hk5.delay;
				hk5.activate(x, y);
			}
		}
		public function useHotKey6() {
			if (KeyDown.keyIsDown(hotKey6)&&hk3!=null&&hk6Delay>=0) {
				hk6Delay=-1*hk6.delay;
				hk6.activate(x, y);
			}
		}

		public function useComboAttack() {
			if (KeyDown.keyIsDown(attackKey)&&! KeyDown.keyIsDown(friendshipKey)&&attackDelay>=0) {
				attackDelay=-5;
				var ax=this.parent.mouseX;
				var ay=this.parent.mouseY;


				score+=Math.floor(Math.random()*1000+100);

				for (var i = -1; i < 2; i++) {
					var radian=Math.atan2(ay-this.y,ax-this.x);

					var degree = (radian*180/Math.PI);
					degree+=5*i;
					radian=degree*Math.PI/180;
					var bxspeed=20;
					var byspeed=20;

					var b1=new CM_BasicShot(bxspeed*Math.cos(radian),byspeed*Math.sin(radian),5,"PC",tileMap);
					b1.x=x+width*Math.cos(radian)/2;
					b1.y=y+height*Math.sin(radian)/2;

					b1.scaleX=0.40;
					b1.rotation=90+degree;
					this.parent.addChild(b1);
					this.parent.setChildIndex(b1, 0);
				}
				/*var radian=Math.atan2(my-this.y,mx-this.x);
				
				var degree = (radian*180/Math.PI);
				
				var bxspeed=10;
				var byspeed=10;
				
				//var b1=new CM_MagicShot(bxspeed*Math.cos(radian),byspeed*Math.sin(radian),5,dir,tileMap);
				//var b1=new CK_ElecShot(bxspeed*Math.cos(radian),byspeed*Math.sin(radian),5,"PC",tileMap);
				//var b1 = new CM_RisingSun(30, 10);
				
				var b1 = new CM_BasicShot(bxspeed*Math.cos(radian),byspeed*Math.sin(radian),5,"PC",tileMap);
				b1.x=x+width*Math.cos(radian)/2;
				b1.y=y+height*Math.sin(radian)/2;
				
				b1.rotation=90+degree;
				this.parent.addChild(b1);
				this.parent.setChildIndex(b1, 0);
				*/
			}
		}
		public function updateHP(damage) {
			damage=Math.round(damage);
			if (HP>0) {
				HP-=damage;
				if (HP>maxHP) {
					HP=maxHP;
				}
				if (HP<0) {
					HP=0;
				}
				HPBar.update(HP, maxHP);
				if (damage>0) {

					var radian,xs,ys,exfrag;
					radian=Math.floor(Math.random()*360)*Math.PI/180;
					xs=5*Math.cos(radian);
					ys=5*Math.sin(radian);
					exfrag=new ExFrag1(xs,ys,Unit.tileMap);
					exfrag.x=x;
					exfrag.y=y;
					exfrag.scaleX=0.3;
					exfrag.scaleY=0.3;
					this.parent.addChild(exfrag);
				}
				if (0>=HP) {
					KO();
					toggleAbilities(false);
				}
			}
			//hud.updateHP prease :)
		}

		static public function updateEXP(gain) {
			Unit.EXP+=gain;
			if (Unit.EXP>=Unit.nextEXP) {
				Unit.maxLP+=1;
				Unit.nextEXP+=Unit.maxLP*200;
				updateEXP(0);
			}
			//hud.updateEXP
		}
		public function toggleAbilities(switchOn) {
			for (var i = 0; i < commands.length; i++) {
				commands[i].enable(switchOn);
			}
		}
		public function KO() {
			HUD_Unit.autoUpdate=true;
			for (var i = 0; i < commands.length; i++) {
				if (commands[i].Name=="Second Chance"&&commands[i].activate(x,y)) {
					HP=1;
					break;
				} else if (commands[i].Name == "Second Wind" && commands[i].activate(x, y)) {
					HP=maxHP/2;
					break;
				} else if (commands[i].Name == "Second World" && commands[i].activate(x, y)) {
					HP=maxHP;
					break;
				}
			}
			if (Unit.currentUnit.HP<=0&&Unit.partnerUnit.HP<=0) {
				stage.addChild(new GameOverDisplay());
				Unit.currentUnit.end();
				Unit.partnerUnit.end();
			} else if (Unit.currentUnit.HP<=0) {
				Unit.currentUnit.end();
				//this.parent.removeChild(Unit.currentUnit);
				switchUnits(true);
			} else if (Unit.partnerUnit.HP<=0) {
				Unit.partnerUnit.end();
			}//this.parent.removeChild(Unit.partnerUnit);
		}

		function faceMouse() {
			var radian=Math.atan2(this.parent.mouseY+ScreenRect.getY()-y,this.parent.mouseX+ScreenRect.getX()-x);
			var degree = Math.round((radian*180/Math.PI));
			if (degree>-45&&45>=degree) {
				dir=6;
				gotoAndStop(3);
			} else if (degree > -135 && -45 >= degree) {
				dir=8;
				gotoAndStop(4);
			} else if (degree > 45 && 135 >= degree) {
				dir=2;
				gotoAndStop(1);
			} else if ((degree > 135 && 180 >= degree) || (degree >=-180 && -135 >= degree)) {
				dir=4;
				gotoAndStop(2);
			}
		}

		public function movePlayer() {
			moving=true;
			if (Unit.tileMap!=null) {
				//if (mxpos!=null&&mypos!=null) {
				var mxtile=Math.floor(mxpos/SuperLevel.tileWidth);
				var mytile=Math.floor(mypos/SuperLevel.tileHeight);
				if (! tileMap["t_"+mytile+"_"+mxtile].walkable) {
					if (! tileMap["t_"+ytile+"_"+mxtile].walkable) {
						while (! tileMap["t_"+ytile+"_"+mxtile].walkable) {
							if (mxpos>x) {
								mxtile--;
							} else if (x > mxpos) {
								mxtile++;
							}
						}
						if (mxpos>x) {
							mxpos=(mxtile+1)*SuperLevel.tileWidth-width/2;//-w_collision.x+width/2-4;
						} else if (x > mxpos) {
							mxpos=(mxtile)*SuperLevel.tileWidth+width/2;
						}
					}
					if (! tileMap["t_"+mytile+"_"+mxtile].walkable) {
						while (! tileMap["t_"+mytile+"_"+mxtile].walkable) {
							if (mypos>y) {
								mytile--;
							} else if (y > mypos) {
								mytile++;
							}
						}
						if (mypos>y) {
							//prevent bouncing
							mypos=(mytile+1)*SuperLevel.tileHeight-1;//-w_collision.y+height/2-4;
						} else if (y > mypos) {
							mypos=(mytile)*SuperLevel.tileHeight;
						}
					}
				} else {

					if (Math.sqrt(Math.pow(mxpos-x,2)+Math.pow(mypos-y,2))>speed) {
						var radian=Math.atan2(mypos-y,mxpos-x);
						var degree = Math.round((radian*180/Math.PI));
						var mx=x+speed*Math.cos(radian);
						var my=y+speed*Math.sin(radian);

						mxtile=Math.floor(mx/SuperLevel.tileWidth);
						mytile=Math.floor(my/SuperLevel.tileHeight);
						if (! tileMap["t_"+mytile+"_"+mxtile].walkable) {
							if (! tileMap["t_"+ytile+"_"+mxtile].walkable) {
								while (! tileMap["t_"+ytile+"_"+mxtile].walkable) {
									if (mx>x) {
										mxtile--;
									} else if (x > mx) {
										mxtile++;
									}
								}
								if (mx>x) {
									mx=(mxtile)*SuperLevel.tileWidth-width/2;//-w_collision.x+width/2-4;
								} else if (x > mx) {
									mx=(mxtile)*SuperLevel.tileWidth+width/2;
								}

								x=mx;
								y=my;

							} else if (! tileMap["t_"+mytile+"_"+xtile].walkable) {
								while (! tileMap["t_"+mytile+"_"+xtile].walkable) {
									if (my>y) {
										mytile--;
									} else if (y > my) {
										mytile++;
									}
								}
								if (my>y) {
									//prevent bouncing
									my=(mytile+1)*SuperLevel.tileHeight-1;//-w_collision.y+height/2-4;
								} else if (y > my) {
									my=(mytile)*SuperLevel.tileHeight;
								}
								x=mx;
								y=my;
							} else {
								x=mx;
								y=my;
							}
						} else {
							x=mx;
							y=my;
						}
					} else {
						x=mxpos;
						y=mypos;
					}
				}
				//}
			}
			xtile=Math.floor(x/SuperLevel.tileWidth);
			ytile=Math.floor(y/SuperLevel.tileHeight);
		}
	}
}