package pl.mateuszmackowiak.nativeANE.events
{
	import flash.events.Event;
	
	public class NativeDialogEvent extends Event
	{
		/**
		 * Defines the value of the type property of a NativeDialogEvent object. When a dialog has been canceled.
		 */
		public static const CANCELED:String = "nativeDialog_canceled";
		/**
		 * Defines the value of the type property of a NativeDialogEvent object.When a dialog has been closed.
		 */
		public static const CLOSED:String = "nativeDialog_closed";
		/**
		 * Defines the value of the type property of a NativeDialogEvent object. When a dialog is displayed.
		 */
		public static const OPENED:String = "nativeDialog_opened";
		
		/**
		 * Defines the value of the type property of a NativeDialogEvent object. When a user presses outside the dialog.
		 */
		//public static const PRESSED_OUTSIDE:String = "nativeDialog_pressedOutside";
		
		/**
		 * Defines the value of the type property of a NativeDialogEvent object. When a user presses the button of the dialog.
		 */
		//public static const PRESSED_BUTTON:String = "nativeDialog_pressedButton";
		/**
		 * @private
		 */
		private var _index:String;
		
		/**
		 * Dispatched when native window changes its state.
		 */
		public function NativeDialogEvent(type:String,index:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			_index = index;
			super(type, bubbles, cancelable);
		}
		
		
		/**
		 * The index of the clicked button.
		 */
		public function get index() : String
		{
			return _index;
		}
		
		
		/**
		 * @copy flash.events.Event#toString()
		 */
		override public function toString():String
		{
			return "[NativeDialogEvent type='"+type+"'  index='"+String(_index)
				+"' bubbles='"+String(bubbles)+"' cancelable='"+String(cancelable)
				+"' ]";
		}
		/**
		 * @copy flash.events.Event#clone()
		 */
		override public function clone() : Event
		{
			return new NativeDialogEvent(type,_index,bubbles,cancelable);
		}
	}
}