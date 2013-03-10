# Native Dialogs - Adobe air Native Extension #
=============

Adobe Air Native Extension for mobile native dialogs (IOS,Andoid) - Toast, Text Input dialog, Progress dialog, Alert dialog, multi single choice dialog + DatePicker dialog


***
If You like what I make please donate:
[![Foo](https://www.paypalobjects.com/en_GB/i/btn/btn_donate_SM.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=CMYHNG32SVXZ4)
***

Before creating an Issue. Please:
- Please make sure that Your code is not the reason of the error.
- On Android: Try downloading the Android sdk and use "androidSDK/platform-tools/adb logcat" to pin to the android logs of the device. If something goes wrong there should be some output.
- On IOS: To see the answers of the console with the terminal (IOS Simulator) type: "tail -f /var/log/system.log" in the console. To see it on the device download form the app store a free app "Console" and if the app crashes go to the app.
- Please send part of Your code that causes the problem.


## NativeDatePickerDialog (IOS/Andorid) ##

	Displays a native date-picker dialog.
  
*Usage*

		protected function showDatePicker():void
		{
			var d:NativeDatePickerDialog = new NativeDatePickerDialog();
			d.addEventListener(NativeDialogEvent.CLOSED,onCloseDialog);
			d.addEventListener(NativeDialogEvent.CANCELED,trace);
			d.addEventListener(NativeDialogEvent.OPENED,trace);
			d.addEventListener(Event.CHANGE,function(event:Event):void
			{
				var n:NativeDatePickerDialog = NativeDatePickerDialog(event.target);
				trace(event);
				trace("Date set to:"+String(n.date));
			});
			d.buttons = Vector.<String>(["Cancle","OK"]);
			d.displayMode = NativeDatePickerDialog.DISPLAY_MODE_DATE_AND_TIME;
			d.title = "DatePicker";
			d.message = "Select date:";
			d.show(false);
		}
		private function onCloseDialog(event:NativeDialogEvent):void
		{
			var m:iNativeDialog = iNativeDialog(event.target);
			m.removeEventListener(NativeDialogEvent.CLOSED,onCloseDialog);
			trace(event);
			m.dispose();//Must be called if not used again
		}


## NativeAlertDialog (IOS/Android) ##

	Displays a native alert dialog.

*Usage:*

	private function showAler(){
		NativeAlert.show( "some message" , "title" , "first button label" , "otherButtons,LabelsSeperated,WithAComma", someAnswerFunction);
	}
	private function someAnswerFunction(event:NativeDialogEvent):void{
		//event.preventDefault(); 

		// IMPORTANT: 
		//default behavior is to remove the default listener "someAnswerFunction()" and to call the dispose()
		//
		trace(event);
	}



	/*
		var a:NativeAlertDialog = new NativeAlertDialog();
		a.addEventListener(NativeDialogEvent.OPENED,trace);


		 // This solution (a.closeHandler) is added only in NativeAlertDialog class to create a default handler.
		 // By default the dialog will be desposed using this method
		a.closeHandler = function(e:NativeDialogEvent):void{ 
			trace(e);
		};

		a.title = "Title";
		a.message = "Some message.";
		a.closeLabel = "OK";
		a.show();

	*/



# NativeProgressDialog (Android / IOS) #
	Displays a progress dialog.

Some help provided by [memeller](https://github.com/memeller)

Available themes for IOS:

* IOS\_SVHUD\_BLACK\_BACKGROUND\_THEME - uses [SVProgressHUD](http://github.com/samvermette/SVProgressHUD)
* IOS\_SVHUD\_NON\_BACKGROUND\_THEME - uses [SVProgressHUD](http://github.com/samvermette/SVProgressHUD)
* IOS\_SVHUD\_GRADIENT\_BACKGROUND\_THEME - uses [SVProgressHUD](http://github.com/samvermette/SVProgressHUD)
* DEFAULT\_THEME (cancleble is ignored)


*Usage:*

	private var progressPopup:NativeProgressDialog;
	private var myTimer:Timer = new Timer(100);

	protected function showProgressDialog():void
	{
    	var p:NativeProgressDialog= new NativeProgressDialog();
		p.addEventListener(NativeDialogEvent.CLOSED,onCloseDialog);
		p.addEventListener(NativeDialogEvent.CANCELED,trace);
		p.addEventListener(NativeDialogEvent.OPENED,trace);
		p.secondaryProgress = 45;
		p.max = 50;
		p.title = "Title";
		p.message ="Message";
		p.showProgressbar();
				
		progressPopup = p;

		myTimer.addEventListener(TimerEvent.TIMER, updateProgress);
		myTimer.start();
	}

	private function onCloseDialog(event:NativeDialogEvent):void
	{
		var m:iNativeDialog = iNativeDialog(event.target);
		m.removeEventListener(NativeDialogEvent.CLOSED,onCloseDialog);
		trace(event);
		m.dispose();
	}



	private function updateProgress(event:TimerEvent):void
	{
    	var p:int = progressPopup.progress;
		p++;
		if(p>=50){
			p = 0;
			progressPopup.hide(1);
			myTimer.removeEventListener(TimerEvent.TIMER,updateProgress);
			(event.target as Timer).stop();
		}
		else{
			if(p==25){
				progressPopup.shake();
				//progressPopup.setMessage("some message changed in between");
				//progressPopup.setTitle("some title changed in between");
			}
			try{
				progressPopup.setProgress(p);
			}catch(e:Error){
				trace(e);
			}
		}
	}




# NativeListDialog(Android / IOS) #
	Displays a native popup dialog with a multi-choice or single-choice list.

IOS uses: [SBTableAlert](https://github.com/blommegard/SBTableAlert)

*Usage:*

		private function showMultiChoiceDialog():void{
			var m:NativeListDialog = new NativeListDialog();
				
			m.addEventListener(NativeDialogEvent.CANCELED,trace);
			m.addEventListener(NativeDialogEvent.OPENED,trace);
			m.addEventListener(NativeDialogEvent.CLOSED,readSelected);
			m.addEventListener(NativeDialogListEvent.LIST_CHANGE,function(event:NativeDialogListEvent):void
			{
				trace(event);
				var m:iNativeDialog = iNativeDialog(event.target);
				m.shake();
			});
				
			m.buttons = Vector.<String> (["OK","Cancle"]);
			m.title = "Title";
			m.message = "Message";
			m.dataProvider = Vector.<Object>(["one","two","three"]);
			m.displayMode = NativeListDialog.DISPLAY_MODE_MULTIPLE;
			m.show();
		}


		protected function showSingleChoiceDialog(event:MouseEvent):void
		{
			var m:NativeListDialog = new NativeListDialog();

			m.addEventListener(NativeDialogEvent.CANCELED,trace);
			m.addEventListener(NativeDialogEvent.OPENED,trace);
			m.addEventListener(NativeDialogEvent.CLOSED,readSelected);
			m.addEventListener(NativeDialogListEvent.LIST_CHANGE,trace);
				
			m.buttons = Vector.<String> (["OK","Cancle"]);
			m.title = "Title";
			m.message = "Message";
			m.dataProvider = Vector.<Object>(["one","two","three"]);
			m.displayMode = NativeListDialog.DISPLAY_MODE_SINGLE;
			m.show();
		}



		private function readSelected(event:NativeDialogEvent):void
		{
			var m:NativeListDialog = NativeListDialog(event.target);
				
			trace(event);
			trace("selectedIndex: "+m.selectedIndex);
			trace("selectedIndexes: "+m.selectedIndexes);
			trace("selectedItem: "+m.selectedItem);
			trace("selectedItems: "+m.selectedItems);
				
			m.dispose();
		}
		private function onCloseDialog(event:NativeDialogEvent):void
		{
			var m:iNativeDialog = iNativeDialog(event.target);
			m.removeEventListener(NativeDialogEvent.CLOSED,onCloseDialog);
			trace(event);
			m.dispose();
		}






# Text input Dialog (Android /IOS) #
	Displays a dialog with defined text-fields..

 (on IOS 5 uses default dialog) - on ios 4 don't know if Apple will not refuses
###Important:###
IOS limitations -  There can be only 2 buttons and 2 text inputs.

To display message specyfie for the first NativeTextField editable == false

*Usage:*

	protected function showTextInput():void
	{
		var t:NativeTextInputDialog = new NativeTextInputDialog();
		t.addEventListener(NativeDialogEvent.CANCELED,trace);
		t.addEventListener(NativeDialogEvent.CLOSED,onCloseDialog);
				
		var v:Vector.<NativeTextField> = new Vector.<NativeTextField>();
		
		//creates a message text-field	
		var message:NativeTextField = new NativeTextField(null);
		message.text = "Message";
		message.editable = false;
		v.push(message);
		
		// create text-input
		var serverAdressTextInput:NativeTextField = new NativeTextField("serverAdress");
		serverAdressTextInput.displayAsPassword = true;
		serverAdressTextInput.prompText = "prompt";
		serverAdressTextInput.softKeyboardType = SoftKeyboardType.URL;
		serverAdressTextInput.addEventListener(Event.CHANGE,function(event:Event):void{
			var tf:NativeTextField = NativeTextField(event.target);
			tf.nativeTextInputDialog.shake();
		});
		// on return click
		serverAdressTextInput.addEventListener(TextEvent.TEXT_INPUT,function(event:Event):void{
			var tf:NativeTextField = NativeTextField(event.target);
			tf.nativeTextInputDialog.hide(0);
		});
		v.push(serverAdressTextInput);
				
		t.textInputs = v;
		t.title = "Title";
		t.show();
				
	}

	private function onCloseDialog(event:NativeDialogEvent):void
	{
		var m:iNativeDialog = iNativeDialog(event.target);
		m.removeEventListener(NativeDialogEvent.CLOSED,onCloseDialog);
		trace(event);
		m.dispose();
	}




# Toast (Android / IOS) #

![](https://github.com/mateuszmackowiak/NativeAlert/raw/master/images/AndoridToast.png)

For IOS uses : [WToast](https://github.com/Narmo/WToast)

*Usage:*

	Toast.show("some message",Toast.LENGTH_LONG);







##License
This project made available under the MIT License.

Copyright (C) 2013 Mateusz Maćkowiak

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
