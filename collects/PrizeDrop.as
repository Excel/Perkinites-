
package collects{

	import abilities.*;
	import actors.*;
	import game.*;
	import items.*;
	import ui.*;

	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.ui.Keyboard;


	public class PrizeDrop extends GameUnit {

		public var exist;//how long this exists
		public var prize;//the item to give
		public var sound;//the sound to make
		public function PrizeDrop(e, p, s) {

			exist=24*e;
			prize=p;
			if (s!=null) {
				sound=s;
			}
			addEventListener(Event.ENTER_FRAME, gameHandler);
		}

		public function endHandler(e) {
			rotation+=20;
			if (! collide()) {
				scaleX-=0.05;
				scaleY-=0.05;
				if (scaleX<=0.10&&scaleY<=0.10) {
					this.removeEventListener(Event.ENTER_FRAME, gameHandler);
					this.removeEventListener(Event.ENTER_FRAME, endHandler);
					if (this.parent!=null) {
						this.parent.removeChild(this);
					}
				}
			}
		}
		override public function gameHandler(e) {
			rotation+=20;
			collide();
			exist--;
			if (exist==0) {
				removeEventListener(Event.ENTER_FRAME, gameHandler);
				addEventListener(Event.ENTER_FRAME, endHandler);
			}
		}
		public function collide() {
			if (this.parent != null &&
			(this.hitTestObject(Unit.currentUnit)||this.hitTestObject(Unit.partnerUnit))) {
				if (sound!=null) {
					sound.play();
				}
				var getDisplay;
				var addUses;
				if (prize is Item) {
					var i=ItemDatabase.getDatabaseIndex(prize.Name);
					getDisplay=new GetDisplay(i,prize.amount, "Item");

					addUses=Unit.itemAmounts[i]+prize.amount;
					if (addUses<ItemDatabase.getMaxUses(i)) {
						Unit.itemAmounts[i]=addUses;
					} else {
						Unit.itemAmounts[i]=ItemDatabase.getMaxUses(i);
					}

				} else if (prize is Ability) {
					var a=AbilityDatabase.getName(prize.id);
					getDisplay=new GetDisplay(prize.id,prize.amount, "Ability");
					addUses=Unit.abilityAmounts[prize.id]+prize.amount;
					if (addUses<9) {
						Unit.abilityAmounts[prize.id]=addUses;
					} else {
						Unit.abilityAmounts[prize.id]=9;
					}
				}
				stage.addChild(getDisplay);
				this.removeEventListener(Event.ENTER_FRAME, gameHandler);
				this.removeEventListener(Event.ENTER_FRAME, endHandler);
				this.parent.removeChild(this);
				return true;
			}
			return false;
		}
	}
}