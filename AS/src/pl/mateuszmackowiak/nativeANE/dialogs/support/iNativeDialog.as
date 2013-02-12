package pl.mateuszmackowiak.nativeANE.dialogs.support
{
	import flash.events.IEventDispatcher;

	public interface iNativeDialog extends IEventDispatcher
	{
		
		/**
		 * Determinants of the dialog is currently showing.
		 * 
		 * @throws Error if the call was unsuccessful. Or will dispatch an Error Event.ERROR if there is a listener.
		 */
		function isShowing():Boolean;
		
		/**
		 * The title of the dialog. Changes the title even if isShowing.
		 * @return if call sucessfull
		 */
		function setTitle(value:String):Boolean;
		/**
		 * The title of the dialog.
		 */
		function set title(value:String):void;
		/**
		 * The title of the dialog.
		 */
		function get title():String;
		/**
		 * Determinates if the extension was disposed.
		 */
		function get disposed():Boolean
		/**
		 * Hides the dialog if is showing.
		 * 
		 * @param buttonIndex the index of the button that will be passed to the close event.
		 * 
		 * @throws Error if the call was unsuccessful. Or will dispatch an Error Event.ERROR if there is a listener.
		 * 
		 * @return if call sucessfull
		 */
		function hide(buttonIndex:int = 0):Boolean;
		/**
		 * Disposes of this ExtensionContext instance.<br><br>
		 * The runtime notifies the native implementation, which can release any associated native resources. After calling <code>dispose()</code>,
		 * the code cannot call the <code>call()</code> method and cannot get or set the <code>actionScriptData</code> property.
		 * 
		 * @throws Error if the call was unsuccessful. Or will dispatch an Error Event.ERROR if there is a listener.
		 */
		function dispose():void;
		
		/**
		 * Shakes the dialog.
		 * 
		 * @throws Error if the call was unsuccessful. Or will dispatch an Error Event.ERROR if there is a listener.
		 */
		function shake():void;
	}
}