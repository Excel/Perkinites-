﻿package ui.screens{

	import flash.text.TextField;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.*;
	import flash.filters.GlowFilter;


	public class FileScreen extends BaseScreen {

		public var loadGame;
		public var frame;
		public var checkedEntry;
		public var chosenEntry;
		function FileScreen(loadGame:Boolean, nextScreen:BaseScreen, stageRef:Stage = null) {

			this.loadGame=loadGame;
			this.nextScreen=nextScreen;
			this.stageRef=stageRef;
			gotoAndStop(1);

			displayInfo(file1, false);
			displayInfo(file2, false);
			file1.hasData=false;
			file2.hasData=false;
			file1.fileNum.text="File 1";
			file2.fileNum.text="File 2";
			checkBox1.gotoAndStop(1);
			checkBox2.gotoAndStop(1);
			checkBox1.addEventListener(MouseEvent.CLICK, checkEntry);
			checkBox2.addEventListener(MouseEvent.CLICK, checkEntry);


			file1.mouseChildren=false;
			file2.mouseChildren=false;
			//move the arrow to the most recently saved
			arrow.y=169;


			frame=0;
			deleteButton.buttonText.text="Delete Game";
			popup.alpha=0;
			popup.visible = false;

			deleteButton.addEventListener(MouseEvent.CLICK, deleteEntry);
			back.addEventListener(MouseEvent.CLICK, goBack);
			file1.addEventListener(MouseEvent.CLICK, chooseEntry);
			file2.addEventListener(MouseEvent.CLICK, chooseEntry);
			if (loadGame) {
				optionDescription.text="Load your game by clicking on a file entry! Yum! The freshness is always good. :)";
				optionDisplay.text="Load from which file?";
			} else {
				optionDescription.text="Save your game by clicking on a file entry! It's always good to save your progress for the benefit of the happiness! :)";
				optionDisplay.text="Save to which file?";
			}
			confirm.visible=false;

			load();
		}


		public function checkEntry(e) {
			if (checkedEntry!=null) {
				if (checkedEntry==file1&&e.target==checkBox1) {
					checkBox1.gotoAndStop(1);
					checkedEntry=null;
				} else if (checkedEntry == file2 && e.target == checkBox2) {
					checkBox2.gotoAndStop(1);
					checkedEntry=null;
				} else {
					if (e.target==checkBox1) {
						checkBox1.gotoAndStop(2);
						checkBox2.gotoAndStop(1);
						checkedEntry=file1;
					} else if (e.target == checkBox2) {
						checkBox1.gotoAndStop(1);
						checkBox2.gotoAndStop(2);
						checkedEntry=file2;

					}

				}
			} else {
				if (e.target==checkBox1) {
					checkBox1.gotoAndStop(2);
					checkedEntry=file1;
				} else if (e.target == checkBox2) {
					checkBox2.gotoAndStop(2);
					checkedEntry=file2;
				}
			}
		}


		public function chooseEntry(e) {
			chosenEntry=e.target;
			if (!loadGame || (chosenEntry.hasData && loadGame)) {
				confirm.visible=true;
				confirm.x=0;
				confirm.y=0;

				if (loadGame) {
					if (chosenEntry==file1) {
						confirm.confirmMessage.text="LOAD FILE 1 DOOD?";
					} else if (chosenEntry == file2) {
						confirm.confirmMessage.text="LOAD FILE 2 MAN?";
					}
				} else {
					if (chosenEntry==file1) {
						confirm.confirmMessage.text="SAVE FILE 1 DOOD?";
					} else if (chosenEntry == file2) {
						confirm.confirmMessage.text="SAVE FILE 2 MAN?";
					}
				}
				confirm.yesButton.buttonText.text="YA DOOD";
				confirm.noButton.buttonText.text="NO DAWG";

				//confirm.addEventListener(MouseEvent.CLICK, confirmHandler);
				confirm.mouseChildren=true;
				confirm.yesButton.removeEventListener(MouseEvent.CLICK, confirmDelete);
				confirm.yesButton.addEventListener(MouseEvent.CLICK, confirmHandler);
				confirm.noButton.addEventListener(MouseEvent.CLICK, removeConfirm);
			}
		}

		public function deleteEntry(e) {
			if (checkedEntry!=null) {
				confirm.visible=true;
				confirm.x=0;
				confirm.y=0;

				if (checkedEntry==file1) {
					confirm.confirmMessage.text="DELETE FILE 1 DOOD?";
				} else if (checkedEntry == file2) {
					confirm.confirmMessage.text="DELETE FILE 2 MAN?";
				}

				confirm.yesButton.buttonText.text="YA DOOD";
				confirm.noButton.buttonText.text="NO DAWG";

				confirm.mouseChildren=true;


				confirm.yesButton.removeEventListener(MouseEvent.CLICK, confirmHandler);
				confirm.yesButton.addEventListener(MouseEvent.CLICK, confirmDelete);
				confirm.noButton.addEventListener(MouseEvent.CLICK, removeConfirm);
			}
		}

		public function confirmHandler(e) {
			confirm.visible=false;
			//SHAREDOBJECT JANX
			if (loadGame) {

			} else {
				frame=0;
				var obj=chosenEntry;
				popup.alpha=0;
				popup.visible = false;
				if (obj.fileNum.text=="File 1") {
					popup.y=135;
					arrow.y=169;
					updateInfo(file1);
				} else {
					popup.y=313;
					arrow.y=347;
					file2.gotoAndStop(2);
					updateInfo(file2);
				}
				//flash the screen with white
				popup.addEventListener(Event.ENTER_FRAME, showPopup);

			}

		}




		public function confirmDelete(e) {
			confirm.visible=false;
			//SHAREDOBJECT JANX

			var obj=checkedEntry;
			popup.alpha=0;
			popup.visible = false;
			if (obj.fileNum.text=="File 1") {
				displayInfo(file1, false);
			} else {
				displayInfo(file2, false);
			}
			//flash the screen with white
			popup.removeEventListener(Event.ENTER_FRAME, showPopup);

			checkBox1.gotoAndStop(1);
			checkBox2.gotoAndStop(1);
			checkedEntry=null;

		}
		public function removeConfirm(e) {
			confirm.visible=false;

		}
		public function goBack(e) {
			gotoNextScreen();
		}

		public function showPopup(e) {
			popup.visible = true;
			if (frame<12) {
				popup.alpha+=1/12;
			} else if (frame < 24) {

				popup.alpha-=1/12;
			} else {
				popup.removeEventListener(Event.ENTER_FRAME, showPopup);
				popup.visible = false;
				popup.alpha = 0;
			}
			frame++;

		}

		public function updateInfo(file) {
			displayInfo(file, true);
			file.faceIcon1.gotoAndStop(1);
			file.faceIcon2.gotoAndStop(1);
			file.levelCount.text="00";
			file.FPDisplay.text="";
			file.timeDisplay.text="";
			file.locationDisplay.text="";
			file.unitName1.text="";
			file.unitName2.text="";

			file.hotkeyHolder.qIcon.gotoAndStop(1);
			file.hotkeyHolder.wIcon.gotoAndStop(1);
			file.hotkeyHolder.eIcon.gotoAndStop(1);
			file.hotkeyHolder.aIcon.gotoAndStop(1);
			file.hotkeyHolder.sIcon.gotoAndStop(1);
			file.hotkeyHolder.dIcon.gotoAndStop(1);
			file.hotkeyHolder.fIcon.gotoAndStop(1);
		}

		public function displayInfo(file, display:Boolean) {
			file.faceIcon1.visible=display;
			file.faceIcon2.visible=display;
			file.levelCount.visible=display;
			file.FPDisplay.visible=display;
			file.timeDisplay.visible=display;
			file.locationDisplay.visible=display;
			file.unitName1.visible=display;
			file.unitName2.visible=display;

			file.hotkeyHolder.visible=display;
		}

		/*public function overHandler1(e) {
		var gf1=new GlowFilter(0xFF0000,100,20,20,1,10,true,false);
		newButton.filters=[gf1];
		}
		public function overHandler2(e) {
		var gf1=new GlowFilter(0x00FF00,100,20,20,1,10,true,false);
		continueButton.filters=[gf1];
		}
		public function overHandler3(e) {
		var gf1=new GlowFilter(0x0000FF,100,20,20,1,10,true,false);
		configButton.filters=[gf1];
		}
		public function outHandler1(e) {
		newButton.filters=[];
		}
		public function outHandler2(e) {
		continueButton.filters=[];
		}
		public function outHandler3(e) {
		configButton.filters=[];
		}
		*/
	}
}