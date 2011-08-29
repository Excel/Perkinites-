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
		public var carry:int;
		static public var EXP=0;
		static public var nextEXP=200;
		static public var maxLP=20;
		static public var unitHUD=HUDManager.getUnitHUD();



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

		static public var abilityAmounts:Array=AbilityDatabase.abilityAmounts;
		//work on implementing this
		static public var itemAmounts:Array = AbilityDatabase.itemAmounts;

		public var buffs:Array;
		public var passiveItems:Array;
		public var passiveAbilities:Array;
		/**
		 * Position of the Unit
		 */
		//public var mxpos=0;
		//public var mypos=0;
		//public var range=0;

		/**
		 * Unit Booleans
		 */

		public var canAttack:Boolean;
		public var canOpenMenu:Boolean;
		public var canUseHotkeys:Array;


		public var activating:Boolean=false;
		//public var moving:Boolean=false;
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
				maxHP=ActorDatabase.getHP(id);
				HP = 1;
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

				activating = false;
				moving=false;
				//gotoAndStop(1);

				HPBar=new HealthBar(HP,maxHP,this,48);

				basicAbilities=AbilityDatabase.getBasicAbilities(Name);
				hotkeySet=new Array(basicAbilities[0]);

				powerpoints=50;
				knockout = 24 * 30;
				
				buffs = new Array();
				
			}
		}
		
		static public function levelup() {
			
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
					hk4 = a;
					Unit.currentUnit.hotkeySet[0] = a;
					break;
				case 5 :
					hk5=a;
					Unit.currentUnit.hotkeySet[1] = a;
					break;
				case 6 :
					hk6 = a;
					Unit.partnerUnit.hotkeySet[0] = a;					
					break;
				case 7 :
					hk7=a;
					Unit.partnerUnit.hotkeySet[1] = a;					
					break;
			}
		}

		public function begin() {
			startAnimation(dir, true);
			addEventListener(Event.ENTER_FRAME, gameHandler);
			moving = false;
			range = 0;

			unitHUD.updateFaces();
			unitHUD.updateHP();
			knockout=24*30;

			if (Unit.currentUnit==this) {
				Unit.setHotkey(4, hotkeySet[0]);
				Unit.setHotkey(5, hotkeySet[1]);
			} else if (Unit.partnerUnit == this) {
				Unit.setHotkey(6, hotkeySet[0]);
				Unit.setHotkey(7, hotkeySet[1]);
			}
			Unit.currentUnit.addEventListener(Event.ENTER_FRAME, detectHandler);
			stopAnimation();

		}
		public function end() {
			removeEventListener(Event.ENTER_FRAME,gameHandler);
		}

		override public function detectHandler(e:Event):void{
			if ((Unit.currentUnit.hitTestPoint(GameVariables.stageRef.mouseX, GameVariables.stageRef.mouseY)  && Unit.currentUnit.parent != null)
				|| (Unit.partnerUnit.hitTestPoint(GameVariables.stageRef.mouseX, GameVariables.stageRef.mouseY)  && Unit.partnerUnit.parent != null)){
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

					//movePlayer();
					//moveDirection();

				}
				if (Unit.partnerUnit==this&&Unit.partnerUnit.parent!=null) {
					if (Unit.currentUnit.x!=mxpos&&Unit.currentUnit.y!=mypos) {
					//	movePlayer();
					}
				}
				
				for (var i = buffs.length-1; i >=0; i--) {
					buffs[i].tick();
					if (buffs[i].duration == 0) {
						buffs.splice(i, 1);
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

		public function switchUnits() {
			var temp=Unit.currentUnit;
			Unit.currentUnit=Unit.partnerUnit;
			Unit.partnerUnit=temp;

		}

		public function updateHP(damage, popup) {
			if (popup == "Yes") {
				var p;
				if (damage >= 0) {
					p = new PopUp(1, Math.abs(damage));
					p.x = this.x;
					p.y = this.y;
					GameVariables.stageRef.addChild(p);
				}
				else {
					p = new PopUp(3, Math.abs(damage));
					p.x = this.x;
					p.y = this.y;					
					GameVariables.stageRef.addChild(p);
				}
			}						
			damage = Math.floor(damage);
			if (HP>0) {
				HP -= damage;
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
				levelup();

/*				for (var i = 0; i < Menu.sliderValueArray.length; i++) {
					Menu.sliderValueArray[i]+=1;
				}*/
				//change stats here
			}
		}

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
					HP = 1;
					updateHP(Math.floor(maxHP / 2), "Yes");
					this.HP -= 1;
					updateHP(0, "No");
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

		public function faceDirection(radian) {
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
		
		public function getHealth() {
			
		}
		public function getAttack() {
			var totalAttack = this.AP;
			var i = 0;
			for (i = 0; i < passiveItems.length; i++) {
				if(passiveItems[i].equipStatBuff == "Yes"){
					totalAttack *= 1 + (passiveItems[i].attackPerc / 100);
					totalAttack += passiveItems[i].attackLump;
				}
			}
			for (i = 0; i < passiveAbilities.length; i++) {
				if(passiveAbilities[i].equipStatBuff == "Yes"){
					totalAttack *= 1 + (passiveAbilities[i].attackPerc / 100);
					totalAttack += passiveAbilities[i].attackLump;
				}
			}
			
			var hotkeys;
			if (this == Unit.currentUnit) {
				hotkeys = new Array(Unit.hk1, Unit.hk2, Unit.hk4, Unit.hk5);
			} else if (this == Unit.partnerUnit) {
				hotkeys = new Array(Unit.hk3, Unit.hk6, Unit.hk7); //add hk8 here later, which is R				
			}
			
			for (i = 0; i < hotkeys.length; i++) {
				if(hotkeys[i] != null && hotkeys[i].equipStatBuff == "Yes"){
					totalAttack *= 1 + (hotkeys[i].attackPerc / 100);
					totalAttack += hotkeys[i].attackLump;
				}
			}
			
			for (i = 0; i < buffs.length; i++) {
				totalAttack *= 1 + (buffs[i].attackPerc / 100);
				totalAttack += buffs[i].attackLump;
			}
			return Math.floor(totalAttack);
		}
		public function getDefense() {
			var totalDefense = this.DP;
			
			var i = 0;
			for (i = 0; i < passiveItems.length; i++) {
				if(passiveItems[i].equipStatBuff == "Yes"){
					totalDefense *= 1 + (passiveItems[i].defensePerc / 100);
					totalDefense += passiveItems[i].defenseLump;
				}
			}
			for (i = 0; i < passiveAbilities.length; i++) {
				if(passiveAbilities[i].equipStatBuff == "Yes"){
					totalDefense *= 1 + (passiveAbilities[i].defensePerc / 100);
					totalDefense += passiveAbilities[i].defenseLump;
				}
			}
			
			var hotkeys;
			if (this == Unit.currentUnit) {
				hotkeys = new Array(Unit.hk1, Unit.hk2, Unit.hk4, Unit.hk5);
			} else if (this == Unit.partnerUnit) {
				hotkeys = new Array(Unit.hk3, Unit.hk6, Unit.hk7); //add hk8 here later, which is R				
			}
			
			for (i = 0; i < hotkeys.length; i++) {
				if(hotkeys[i] != null && hotkeys[i].equipStatBuff == "Yes"){
					totalDefense *= 1 + (hotkeys[i].defensePerc / 100);
					totalDefense += hotkeys[i].defenseLump;
				}
			}			
			
			for (i = 0; i < buffs.length; i++) {
				totalDefense *= 1 + (buffs[i].defensePerc / 100);
				totalDefense += buffs[i].defenseLump;
			}
			return Math.floor(totalDefense);
		}	
		public function getSpeed() {
			var totalSpeed = this.speed;
			
			var i = 0;
			for (i = 0; i < passiveItems.length; i++) {
				if(passiveItems[i].equipStatBuff == "Yes"){
					totalSpeed *= 1 + (passiveItems[i].speedPerc / 100);
					totalSpeed += passiveItems[i].speedLump;
				}
			}
			for (i = 0; i < passiveAbilities.length; i++) {
				if(passiveAbilities[i].equipStatBuff == "Yes"){
					totalSpeed *= 1 + (passiveAbilities[i].speedPerc / 100);
					totalSpeed += passiveAbilities[i].speedLump;
				}
			}
			
			var hotkeys;
			if (this == Unit.currentUnit) {
				hotkeys = new Array(Unit.hk1, Unit.hk2, Unit.hk4, Unit.hk5);
			} else if (this == Unit.partnerUnit) {
				hotkeys = new Array(Unit.hk3, Unit.hk6, Unit.hk7); //add hk8 here later, which is R				
			}
			
			for (i = 0; i < hotkeys.length; i++) {
				if(hotkeys[i] != null && hotkeys[i].equipStatBuff == "Yes"){
					totalSpeed *= 1 + (hotkeys[i].speedPerc / 100);
					totalSpeed += hotkeys[i].speedLump;
				}
			}					
			
			var slowPerc = 0;
			for (i = 0; i < buffs.length; i++) {
				totalSpeed *= 1 + (buffs[i].speedPerc / 100);
				totalSpeed += buffs[i].speedLump;
				if (buffs[i].debuffType == "Stun") {
					return 0;
				} else if (buffs[i].debuffType == "Slow") {
					slowPerc = buffs[i].slowPerc;
				}
			}
			totalSpeed *= 1 - (slowPerc / 100);
			return Math.floor(totalSpeed);
		}	
		
		public function getDashSpeed() {
			var totalDashSpeed = this.getSpeed();
			return Math.floor(totalDashSpeed * 1.2);
		}
		public function isSlowed() {
			for (var i = 0; i < buffs.length; i++) {
				if (buffs[i].debuffType == "Slow") {
					return true;
				}
			}
			return false;
		}				
		public function isStunned() {
			for (var i = 0; i < buffs.length; i++) {
				if (buffs[i].debuffType == "Stun") {
					return true;
				}
			}
			return false;
		}		
		public function isSick() {
			for (var i = 0; i < buffs.length; i++) {
				if (buffs[i].debuffType == "Sick") {
					return true;
				}
			}
			return false;
		}						
		public function isExhausted() {
			for (var i = 0; i < buffs.length; i++) {
				if (buffs[i].debuffType == "Exhaust") {
					return true;
				}
			}
			return false;
		}
		public function isRegen() {
			for (var i = 0; i < buffs.length; i++) {
				if (buffs[i].debuffType == "Regen") {
					return true;
				}
			}
			return false;
		}		
	}
}