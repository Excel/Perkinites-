package game{

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.xml.*;

	/**
	 * Holds BGM information and dispatches events to signal when loading is complete...once I make the events. :)
	 */
	public class BGMDatabase extends EventDispatcher {

		public var xmlLoader:URLLoader = new URLLoader();

		public const BGMURL:String="xml/BGM.xml";

		/**
		 * nameInfo - names of the BGMs
		 * offsetInfo - starting offsets of the BGMs
		 * loopInfo - looping offsets of the BGMs
		 * endInfo - when to end the loop for the BGMs
		 */
		public static var nameInfo = new Array();
		public static var offsetInfo = new Array();
		public static var loopInfo = new Array();
		public static var endInfo = new Array();

		/**
		 * Loads the information aboot the BGMs.
		 */

		public function BGMDatabase() {

		}

		public function loadData() {
			this.loadObject(BGMURL, handleLoadedBGMs);
		}

		/**
		 * Creates a request using the passed URL and calls the passed function on complete.
		 *
		 * @param url The URL to request.
		 * @param handleFunction The function to be called on complete.
		 */

		public function loadObject(url:String, handleFunction:Function):void {
			var request:URLRequest=new URLRequest(url);
			xmlLoader.addEventListener(Event.COMPLETE, handleFunction);
			xmlLoader.load(request);
		}

		/**
		 * Loads the tilesets.
		 */
		public function handleLoadedBGMs(e:Event):void {
			xmlLoader.removeEventListener(Event.COMPLETE, handleLoadedBGMs);
			var xmlData=new XML(e.target.data);
			parseData(xmlData);
		}
		public function parseData(input:XML):void {
			for each (var BGMElement:XML in input.BGM) {
				nameInfo.push(BGMElement.Name);
				offsetInfo.push(parseInt(BGMElement.Offset));
				loopInfo.push(parseInt(BGMElement.Loop));
				endInfo.push(parseInt(BGMElement.End));
			}
		}

		public static function getIndex(Name:String):int {
			for (var i = 0; i < nameInfo.length; i++) {
				if (nameInfo[i] == Name) {
					return i;
				}
			}
			return -1;
		}
		public static function getName(id:int):String {
			return nameInfo[id];
		}
		public static function getOffset(Name:String):int {
			var id = getIndex(Name);
			return offsetInfo[id];
		}
		public static function getLoop(Name:String):int {
			var id = getIndex(Name);
			return loopInfo[id];
		}
		public static function getEnd(Name:String):int {
			var id = getIndex(Name);
			return endInfo[id];
		}
	}

}