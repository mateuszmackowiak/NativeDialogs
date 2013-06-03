/** 
 * @author Mateusz Maćkowiak
 * @see http://mateuszmackowiak.wordpress.com/
 * @since 2013
 */
package pl.mateuszmackowiak.nativeANE.dialogs
{
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	
	import pl.mateuszmackowiak.nativeANE.dialogs.support.AbstractNativeDialog;
	import pl.mateuszmackowiak.nativeANE.events.NativeDialogEvent;
	import pl.mateuszmackowiak.nativeANE.events.NativeDialogListEvent;

	/** 
	 * @author Mateusz Maćkowiak
	 * @see http://mateuszmackowiak.wordpress.com/
	 * @since 2013
	 */
	public class NativeListDialog extends AbstractNativeDialog
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
		 * use a picker instead of a popup to draw the list
		 * <br>Constant Value: 6 (0x00000006)
		 */
		public static const IOS_PICKER_THEME:uint = 0x00000006;
		/**
		 * use the traditional (pre-Holo) alert dialog theme
		 * <br>the default style for Android devices
		 * <br>Constant Value: 1 (0x00000001)
		 */
		public static const DEFAULT_THEME:uint = 0x00000001;
		
		
		public static const DISPLAY_MODE_SINGLE:String = "SingleChoice";
		public static const DISPLAY_MODE_MULTIPLE:String = "MultipleChoice";
		
		//---------------------------------------------------------------------
		//
		// Private Static Constants
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
		private var _buttons:Vector.<String>=null;
		/**@private*/
		private var _androidTheme:int = NaN;
		/**@private*/
		private var _iosTheme:int = NaN;
		/**@private*/
		private var _cancelable:Boolean = false;
		/**@private*/
		private var _dataProvider:Vector.<Object>;
		/**@private*/
		private var _selectedValues:Vector.<Boolean>;
		/**@private*/
		private var _selectedIndex:int = -1;
		/**@private*/
		private var _displayMode:String = DISPLAY_MODE_SINGLE;
		/**@private*/
		private var _labelField:String = null;
		/**@private*/
		private var _labelFunction:Function = null;
		private var _indexSelectedOnStart:int;
		private var _valuesSelectedOnStart:Vector.<Boolean>;
		
		/**

		 * @param the theme of the dialog - defined by the version of software
		 * @author Mateusz Maćkowiak
		 * @since 2013
		 * 
		 * @event flash.events.ErrorEvent
		 * <br>pl.mateuszmackowiak.nativeANE.NativeDialogEvent
		 * <br>pl.mateuszmackowiak.nativeANE.NativeDialogListEvent
		 */
		public function NativeListDialog(androidTheme:int=-1,iOSTheme:int=-1)
		{
			super(abstractKey);
			
			if(!isNaN(androidTheme) && androidTheme>-1)
				_androidTheme = androidTheme;
			else
				_androidTheme = _defaultAndroidTheme;
			
			if(!isNaN(iOSTheme) && iOSTheme>-1)
				_iosTheme = iOSTheme;
			else
				_iosTheme = _defaultIOSTheme;
			
			init();
		}
		
		/**@private*/
		override protected function init():void{
			try{
				_context = ExtensionContext.createExtensionContext(NativeAlertDialog.EXTENSION_ID, "ListDialogContext");
				_context.addEventListener(StatusEvent.STATUS, onStatus);
			}catch(e:Error){
				throw new Error("Error initiating contex of the NativeListDialog extension: "+e.message+", "+e.getStackTrace(),e.errorID);
			}
		}
		
		
		/**
		 * Shows the dialog.
		 * 
		 * @event pl.mateuszmackowiak.nativeANE.events.NativeDialogEvent.CLOSED
		 * pl.mateuszmackowiak.nativeANE.events.NativeDialogEvent.CANCELED
		 * pl.mateuszmackowiak.nativeANE.events.NativeDialogEvent.OPENED
		 * 
		 * @throws Error if the call was unsuccessful. Or will dispatch an Error Event.ERROR if there is a listener.
		 */
		public function show():Boolean
		{
			if(_isShowing){
				trace("Already showing!");
				return false;
			}
			
			if(_dataProvider==null || _dataProvider.length==0){
				showError("dataProvider can't be empty while showing");
				return false;	
			}
			
			var labels:Vector.<String> = new Vector.<String>();
			try{
				for each (var obj:Object in _dataProvider) 
				{
					if(_labelField!=null){
						labels.push(obj[_labelField]);
					}else if(_labelFunction!=null){
						labels.push(_labelFunction(obj));
					}else{
						labels.push(String(obj));
					}
				}
				if(!_buttons || _buttons.length==0){
					_buttons = Vector.<String>(["OK"]);
				}
				if(_buttons.length==1 && _cancelable)
				{
					_buttons.push("Cancel");
				}

				var selected: * = isSingleMode() ? _selectedIndex : _selectedValues;

				_valuesSelectedOnStart = _selectedValues.concat();
				_indexSelectedOnStart = _selectedIndex;

				if(isAndroid()) {
					_context.call("show",_title,_buttons,labels,selected,_cancelable,_androidTheme);
					return true;
				} else if(isIOS()) {
					_context.call("show",_title,_buttons,labels,selected,_cancelable,_iosTheme,_message);
					return true;
				} else {
					return false;
				}
			}catch(error:Error){
				showError("Error calling show method "+error.message,error.errorID);
			}
			return false;
		}

		private function isSingleMode():Boolean
		{
			return _displayMode == DISPLAY_MODE_SINGLE || _iosTheme != DEFAULT_THEME;
		}
		
		
		
		/**@private*/
		public function set dataProvider(value:Vector.<Object>):void
		{
			if(_isShowing){
				trace("dataProvider can't be changed when isShowing==true ");
				return;
			}
			if(value!=_dataProvider){
				if(value==null){
					_dataProvider = null;
					_selectedValues = null;
				}else{
					_dataProvider = value;
					const len:int = value.length;
					_selectedValues = new Vector.<Boolean>(len,true);
					
					for (var i:int = 0; i < len; i++) 
					{
						_selectedValues[i] = false;
					}
					
				}
			}
		}
		/**
		 * Set of data to be viewed.
		 * The default value is null.
		 */
		public function get dataProvider():Vector.<Object>
		{
			return _dataProvider;
		}
		
		
		/**@private*/
		public function set labelField(value:String):void
		{
			if(_isShowing){
				trace("labelField can't be changed when isShowing==true ");
				return;
			}
			if(value !=null && value!=""){
				_labelField = value;
				_labelFunction = null;
			}
		}
		
		/**
		 * The name of the field in the data provider items to display as the label. The labelFunction property overrides this property.
		 * @default null
		 */
		public function get labelField():String
		{
			return _labelField;	
		}
		
		
		
		
		/**@private*/
		public function set labelFunction(value:Function):void
		{
			if(_isShowing){
				trace("labelFunction can't be changed when isShowing==true ");
				return;
			}
			if(value!=null){
				_labelFunction = value;
				_labelField = null;
			}
		}
		/**
		 * A user-supplied function to run on each item to determine its label. The labelFunction property overrides the labelField property.
		 * <br>You can supply a labelFunction that finds the appropriate fields and returns a displayable string. The labelFunction is also good for handling formatting and localization.
		 * <br>The label function takes a single argument which is the item in the data provider and returns a String.
		 * <br><br>    <code>myLabelFunction(item:Object):String</code>
		 * @default null
		 */
		public function get labelFunction():Function
		{
			return _labelFunction;
		}
		
		
		/**@private*/
		public function set selectedItems(value:Vector.<Object>):void
		{
			if(_isShowing){
				trace("selectedItems can't be changed when isShowing==true ");
				return;
			}
			if(_dataProvider==null || _dataProvider.length==0){
				return;
			}
			const len:int = _dataProvider.length;
			if(value==null || value.length==0){
				_selectedIndex = -1;
				for (var i:int = 0; i < len; i++) 
				{
					_selectedValues[i] = false;
				}
			}else{
				var singleSetup:Boolean = false;
				for (var j:int = 0; j < len; j++) 
				{
					_selectedValues[j] = false;
				}
				for each (var val:Object in value) 
				{
					for (var k:int = 0; k < len; k++) 
					{
						if(val == _dataProvider[k]){
							if(singleSetup==false){
								singleSetup = true;
								_selectedIndex = k;
							}
							_selectedValues[k]==true;
							break;
						}
					}
				}
				
			}
		}
		
		/**
		 * An vector of references to the selected items in the data provider. 
		 * @default empty Vector.
		 * @see #type 
		 */
		public function get selectedItems():Vector.<Object>{
			var returnVec:Vector.<Object> = new Vector.<Object>();
			if(_dataProvider!==null && _dataProvider.length>0){
				const len:int = _dataProvider.length;
				if(isSingleMode()){
					if(_selectedIndex>-1 && _selectedIndex<len){
						returnVec.push(_dataProvider[_selectedIndex]);
					}
				}else{
					for (var i:int = 0; i < len; i++) 
					{
						if(_selectedValues[i] == true){
							returnVec.push(_dataProvider[i]);
						}
					}
				}
			}
			return returnVec;
		}
		
		
		/**@private*/
		public function set selectedIndexes(value:Vector.<int>):void
		{
			if(_isShowing){
				trace("selectedIndexes can't be changed when isShowing==true ");
				return;
			}
			if(_dataProvider==null || _dataProvider.length==0){
				return;
			}
			const len:int = _dataProvider.length;
			if(value==null || value.length==0){
				_selectedIndex = -1;
				for (var i:int = 0; i < len; i++) 
				{
					_selectedValues[i] = false;
				}
			}else{
				_selectedIndex = value[0];
				for (var j:int = 0; j < len; j++) 
				{
					_selectedValues[j] = false;
				}
				for each (var val:int in value) 
				{
					if(!isNaN(val) && val>0 && val<len){
						_selectedValues[j] = true;
					}
				}
			}
		}
		/**
		 * list of selected indexes. If <code>type==SINGLE</code> returns a list with selected index else empty
		 * @see #type
		 */
		public function get selectedIndexes():Vector.<int>{
			var indexes:Vector.<int> = new Vector.<int>();
			if(_dataProvider!==null && _dataProvider.length>0){
				const len:int = _dataProvider.length;
				if(isSingleMode()){
					if(_selectedIndex>-1 && _selectedIndex<len){
						indexes.push(_selectedIndex);
					}
				}else{
					for (var i:int = 0; i < len; i++) 
					{
						if(_selectedValues[i] == true){
							indexes.push(i);
						}
					}
				}
			}
			return indexes;
		}
		
		
		/**
		 * The type of dialog <code>DISPLAY_MODE_MULTIPLE</code> or <code>DISPLAY_MODE_SINGLE</code>
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
		
		/**@private*/
		public function set selectedIndex(value:int):void
		{
			if(_isShowing){
				trace("slectedIndex can't be changed when isShowing==true ");
				return;
			}
			if(_dataProvider==null || _dataProvider.length==0){
				return;
			}
			_selectedIndex = value;
			const len:int = _dataProvider.length;
			for (var i:int = 0; i < len; i++) 
			{
				if(i==value){
					_selectedValues[i] = true;
				}else{
					_selectedValues[i] = false;
				}
			}
		}
		/**
		 * The index in the data provider of the selected item.
		 * <br>If is <code>type == MULTIPLE</code> return the first slected index
		 * @see #type
		 * @default -1 (no selected item).
		 */
		public function get selectedIndex():int{
			if(isSingleMode())
				return _selectedIndex;
				
			else if(_dataProvider!==null && _dataProvider.length>0){
				const len:int = _dataProvider.length;
				for (var i:int = 0; i < len; i++) 
				{
					if(_selectedValues[i] == true)
						return i;
				}
			}
			return -1;
		}
		
		
		/**@private*/
		public function set selectedItem(value:Object):void
		{
			if(_isShowing){
				trace("selectedItem can't be changed when isShowing==true ");
				return;
			}
			if(_dataProvider==null || _dataProvider.length==0){
				return;
			}
			const len:int = _dataProvider.length;
			for (var i:int = 0; i < len; i++) 
			{
				if(_dataProvider[i] == value){
					_selectedValues[i] = true;
					_selectedIndex = i;
				}else{
					_selectedValues[i] = false;
				}
			}
		}
		/**
		 * A reference to the selected item in the data provider.
		 * <br>If <code>type == MULTIPLE</code> choice return the first slected item or null if non selected
		 * @see type
		 * @default null
		 */
		public function get selectedItem():Object{
			if(isSingleMode()){
				if(_selectedIndex>-1 && _dataProvider!=null && _dataProvider.length>0 && _selectedIndex<_dataProvider.length)
					return _dataProvider[_selectedIndex];
				else
					return null;
			}else{
				if(_dataProvider!=null && _dataProvider.length>0){
					const len:int = _dataProvider.length;
					for (var i:int = 0; i < len; i++) 
					{
						if(_selectedValues[i] == true)
							return _dataProvider[i];
					}
				}
				return null;
			}
		}
		
		
	
		
		/**
		 * The message of the dialog. Changes the message even if isShowing.
		 * <br><b>AVAILABLE ONLY ON IOS</b>
		 * 
		 * @return if call sucessfull
		 * 
		 * @throws Error if the call was unsuccessful. Or will dispatch an Error Event.ERROR if there is a listener.
		 */
		public function setMessage(value:String):Boolean
		{
			if(value==_message){
				return false;
			}
			if(_isShowing && isIOS()){
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
		 * The message of the dialog.
		 * @see setMessage()
		 */
		public function get message():String
		{
			return _message;
		}
		
		/**
		 * If back button on Android cancles the dialog.Changes it event if isShowing.
		 * <br><b>AVAILABLE ONLY ON ANDROID</b>
		 * @return if call sucessfull
		 * 
		 * @throws Error if the call was unsuccessful. Or will dispatch an Error Event.ERROR if there is a listener.
		 */
		public function setCancelable(value:Boolean):Boolean
		{
			if(_cancelable==value){
				return false;
			}
			if(_isShowing && isAndroid()){
				try{
					_context.call("setCancelable",value);
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
		 * <br><b>AVAILABLE ONLY ON ANDROID</b>
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
			else 
				return false;
		}

		
		/**
		 * The Andorid default theme of all NativeListDialogs dialogs
		 * @default pl.mateuszmackowiak.nativeANE.dialogs.NativeListDialogs#DEFAULT_THEME
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
		 * The IOS default theme of all NativeListDialogs dialogs
		 * @default pl.mateuszmackowiak.nativeANE.dialogs.NativeListDialogs#DEFAULT_THEME
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
				if(event.code == NativeDialogEvent.CLOSED){
					_isShowing = false;
					if(hasEventListener(NativeDialogEvent.CLOSED))
						dispatchEvent(new NativeDialogEvent(NativeDialogEvent.CLOSED,event.level));
					
				}else if(event.code == NativeDialogEvent.CANCELED){
					_isShowing = false;
					dispatchStartState();
					if(hasEventListener(NativeDialogEvent.CANCELED))
						dispatchEvent(new NativeDialogEvent(NativeDialogEvent.CANCELED,event.level));
					
				}else if(event.code == NativeDialogEvent.OPENED){
					_isShowing = true;
					if(hasEventListener(NativeDialogEvent.OPENED))
						dispatchEvent(new NativeDialogEvent(NativeDialogEvent.OPENED,event.level));
					
				}else if(event.code == NativeDialogListEvent.LIST_CHANGE){
					var index:int = -1;
					trace("List Change", event.level)
					if(event.level.indexOf("_")>-1){
						const args:Array = event.level.split("_");
						index = int(args[0]);
						var selected:Boolean=false;
						const selectedStr:String= String(args[1]).toLowerCase();
						if(selectedStr=="true" || selectedStr=="1")
							selected = true;
						_selectedValues[index] = selected;
						
						dispatchChange(index, selected);
					} else {
						index = int(event.level);
						_selectedIndex = index;
						dispatchChange(index, true);
					}
					
				}else{
					isShowing();
					showError(event);
				}
			}catch(e:Error){
				showError(e.message,e.errorID);
			}
		}

		private function dispatchStartState():void
		{
			_selectedIndex = _indexSelectedOnStart;
			_selectedValues = _valuesSelectedOnStart.concat();
			if(isSingleMode())
			{
				dispatchChange(_indexSelectedOnStart,true);
			}
			else
			{
				for(var index:int =0;index<_valuesSelectedOnStart.length;++index)
				{
					var wasSelected:Boolean = _valuesSelectedOnStart[index];
					if(_selectedValues[index] != wasSelected)
					{
						dispatchChange(index,wasSelected);
					}
				}
			}
		}

		private function dispatchChange(index:int, selected:Boolean):void
		{
			if (hasEventListener(NativeDialogListEvent.LIST_CHANGE))
				dispatchEvent(new NativeDialogListEvent(NativeDialogListEvent.LIST_CHANGE, index, selected));
		}
	}
}