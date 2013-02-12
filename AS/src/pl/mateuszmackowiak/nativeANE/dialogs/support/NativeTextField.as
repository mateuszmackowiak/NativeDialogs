package pl.mateuszmackowiak.nativeANE.dialogs.support
{
	import flash.events.EventDispatcher;
	
	import pl.mateuszmackowiak.nativeANE.nativeDialogNamespace;
	import pl.mateuszmackowiak.nativeANE.dialogs.NativeTextInputDialog;
	
	use namespace nativeDialogNamespace;
	
	/**
	 * @playerversion 3.0
	 */
	public class NativeTextField extends EventDispatcher
	{
		
		/**@private*/
		private var _name:String;
		/**
		 * the name of the text field
		 * @default null
		 * @playerversion 3.0
		 */
		public function get name():String
		{
			return _name;
		}
		
		
		/**
		 * The current text in the text field.
		 * @default null
		 * @playerversion 3.0
		 */
		public var text:String="";
		/**
		 * The promp text in the text field.
		 * @default null
		 * @playerversion 3.0
		 */
		public var prompText:String="";
		
		/**
		 * Controls how a device applies auto capitalization to user input. Valid values are defined as constants in the AutoCapitalize class:
		 * <ul><li>"none"</li>
		 * <li>"word"</li>
		 * <li>"sentence"</li>
		 * <li>"all"</li></ul>
		 * <p>This property is only a hint to the underlying platform, because not all devices and operating systems support this functionality.</p>
		 * @default AutoCapitalize.NONE
		 * @playerversion 3.0
		 */
		public var autoCapitalize:String="none";
		/**
		 * Indicates whether a device auto-corrects user input for spelling or punctuation mistakes.
		 * <p>This property is only a hint to the underlying platform, because not all devices and operating systems support this functionality.</p>
		 * @default false
		 * @playerversion 3.0
		 */
		public var autoCorrect:Boolean = false;
		/**
		 * Indicates whether the text field is a password text field. If <code>true</code>, the text field hides input characters using a substitute character (for example, an asterisk).
		 * <p><b>Important:</b> On iOS, a multiline stage text object does not display substitute characters even when the value of this property is <code>true</code>.</p>
		 * @default false
		 * @playerversion 3.0
		 */
		public var displayAsPassword:Boolean =false;
		/**
		 * Indicates whether the user can edit the text field.
		 * @default true
		 * @playerversion 3.0
		 */
		public var editable:Boolean = true;
		
		
		/**
		 * Indicates the label on the Return key for devices that feature a soft keyboard. The available values are constants defined in the ReturnKeyLabel class:
		 * <ul><li>"default"</li>
		 * <li>"done"</li>
		 * <li>"go"</li>
		 * <li>"next"</li>
		 * <li>"search"</li></ul>
		 * <p>This property is only a hint to the underlying platform, because not all devices and operating systems support these values. This property has no affect on devices that do not feature a soft keyboard.</p>
		 * @default ReturnKeyLabel.DEFAULT
		 * @playerversion 3.0
		 */
		public var returnKeyLabel:String = "default";
		
		/**
		 * Controls the appearance of the soft keyboard.
		 * <p>Devices with soft keyboards can customize the keyboard's buttons to match the type of input expected. For example, if numeric input is expected, a device can use SoftKeyboardType.NUMBER to display only numbers on the soft keyboard. Valid values are defined as constants in the SoftKeyboardType class:</p>
		 * <ul><li>"default"</li>
		 * <li>"punctuation"</li>
		 * <li>"url"</li>
		 * <li>"number"</li>
		 * <li>"contact"</li>
		 * <li>"email"</li></ul>
		 * <p>These values serve as hints, to help a device display the best keyboard for the current operation.</p>
		 * @default SoftKeyboardType.DEFAULT
		 * @playerversion 3.0
		 */
		public var softKeyboardType:String = "default";
		
		
		/**@private*/
		private var _nativeTextInputDialog:NativeTextInputDialog;
		/**@private*/
		nativeDialogNamespace function setNativeTextInputDialog(value:NativeTextInputDialog):void
		{
			_nativeTextInputDialog = value;
		}
		
		/**
		 * The dialog in which the textinput is used;
		 */
		public function get nativeTextInputDialog():NativeTextInputDialog
		{
			return _nativeTextInputDialog;
		}
		/**
		 * Constructor.
		 * @param the name of the textfield by which the references are made. <b>Important:</b> Must be unique in the group
		 */
		public function NativeTextField(name:String)
		{
			this._name = name;
		}
	}
}