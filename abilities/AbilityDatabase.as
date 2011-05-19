package game{
	import ui.*;
	import ui.screens.*;

	import flash.display.MovieClip;
	import flash.events.*;
	import flash.ui.*;
	import flash.display.Stage;

	public class AbilityDatabase

		static public function useCheatCode(cheatCode) {
			switch (cheatCode) {
					//Ananya
				case "114114251" :
					StageSelect.Ananya=! StageSelect.Ananya;
					var display="Ananya Difficulty Off";
					if (StageSelect.Ananya) {
						display="Ananya Difficulty On";
					}
					return display;
					break;
					//Huong
				case "82115147" :
					return "H Mode 1 - Normal";
					break;
					//Sausage
				case "1912119175" :
					return "H Mode 2 - Sausage";
					break;
					//Bean
				case "25114" :
					return "H Mode 3 - Bean";
					break;
				default :
					return null;
					break;
			}
		}
	}
}