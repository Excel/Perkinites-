package util
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	/**
	* collection of static functions to make functional programming a bit easier.
	* @author srs
	*/
	public class FunctionUtils 
	{
		public function FunctionUtils() 
		{
			
		}
		
		/**
		 * creates an anonymous function which you can use to pass extra variables to an event handler function
		 * pretty much exactly the same as closurizeEventHandler, but also removes the event listener after one invocation.
		 * 
		 * @param	func Function - first argument should be an Event of some sort.  other args may follow.
		 * @param	args ... rest style Array - all non-event arguments to apply 
		 * @return
		 */
		public static function closurizeSelfRemovingEventHandler(func:Function, ... args):Function
		{
			var ags2:Array = args.concat();
			ags2.unshift(0); //move things to make room for event.
			return function(event:Event):void
			{
				event.currentTarget.removeEventListener(event.type, arguments.callee);
				ags2[0] = event;
				func.apply(null, ags2);
			}
		}
		
		/**
		 * creates an anonymous function which you can use to pass extra variables to an event handler function
		 * @param	func Function - first argument should be an Event of some sort.  other args may follow.
		 * @param	args ... rest style Array - all non-event arguments to apply 
		 * @return
		 */
		public static function closurizeEventHandler(func:Function, ... args):Function
		{
			var ags2:Array = args.concat();
			ags2.unshift(0); //move things to make room for event.
			return function(event:Event):void
			{
				ags2[0] = event;
				func.apply(null, ags2);
			}
		}
		
		/**
		 * creates an anonymous function which can capture current variable state to be evaluated later.
		 * arguments are still passed by reference, so don't expect objects to freeze state,
		 * but the arguments array is copied, so primitives should remain as they were when thunkify was called.
		 * 
		 * If you need to provide a 'this' argument for the thunked function, use thunkifyWithThisParam
		 * @param	func Function
		 * @param	args ... rest style any number of arguments
		 * @return
		 */
		public static function thunkify(func:Function, ... args):Function
		{
			return thunkifyWithThisParam(func, args, null);
		}
		
		/**
		 * Same idea as thunkify, but allows one to provide a value for 'this' in the context of the wrapped function.
		 * @param	func Function
		 * @param	args Array of arguments
		 * @param	thisObj Object to use as 'this' in wrapped function execution.
		 * @return
		 */
		public static function thunkifyWithThisParam(func:Function, args:Array, thisObj:Object):Function
		{
			var ags2:Array = args.concat();
			return function():*
			{
				return func.apply(thisObj, ags2);
			}
		}
		
		/**
		 * creates a version of a function which remembers inputs and avoids recomputing if it has seen the inputs before
		 * two cautions with this:
		 * 1) This relies on toString, so all inputs should implement a useful identifying toString method
		 * 2) This relies on toString, so any input which has an expensive toString method (perhaps recursive) should be used with 
		 * extreme caution
		 * @param	func Function to memoize
		 * @param	thisObj Object which will be used as 'this' for the function.
		 * @return
		 */

		 public static function _memoizeByString(func:Function, thisObj:Object = null):Function
		{
			var memos:Dictionary = new Dictionary(true); //use weak keys to prevent memory hogging
			return function(... args):*{
			    var tuple:String = makeTuple(args);
				if (memos[tuple] != null)
				{
					return memos[tuple];
				}else
				{
					var retval:* = func.apply(thisObj, args);
					memos[tuple] = retval;
					return retval;
				}
			}
		}
		
		//creates a string from list of arguments.  Simply concatenates their toStrings with a "`" delimiter, so this isn't perfect
		private static function makeTuple(ags:Array):String
		{
			return ags.join("`");
		}

		/**
		 * creates a version of a function which caches already seen object input.  Uses object identity directly, so if argument object properties change,
		 * cached values may be returned.  Be careful.
		 * @param	func Function
		 * @param	thisObj Object to use as 'this' in wrapped function execution
		 * @return
		 */
		private static function _memoize(func:Function, thisObj:Object = null):Function
		{
			var noArgsPathElement:ArgPathElement = new ArgPathElement();
			var memos:Dictionary = noArgsPathElement.dict; //uses weak keys to prevent memory hogging
			return function(... args):*{
				var ap:ArgPathElement = noArgsPathElement;
				var memoDic:Dictionary = memos;
				for (var i:int = 0; i < args.length; i++){
					ap = memoDic[args[i]];
					if (null == ap)
					{
						ap = new ArgPathElement();
						memoDic[args[i]] = ap;
					}
					memoDic = ap.dict;
				}
				if (ap.seen)
				{
					return ap.val;
				}else
				{
					var retval:* = func.apply(thisObj, args);
					ap.val = retval;
					ap.seen = true;
					return retval;
				}
			}
			
		}
		public static const memoize:Function = _memoize(_memoize);
		public static const memoizeByString:Function = _memoize(_memoizeByString);
	}
	
}