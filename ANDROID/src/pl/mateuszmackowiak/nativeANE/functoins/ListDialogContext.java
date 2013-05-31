package pl.mateuszmackowiak.nativeANE.functoins;

import java.util.HashMap;
import java.util.Map;

import pl.mateuszmackowiak.nativeANE.FREUtilities;
import pl.mateuszmackowiak.nativeANE.NativeDialogsExtension;
import android.annotation.SuppressLint;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.text.Html;
import android.util.Log;
import android.view.animation.Animation;
import android.view.animation.CycleInterpolator;
import android.view.animation.TranslateAnimation;

import com.adobe.fre.FREArray;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

public class ListDialogContext extends FREContext {

	public static final String KEY = "ListDialogContext";
	
	private AlertDialog dialog = null;
	
	@Override
	public void dispose() {
		Log.d(KEY, "Disposing Extension Context");
		
		if(dialog!=null){
			dialog.dismiss();
			dialog = null;
		}
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
					context.dispatchStatusEventAsync(NativeDialogsExtension.CLOSED,String.valueOf(v));        
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
				if(dialog!=null){
					boolean cancelable = args[0].getAsBool();
					dialog.setCancelable(cancelable);
					 if(cancelable==true){
						 dialog.setOnCancelListener(new CancelListener(context));
					 }
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
				if(dialog!=null){
					String title="";
					title = args[0].getAsString();
					
					dialog.setTitle(title);
				}
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
				String buttons[] = null, choices[] = null;
				boolean checkedItems[] = null,cancelable = false;
				Integer checkedItem = null;
				int theme = 2;
				
				title = args[0].getAsString();
		        
				if(args[1] instanceof FREArray)
		        	buttons = FREUtilities.convertFREArrayToStringArray((FREArray)args[1]);
				
		        if(args[2] instanceof FREArray)
		        	choices = FREUtilities.convertFREArrayToStringArray((FREArray)args[2]);
		        else
		        	context.dispatchStatusEventAsync(NativeDialogsExtension.ERROR_EVENT, "args[2] is not an array");
		        
		        
		        if(args[3]!=null && args[3] instanceof FREArray)
					checkedItems = FREUtilities.convertFREArrayToBooleadArray((FREArray)args[3]);
				else if(args[3]!=null)
		        	checkedItem = args[3].getAsInt();
		        else
					context.dispatchStatusEventAsync(NativeDialogsExtension.ERROR_EVENT, "args[3] is not an array");
		        
		        cancelable = args[4].getAsBool();
		        theme = args[5].getAsInt();
		        
		        if(dialog!=null){
		        	dialog.dismiss();
		        }
		        
	        	dialog = createPopup(context,title,buttons,choices,checkedItems,checkedItem,cancelable,theme);

	        	
				context.dispatchStatusEventAsync(NativeDialogsExtension.OPENED,"-1");
				dialog.show();
			}catch (Exception e){
	        	context.dispatchStatusEventAsync(NativeDialogsExtension.ERROR_EVENT,String.valueOf(e));
	            e.printStackTrace();
	        }
			return null;
	    }
	}

	
	
	
	
	
	@SuppressLint("NewApi")
	public static AlertDialog createPopup(FREContext frecontext, String title, String buttons[], CharSequence choices[],boolean checkedItems[],Integer checkedItem, boolean cancelable, int theme) {
		
		AlertDialog.Builder builder = (android.os.Build.VERSION.SDK_INT<11)?
				new AlertDialog.Builder(frecontext.getActivity())
				:new AlertDialog.Builder(frecontext.getActivity(),theme);
		
		try{
			if(title!=null && !"".equals(title))
				builder.setTitle(Html.fromHtml(title));
			
			builder.setCancelable(cancelable);
			if(cancelable==true)
				builder.setOnCancelListener(new CancelListener(frecontext));
			
			if(choices!=null && checkedItem!=null){
				builder.setSingleChoiceItems(choices, checkedItem.intValue(), new SingleChoiceClickListener(frecontext));
			}else if(choices!=null && (checkedItems==null || checkedItems.length == choices.length)){
				builder.setMultiChoiceItems(choices, checkedItems, new IndexChange(frecontext));
			}else
				frecontext.dispatchStatusEventAsync(NativeDialogsExtension.ERROR_EVENT, KEY+"  labels are empty or the list of labels is not equal to list of selected labels ");
			
			if(buttons!=null && buttons.length>0){
				builder.setPositiveButton(buttons[0], new ConfitmListener(frecontext,0,cancelable));
				if(buttons.length>1)
					builder.setNeutralButton(buttons[1], new ConfitmListener(frecontext,1,cancelable));
				if(buttons.length>2)
					builder.setNegativeButton(buttons[2], new ConfitmListener(frecontext,2,cancelable));
			}else
				builder.setPositiveButton("OK",new ConfitmListener(frecontext,0,cancelable));
			
		}catch(Exception e){
			frecontext.dispatchStatusEventAsync(NativeDialogsExtension.ERROR_EVENT,KEY+"   "+e.toString());
		}
		return builder.create();
	}
	
	
	
	private static class CancelListener implements DialogInterface.OnCancelListener{
		FREContext freContext;
		
		public CancelListener(FREContext freContext) {
			this.freContext = freContext;
		}
		
        @Override
		public void onCancel(DialogInterface dialog) 
        {
        	Log.e("List Dialog","onCancle");
        	freContext.dispatchStatusEventAsync(NativeDialogsExtension.CANCELED,String.valueOf(-1));   
     	   dialog.dismiss();
        }
    }
	private static class ConfitmListener implements DialogInterface.OnClickListener{
    	private int index;
    	private boolean cancelable;
    	FREContext freContext;
    	
    	ConfitmListener(FREContext context,int index,boolean cancelable)
    	{
    		this.freContext = context;
    		this.cancelable = cancelable;
    		this.index = index;
    	}
 
        @Override
		public void onClick(DialogInterface dialog,int id) 
        {
        	String event = NativeDialogsExtension.CLOSED;
        	if(cancelable && index == 1)
        	{
        		event = NativeDialogsExtension.CANCELED;
        	}
			freContext.dispatchStatusEventAsync(event,String.valueOf(index));//Math.abs(id-1)));
        	dialog.dismiss();
        }
    }
	
	private static class SingleChoiceClickListener implements DialogInterface.OnClickListener{
 
		FREContext freContext;
		
		
		public SingleChoiceClickListener(FREContext freContext) {
			this.freContext = freContext;
		}
		
        @Override
		public void onClick(DialogInterface dialog,int id) 
        {
        	freContext.dispatchStatusEventAsync(NativeDialogsExtension.LIST_CHANGE,String.valueOf(id));  
        }
    }
	
	
	private static class IndexChange implements DialogInterface.OnMultiChoiceClickListener{

		FREContext freContext;
		public IndexChange(FREContext freContext) {
			this.freContext = freContext;
		}
        @Override
		public void onClick(DialogInterface dialog,int id , boolean checked) 
        {
        	freContext.dispatchStatusEventAsync(NativeDialogsExtension.LIST_CHANGE,String.valueOf(id)+"_"+String.valueOf(checked));        
        }
    }
}
