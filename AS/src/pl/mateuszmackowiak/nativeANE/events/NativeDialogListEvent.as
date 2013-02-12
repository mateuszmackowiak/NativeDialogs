package pl.mateuszmackowiak.nativeANE.events
{
	import flash.events.Event;
	
	public class NativeDialogListEvent extends Event
	{
		/**
		* Defines the value of the type property of a NativeDialogListEvent object.
		*/
		public static const LIST_CHANGE:String = "nativeListDialog_change";
		/**
		 * @private
		 */
		private var _index:int = -1;
		/**
		 * @private
		 */
		private var _selected:Boolean = false;
		
		
		/**
		 * Dispatched if the native windows list has changed.
		 */
		public function NativeDialogListEvent(type:String, index:int , selected:Boolean, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			_index = index;
			_selected  = selected;
			super(type, bubbles, cancelable);
		}
		
		
		/**
		 * The index of element that has changed.
		 */
		public function get index() : int
		{
			return _index;
		}
		/**
		 * Defines the new state of the element.
		 */
		public function get selected() : Boolean
		{
			return _selected;
		}

		/**
		 * @copy flash.events.Event#toString()
		 */
		override public function toString():String
		{
			return "[NativeDialogListEvent type='"+type+"'  index='"+String(_index)
				+"' selected='"+String(_selected)+"'  bubbles='"+String(bubbles)
				+"' cancelable='"+String(cancelable)+"' ]";
		}
		/**
		 * @copy flash.events.Event#clone()
		 */
		override public function clone() : Event
		{
			return new NativeDialogListEvent(type,_index,_selected,bubbles,cancelable);
		}
	}
}