
package collects{

	import actors.*;
	import game.*;
	import ui.*;

	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.ui.Keyboard;


	public class ItemDrop extends Action {

		public var exist;//how long this exists
		public var item;//the item to give
		public var sound;//the sound to make
		public function ItemDrop(e, i, s) {

			exist=24*e;
			item=i;
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
				for (var i = 0; i < Unit.Items.length; i++) {
					if (Unit.Items[i].Name==item.Name) {
						if (Unit.Items[i].uses+item.uses<Unit.Items[i].maxUses) {
							Unit.Items[i].uses+=item.uses;
						} else {
							Unit.Items[i].uses=Unit.Items[i].maxUses;
						}
						break;
					}
				}
				if (i==Unit.Items.length) {
					Unit.Items.push(item);

				}
				this.removeEventListener(Event.ENTER_FRAME, gameHandler);
				this.removeEventListener(Event.ENTER_FRAME, endHandler);
				this.parent.removeChild(this);
				return true;
			}
			return false;
		}
	}
}