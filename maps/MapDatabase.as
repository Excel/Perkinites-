﻿package maps{
	public class MapDatabase {
		public static function getMapData(map:int) {
			var mapCode;
			var mapName;
			switch (map) {
				case 0 :
					mapCode="";
					mapName="";
					break;
				//PERKINS HALL				
				
				case 1 ://Clarissa's Room
					mapCode="15:20:333333333333333333333333333333333333333333444444444444444433334444444444444444333300000000000000003333000000000000000033330000333003330000333300003330033300003333000033300333000033330000333003330000333300003330033300003333000000000000000033330000000000000000333333333333333333333333333333333333333333000000000000000(9,12)";
					mapName="Clarissa's Room";
					break;
				case 2 ://Perkins Hall 2F
					mapCode="31:71:333333333333333333333333333333333333333333333333333333333333333333333333444434444344443444434444333333333333333333333444434444344443444434444334444344443444434444344443333333333333333333334444344443444434444344443300003000030000300003000033333333333333333333300003000030000300003000033000030000300003000030000333333333333333333333000030000300003000030000330000300003000030000300003333333333333333333330000300003000030000300003333333333333333333333333334444344443444434444333333333333333333333333333444444444444444444444444344443444434444344443444444444444444444444444335555555555555555555555553000030000300003000035555555555555555555555553300000000000000000000000030000300003000030000300000000000000000000000033000000000000000000000000300003000030000300003000000000000000000000000333333333333333303333030003333333333333333333330003033330333333333333333344443333333333333333300044444444444444444444400033333333333333333444433444433333333333333333000555555555555555555555000333333333333333334444330000333333333333333330000000000000000000000000003333333333333333300003300003333333333333333300000000000000000000000000033333333333333333000033000033333333333333333000303333333330000333303000333333333333333330000333333333333333333333330003444433333300003444430003333333333333333333333344444444444444444444400034444333333333334444300044444444444444444444433555555555555555555555000300003333333333300003000555555555555555555555330000000000000000000000003000033333333333000030000000000000000000000003300000000000000000000000030000333333333330000300000000000000000000000033333030333303333033330333333333333333333333333333033330333303333030333334444344443444434444344443333333333333333333334444344443444434444344443344443444434444344443444433333333333333333333344443444434444344443444433000030000300003000030000333333333333333333333000030000300003000030000330000300003000030000300003333333333333333333330000300003000030000300003300003000030000300003000033333333333333333333300003000030000300003000033333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333330000000000000000000000000000000(66,20)";
					mapName="Perkins Hall 2F"
					break;
					
					
				default :
					mapCode="";
					mapName="";
					break;
			}
			return new Array(mapCode, mapName);
		}
	}
}