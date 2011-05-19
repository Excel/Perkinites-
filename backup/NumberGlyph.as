package attacks{

	import actors.*;
	import enemies.*;

	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.*;
	import flash.ui.*;

	public class NumberGlyph extends MovieClip {

		static public var totalNumbers=[];

		public var damage;//if damage is negative, will attack player

		function NumberGlyph(n, d1, d2, min, xpos, ypos) {
			num.text=n;
			if (min) {
				damage=d1;
			} else {
				damage=d2;
			}


			this.x=xpos;
			this.y=ypos;
			addEventListener(Event.ENTER_FRAME, gameHandler);
			totalNumbers.push(this);


		}

		static public function create(numbers, index) {
			var damage1=15;
			var damage2=-1;
			var truth=[];
			var glyphs=[];
			for (var i = 0; i < 4; i++) {
				if (index==i) {
					truth[i]=true;
				} else {
					truth[i]=false;
				}
			}
			glyphs.push(new NumberGlyph(numbers[0],damage1,damage2,truth[0],96,128));
			glyphs.push(new NumberGlyph(numbers[1],damage1,damage2,truth[1],512,128));
			glyphs.push(new NumberGlyph(numbers[2],damage1,damage2,truth[2],96,384));
			glyphs.push(new NumberGlyph(numbers[3],damage1,damage2,truth[3],512,384));

			return glyphs;

		}

		public function gameHandler(e) {
			var list=Unit.list;
			if (this.hitTestObject(list[1])) {
				if (damage<0) {
					//Unit.health+=damage;

				} else {
					var list2=Enemy.list;
					list2[0].updateHP(damage);

				}
				kill();
				return;
			}

		}
		public function kill() {
			removeEventListener(Event.ENTER_FRAME, gameHandler);
			if (stage!=null) {
				stage.removeChild(this);
			}
			totalNumbers.splice(totalNumbers.indexOf(this),1);
			for (var i = 0; i < totalNumbers.length; i++) {
				totalNumbers[i].kill();
			}
			totalNumbers=[];
		}

	}
}