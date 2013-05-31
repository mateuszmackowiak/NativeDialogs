package pl.mateuszmackowiak.nativeANE.dialogs.support
{
	
	import flash.events.EventDispatcher;
	
	import pl.mateuszmackowiak.nativeANE.nativeDialogNamespace;
	import pl.mateuszmackowiak.nativeANE.dialogs.NativePickerDialog;
	
	use namespace nativeDialogNamespace;
	/**
	 * @playerversion 3.0
	 */
	public class PickerList extends EventDispatcher
	{
		/**@private*/
		private var _dataProvider:Object;
		/**@private*/
		private var _locked:Boolean= false;
		/**@private*/
		private var _width:Number = 300;
		/**@private*/
		private var _labelFunction:Function = null;
		/**@private*/
		private var _labelField:String = null;
		/**@private*/
		private var _selectedItem:* = null;
		/**@private*/
		private var _selectedIndex:int = -1;
		private var _hadSetWidth:Boolean = false;
		/**@private*/
		private var _dialog:NativePickerDialog = null;
		
		public function PickerList(dataProvider:*=null, selectedIndex:int = -1)
		{
			this.dataProvider = dataProvider;
			this.selectedIndex = selectedIndex;
		}
		
		/**@private*/
		nativeDialogNamespace function set locked(value:Boolean):void{
			_locked = value;
		}
		/**@private*/
		nativeDialogNamespace function get locked():Boolean
		{
			return _locked;
		}
		/**@private*/
		nativeDialogNamespace function set dialog(value:NativePickerDialog):void{
			_dialog = value;
		}
		/**@private*/
		nativeDialogNamespace function get hadSetWidth():Boolean
		{
			return _hadSetWidth;
		}
		/**@private*/
		nativeDialogNamespace function setWidth(value:Number):void
		{
			_width = value;
		}
		
		public function get dialgo():NativePickerDialog
		{
			return _dialog;
		}
		/**
		 * @private
		 */
		public function get labelField():String
		{
			return _labelField;
		}

		
		public function getLabels():Vector.<String>{
			if(!_dataProvider){
				return null;
			}
			var v:Vector.<String> = new Vector.<String>(_dataProvider.length);
			var s:String;
			var obj:Object;
			const leng:uint = _dataProvider.length;
			if(_dataProvider.hasOwnProperty("getItemIndex")){
				for (var i:int = 0; i < leng; i++) 
				{
					obj = _dataProvider.getItemAt(i);
					if(labelFunction!=null){
						s = labelFunction(obj);
					}else if(obj && labelField){
						if(labelField!="" && obj.hasOwnProperty("labelField")){
							s = obj[labelField];
						}else{
							s = "";
						}
					}else{
						s = String(obj);
					}
					v[i] = s;
				}
			}else{
				for (var j:int = 0; j < leng; j++) 
				{
					obj = _dataProvider[j];
					if(labelFunction!=null){
						s = labelFunction(obj);
					}else if(obj && labelField){
						if(labelField!="" && obj.hasOwnProperty("labelField")){
							s = obj[labelField];
						}else{
							s = "";
						}
					}else{
						s = String(obj);
					}
					v[j] = s;
				}
			}
			return v;
		}
		/**
		 * The name of the field in the data provider items to display
		 * as the label. 
		 *
		 * If labelField is set to an empty string (""), no field will
		 * be considered on the data provider to represent label.
		 * 
		 * @default null
		 */
		public function set labelField(value:String):void
		{
			if(_locked){
				trace("PickerList is currently locked.");
			}
			_labelField = value;
		}

		/**
		 * @private
		 */
		public function get labelFunction():Function
		{
			return _labelFunction;
		}
		/**
		 *  A user-supplied function to run on each item to determine its label.  
		 *  The <code>labelFunction</code> property overrides 
		 *  the <code>labelField</code> property.
		 *
		 *  <p>You can supply a <code>labelFunction</code> that finds the 
		 *  appropriate fields and returns a displayable string. The 
		 *  <code>labelFunction</code> is also good for handling formatting and 
		 *  localization. </p>
		 *
		 *  <p>The label function takes a single argument which is the item in 
		 *  the data provider and returns a String.</p>
		 *  <pre>
		 *  myLabelFunction(item:Object):String</pre>
		 *
		 *  @default null
		 *  
		 */
		public function set labelFunction(value:Function):void
		{
			if(_locked){
				trace("PickerList is currently locked.");
			}
			_labelFunction = value;
		}

		
		/**
		 * @private
		 */
		public function get dataProvider():*
		{
			return _dataProvider;
		}

		/**
		 *  A list of data items that correspond to the rows in the picker.
		 * Can be IList or a simple array or vector
		 * 
		 */
		public function set dataProvider(value:*):void
		{
			if(!value.hasOwnProperty("length")){
				throw new TypeError("DataProvider must be of type Array, Vector or IList");
				return;
			}
			_selectedIndex = -1;
			_selectedItem = null;
			if(_locked){
				trace("PickerList is currently locked.");
			}
			_dataProvider = value;
		}

		
		
		/**
		 * @private
		 */
		public function get width():Number
		{
			return _width;
		}
		/**
		 * The width of the list.
		 */
		public function set width(value:Number):void
		{
			if(_locked){
				trace("PickerList is currently locked.");
			}
			_hadSetWidth = true;
			_width = value;
		}

		
		/**
		 * @private
		 */
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}

		public function set selectedIndex(value:int):void
		{
			if(_selectedIndex ==value){
				return;
			}
			if(!_dataProvider || _dataProvider.length==0 || value<0 || value>=_dataProvider.length){
				_selectedItem = null;
				_selectedIndex = -1;
				if(_dialog){
					_dialog.setSelectedIndex(this,-1);
				}
				return;
			}
			_selectedIndex = value;
			if(_dataProvider.hasOwnProperty("getItemIndex")){
				_selectedItem = _dataProvider.getItemAt(value);
			}else{
				_selectedItem = _dataProvider[value];
			}
			if(_dialog){
				_dialog.setSelectedIndex(this,value);
			}
			
		}
		/**@private*/
		nativeDialogNamespace function setSelectedIndex(value:int):void{
			if(_selectedIndex ==value){
				return;
			}
			if(!_dataProvider || _dataProvider.length==0 || value<0 || value>=_dataProvider.length){
				_selectedItem = null;
				_selectedIndex = -1;
				return;
			}
			_selectedIndex = value;
			if(_dataProvider.hasOwnProperty("getItemIndex")){
				_selectedItem = _dataProvider.getItemAt(value);
			}else{
				_selectedItem = _dataProvider[value];
			}
		}
		
		
		/**
		 * @private
		 */
		public function get selectedItem():Object
		{
			return _selectedItem;
		}

		public function set selectedItem(value:Object):void
		{
			if(_selectedItem ==value){
				return;
			}
			if(!_dataProvider || _dataProvider.length==0){
				_selectedItem = null;
				_selectedIndex = -1;
				if(_dialog){
					_dialog.setSelectedIndex(this,-1);
				}
				return;
			}
			var index:int = -1;
			
			if(_dataProvider.hasOwnProperty("getItemIndex")){
				index = _dataProvider.getItemIndex(value);
			}else{
				for (var i:int = 0; i < _dataProvider.length; i++) 
				{
					if(_dataProvider[i] == value){
						index = i;
						break;
					}
				}
			}
			_selectedIndex = index;
			if(index>-1){
				_selectedItem = value;
			}else{
				_selectedItem = null;
			}
			if(_dialog){
				_dialog.setSelectedIndex(this,index);
			}
		}
		
		
	}
}