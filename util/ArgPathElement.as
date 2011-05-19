package util
{
	import flash.utils.Dictionary;
	
	/**
	* Used for memoization.  Do not use directly
	* @author srs
	*/

	public class ArgPathElement
	{
		public var seen:Boolean;
		public var dict:Dictionary;
		public var val:*;
		
		public function ArgPathElement()
		{
			dict = new Dictionary(true);
			seen = false;
		}
		
	}
}