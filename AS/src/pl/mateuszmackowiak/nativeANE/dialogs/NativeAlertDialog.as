/** 
 * @author Mateusz Maćkowiak
 * @see http://mateuszmackowiak.wordpress.com/
 * @since 2011
 */
package pl.mateuszmackowiak.nativeANE.dialogs
{
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	
	import pl.mateuszmackowiak.nativeANE.dialogs.support.AbstractNativeDialog;
	import pl.mateuszmackowiak.nativeANE.events.NativeDialogEvent;

	/**
	 * Simple NativeAlert extension that allows you to
	 * Open device specific alerts and recieve information about
	 * what button the user pressed to close the alert.
	 * 
	 * @author Mateusz Maćkowiak
	 * @see http://mateuszmackowiak.wordpress.com/
	 * @since 2011
	 * 
	 */
	public class NativeAlertDialog extends AbstractNativeDialog
	{
		//---------------------------------------------------------------------
		//
		// Constants
		//
		//---------------------------------------------------------------------
		/**
		 * The id of the extension that has to be added in the descriptor file.
		 */
		public static const EXTENSION_ID : String = "pl.mateuszmackowiak.nativeANE.NativeDialogs";
		
		/**
		 * The current Version of the Extension.
		 */
		public static const VERSION:String = "0.9.5 Beta";
		/**
		 * Uses the device's default alert theme with a dark background.
		 * <br>Constant Value: 4 (0x00000004)
		 */
		public static const ANDROID_DEVICE_DEFAULT_DARK_THEME:int = 0x00000004;
		/**
		 *  Uses the device's default alert theme with a dark background.
		 * <br>Constant Value: 5 (0x00000005)
		 */
		public static const ANDROID_DEVICE_DEFAULT_LIGHT_THEME:int = 0x00000005;
		/**
		 * Uses the holographic alert theme with a dark background.
		 * <br>Constant Value: 2 (0x00000002)
		 */
		public static const ANDROID_HOLO_DARK_THEME:int = 0x00000002;
		/**
		 * Uses the holographic alert theme with a light background.
		 * <br>Constant Value: 3 (0x00000003)
		 */
		public static const ANDROID_HOLO_LIGHT_THEME:int = 0x00000003;
		/**
		 * Uses the traditional (pre-Holo) alert dialog theme.
		 * <br>Constant Value: 1 (0x00000001)
		 */
		public static const DEFAULT_THEME:int = 0x00000001;
		
		//---------------------------------------------------------------------
		//
		// Private Static Properties.
		//
		//---------------------------------------------------------------------
		/**
		 * @private
		 */
		private static var _defaultTheme:uint = DEFAULT_THEME;
		//---------------------------------------------------------------------
		//
		// private properties.
		//
		//---------------------------------------------------------------------
		/**@private*/
		private var _closeLabel:String = null;
		/**@private*/
		private var _buttons:Vector.<String> = null;
		/**@private*/
		private var _theme:int = -1;
		/**@private*/
		private var _closeHandler:Function=null;
		/**@private*/
		private var _disposeAfterClose:Boolean = false;

		
		//---------------------------------------------------------------------
		//
		// Public Methods.
		//
		//---------------------------------------------------------------------
		/** 
		 * @author Mateusz Maćkowiak
		 * 
		 * @param theme the selected theme for the NativeAlertDialog.
		 * 
		 * @since 2011
		 * 
		 * @see pl.mateuszmackowiak.nativeANE.events.NativeDialogEvent
		 * @see http://mateuszmackowiak.wordpress.com/
		 * 
		 * 
		 * @event pl.mateuszmackowiak.nativeANE.events.NativeDialogEvent.OPENED
		 * pl.mateuszmackowiak.nativeANE.events.NativeDialogEvent.CLOSEED
		 */
		public function NativeAlertDialog(theme:int=-1)
		{
			super(abstractKey);
			
			if(!isNaN(theme) && theme>-1)
				_theme = theme;
			else
				_theme = _defaultTheme;
			
			init();
		}
		
		
		
		/**@private*/
		override protected function init():void{
			try{
				_context = ExtensionContext.createExtensionContext(EXTENSION_ID, "NativeAlertContext");
				_context.addEventListener(StatusEvent.STATUS, onStatus);
			}catch(e:Error){
				showError("Error initiating contex of the NativeAlertDialog extension: "+e.message,e.errorID);
			}
		}
		
		/**
		 * OnClose default handler. There can be only one and will be removed after the closing of the dialog.
		 * <b><br/>Use <code>event.preventDefault()</code> to prevent removing it.</b>
		 * 
		 */
		public function set closeHandler(value:Function):void
		{
			
			if(_closeHandler!=null && hasEventListener(NativeDialogEvent.CLOSED))
				removeEventListener(NativeDialogEvent.CLOSED,_closeHandler);
			_disposeAfterClose = true;
			_closeHandler = value;
			if(value!=null)
				addEventListener(NativeDialogEvent.CLOSED,value);
		}
		/**
		 * @private
		 */
		public function get closeHandler():Function
		{
			return _closeHandler;
		}
		
		
		[Deprecated]
		/**
		 * List of buttons as a string with comma as separator.
		 */
		public function set otherLabels(value:String):void
		{
			if(value){
				_buttons = Vector.<String>(value.split(",")); 
			}else{
				_buttons = null;
			}
		}
		/**
		 * @private
		 */
		public function get otherLabels():String
		{
			if(_buttons){
				return _buttons.join(",");
			}
			return null;
		}

		
		/**
		 * List of buttons.
		 */
		public function set buttons(value:Vector.<String>):void
		{
			_buttons = value;
		}
		/**
		 * @private
		 */
		public function get buttons():Vector.<String>
		{
			return _buttons;
		}
		
		
		
		
		[Deprecated]
		/**
		 * Cancle button label for the alert.
		 * @default "OK"
		 */
		public function set closeLabel(value:String):void
		{
			_closeLabel = value;
		}
		/**
		 * @private
		 */
		public function get closeLabel():String
		{
			return _closeLabel;
		}
		
		
		
		
		
		/**
		 * The theme of the dialog.
		 * (if isShowing will be ignored until next show)
		 */
		public function set theme(value:int):void
		{
			if(!isNaN(value))
				_theme = value;
			else
				_theme = _defaultTheme;
		}
		/**
		 * @private
		 */
		public function get theme():int
		{
			return _theme;
		}
		
		/**
		 * The message of the dialog. Changes the message even if isShowing.
		 * @throws Error - if the call was unsuccessful. Or will dispatch an ErrorEvent.ERROR if there is a listener.
		 * @return if call sucessfull
		 */
		public function setMessage(value:String):Boolean
		{
			if(value==_message){
				return false;
			}
			if(_isShowing && (isIOS() || isAndroid())){
				try{
					_context.call("updateMessage",value);
					_message = value;
					return true;
				}catch(e:Error){
					showError("Error setting message "+e.message,e.errorID);
				}
				return false;
			}
			_message = value;
			return true;
		}
		/**@private*/
		public function set message(value:String):void
		{
			if(value==_message || _isShowing==true){
				return;
			}
			_message = value;
		}
		/**
		 * The message of the dialog
		 * @see setMessage()
		 */
		public function get message():String
		{
			return _message;
		}
		
		

		
		/**
		 * @param cancelable if pressing outside the dialog or the back button hides the dialog <b>Only on Android</b>
		 * 
		 * @see pl.mateuszmackowiak.nativeANE.dialogs.NativeAlertDialog.defaultTheme
		 * @see pl.mateuszmackowiak.nativeANE.dialogs.NativeAlertDialog.show
		 * 
		 * @throws Error - if the call was unsuccessful. Or will dispatch an Error Event.ERROR if there is a listener.
		 * 
		 * @event pl.mateuszmackowiak.nativeANE.dialogs.NativeDialogEvent.OPENED
		 * pl.mateuszmackowiak.nativeANE.dialogs.NativeDialogEvent.CLOSEED
		 * pl.mateuszmackowiak.nativeANE.dialogs.NativeDialogEvent.CANCELED
		 */
		public function show(cancelable:Boolean = true) : Boolean
		{
			try{
				if(_isShowing){
					trace("Already showing!");
					return false;
				}
				if(!_title)
					_title="";
				if(!_buttons || _buttons.length==0)
					_buttons = Vector.<String>(["OK"]);
				
				if(_closeLabel && _buttons.indexOf(_closeLabel)==-1){
					_buttons.unshift(_closeLabel);
				}
				if(!_message)
					_message="";
				
				
				_context.call("showAlertWithTitleAndMessage", _title, _message, _buttons, cancelable, _theme);
				
				return true;
			}catch(e:Error){
				showError("While show  "+e.message,e.errorID);
			}
			return false;
		}
		
		

		
		
		/**
		 * The default theme of all dialogs
		 * @default pl.mateuszmackowiak.nativeANE.dialogs.NativeAlertDialog#DEFAULT_THEME
		 */
		public static function set defaultTheme(value:int):void
		{
			_defaultTheme = value;
		}
		/**@private*/
		public static function get defaultTheme():int
		{
			return _defaultTheme;
		}
		
	
		[Deprecated(replacement="pl.mateuszmackowiak.nativeANE.dialogs.NativeAlertDialog#showAlert()")] 
		/**
		 * Creates and shows a NativeAlertDialog dialog. <b><br>Use event.prevetDefault() to prevent disposing.</b>
		 * @param text message showed in the Alert control.
		 * @param title title of the Alert control.
		 * @param closeLabel text of the default button
		 * @param otherLabels text of the other buttons. Sepperated with "," adds aditional buttons. In the close event answer look for the index of the button.
		 * @param closeHandler function called when dialog closes (NativeDialogEvent). <i>Called only once and if not </i><code>event.preventDefault()</code><i> will be removed.</i> 
		 * @param cancelable on back button or outside relese closes with index -1 (only Android)
		 * @param androidTheme default -1 uses the defaultAndroidTheme 
		 * 
		 * @throws Error if the call was unsuccessful.
		 * 
		 * @event pl.mateuszmackowiak.nativeANE.events.NativeDialogEvent
		 * 
		 * @see pl.mateuszmackowiak.nativeANE.dialogs.NativeAlertDialog.showAlert
		 */
		public static function show(message:String = "", title:String = "Error", closeLabel : String="OK", otherLabels : String = "" , closeHandler:Function = null ,cancelable:Boolean = true, theme:int = -1):NativeAlertDialog
		{
			var alert:NativeAlertDialog = new NativeAlertDialog(theme);
			if (closeHandler !== null){
				alert.closeHandler = closeHandler;
			}
			alert._disposeAfterClose = true;
			alert.title = title;
			alert.message = message;
			alert.closeLabel = closeLabel;
			alert.otherLabels = otherLabels;
			alert.show(cancelable);
			
			return alert;
		}
		
		
		/**
		 * Creates and shows a NativeAlertDialog dialog. <b><br>Use event.prevetDefault() to prevent disposing.</b>
		 * @param text message showed in the Alert control.
		 * @param buttons vector of labels for dialog buttons
		 * @param title title of the Alert control.
		 * @param otherLabels text of the other buttons. Sepperated with "," adds aditional buttons. In the close event answer look for the index of the button.
		 * @param closeHandler function called when dialog closes (NativeDialogEvent). <i>Called only once and if not </i><code>event.preventDefault()</code><i> will be removed.</i> 
		 * @param cancelable on back button or outside relese closes with index -1 (only Android)
		 * @param androidTheme default -1 uses the defaultAndroidTheme 
		 * 
		 * @throws Error if the call was unsuccessful.
		 * 
		 * @event pl.mateuszmackowiak.nativeANE.events.NativeDialogEvent
		 */
		public static function showAlert(message:String = "", title:String = "Error", buttons:Vector.<String> = null , closeHandler:Function = null ,cancelable:Boolean = true, theme:int = -1):NativeAlertDialog
		{
			var alert:NativeAlertDialog = new NativeAlertDialog(theme);
			if (closeHandler !== null){
				alert.closeHandler = closeHandler;
			}
			alert._disposeAfterClose = true;
			alert.title = title;
			alert.message = message;
			alert.buttons = buttons;
			alert.show(cancelable);
			
			return alert;
		}
		

		
		/**
		 * Whether the extension is available on the device (<code>true</code>);<br>otherwise <code>false</code>.
		 */
		public static function get isSupported():Boolean{
			if(isIOS()|| isAndroid())
				return true;
			else 
				return false;
		}
		
		//---------------------------------------------------------------------
		//
		// Private Methods.
		//
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function onStatus( event : StatusEvent ) : void
		{
			event.stopImmediatePropagation();
			if(event.code==NativeDialogEvent.OPENED){
				_isShowing = true;
				if(hasEventListener(NativeDialogEvent.OPENED))
					dispatchEvent(new NativeDialogEvent(NativeDialogEvent.OPENED,event.level));
				
			}
			else if( event.code == NativeDialogEvent.CLOSED || event.code =="ALERT_CLOSED")
			{
				_isShowing = false;
				
				var level:int = int(event.level);
				if(isWindows())
					level--;
				var wasPrevented:Boolean = true;
				if(hasEventListener(NativeDialogEvent.CLOSED)){
					wasPrevented = dispatchEvent(new NativeDialogEvent(NativeDialogEvent.CLOSED,String(level)));
					if(wasPrevented && _closeHandler!=null){
						removeEventListener(NativeDialogEvent.CLOSED,_closeHandler);
						_closeHandler = null;
					}
				}
				
				if(_disposeAfterClose && wasPrevented){
					dispose();
				}
				
			}else{
				showError(event);
			}
		}
		
		
	}
}