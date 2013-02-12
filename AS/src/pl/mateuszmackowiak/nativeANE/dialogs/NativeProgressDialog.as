/** 
 * @author Mateusz Maćkowiak
 * @see http://mateuszmackowiak.wordpress.com/
 * @since 2011
 */
package pl.mateuszmackowiak.nativeANE.dialogs
{
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	
	import pl.mateuszmackowiak.nativeANE.events.NativeDialogEvent;
	import pl.mateuszmackowiak.nativeANE.dialogs.support.AbstractNativeDialog;

	/** 
	 * @author Mateusz Maćkowiak
	 * 
	 * <img src="https://github.com/mateuszmackowiak/NativeAlert/raw/master/images/NativeProgressAndoridHorizontalDefaultTheme.png"></img>
	 * <img src="https://github.com/mateuszmackowiak/NativeAlert/raw/master/images/NativeProgressAndoridHorizontalHaloDarkTheme.png"></img>
	 * <img src="https://github.com/mateuszmackowiak/NativeAlert/raw/master/images/NativeProgressAndoridHorizontalIndeterminateDefaultTheme.png"></img>
	 * <img src="https://github.com/mateuszmackowiak/NativeAlert/raw/master/images/NativeProgressAndoridHorizontalIndeterminateHaloDarkTheme.png"></img>
	 * <img src="https://github.com/mateuszmackowiak/NativeAlert/raw/master/images/NativeProgressAndoridSpinnerDefaultTheme.png"></img>
	 * <img src="https://github.com/mateuszmackowiak/NativeAlert/raw/master/images/NativeProgressAndoridSpinnerHaloLightTheme.png"></img>
	 * <img src="https://github.com/mateuszmackowiak/NativeAlert/raw/master/images/NativeProgressIOSHorizontal.png"></img>
	 * <img src="https://github.com/mateuszmackowiak/NativeAlert/raw/master/images/NativeProgressIOSSpinner.png"></img>
	 * <img src="https://github.com/mateuszmackowiak/NativeAlert/raw/master/images/NativeProgressIOS_SVHUD_Theme.png"></img>
	 * 
	 * @see http://mateuszmackowiak.wordpress.com/
	 */
	public class NativeProgressDialog extends AbstractNativeDialog
	{
		//---------------------------------------------------------------------
		//
		// Public Static Constants
		//
		//---------------------------------------------------------------------
		public static const STYLE_HORIZONTAL:uint = 1;
		public static const STYLE_SPINNER:uint = 0;
		
		
		public static const ANDROID_DEVICE_DEFAULT_DARK_THEME:uint = 4;
		public static const ANDROID_DEVICE_DEFAULT_LIGHT_THEME:uint = 5;
		public static const ANDROID_HOLO_DARK_THEME:uint = 2;
		public static const ANDROID_HOLO_LIGHT_THEME:uint = 3;
		/**
		 * uses : SVProgressHUD
		 * @see http://github.com/samvermette/SVProgressHUD
		 */
		public static const IOS_SVHUD_BLACK_BACKGROUND_THEME:uint = 2;
		/**
		 * uses : SVProgressHUD
		 * @see http://github.com/samvermette/SVProgressHUD
		 */
		public static const IOS_SVHUD_NON_BACKGROUND_THEME:uint = 3;
		/**
		 * uses : SVProgressHUD
		 * @see http://github.com/samvermette/SVProgressHUD
		 */
		public static const IOS_SVHUD_GRADIENT_BACKGROUND_THEME:uint = 4;
		
		/**
		 * the default style for bouth IOS and Android devices 
		 */
		public static const DEFAULT_THEME:uint = 1;
		
		
		
		//---------------------------------------------------------------------
		//
		// Private Static Variables
		//
		//---------------------------------------------------------------------
		/**@private*/
		private static var _defaultAndroidTheme:uint = DEFAULT_THEME;
		/**@private*/
		private static var _defaultIOSTheme:uint = DEFAULT_THEME;
		
		//---------------------------------------------------------------------
		//
		// Private Properties.
		//
		//---------------------------------------------------------------------
		/**@private*/
		private var _progress:int=0;
		/**@private*/
		private var _secondary:int=NaN;
		/**@private*/
		private var _style:uint = STYLE_SPINNER;
		/**@private*/
		private var _androidTheme:int = NaN;
		/**@private*/
		private var _iosTheme:int = NaN;
		/**@private*/
		private var _maxProgress:int  = 100;
		/**@private*/
		private var _indeterminate:Boolean = false;

		//---------------------------------------------------------------------
		//
		// Public Methods.
		//
		//---------------------------------------------------------------------
		/** 
		 * @author Mateusz Maćkowiak
		 * @since 2011
		 * 
		 * @param android theme for progoress dialog. If NaN uses <code>defaultAndroidTheme</code>
		 * @param theme for progoress dialog. If NaN uses <code>defaultIOSTheme</code>
		 * 
		 * @throws Error if not supported or native files not packaged
		 * 
		 * @playerversion 3.0
		 */
		public function NativeProgressDialog(androidTheme:int=-1,IOSTheme:int=-1)
		{
			super(abstractKey);
			if(!isNaN(androidTheme) && androidTheme>-1)
				_androidTheme = androidTheme;
			else
				_androidTheme = _defaultAndroidTheme;
			
			if(!isNaN(IOSTheme) && IOSTheme>-1)
				_iosTheme = IOSTheme;
			else
				_iosTheme = _defaultIOSTheme;
			
			init();
		}
		
		/**@private*/
		override protected function init():void
		{
			try{
				_context = ExtensionContext.createExtensionContext(NativeAlertDialog.EXTENSION_ID, "ProgressContext");
				_context.addEventListener(StatusEvent.STATUS, onStatus);
			}catch(e:Error){
				throw new Error("Error initiating contex of the extension: "+e.message,e.errorID);
			}
		}
		/**
		 * Shows the dialog.
		 * 
		 * @param cancleble if pressing outside the popup or the back button hides the popup <b>(Only on Android)</b>
		 * @param indeterminate if the progressbar should indicate indeterminate values (on IOS shows with <code>STYLE_SPINNER</code>)
		 * 
		 * @return if call sucessfull
		 * 
		 * @throws Error if the call was unsuccessful. Or will dispatch an Error Event.ERROR if there is a listener.
		 */
		public function show(cancleble:Boolean=false,indeterminate:Object=null):Boolean
		{
			if(indeterminate!==null)
				_indeterminate = indeterminate;
			
			try{
				if(isAndroid()){
					_context.call("showProgressPopup",_progress,_secondary,_style,_title,_message,_maxProgress,cancleble,_indeterminate,_androidTheme);
					_isShowing = true;
					return true;
				}
				else if(isIOS()){
					_context.call("showProgressPopup",_progress/_maxProgress,null,_style,_title,_message,cancleble,_indeterminate,_iosTheme);
					_isShowing = true;
					return true;
				}
				return false;
			}catch(e:Error){
				showError("Error calling show method "+e.message,e.errorID);
			}
			return false;
		}
		
		
		/**
		 * Shows the dialog with a Horizontal style progress bar.
		 * 
		 * @param cancleble if pressing outside the popup or the back button hides the popup <b>(Only on Andorid)</b>
		 *  
		 * @throws Error if the call was unsuccessful. Or will dispatch an Error Event.ERROR if there is a listener.
		 * 
		 * @return if call sucessfull
		 */
		public function showProgressbar(cancleble:Boolean=false):Boolean
		{
			_style = STYLE_HORIZONTAL;
			try{
				if(isAndroid()){
					_context.call("showProgressPopup",_progress,_secondary,_style,_title,_message,_maxProgress,cancleble,false,_androidTheme);
					_isShowing = true;
					return true;
				}
				else if(isIOS()){
					_context.call("showProgressPopup",_progress,null,_style,_title,_message,cancleble,false,_iosTheme);
					_isShowing = true;
					return true;
				}
				return false;
			}catch(e:Error){
				showError("Error calling show method "+e.message,e.errorID);
			}
			return false;
		}
		
		
		
		/**
		 * Shows the dialog with a spinner style progress indicator.
		 * 
		 * @param cancleble if pressing outside the popup or the back button hides the popup <b>(Only on Andorid)</b>
		 * 
		 * @throws Error if the call was unsuccessful. Or will dispatch an Error Event.ERROR if there is a listener.
		 * 
		 * @return if call sucessfull
		 */
		public function showSpinner(cancleble:Boolean=false):Boolean
		{
			try{
				_style = STYLE_SPINNER;
				if(isAndroid()){
					_context.call("showProgressPopup",_progress,_secondary,_style,_title,_message,_maxProgress,cancleble,false,_androidTheme);
					_isShowing = true;
					return true;
				}
				else if(isIOS()){
					_context.call("showProgressPopup",_progress,null,_style,_title,_message,cancleble,true,_iosTheme);
					_isShowing = true;
					return true;
				}
				return false;
			}catch(e:Error){
				showError("Error calling show method "+e.message,e.errorID);
			}
			return false;
		}
		
		
		
		
		/**
		 * If style set to <code>STYLE_HORIZONTAL</code> defines if progressbar shows indeterminate values. Otherwise it is ignored.
		 * <br><b>AVAILABLE ONLY ON ANDROID</b>
		 * 
		 * @return if call sucessfull
		 * 
		 * @throws Error if the call was unsuccessful. Or will dispatch an Error Event.ERROR if there is a listener.
		 */
		public function setIndeterminate(value:Boolean):Boolean{
			if(_indeterminate!==value  && value>=0 && value<= _maxProgress){
				_indeterminate = value;
				if(isAndroid() && _isShowing){
					try{
						_context.call("setIndeterminate",value);
						return true;
					}catch(e:Error){
						showError("Error setting setIndeterminate "+e.message,e.errorID);
					}
				}
			}
			return false;
		}
		
		/**@private*/
		public function set indeterminate(value:Boolean):void
		{
			if(value==_indeterminate || _isShowing==true || value<0 || value> _maxProgress){
				return;
			}
			_indeterminate = value;
		}
		/**
		 * If progressbar shows indeterminate values. Only if style set to <code>STYLE_HORIZONTAL</code>
		 * <br><b>AVAILABLE ONLY ON ANDROID</b>
		 * @see #setIndeterminate()
		 */
		public function get indeterminate():Boolean{
			return _indeterminate;
		}
		
		
		
		
		
		/**
		 * Sets the value of the second values in progressbar. Only if style set to <code>STYLE_HORIZONTAL</code>
		 * <br><b>AVAILABLE ONLY ON ANDROID</b>
		 * @return if call sucessfull
		 */
		public function setSecondaryProgress(value:int):Boolean{
			if(_secondary!==value  && value>=0 && value<= _maxProgress){
				_secondary = value;
				if(isAndroid() && _isShowing){
					try{
						_context.call("updateSecondary",value);
						return true;
					}catch(e:Error){
						showError("Error setting secondary progress "+e.message,e.errorID);
					}
				}
			}
			return false;
		}
		
		/**@private*/
		public function set secondaryProgress(value:int):void
		{
			if(value==_secondary || _isShowing==true || value<0 && value> _maxProgress){
				return;
			}
			_secondary = value;
		}
		/**
		 * The second vaule of the progressbar
		 * <br><b>AVAILABLE ONLY ON ANDROID</b>
		 * @see setSecondaryProgress()
		 */
		public function get secondaryProgress():int{
			return _secondary;
		}
		
		
		
		/**
		 * Sets the progress value in the progressbar. Only if style set to <code>STYLE_HORIZONTAL</code>
		 * @return if call sucessfull
		 */
		public function setProgress(value:int):Boolean{
			if(!isNaN(value) && _progress!==value  && value>=0 && value<= _maxProgress){
				try{
					if(_isShowing){
						if(isAndroid())
							_context.call("updateProgress",value);
						else
							_context.call("updateProgress",value/_maxProgress);
						_progress = value;
						return true;
					}else{
						_progress = value;
						return true;
					}
					
				}catch(e:Error){
					showError("Error setting progress "+e.message,e.errorID);
				}
			}
			return false;
		}
		
		
		
		/**@private*/
		public function set progress(value:int):void
		{
			if(value==_progress || _isShowing==true){
				return;
			}
			_progress = value;
		}
		/**
		 * The progress vaule in the progressbar.
		 * @see setProgress()
		 */
		public function get progress():int{
			return _progress;
		}
		
		
		
		/**
		 * Sets the maximum value of the progress in progressbar. Only if style set to <code>STYLE_HORIZONTAL</code>
		 * <br><b>AVAILABLE ONLY ON ANDROID</b>
		 * @return if call sucessfull
		 * 
		 * @throws Error if the call was unsuccessful. Or will dispatch an Error Event.ERROR if there is a listener.
		 */
		public function setMax(value:int):Boolean{
			if(_maxProgress==value || isNaN(value)){
				return false;
			}
			
			try{
				if(_isShowing && isAndroid()){
					_context.call("setMax",value);
				}
				_maxProgress= value;
				if(_progress>value)
					_progress = value;
				if(_secondary>value)
					_secondary = value;
				
				return true;
			}catch(e:Error){
				showError("Error setting MAX "+e.message,e.errorID);
			}
			
			return false;
		}
		/**@private*/
		public function set max(value:int):void
		{
			if(value==_maxProgress || isNaN(value) || _isShowing){
				return;
			}
			_maxProgress= value;
			if(_progress>value)
				_progress = value;
			if(_secondary>value)
				_secondary = value;
		}
		/**
		 * The maximum vaule of the progressbar.
		 * <br><b>AVAILABLE ONLY ON ANDROID</b>
		 * @see #setMax()
		 */
		public function get max():int{
			return _maxProgress;
		}
		
		
		
		/**
		 * The message of the dialog. Changes the title even if isShowing.
		 * @return if call sucessfull
		 * 
		 * @throws Error if the call was unsuccessful. Or will dispatch an Error Event.ERROR if there is a listener.
		 */
		public function setMessage(value:String):Boolean
		{
			if(value!==_message){
				
				try{
					if(_isShowing){
						if(isAndroid() || isIOS())
							_context.call("updateMessage",value);
						_message = value;
						return true;
					}
				}catch(e:Error){
					showError("Error setting message "+e.message,e.errorID);
				}
			}
			return false;
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
		 * The theme of the dialog on Android.
		 * (if isShowing will be ignored until next call of the <code>show()</code> method.)
		 */
		public function set androidTheme(value:uint):void
		{
			if(!isNaN(value))
				_androidTheme = value;
			else
				_androidTheme = _defaultAndroidTheme;
		}
		/**
		 * @private
		 */
		public function get androidTheme():uint
		{
			return _androidTheme;
		}
		
		/**
		 * The theme of the dialog on IOS.
		 * (if isShowing will be ignored until next call of the <code>show()</code> method.)
		 */
		public function set iosTheme(value:int):void
		{
			if(!isNaN(value))
				_iosTheme = value;
			else
				_iosTheme = _defaultIOSTheme;
		}
		/**
		 * @private
		 */
		public function get iosTheme():int
		{
			return _iosTheme;
		}
		
		
		
		
		
		
		//---------------------------------------------------------------------
		//
		// Public Static Methods.
		//
		//---------------------------------------------------------------------
		/**
		 * Whether the extension is available on the device (true);<br>otherwise false
		 */
		public static function get isSupported():Boolean{
			if(isAndroid() || isIOS())
				return true;
			return false;
		}
		
		/**
		 * The Andorid default theme of all NativeProgess dialogs
		 * @default pl.mateuszmackowiak.nativeANE.dialogs.NativeProgessDialog#DEFAULT_THEME
		 */
		public static function set defaultAndroidTheme(value:uint):void
		{
			_defaultAndroidTheme = value;
		}
		/**
		 * @private
		 */
		public static function get defaultAndroidTheme():uint
		{
			return _defaultAndroidTheme;
		}
		/**
		 * The IOS default theme of all NativeProgess dialogs
		 * @default pl.mateuszmackowiak.nativeANE.dialogs.NativeProgessDialog#DEFAULT_THEME
		 */
		public static function set defaultIOSTheme(value:uint):void
		{
			_defaultIOSTheme = value;
		}
		/**
		 * @private
		 */
		public static function get defaultIOSTheme():uint
		{
			return _defaultIOSTheme;
		}
		
		
		//---------------------------------------------------------------------
		//
		// Private Methods.
		//
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function onStatus(event:StatusEvent):void
		{
			try{
				switch(event.code)
				{
					case NativeDialogEvent.CLOSED:
					{
						_isShowing = false;
						dispatchEvent(new NativeDialogEvent(NativeDialogEvent.CLOSED,event.level));
						break;
					}
						
					case NativeDialogEvent.CANCELED:
					{
						_isShowing = false;
						dispatchEvent(new NativeDialogEvent(NativeDialogEvent.CANCELED,event.level));
						break;
					}
						
					case NativeDialogEvent.OPENED:
					{
						_isShowing = true;
						dispatchEvent(new NativeDialogEvent(NativeDialogEvent.OPENED,event.level));
						break;
					}
					default:
					{
						_isShowing = isShowing();
						showError(event.toString());
						break;
					}
				}
			}catch(e:Error){
				showError(e.message,e.errorID);
			}
		}
		
		
		
	}
}