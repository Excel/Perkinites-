package maps{

	import flash.display.Stage;
	import flash.events.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.ui.*;
	import flash.xml.*;

	public class MapDatabase {

		public static var xmlData:XML = new XML(); //for general maps
		public static var xmlEData:XML = new XML();	//for the Map Events in maps
		
		public static var mapInfo = new Array();
		public static var mapEvents = new Array([1, 1, 1, 1, 1], [2, 2, 2, 2], [3, 3, 3, 3, 3, 3, 3, 3]);

		public static function loadData() {
			var xmlLoader:URLLoader = new URLLoader();

			xmlLoader.addEventListener(Event.COMPLETE, LoadXML);
			xmlLoader.load(new URLRequest("xml/Maps.xml"));
		}

		public static function LoadXML(e:Event):void {
			xmlData=new XML(e.target.data);
			parseData(xmlData);
		}
		public static function LoadXML2(e:Event):void {
			xmlEData=new XML(e.target.data);
			parseMapEvents(xmlEData);
		}


		public static function parseData(input:XML):void {
			var xmlLoader2:URLLoader = new URLLoader();
			
			xmlLoader2.addEventListener(Event.COMPLETE, LoadXML);
			
			
			for each(var mapElement:XML in input.Map){
				var map = new Map(mapElement.ID, mapElement.MapCode, mapElement.MapName, 
								  mapElement.TilesetID, mapElement.BGM, mapElement.BGS);
				mapInfo.push(map);
				xmlLoader2.load(new URLRequest("xml/Maps/Map"+mapElement.ID+".xml"));
			}
			
		}

		public static function parseMapEvents(input:XML):void{
			
		}
		
		public static function getMap(id:int):Map {
			return mapInfo[id];
		}
		
	}
}