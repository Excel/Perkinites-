package levels{
	import actors.*;
	import attacks.*;
	import collects.*;
	import enemies.*;
	import game.*;
	import items.*;
	import util.*;

	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.*;
	import flash.net.SharedObject;
	import flash.ui.*;
	import flash.ui.Keyboard;


	import flash.utils.Timer;
	import flash.events.TimerEvent;

	public class Level1B extends SuperLevel {

		function Level1B() {
			mapClip = new MovieClip();
			setLevel=1;
			//Dialogue goes here
			names=[];
			messages=[];

			/*
			names.push("CY");
			messages.push("But...I'm already friends with my roommate.");
			names.push("KG");
			messages.push("Okay, so I know you guys are best friends with each other, but like, from now on, your friendship is determined by that empty bar on the left.");
			names.push("CY");
			messages.push("Aww... >:");
			names.push("KG");
			messages.push("So here's how this whole shindig works.");
			names.push("KG");
			messages.push("You can increase your friendship power by attacking enemies and grabbing Happy Orbs. Once your friendship power is at 100.00%, you can perform a Friendship Finale.");
			names.push("KG");
			messages.push("So a Friendship Finale is like, a really super powerful move that you can use by holding down 'Z' and 'C', and then a cutscene appears and you do like, craploads of damage.");
			names.push("KG");
			messages.push("Does that make sense...or should I repeat it?");
			
			names.push("KG");
			messages.push("Okay, awesome. That's all I needed to really say. You guys good?");
			names.push("KG");
			messages.push("Awesome! So...be safe, and don't get into too much trouble.");
			*/

			myMap=[
			   [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
			   [1,1,1,1,1,1,1,1,1,0,0,0,1,1,1,1,1,1,1,1,1],
			   [1,1,1,1,1,1,1,1,1,0,0,0,1,1,1,1,1,1,1,1,1],
			   [1,1,1,1,1,1,1,1,1,0,0,0,1,1,1,1,1,1,1,1,1],
			   [1,1,1,1,1,1,1,1,1,0,0,0,1,1,1,1,1,1,1,1,1],
			   [1,1,1,1,1,1,1,1,1,0,0,0,1,1,1,1,1,1,1,1,1],
			   [1,1,1,1,1,1,1,1,1,0,0,0,1,1,1,1,1,1,1,1,1],
			   [1,1,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,1,1,1,1],
			   [1,1,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,1,1,1,1],
			   [1,1,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,1,1,1,1],
			   [1,1,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,1,1,1,1],
			   [1,1,1,1,1,1,1,1,1,0,0,0,1,1,1,1,1,1,1,1,1],
			   [1,1,1,1,1,1,1,1,1,0,0,0,1,1,1,1,1,1,1,1,1],
			   [1,1,1,1,1,1,1,1,1,0,0,0,1,1,1,1,1,1,1,1,1],
			   [1,1,1,1,1,1,1,1,1,0,0,0,1,1,1,1,1,1,1,1,1],
			   [1,1,1,1,1,1,1,1,1,0,0,0,1,1,1,1,1,1,1,1,1],
			   [1,1,1,1,1,1,1,1,1,0,0,0,1,1,1,1,1,1,1,1,1],
			   [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]];
			this.tileMap=buildMap();




		}

		override public function buildEvents() {
			//set up Hero
			var u=Unit.currentUnit;
			Unit.level=this;
			Unit.tileMap=this.tileMap;
			u.x=340;
			u.y=200;
			mapClip.addChild(u);
			u.begin();


			var u2=Unit.partnerUnit;
			u2.x=300;
			u2.y=200;
			mapClip.addChild(u2);
			u2.begin();

			//set up Enemies
			var c=new DrunkGuy();
			c.x=340;
			c.y=150;
			c.level=this;
			GameUnit.tileMap=this.tileMap;
			mapClip.addChild(c);
			c.begin();



			/*addEventListener(Event.ENTER_FRAME,talkingHandler);
			stage.addEventListener(KeyboardEvent.KEY_DOWN,talkingConfirmHandler);
			*/
			/*var cutscene = new GameUnit();
			cutscene.names.push("Unknown Invader");
			cutscene.messages.push("Who DARES trespass on MY territory?");
			cutscene.names.push("Unknown Invader");
			cutscene.messages.push("Filthy scum will be shot down on sight. You hear me!? ON SIGHT.");
			
			cutscene.names.push("CM");
			cutscene.messages.push("Daaaang, this girl is ANGRY.");
			cutscene.names.push("CK");
			cutscene.messages.push("Okay, H said that she was on the second floor. Let's move, people!");
			
			cutscene.moveArray.push(cutscene.displayMessage);
			cutscene.moveArray.push(cutscene.displayMessage);
			cutscene.moveArray.push(cutscene.displayMessage);
			cutscene.moveArray.push(cutscene.displayMessage);
			cutscene.moveArray.push(FunctionUtils.thunkify(cutscene.forceAction, c, c.turnLeft));
			cutscene.moveArray.push(cutscene.eraseAction);
			
			//mapClip.addChild(cutscene);
			*/
			var itemdrop=new ItemDrop(0,new Item(0,5),null);
			itemdrop.x=300;
			itemdrop.y=300;
			mapClip.addChild(itemdrop);

			var itemdrop2=new ItemDrop(0,new Item(1,10),null);
			itemdrop2.x=300;
			itemdrop2.y=400;
			mapClip.addChild(itemdrop2);

			var itemdrop3=new ItemDrop(0,new Item(2,5),null);
			itemdrop3.x=300;
			itemdrop3.y=500;
			mapClip.addChild(itemdrop3);

			var itemdrop4=new ItemDrop(0,new Item(4,5),null);
			itemdrop4.x=300;
			itemdrop4.y=501;
			mapClip.addChild(itemdrop4);

			stage.addEventListener(KeyboardEvent.KEY_DOWN, VCamHandler);
			makeHappiness();

			/*var retry = SharedObject.getLocal("Retry Level");
			retry.data.currentUnit = Unit.currentUnit;
			retry.data.partnerUnit = Unit.partnerUnit;
			retry.flush();
			*/
			//stage.addEventListener(Event.ENTER_FRAME, gameHandler);
			//numberOnTimer.start();
		}



	}
}