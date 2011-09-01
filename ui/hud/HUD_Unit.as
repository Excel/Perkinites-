package ui.hud{
	import flash.text.TextField;
	import actors.*;
	import abilities.*;
	import util.*;

	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.*;
	import flash.geom.ColorTransform;
	import flash.ui.*;

	public class HUD_Unit extends MovieClip {
		var currentHP;
		var partnerHP;
		public var percentage;


		public var iconCover;
		public var redCover;

		function HUD_Unit() {
			x=0;
			y=385+16;
			currentHP=-1;
			partnerHP=-1;
			percentage=0;
			friendshipBar.FP.width=62*percentage/10000;

			iconCover=new ColorTransform(0.3,0.3,0.3,0.5,0,0,0,0);
			redCover=new ColorTransform(0.75,0.3,0.3,0.5,0,0,0,0);

			/*var hotkeyIconArray = [hotkeyHolder.qIcon,
			   hotkeyHolder.wIcon,
			   hotkeyHolder.eIcon,
			   hotkeyHolder.aIcon,
			   hotkeyHolder.sIcon,
			   hotkeyHolder.dIcon,
			   hotkeyHolder.fIcon];

			for (var i = 0; i < hotkeyIconArray.length; i++) {
				hotkeyIconArray[i].gotoAndStop(1);
				hotkeyIconArray[i].addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
				hotkeyIconArray[i].addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
			}*/
			ffIcon.gotoAndStop(1);

			/*healthBar1=new HealthBar(Unit.currentUnit.HP,Unit.currentUnit.maxHP);
			healthBar2=new HealthBar(Unit.partnerUnit.HP,Unit.partnerUnit.maxHP);
			healthBar1.x=32;
			healthBar1.y=16+64+2;
			healthBar2.x=144;
			healthBar2.y=16+64+2;
			addChild(healthBar1);
			addChild(healthBar2);
			*/
			addEventListener(Event.ENTER_FRAME, gameHandler);
		}
		/*public function mouseOutHandler(e) {
			description.text="";
		}
		public function mouseOverHandler(e) {
			var hotkeyIconArray = [hotkeyHolder.qIcon,
			   hotkeyHolder.wIcon,
			   hotkeyHolder.eIcon,
			   hotkeyHolder.aIcon,
			   hotkeyHolder.sIcon,
			   hotkeyHolder.dIcon,
			   hotkeyHolder.fIcon];
			var hotkeyArray =[Unit.hk1, Unit.hk2, Unit.hk3, 
			  Unit.hk4, Unit.hk5, Unit.hk6, 
			  Unit.hk7];

			var obj=e.target;
			var index=hotkeyIconArray.indexOf(obj);
			var hotkeys=new Array("Q","W","E","R","A","S","D","F");
			description.text="["+hotkeys[index]+"]: ";

			if (hotkeyArray[index]!=null) {
				var hotkey=hotkeyArray[index];
				description.text="["+hotkeys[index]+"]: "+hotkey.description;
			}
		}*/
		public function gameHandler(e) {
			collide();

			updateName();
			//updateFP();
			//updateHKeys();
			//updateProfile();
		}

		/*public function updateHKeys() {
			var hotkeyArray =[Unit.hk1, Unit.hk2, Unit.hk3, 
			  Unit.hk4, Unit.hk5, Unit.hk6, 
			  Unit.hk7];
			var hotkeyIconArray = [hotkeyHolder.qIcon,
			   hotkeyHolder.wIcon,
			   hotkeyHolder.eIcon,
			   hotkeyHolder.aIcon,
			   hotkeyHolder.sIcon,
			   hotkeyHolder.dIcon,
			   hotkeyHolder.fIcon];

			for (var i = 0; i < hotkeyArray.length; i++) {
				if (hotkeyArray[i]!=null) {
					hotkeyIconArray[i].useCount.visible=true;
					hotkeyIconArray[i].gotoAndStop(hotkeyArray[i].index);
					if (hotkeyArray[i] is Item) {
						hotkeyIconArray[i].useCount.text=Unit.itemAmounts[hotkeyArray[i].id];
						if (Unit.itemAmounts[hotkeyArray[i].id]==0) {
							hotkeyIconArray[i].transform.colorTransform=iconCover;
						} else if (hotkeyArray[i].min == 0) {
							hotkeyIconArray[i].transform.colorTransform=redCover;

						} else {
							hotkeyIconArray[i].transform.colorTransform=new ColorTransform();
						}
					} else {
						hotkeyIconArray[i].useCount.text=hotkeyArray[i].uses;
						if (hotkeyArray[i].uses==0) {
							hotkeyIconArray[i].transform.colorTransform=iconCover;
						} else if (hotkeyArray[i].min == 0) {
							hotkeyIconArray[i].transform.colorTransform=redCover;

						} else {
							hotkeyIconArray[i].transform.colorTransform=new ColorTransform();
						}
					}
				} else {
					hotkeyIconArray[i].gotoAndStop(1);
					hotkeyIconArray[i].useCount.visible=false;
				}
			}
		}*/
		public function updateHP() {

			if (Unit.currentUnit!=null&&Unit.currentUnit.id!=-1) {
				var u1=Unit.currentUnit;
				currentHP=u1.HP;
				if (currentHP<=0) {
					HPDisplay1.text="000";
				} else if (currentHP<10) {
					HPDisplay1.text="00"+currentHP;
				} else if (currentHP < 100) {
					HPDisplay1.text="0"+currentHP;
				} else {
					HPDisplay1.text=currentHP;
				}
				//healthBar1.update(Unit.currentUnit.HP, Unit.currentUnit.maxHP);
			}
			if (Unit.partnerUnit!=null&&Unit.partnerUnit.id!=-1) {
				var u2=Unit.partnerUnit;
				partnerHP=u2.HP;
				if (partnerHP<=0) {
					HPDisplay2.text="000";
				} else if (partnerHP<10) {
					HPDisplay2.text="00"+partnerHP;
				} else if (partnerHP < 100) {
					HPDisplay2.text="0"+partnerHP;
				} else {
					HPDisplay2.text=partnerHP;
				}
				//healthBar2.update(Unit.partnerUnit.HP, Unit.partnerUnit.maxHP);
			}
		}

		public function updateFaces(){
			faceIcon1.gotoAndStop(Unit.currentUnit.id+2);
			faceIcon2.gotoAndStop(Unit.partnerUnit.id+2);			
		}
		public function updateName() {
			if (currentHP>=0) {
				unitName1.text=Unit.currentUnit.Name;
			}
			if (partnerHP>=0) {
				unitName2.text=Unit.partnerUnit.Name;
			}
		}

		public function updateFP() {
			addEventListener(Event.ENTER_FRAME, updateFPHandler);
		}

		public function updateFPHandler(e) {
			for (var i = 0; i < 10; i++) {
				if (percentage<Unit.FP) {
					percentage+=10;
				}
			}
			if (percentage>Unit.FP) {
				percentage-=500;
			}

			if (percentage>10000) {
				percentage=10000;
			}
			friendshipBar.FP.width=62*percentage/10000;
			if (percentage<=0) {
				FPDisplay.text="00.0%";
			} else if (percentage<1000) {
				FPDisplay.text="0"+Math.floor(percentage/100)+"."+(percentage%100)/10+"%";
			} else if (percentage < 10000) {
				FPDisplay.text=Math.floor(percentage/100)+"."+(percentage%100)/10+"%";
			} else {
				FPDisplay.text="100.0%";
			}

			if (percentage==Unit.FP) {
				removeEventListener(Event.ENTER_FRAME, updateFPHandler);
			}
		}



		public function collide() {
			if (Unit.currentUnit!=null) {
				checkCollide(Unit.currentUnit);
			}
			if (Unit.partnerUnit!=null) {
				checkCollide(Unit.partnerUnit);
			}
		}
		public function checkCollide(unit) {
			if (this.hitTestObject(unit)) {
				if (alpha>0.5) {
					alpha-=0.1;
				}
			} else {
				if (alpha<1) {
					alpha+=0.1;
				}
			}
		}


	}


}