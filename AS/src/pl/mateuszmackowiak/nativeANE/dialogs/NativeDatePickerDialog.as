/** 
 * @author Mateusz Maćkowiak
 * @see http://mateuszmackowiak.wordpress.com/
 * @since 2013
 */
package pl.mateuszmackowiak.nativeANE.dialogs
{
	import flash.events.Event;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	
	import pl.mateuszmackowiak.nativeANE.dialogs.support.AbstractNativeDialog;
	import pl.mateuszmackowiak.nativeANE.events.NativeDialogEvent;
	
	/**
	 * 
	 * @author Mateusz Maćkowiak
	 * @see http://mateuszmackowiak.wordpress.com/
	 * @since 2013
	 * 
	 */
	public class NativeDatePickerDialog extends AbstractNativeDialog
	{
		//---------------------------------------------------------------------
		//
		// Constants
		//
		//---------------------------------------------------------------------
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
		
		/**
		 *  Show selection options for date.
		 * 
		 *  @langversion 3.0
		 *  @playerversion AIR 3
		 *  @productversion Flex 4.6
		 */
		public static const DISPLAY_MODE_DATE:String = "date";
		
		/**
		 *  Show selection options for time.
		 * 
		 *  @langversion 3.0
		 *  @playerversion AIR 3
		 *  @productversion Flex 4.6
		 */
		public static const DISPLAY_MODE_TIME:String = "time";
		
		/**
		 *  Show selection options for both date and time.
		 * 
		 *  @langversion 3.0
		 *  @playerversion AIR 3
		 *  @productversion Flex 4.6
		 */
		public static const DISPLAY_MODE_DATE_AND_TIME:String = "dateAndTime";    
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
		private var _theme:int = -1;
		/**@private*/
		private var _buttons:Vector.<String>=null;
		/**@private*/
		private var _date:Date = null;
		/**@private*/
		private var _cancelable:Boolean = false;
		/**@private*/
		private var _displayMode:String = DISPLAY_MODE_DATE;
		/**@private*/
		private var _is24HourView:Boolean = false;
		private var _startDate:Date;
		private var _maxDate:Date;
		private var _minDate:Date;
		//---------------------------------------------------------------------
		//
		// Public Methods.
		//
		//---------------------------------------------------------------------
		/** 
		 * @author Mateusz Maćkowiak
		 * 
		 * @param theme the selected theme for the NativeDatePickerDialog.
		 * 
		 * @since 2013
		 * 
		 * @see pl.mateuszmackowiak.nativeANE.events.NativeDialogEvent
		 * @see http://mateuszmackowiak.wordpress.com/
		 * 
		 * 
		 * @event pl.mateuszmackowiak.nativeANE.events.NativeDialogEvent.OPENED
		 * pl.mateuszmackowiak.nativeANE.events.NativeDialogEvent.CLOSED
		 * pl.mateiszmackowiak.nativeANE.events.NativeDialogEvent.CANCELED
		 * flash.events.Event.CHANGE
		 * 
		 */
		public function NativeDatePickerDialog(theme:int=-1)
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
				_context = ExtensionContext.createExtensionContext(NativeAlertDialog.EXTENSION_ID, "DatePickerDialogContext");
				_context.addEventListener(StatusEvent.STATUS, onStatus);
			}catch(e:Error){
				showError("Error initiating contex of the NativeDatePickerDialog extension: "+e.message,e.errorID);
			}
		}
		
		
		/**
		 * The style of the dialog. May be : <code>TIME , DATE</code>
		 */
		public function get displayMode():String
		{
			return _displayMode;
		}

		/**
		 * @private
		 */
		public function set displayMode(value:String):void
		{
			if(_isShowing)
				return;
			_displayMode = value;
		}

		/**
		 * Whether this is a 24 hour view, or AM/PM.
		 */
		public function get is24HourView():Boolean
		{
			return _is24HourView;
		}

		/**
		 * @private
		 */
		public function set is24HourView(value:Boolean):void
		{
			if(_isShowing)
				return;
			_is24HourView = value;
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

		public function set maxDate(date:Date):void
		{
			_maxDate = date;
		}

		public function set minDate(date:Date):void
		{
			_minDate = date;
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
		 * If back button on Android or pressing outside the dialog cancles it.Changes it event if isShowing.
		 * @return if call sucessfull
		 * 
		 * @throws Error if the call was unsuccessful. Or will dispatch an Error Event.ERROR if there is a listener.
		 */
		public function setCancelable(value:Boolean):Boolean
		{
			if(_cancelable==value){
				return false;
			}
			if(_isShowing){
				try{
					if(isAndroid() || isIOS()){
					_context.call("setCancelable",value);
					}
					_cancelable = value;
					return true;
				}catch(e:Error){
					showError("Error setting canceleble: "+e.message,e.errorID);
				}
				return false;
			}
			_cancelable = value;
			return true;
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
		 * If back button cancles the dialog.
		 */
		public function get cancelable():Boolean
		{
			return _cancelable;
		}
		
		
		
		
		/**
		 * List of button labels in the dialog.
		 * (if isShowing will be ignored until next call of the <code>show</code> method.)
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
		 * @param cancelable if pressing outside the dialog or the back button hides the dialog
		 * 
		 * @see pl.mateuszmackowiak.nativeANE.dialogs.NativeDatePickerDialog.defaultTheme
		 * @see pl.mateuszmackowiak.nativeANE.dialogs.NativeDatePickerDialog.show
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
				_cancelable = cancelable;
				
				if(!_title)
					_title="";
				if(_theme ==-1)
					_theme = defaultTheme;
				if(_date==null){
					_date = new Date();
				}
				if(!_buttons || _buttons.length==0){
					_buttons = Vector.<String>(["OK"]);
				}
				if(_buttons.length==1 && _cancelable && isIOS())
				{
					_buttons.push("Cancel");
				}
				_startDate = date;


				if(_minDate != null && _maxDate != null)
				{
					if(isAndroid()){
						_context.call("show", _title,_message,dateToString(_date),_buttons,_displayMode, _is24HourView,_cancelable, _theme, _minDate.time, _maxDate.time);
					}else if(isIOS()){
						_context.call("show", _title,_message,dateToIOSTimestamp(_date),_buttons,_displayMode, _is24HourView,_cancelable, _theme, dateToIOSTimestamp(_minDate), dateToIOSTimestamp(_maxDate));
					}
				}
				else
				{
					if(isAndroid()){
						_context.call("show", _title,_message,dateToString(_date),_buttons,_displayMode, _is24HourView,_cancelable, _theme);
					}else if(isIOS()){
						_context.call("show", _title,_message,dateToIOSTimestamp(_date),_buttons,_displayMode, _is24HourView,_cancelable, _theme);
					}
				}
				
				return true;
			}catch(e:Error){
				showError("While calling show method: "+e.message,e.errorID);
			}
			return false;
		}
		/**
		 * @private
		 */
		private function dateToString(date:Date):String
		{
			return String(date.fullYear)
					+","+String(date.month)
					+","+String(date.date)
					+","+String(date.hours)
					+","+String(date.minutes);
		}
		/**
		 * @private
		 */
		private static function dateToIOSTimestamp(date:Date):Number
		{
			if(date==null)
				return new Date().time/1000;
			var u:Number = date.time/1000;
			return u;
		}
		/**
		 * @private
		 */
		private function stringDateToDate(year:String,month:String,day:String,useDateObject:Date=null):Date
		{
			var d:Date = useDateObject;
			if(d==null){
				d = new Date(int(year),int(month),int(day));
			}else{
				d.fullYear = int(year);
				d.month = int(month);
				d.date = int(day);
			}
			return d;
		}
		/**
		 * @private
		 */
		private function stringTimeToDate(hours:String,minutes:String,useDateObject:Date=null):Date
		{
			var d:Date = useDateObject;
			if(d==null){
				d = new Date(null,null,null,int(hours),int(minutes));
			}else{
				d.minutes = int(minutes);
				d.hours = int(hours);
			}
			return d;
		}
		
		/**
		 * The selected date. Changes the title even if isShowing.
		 * @return if call sucessfull
		 */
		public function setDate(value:Date):Boolean
		{
			if(value==_date){
				return false;
			}
			try{
				if(_isShowing){
					if(isAndroid()){
						_context.call("setDate",dateToString(value));
					}else if(isIOS()){
						_context.call("setDate",dateToIOSTimestamp(value));
					}
				}
				_date = value;
				return true;
			}catch(e:Error){
				showError("Error setting date: "+e.message,e.errorID);
			}
			return false;
		}
		
		
		/**@private*/
		public function set date(value:Date):void
		{
			if(_isShowing || value==_date){
				return;
			}
			_date = value;
		}
		/**
		 * The selected date.
		 * @default new Date()
		 */
		public function get date():Date
		{
			return _date;
		}
		
		//---------------------------------------------------------------------
		//
		// STATIC Content
		//
		//---------------------------------------------------------------------
		/**@private*/
		public static function set defaultTheme(value:int):void
		{
			_defaultTheme = value;
		}
		/**
		 * The default theme of all dialogs
		 * @default pl.mateuszmackowiak.nativeANE.dialogs.NativeDatePickerDialog#DEFAULT_THEME
		 */
		public static function get defaultTheme():int
		{
			return _defaultTheme;
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
				if(hasEventListener(NativeDialogEvent.OPENED)){
					dispatchEvent(new NativeDialogEvent(NativeDialogEvent.OPENED,event.level));
				}
			}
			else if( event.code == 'log') {
				trace(event.level);
			}
			else if( event.code == Event.CHANGE)
			{
				if(isAndroid()){
					var a:Array = event.level.split(",");
					trace("reading date", a[1],a[2],a[3]);
					if(a[0]=="day"){
						_date = stringDateToDate(a[1],a[2],a[3],_date);
					}else{
						_date = stringTimeToDate(a[1],a[2],_date);
					}
					trace(_date.toString());
				}else{
					var timestamp:Number = Number(event.level)*1000;
					_date.time = timestamp;
				}
				dispatchChange();
			}
			else if( event.code == NativeDialogEvent.CLOSED)
			{
				_isShowing = false;
				if(hasEventListener(NativeDialogEvent.CLOSED))
					dispatchEvent(new NativeDialogEvent(NativeDialogEvent.CLOSED,event.level));
			
			}else if(event.code == NativeDialogEvent.CANCELED){
				_isShowing = false;
				reset();
				if(hasEventListener(NativeDialogEvent.CANCELED))
					dispatchEvent(new NativeDialogEvent(NativeDialogEvent.CANCELED,event.level));
				
			}
			else{
				showError(event);
			}
		}

		private function reset():void
		{
			_date = _startDate;
			dispatchChange();
		}

		private function dispatchChange():void
		{
			if (hasEventListener(Event.CHANGE))
			{
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
	}
}