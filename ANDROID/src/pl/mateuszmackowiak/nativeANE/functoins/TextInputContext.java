package pl.mateuszmackowiak.nativeANE.functoins;

import java.util.HashMap;
import java.util.Map;

import pl.mateuszmackowiak.nativeANE.FREUtilities;
import pl.mateuszmackowiak.nativeANE.NativeDialogsExtension;
import android.annotation.SuppressLint;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.text.Editable;
import android.text.Html;
import android.text.InputType;
import android.text.TextWatcher;
import android.util.Log;
import android.view.animation.Animation;
import android.view.animation.CycleInterpolator;
import android.view.animation.TranslateAnimation;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.TextView;

import com.adobe.fre.FREASErrorException;
import com.adobe.fre.FREArray;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREInvalidObjectException;
import com.adobe.fre.FRENoSuchNameException;
import com.adobe.fre.FREObject;
import com.adobe.fre.FRETypeMismatchException;
import com.adobe.fre.FREWrongThreadException;

public class TextInputContext extends FREContext {

	public static final String KEY = "TextInputDialogContext";
	
	private AlertDialog dialog = null;
	
	
	@Override
	public void dispose() {
		Log.d(KEY, "Disposing Extension Context");
		
		if(dialog!=null){
			dialog.dismiss();
			dialog = null;
		}
		NativeDialogsExtension.context = null;
	}

	@Override
	public Map<String, FREFunction> getFunctions() {
		
		Log.d(KEY, "Registering Extension Functions");
		Map<String, FREFunction> functionMap = new HashMap<String, FREFunction>();
		functionMap.put(show.KEY, new show());
		functionMap.put(dismiss.KEY, new dismiss());
		functionMap.put(isShowing.KEY, new isShowing());
		functionMap.put(setCancelable.KEY, new setCancelable());
		functionMap.put(updateTitle.KEY, new updateTitle());
		functionMap.put(shake.KEY, new shake());
		// add other functions here
		return functionMap;	
	}
	
	
	
	
	public class shake implements FREFunction{
		public static final String KEY = "shake";
		
		@Override
	    public FREObject call(FREContext context, FREObject[] args)
	    {
			
			try{
				if(dialog!=null){
					
					Animation shake = new TranslateAnimation(0, 5, 0, 0);
				    shake.setInterpolator(new CycleInterpolator(5));
				    shake.setDuration(300);
				    dialog.getCurrentFocus().startAnimation(shake);
				    //
				}
			}catch (Exception e){
	        	//context.dispatchStatusEventAsync(NativeDialogsExtension.ERROR_EVENT,String.valueOf(e));
	            e.printStackTrace();
	        }
			return null;
	    }
	}
	
	public class dismiss implements FREFunction{
		public static final String KEY = "dismiss";
		
		@Override
	    public FREObject call(FREContext context, FREObject[] args)
	    {
			
			try{
				if(dialog!=null){
					int v = args[0].getAsInt();
					NativeDialogsExtension.context.dispatchStatusEventAsync(NativeDialogsExtension.CLOSED,String.valueOf(v));

					dialog.dismiss();
					dialog = null;
				}
			}catch (Exception e){
	        	context.dispatchStatusEventAsync(NativeDialogsExtension.ERROR_EVENT,String.valueOf(e));
	            e.printStackTrace();
	        }
			return null;
	    }
	}
	public class isShowing implements FREFunction{
		public static final String KEY = "isShowing";
		
		@Override
	    public FREObject call(FREContext context, FREObject[] args)
	    {
			try{
				if(dialog!=null && dialog.isShowing()){
					return FREObject.newObject(true);	
				}
				return FREObject.newObject(false);
			}catch (Exception e){
	        	context.dispatchStatusEventAsync(NativeDialogsExtension.ERROR_EVENT,String.valueOf(e));
	            e.printStackTrace();
	        }
			return null;
	    }
	}
	
	public class setCancelable implements FREFunction{
		public static final String KEY = "setCancelable";
		
		@Override
	    public FREObject call(FREContext context, FREObject[] args)
	    {
			try{
				boolean cancelable = args[0].getAsBool();
				dialog.setCancelable(cancelable);
				 if(cancelable==true){
					 dialog.setOnCancelListener(new CancelListener());
				 }
			}catch (Exception e){
	        	context.dispatchStatusEventAsync(NativeDialogsExtension.ERROR_EVENT,String.valueOf(e));
	            e.printStackTrace();
	        }
			return null;
	    }
	}
	public class updateTitle implements FREFunction{
		public static final String KEY = "updateTitle";
		
		@Override
	    public FREObject call(FREContext context, FREObject[] args)
	    {
			try{
				String title="";
				title = args[0].getAsString();
				
				dialog.setTitle(title);
			}catch (Exception e){
	        	context.dispatchStatusEventAsync(NativeDialogsExtension.ERROR_EVENT,String.valueOf(e));
	            e.printStackTrace();
	        }
			return null;
	    }
	}
	
	
	
	
	
	
	
	
	public class show implements FREFunction{
		public static final String KEY = "show";
		
		@Override
	    public FREObject call(FREContext context, FREObject[] args)
	    {
			try{
				String title="";
				boolean cancelable=true;
				int theme = 1;
				
				String buttons[] = null;
				FREArray textInputs = null;
				
				title = args[0].getAsString();
				if(args[1] instanceof FREArray)
					textInputs = (FREArray) args[1];
				if(args.length>2){
					if(args[2]!=null && args[2] instanceof FREArray)
						buttons = FREUtilities.convertFREArrayToStringArray((FREArray)args[2]);
					if(args.length>3 && args[3]!=null)
						cancelable = args[3].getAsBool();
					if(args.length>4 && args[4]!=null)
						theme = args[4].getAsInt();
				}
				
				TextInputDialog textInputDialog = (android.os.Build.VERSION.SDK_INT<11)?
						new TextInputDialog(context.getActivity(),textInputs)
						:new TextInputDialog(context.getActivity(),textInputs,theme);

				if(title!=null)
					textInputDialog.setTitle(Html.fromHtml(title));
				
			    textInputDialog.setCancelable(cancelable);
			    if(cancelable==true)
			    	textInputDialog.setOnCancelListener(new CancelListener());

			    if(buttons!=null && buttons.length>0){
			    	textInputDialog.setPositiveButton(buttons[0], new ClickListener(textInputDialog,0));
					if(buttons.length>1)
						textInputDialog.setNeutralButton(buttons[1], new ClickListener(textInputDialog,1));
					if(buttons.length>2)
						textInputDialog.setNegativeButton(buttons[2], new ClickListener(textInputDialog,2));
				}else
					textInputDialog.setPositiveButton("OK",new ClickListener(textInputDialog,0));
			    
			    if(dialog!=null){
			    	dialog.dismiss();
			    }
			    dialog = textInputDialog.create();
			    context.dispatchStatusEventAsync(NativeDialogsExtension.OPENED,"-1");
			    dialog.show();
			    
			    
			}catch (Exception e){
	        	context.dispatchStatusEventAsync(NativeDialogsExtension.ERROR_EVENT,String.valueOf(e));
	            e.printStackTrace();
	        }
			return null;
	    }
	}
	
	
	
	
	
	
	
	
	
	
	
	
	private class CancelListener implements DialogInterface.OnCancelListener{
 
        @Override
		public void onCancel(DialogInterface dialog) 
        {
        	NativeDialogsExtension.context.dispatchStatusEventAsync(NativeDialogsExtension.CANCELED,String.valueOf(-1));        
	         //dialog.dismiss();
        }
    }
	
	

/////////////////////////////////////////
	
	@SuppressLint("NewApi")
	private class TextInputDialog extends AlertDialog.Builder{

		private TextInput textInputs[];

		
		public TextInputDialog(Context context,FREArray fretextFields) throws IllegalArgumentException, FREInvalidObjectException, FREWrongThreadException, IllegalStateException, FRETypeMismatchException, FREASErrorException, FRENoSuchNameException 
		{
			super(context);
			createContent(context,fretextFields);
		}
		public TextInputDialog(Context context,FREArray fretextFields, int theme) throws IllegalArgumentException, FREInvalidObjectException, FREWrongThreadException, IllegalStateException, FRETypeMismatchException, FREASErrorException, FRENoSuchNameException 
		{
			super(context,theme);
			createContent(context,fretextFields);
		}

		
		public void createContent(Context context,FREArray fretextFields) throws IllegalArgumentException, FREInvalidObjectException, FREWrongThreadException, IllegalStateException, FRETypeMismatchException, FREASErrorException, FRENoSuchNameException 
		{
			if(fretextFields==null)
				return;
			
			ScrollView sv = new ScrollView(context);
			LinearLayout ll = new LinearLayout(context);
			ll.setOrientation(LinearLayout.VERTICAL);
			sv.addView(ll);
			
			
			TextInput textInput = null;
			String name ="";
			boolean editable = false;
			
			int length = (int)fretextFields.getLength();
			
			textInputs = new TextInput[length];
			
			
			for (int i = 0; i < length; i++) {
				FREObject fretextField = fretextFields.getObjectAt(i);

				if(fretextField.getProperty("editable")!=null)
					editable = fretextField.getProperty("editable").getAsBool();
				
				if(editable){
					name = (fretextField.getProperty("name")!=null)?fretextField.getProperty("name").getAsString():"";
					if(name.length()>0){
						
						textInput =  new TextInput(context,name);
						
						if(fretextField.getProperty("text")!=null)
							textInput.setText(fretextField.getProperty("text").getAsString());
						
						if(fretextField.getProperty("prompText")!=null)
							textInput.setHint(fretextField.getProperty("prompText").getAsString());	
						
						textInput.setInputType(getInputType(fretextField));
						
						ll.addView(textInput);
						
						textInputs[i] = textInput;
					}
				}else if(fretextField.getProperty("text")!=null){
					TextView tv = new TextView(context);
					tv.setText(fretextField.getProperty("text").getAsString());
					ll.addView(tv);
				}
			}
			setView(sv);
		}
		
		/**
		 * @return the textInputs
		 */
		public TextInput[] getTextInputs() {
			return textInputs;
		}
		
	}
	
	public static int  getInputType(FREObject textField) throws IllegalStateException, FRETypeMismatchException, FREInvalidObjectException, FREASErrorException, FRENoSuchNameException, FREWrongThreadException{
		int type = 0x00000001;
		String softKeyboardType="default",autoCapitalize="none";
		boolean displayAsPassword=false,autoCorrect=false;
		
		if(textField.getProperty("softKeyboardType")!=null){
			softKeyboardType = textField.getProperty("softKeyboardType").getAsString();
			if(textField.getProperty("autoCapitalize")!=null)
				autoCapitalize = textField.getProperty("autoCapitalize").getAsString();
			if(textField.getProperty("displayAsPassword")!=null)
				displayAsPassword = textField.getProperty("displayAsPassword").getAsBool();
			if(textField.getProperty("autoCorrect")!=null)
				autoCorrect = textField.getProperty("autoCorrect").getAsBool();
			
			if("url".equals(softKeyboardType)){
				type = InputType.TYPE_TEXT_VARIATION_WEB_EDIT_TEXT;
				if(displayAsPassword)
					type = type | InputType.TYPE_TEXT_VARIATION_PASSWORD;
				if(autoCorrect)
					type = type | InputType.TYPE_TEXT_FLAG_AUTO_CORRECT;
				
				if("word".equals(autoCapitalize))
					type = type | InputType.TYPE_TEXT_FLAG_CAP_WORDS;
				else if("sentence".equals(autoCapitalize))
					type = type | InputType.TYPE_TEXT_FLAG_CAP_SENTENCES;
				else if("all".equals(autoCapitalize))
					type = type | InputType.TYPE_TEXT_FLAG_CAP_CHARACTERS;
				
			}else if("number".equals(softKeyboardType)){
				type = InputType.TYPE_CLASS_NUMBER;
				if(displayAsPassword)
					type = type | InputType.TYPE_NUMBER_VARIATION_PASSWORD;
			}else if("contact".equals(softKeyboardType)){
				type = InputType.TYPE_CLASS_PHONE;
				if(displayAsPassword)
					type = type | InputType.TYPE_NUMBER_VARIATION_PASSWORD;
				
			}else if("email".equals(softKeyboardType)){
				type = InputType.TYPE_TEXT_VARIATION_EMAIL_ADDRESS;
				if(displayAsPassword)
					type = type | InputType.TYPE_TEXT_VARIATION_PASSWORD;
				if(autoCorrect)
					type = type | InputType.TYPE_TEXT_FLAG_AUTO_CORRECT;
				
				if("word".equals(autoCapitalize))
					type = type | InputType.TYPE_TEXT_FLAG_CAP_WORDS;
				else if("sentence".equals(autoCapitalize))
					type = type | InputType.TYPE_TEXT_FLAG_CAP_SENTENCES;
				else if("all".equals(autoCapitalize))
					type = type | InputType.TYPE_TEXT_FLAG_CAP_CHARACTERS;
			}else{
				type = InputType.TYPE_CLASS_TEXT;
				if(displayAsPassword)
					type = type | InputType.TYPE_TEXT_VARIATION_PASSWORD;
				if(autoCorrect)
					type = type | InputType.TYPE_TEXT_FLAG_AUTO_CORRECT;
				
				
				if("word".equals(autoCapitalize))
					type = type | InputType.TYPE_TEXT_FLAG_CAP_WORDS;
				else if("sentence".equals(autoCapitalize))
					type = type | InputType.TYPE_TEXT_FLAG_CAP_SENTENCES;
				else if("all".equals(autoCapitalize))
					type = type | InputType.TYPE_TEXT_FLAG_CAP_CHARACTERS;
			}
		}
		return type;
	}

	
	
	private class TextInput extends EditText{
		
		String name="";
		CustomTextWatcher watcher;
		TextInput(Context activity,String _name)
		{
			super(activity);
			name = _name; 
			watcher = new CustomTextWatcher(this);
			addTextChangedListener(watcher);
			
		}
		public void removeWacher(){
			removeTextChangedListener(watcher);
		}
	}
	
	private class CustomTextWatcher implements TextWatcher {
	    private TextInput mEditText;
	    
	    public CustomTextWatcher(TextInput e) {
	        mEditText = e;
	    }
	    
	    @Override
		public void beforeTextChanged(CharSequence s, int start, int count, int after) {
	    }

	    @Override
		public void onTextChanged(CharSequence s, int start, int before, int count) {
	    	String ret=String.valueOf(mEditText.name+"#_#"+mEditText.getText().toString());
	    	NativeDialogsExtension.context.dispatchStatusEventAsync("change",ret);  
	    }

	    @Override
		public void afterTextChanged(Editable s) {
	    }
	}
	
	
	
	
	
	private class ClickListener implements DialogInterface.OnClickListener
	{
    	private TextInputDialog dlg;
    	private int index;
    	
    	ClickListener(TextInputDialog dlg,int index)
    	{
    		this.dlg = dlg;
    		this.index = index;
    	}
 
        @Override
		public void onClick(DialogInterface dialog,int id) 
        {
        	try{
        		Object obj  = NativeDialogsExtension.context.getActivity().getSystemService(Context.INPUT_METHOD_SERVICE);
        		if(obj!=null && obj instanceof InputMethodManager){
		        	InputMethodManager imm = (InputMethodManager)obj;
		        	if(imm.isActive()){
		        		for (TextInput textinput : dlg.getTextInputs()) {
		        			if(textinput!=null)
		        				imm.hideSoftInputFromWindow(textinput.getWindowToken(), 0);
						}
		        	}
		        	
		        	
		        	for (TextInput textinput : dlg.getTextInputs()) {
		        		if(textinput!=null){
		        			textinput.removeWacher();
		        		}
					}

		        	NativeDialogsExtension.context.dispatchStatusEventAsync(NativeDialogsExtension.CLOSED,String.valueOf(index));//Math.abs(id)));
		            dialog.dismiss();
        		}
        	}catch(Exception e){
        		NativeDialogsExtension.context.dispatchStatusEventAsync(NativeDialogsExtension.ERROR_EVENT,e.toString());
                e.printStackTrace();
        	}
        	//_freContext = null;
        }
    }
}
