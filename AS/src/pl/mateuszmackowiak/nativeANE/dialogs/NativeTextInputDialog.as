/** 
 * @author Mateusz Maćkowiak
 * @see http://mateuszmackowiak.wordpress.com/
 * @since 2011
 */
package pl.mateuszmackowiak.nativeANE.dialogs
{
	import flash.events.Event;
	import flash.events.StatusEvent;
	import flash.events.TextEvent;
	import flash.external.ExtensionContext;
	
	import pl.mateuszmackowiak.nativeANE.events.NativeDialogEvent;
	import pl.mateuszmackowiak.nativeANE.nativeDialogNamespace;
	import pl.mateuszmackowiak.nativeANE.dialogs.support.AbstractNativeDialog;
	import pl.mateuszmackowiak.nativeANE.dialogs.support.NativeTextField;
	
	use namespace nativeDialogNamespace;
	
	/** 
	 * @author Mateusz Maćkowiak
	 * 
	 * <img src="https://github.com/mateuszmackowiak/NativeAlert/raw/master/images/NativeTextInputAndroidDefaultLightTheme.png"></img>
	 * <img src="https://github.com/mateuszmackowiak/NativeAlert/raw/master/images/NativeTextInputAndroidHaloLightTheme.png"></img>
	 * <img src="https://github.com/mateuszmackowiak/NativeAlert/raw/master/images/NativeTextInputAndroidHaloDarkTheme.png"></img>
	 * 
	 * @see http://mateuszmackowiak.wordpress.com/
	 */
	public class NativeTextInputDialog extends AbstractNativeDialog
	{
		//---------------------------------------------------------------------
		//
		// Public Static Constants
		//
		//---------------------------------------------------------------------
		
		/**
		 * use the device's default alert theme with a dark background
		 * <br>Constant Value: 4 (0x00000004)
		 */
		public static const ANDROID_DEVICE_DEFAULT_DARK_THEME:uint = 0x00000004;
		/**
		 *  use the device's default alert theme with a dark background.
		 * <br>Constant Value: 5 (0x00000005)
		 */
		public static const ANDROID_DEVICE_DEFAULT_LIGHT_THEME:uint = 0x00000005;
		/**
		 * use the holographic alert theme with a dark background
		 * <br>Constant Value: 2 (0x00000002)
		 */
		public static const ANDROID_HOLO_DARK_THEME:uint = 0x00000002;
		/**
		 * use the holographic alert theme with a light background
		 * <br>Constant Value: 3 (0x00000003)
		 */
		public static const ANDROID_HOLO_LIGHT_THEME:uint = 0x00000003;
		/**
		 * use the traditional (pre-Holo) alert dialog theme
		 * <br>the default style for Android devices
		 * <br>Constant Value: 1 (0x00000001)
		 */
		public static const DEFAULT_THEME:uint = 0x00000001;
		
		//---------------------------------------------------------------------
		//
		// Private Static Constants
		//
		//---------------------------------------------------------------------
		private static var _defaultTheme:int = DEFAULT_THEME;
		
		//---------------------------------------------------------------------
		//
		// Private Properties.
		//
		//---------------------------------------------------------------------
		/**@private*/
		private var _theme:int = -1;
		/**@private*/
		private var _cancelable:Boolean = false;
		/**@private*/
		private var _buttons:Vector.<String>=null;
		/**@private*/
		private var _textInputs:Vector.<NativeTextField>=null;
		//---------------------------------------------------------------------
		//
		// Public Methods.
		//
		//---------------------------------------------------------------------
		
		/** 
		 * @event flash.events.ErrorEvent
		 * <br> pl.mateuszmackowiak.nativeANE.NativeDialogEvent
		 * 
		 * @param theme the theme of the dialog (defined by the version of software on Android)
		 * 
		 * @author Mateusz Maćkowiak
		 * @see http://mateuszmackowiak.wordpress.com/
		 * @since 2011
		 */
		public function NativeTextInputDialog(theme:int=-1)
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
				_context = ExtensionContext.createExtensionContext(NativeAlertDialog.EXTENSION_ID, "TextInputDialogContext");
				_context.addEventListener(StatusEvent.STATUS, onStatus);
			}catch(e:Error){
				throw new Error("Error initiating contex of the NativeTextInputDialog extension: "+e.message,e.errorID);
			}
		}
		
		

		/**
		 * Shows the dialog.
		 * 
		 * @param cancleble if pressing outside the popup or the back button hides the popup <b>(Only on Android)</b>
		 * 
		 * @see pl.mateuszmackowiak.nativeANE.dialogs.NativeTextInputDialog#setCancelable()
		 * 
		 * @event pl.mateuszmackowiak.nativeANE.events.NativeDialogEvent.CLOSED
		 * pl.mateuszmackowiak.nativeANE.events.NativeDialogEvent.CANCELED
		 * pl.mateuszmackowiak.nativeANE.events.NativeDialogEvent.OPENED
		 * 
		 * @throws Error if the call was unsuccessful. Or will dispatch an Error Event.ERROR if there is a listener.
		 */
		public function show(cancleble:Boolean=false):Boolean{
			
			if(_isShowing){
				trace("Already showing!");
				return false;
			}
			_cancelable = cancleble;
			
			if (!_buttons || _buttons.length == 0){
				//no buttons exist, lets make the default buttons
				trace("Buttons not configured, assigning default CANCEL,OK buttons");
				_buttons = Vector.<String>(["Cancel","OK"]);
			}
			if(_textInputs==null || _textInputs.length==0){
				showError("textInputs cannot be null");
				return false;
			}else{
				for each (var t:NativeTextField in _textInputs) 
				{
					if(t)
						t.setNativeTextInputDialog(this);
				}
			}

			try{
				if(isAndroid()){
					if(buttons.length>3){
						trace("Warning: There can be only 3 buttons on Andorid NativeTextInputDialog");
					}
					_context.call("show",_title,_textInputs,_buttons,_cancelable,_theme);
					_isShowing = true;
					return true;
				}
				if(isIOS()){
					var message:String = (textInputs[0].editable==false)? textInputs[0].text :null;
					
					if(buttons.length>2){
						trace("Warning: There can be only 2 buttons on IOS NativeTextInputDialog");
					}
					if(textInputs.length>3){
						trace("Warning: There can be max only 3 NativeTextFields (first with editable==false to display aditional message) on IOS NativeTextInputDialog ");
					}
					
					_context.call("show",_title,message,_textInputs,_buttons);
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
		 * If back button on Android cancles dialog. Works event if isShowing()
		 * <br><b>AVAILABLE ONLY ON ANDROID</b>
		 * @return if call sucessfull
		 * 
		 * @throws Error if the call was unsuccessful. Or will dispatch an Error Event.ERROR if there is a listener.
		 */
		public function setCancelable(value:Boolean):Boolean
		{
			if(_cancelable!==value){
				
				if(_isShowing){
					try{
						if(isAndroid()){
							_context.call("setCancleble",value);
							_cancelable = value;
							return true;
						}
						/*if(isIOS){
						context.call("setCancleble",value);
						return true;
						}*/
					}catch(e:Error){
						showError("Error setting secondary progress "+e.message,e.errorID);
					}
				}
				_cancelable = value;
				return true;
			}
			return false;	
		}
		
		/**@private*/
		public function set cancelable(value:Boolean):void
		{
			if(value==_cancelable || _isShowing==true){
				return;
			}
			_cancelable = value;
		}
		/**
		 * If back button cancles dialog.
		 * <br><b>AVAILABLE ONLY ON ANDROID</b>
		 */
		public function get cancelable():Boolean
		{
			return _cancelable;
		}
		
		
		
		/**@private*/
		public function set textInputs(value:Vector.<NativeTextField>):void
		{
			if(_isShowing)
				return;
			
			if(value==_textInputs || _isShowing==true){
				return;
			}
			var t:NativeTextField;
			if(_textInputs && _textInputs.length>0){
				for each (t in _textInputs) 
				{
					if(t)
						t.setNativeTextInputDialog(null);
				}
			}
			if(value && value.length>0){
				for each (t in value) 
				{
					if(t)
						t.setNativeTextInputDialog(this);
				}
			}
			_textInputs = value;
		}
		
		/**
		 * The list of NativeTextFields where param <code>editable</code> defines if it is a text input or standard label.
		 * <br>(Can be only set while isShowing == false)
		 */
		public function get textInputs():Vector.<NativeTextField>
		{
			return _textInputs;
		}

		
		
		/**
		 * Helper method to get the text input by its name.
		 */
		public function getTextInputByName(name:String):NativeTextField
		{
			if(_textInputs && _textInputs.length>0){
				for each (var t:NativeTextField in _textInputs) 
				{
					if(t.name ==name)
						return t;
				}
			}
			return null;
		}
		
		
		
		/**
		 * @private
		 */
		public function set buttons(value:Vector.<String>):void
		{
			_buttons = value;
		}
		/**
		 * A list of labels of buttons in dialog.
		 * (if isShowing will be ignored until next call of <code>show</code> method.)
		 */
		public function get buttons():Vector.<String>
		{
			return _buttons;
		}
		
		
		
		

		
		/**
		 * The theme of the current dialog.
		 * (if isShowing will be ignored until next call of <code>show</code> method.)
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
		 * Disposes of this ExtensionContext instance.<br><br>
		 * The runtime notifies the native implementation, which can release any associated native resources. After calling <code>dispose()</code>,
		 * the code cannot call the <code>call()</code> method and cannot get or set the <code>actionScriptData</code> property.
		 */
		override public function dispose():void
		{
			_isShowing = false;
			try{
				if(_textInputs && _textInputs.length>0){
					for each (var t:NativeTextField in _textInputs) 
					{
						if(t)
							t.setNativeTextInputDialog(null);
					}
				}
				if(_context){
					_context.dispose();
					_wasDisposed = true;
					_context = null;
				}else{
					trace(className+" was already disposed.");
				}
			}catch(e:Error){
				showError("Error calling dispose method "+e.message,e.errorID);
			}
		}
		
		
		
		
		
		
		
		

		//---------------------------------------------------------------------
		//
		// Public Static Methods.
		//
		//---------------------------------------------------------------------
		/**
		 * If the extension is available on the device (true);<br>otherwise false
		 */
		public static function get isSupported():Boolean{
			if(isAndroid() || isIOS())
				return true;
			return false;
		}
		
		/**
		 * The default theme of dialog on Andorid.
		 */
		public static function set defaultTheme(value:int):void
		{
			_defaultTheme = value;
		}
		/**
		 * @private
		 */
		public static function get defaultTheme():int
		{
			return _defaultTheme;
		}
		
	
		
		//---------------------------------------------------------------------
		//
		// Private Methods.
		//
		//---------------------------------------------------------------------
		/**@private*/
		private function onStatus( event : StatusEvent ) : void
		{
			try{
				if(event.code == Event.CHANGE){
					if(isIOS()){
						const a2:Array = event.level.split("#_#");
						var t:NativeTextField = null;
						if(_textInputs[0].editable==false){
							t = _textInputs[int(a2[0])+1];
							t.text = a2[1];
						}else{
							t = _textInputs[int(a2[0])];
							t.text = a2[1];
						}
						if(t.hasEventListener(Event.CHANGE))
							t.dispatchEvent(new Event(Event.CHANGE));
					}
					if(isAndroid()){
						const a3:Array = event.level.split("#_#");
						
						for each (var n1:NativeTextField in _textInputs)
						{
							if(n1.name==a3[0]){
								if(n1.text != a3[1]){
									n1.text = a3[1];
									if(n1.hasEventListener(Event.CHANGE))
										n1.dispatchEvent(new Event(Event.CHANGE));
								}
							}
						}
						
					}
				}else if(event.code == NativeDialogEvent.CLOSED){
					_isShowing = false;
					
					if(dispatchEvent(new NativeDialogEvent(NativeDialogEvent.CLOSED,event.level,false,true))){
						if(isAndroid()){
							hide();
						}
					}
				}else if(event.code == NativeDialogEvent.CANCELED){
					_isShowing = false;
					
					if(dispatchEvent(new NativeDialogEvent(NativeDialogEvent.CANCELED,event.level,false,true))){
						if(isAndroid()){
							hide();
						}
					}
				}else if(event.code == NativeDialogEvent.OPENED){
					dispatchEvent(new NativeDialogEvent(NativeDialogEvent.OPENED,"",false,true));
					
				}else if(event.code == "returnPressed"){
					if(isIOS()){
						var t2:NativeTextField = null;
						if(_textInputs[0].editable==false){
							t2 = _textInputs[int(event.level)+1];
						}else{
							t2 = _textInputs[int(event.level)];
						}
						if(t2.hasEventListener(TextEvent.TEXT_INPUT))
							t2.dispatchEvent(new TextEvent(TextEvent.TEXT_INPUT,false,false,"\n"));
					}
				}else{
					_isShowing = isShowing();
					showError(event.toString());
				}
			}catch(e:Error){
				showError(e.message,e.errorID);
			}
	
		}
		

	}
}