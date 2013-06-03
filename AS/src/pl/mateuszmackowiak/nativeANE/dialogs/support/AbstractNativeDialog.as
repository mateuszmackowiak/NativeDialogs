package pl.mateuszmackowiak.nativeANE.dialogs.support
{
	import flash.events.ErrorEvent;
	import flash.events.EventDispatcher;
	import flash.external.ExtensionContext;
	import flash.system.Capabilities;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import pl.mateuszmackowiak.nativeANE.nativeDialogNamespace;
	
	use namespace nativeDialogNamespace;
	/**
	 * Abstract Class. <b>It must not be directly instantiated.</b>
	 * <br>Contains the basic logic of the NativeDilogs.
	 */
	public class AbstractNativeDialog extends EventDispatcher implements iNativeDialog
	{
		private static const SUPER_CACHE:Dictionary = new Dictionary();

		//---------------------------------------------------------------------
		//
		// Private Properties.
		//
		//---------------------------------------------------------------------
		/**@private*/
		protected var _context:ExtensionContext;
		/**@private*/
		protected var _title:String="";
		/**@private*/
		protected var _message:String = "";
		/**@private*/
		protected var _isShowing:Boolean=false;
		/**@private*/
		protected var _wasDisposed:Boolean = false;
		/**@private*/
		protected static var abstractKey:Number = Math.random();
		
		/**
		 * @private
		 */
		public function AbstractNativeDialog(k:Number)
		{
			if(k!=abstractKey){
				throw new Error("[AbstractNativeDialog] is an abstract class. It must not be directly instantiated.");
			}
			SUPER_CACHE[this] = true;
			
		}
		
		/**@private*/
		nativeDialogNamespace function get context():ExtensionContext
		{
			return _context;
		}
		
		/**@private*/
		protected function init():void
		{
			
		}
		
		/**
		 * Shakes the dialog.
		 * 
		 * @throws Error if the call was unsuccessful. Or will dispatch an Error Event.ERROR if there is a listener.
		 */
		public function shake():void
		{
			try
			{
				if(isIOS() || isAndroid())
					_context.call("shake");
			} 
			catch(error:Error) 
			{
				showError("'shake' "+error.message,error.errorID);
			}
		}
		
		/**
		 * Determinants of the dialog is currently showing.
		 * 
		 * @throws Error if the call was unsuccessful. Or will dispatch an Error Event.ERROR if there is a listener.
		 */
		public function isShowing():Boolean{
			if(_context){
				try{
					if(isIOS() || isAndroid()){
						const b2:Boolean = _context.call("isShowing");
						_isShowing = b2;
						return b2;
					}
				}catch(error:Error){
					showError("'isShowing' "+error);
				}
			}
			return false;
			
		}
		
		
		
		
		
		
		
		
		
		/**
		 * The title of the dialog. Changes the title even if isShowing.
		 * @return if call sucessfull
		 */
		public function setTitle(value:String):Boolean
		{
			if(value==_title){
				return false;
			}
			
			try{
				if(_isShowing && (isAndroid() || isIOS())){
					_context.call("updateTitle",value);
					_title = value;
					return true;
				}else{
					_title = value;
					return true;
				}
				return false;
			}catch(e:Error){
				showError("'setTitle' "+e.message,e.errorID);
			}
			return false;
		}
		
		
		/**
		 * The title of the dialog.
		 */
		public function set title(value:String):void
		{
			if(value==_title || _isShowing==true){
				return;
			}
			_title = value;
		}
		/**
		 * The title of the dialog.
		 */
		public function get title():String
		{
			return _title;
		}
		
		
		
		
		
		
		
		/**
		 * Determinates if the extension was disposed.
		 */
		public function get disposed():Boolean
		{
			return _wasDisposed;
		}
		
		
		/**
		 * Hides the dialog if is showing.
		 * 
		 * @param buttonIndex the index of the button that will be passed to the close event.
		 * 
		 * @throws Error if the call was unsuccessful. Or will dispatch an Error Event.ERROR if there is a listener.
		 * 
		 * @return if call sucessfull
		 */
		public function hide(buttonIndex:int = 0):Boolean
		{
			try{
				if(_context){
					if(isNaN(buttonIndex) || buttonIndex<0){
						buttonIndex = 0;
					}
					if(isIOS() || isAndroid()){
						
						_context.call("dismiss", buttonIndex);
						return true;
					}
				}
				return false;
			}catch(e:Error){
				showError("'hide' "+e.message,e.errorID);
			}
			return false;
		}
		
		
		
		
		/**
		 * Disposes of this ExtensionContext instance.<br><br>
		 * The runtime notifies the native implementation, which can release any associated native resources. After calling <code>dispose()</code>,
		 * the code cannot call the <code>call()</code> method and cannot get or set the <code>actionScriptData</code> property.
		 * 
		 * @throws Error if the call was unsuccessful. Or will dispatch an Error Event.ERROR if there is a listener.
		 */
		public function dispose():void
		{
			_isShowing = false;
			try{
				delete SUPER_CACHE[this];
				if(_context){
					trace("Disposing on dispose()");
					_context.dispose();
					_wasDisposed = true;
					_context = null;
				}else{
					trace(className+" was already disposed.");
				}
			}catch(e:Error){
				showError("'dispose' "+e.message,e.errorID);
			}
		}

		public static function isIOS():Boolean
		{
			return Capabilities.os.toLowerCase().indexOf("ip")>-1;
		}
		public static function isAndroid():Boolean
		{
			return Capabilities.os.toLowerCase().indexOf("linux")>-1;
		}
		public static function isWindows():Boolean
		{
			return Capabilities.os.toLowerCase().indexOf("win")>-1;
		}

		/**
		 * Returns the class name of an object.
		 */
		public final function get className():String
		{
			return getQualifiedClassName(this).split("::").join(".");
		}
		
		
		
		/**
		 * @private
		 */
		protected function showError(message:*,id:int=0):void
		{
			var m:String = "["+className+"] "+String(message);
			if(hasEventListener(ErrorEvent.ERROR))
				dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,m,id));
			else{
				throw new Error(m,id);
				//trace(m);
			}
		}
	}
}