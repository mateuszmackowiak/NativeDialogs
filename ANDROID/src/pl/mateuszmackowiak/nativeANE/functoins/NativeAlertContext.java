package pl.mateuszmackowiak.nativeANE.functoins;

import java.util.HashMap;
import java.util.Map;

import pl.mateuszmackowiak.nativeANE.NativeDialogsExtension;
import android.annotation.SuppressLint;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.text.Html;
import android.util.Log;
import android.view.animation.Animation;
import android.view.animation.CycleInterpolator;
import android.view.animation.TranslateAnimation;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

/**
* @author Mateusz Mackowiak
*/
public class NativeAlertContext  extends FREContext {

	
	public static final String KEY = "NativeAlert";
	
	private AlertDialog alert = null;
	
	
	@Override
	public void dispose() 
	{
		Log.d(KEY, "Disposing Extension Context");
		
		if(alert!=null){
			alert.dismiss();
			alert = null;
		}
		NativeDialogsExtension.context = null;
	}

	/**
	 * Registers AS function name to Java Function Class
	 */
	@Override
	public Map<String, FREFunction> getFunctions() 
	{
		Log.d(KEY, "Registering Extension Functions");
		Map<String, FREFunction> functionMap = new HashMap<String, FREFunction>();
		functionMap.put(showAlertFunction.KEY, new showAlertFunction());
		functionMap.put(dismiss.KEY, new dismiss());
		functionMap.put(isShowing.KEY, new isShowing());
		functionMap.put(updateMessage.KEY, new updateMessage());
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
				if(alert!=null){
					
					Animation shake = new TranslateAnimation(0, 5, 0, 0);
				    shake.setInterpolator(new CycleInterpolator(5));
				    shake.setDuration(300);
				    alert.getCurrentFocus().startAnimation(shake);
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
				if(alert!=null){
					int v = args[0].getAsInt();
					NativeDialogsExtension.context.dispatchStatusEventAsync(NativeDialogsExtension.CLOSED,String.valueOf(v));        
					alert.dismiss();
					alert = null;
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
				if(alert!=null && alert.isShowing()){
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
	public class updateMessage implements FREFunction{
		public static final String KEY = "updateMessage";
		
		@Override
	    public FREObject call(FREContext context, FREObject[] args)
	    {
			try{
				String message="";
				message = args[0].getAsString();
				
				alert.setMessage(message);
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
				
				alert.setTitle(title);
			}catch (Exception e){
	        	context.dispatchStatusEventAsync(NativeDialogsExtension.ERROR_EVENT,String.valueOf(e));
	            e.printStackTrace();
	        }
			return null;
	    }
	}
	
	
	
	public class showAlertFunction implements FREFunction{
		public static final String KEY = "showAlertWithTitleAndMessage";
		
		@Override
	    public FREObject call(FREContext context, FREObject[] args)
	    {
	        String message="",title="",closeLabel="",otherLabel="";
	        boolean cancelable=false;
	        int theme=1;  
	        try{

	            title = args[0].getAsString();
	            message = args[1].getAsString();
	            closeLabel = args[2].getAsString();
	            otherLabel= args[3].getAsString();
			    cancelable= args[4].getAsBool();
				theme= args[5].getAsInt();
				if(alert!=null){
					alert.dismiss();
				}
				alert = creatAlert(context,message,title,closeLabel,otherLabel,cancelable,theme);
			    alert.show();
			    
			    context.dispatchStatusEventAsync(NativeDialogsExtension.OPENED,"-1");
			    
	        }catch (Exception e){
	        	context.dispatchStatusEventAsync(NativeDialogsExtension.ERROR_EVENT,String.valueOf(e));
	            e.printStackTrace();
	        }    
	        return null;
	    }
	}
	
	
	
	
	
	
	
	
	
	
	
	@SuppressLint("NewApi")
	private static AlertDialog creatAlert(FREContext context,String message,String title,String closeLabel,String otherLabel,boolean cancelable,int theme)
    {  
    	AlertDialog.Builder builder = (android.os.Build.VERSION.SDK_INT<11)?new AlertDialog.Builder(context.getActivity()): new AlertDialog.Builder(context.getActivity(),theme);
    	
    	builder.setCancelable(cancelable);
    	if(cancelable==true){
    		builder.setOnCancelListener(new CancelListener());
    	}
    	if (otherLabel==null || "".equals(otherLabel))
    	{
    		if(message!=null && !"".equals(message))
    			builder.setMessage(Html.fromHtml(message));
    		
    		if(title!=null && !"".equals(title)){
    			builder.setTitle(Html.fromHtml(title));
    			builder.setNeutralButton(closeLabel, new AlertListener());
    		}else{
    			builder.setCancelable(true);
    			builder.setOnCancelListener(new CancelListener());
    		}
    			
    	}
    	else
    	{
	    	String[] als = otherLabel.split(",");
	        if (als.length==1)
	        {
	        	if(title!=null && !"".equals(title))
	        		builder.setTitle(Html.fromHtml(title));
	        	if(message!=null && !"".equals(message))
	        		builder.setMessage(Html.fromHtml(message));
	        	builder.setPositiveButton(closeLabel, new AlertListener())
	                   .setNegativeButton(otherLabel, new AlertListener());
	        }
	        else
	        {
	        	if(title!=null && !"".equals(title) && message!=null && !"".equals(message))
	        		builder.setTitle(Html.fromHtml(title)+": "+Html.fromHtml(message));
	        	else if(title!=null && !"".equals(title))
	        		builder.setTitle(Html.fromHtml(title));
	        	else if(message!=null && !"".equals(message))
	        		builder.setTitle(Html.fromHtml(message));
	        		
	        	String[] als2 = new String[als.length+1];
	         	als2[0]=closeLabel;
	         	for (int i=0;i<als.length;i++)
	        		als2[i+1]=als[i];
	        	builder.setItems(als2, new AlertListener());
	        }
    	}
        return builder.create();
    }
	
	private static class CancelListener implements DialogInterface.OnCancelListener{
		public CancelListener()
    	{ 
    	}
        @Override
		public void onCancel(DialogInterface dialog) 
        {
        	NativeDialogsExtension.context.dispatchStatusEventAsync(NativeDialogsExtension.CLOSED,String.valueOf(-1));       
        	dialog.dismiss();
        	
        }
    }
    private static class AlertListener implements DialogInterface.OnClickListener
    {
    	AlertListener()
    	{
    	}
        @Override
		public void onClick(DialogInterface dialog, int id) 
        {
        	if(id==-1)
        		id=0;
        	else if(id==-2)
        		id=1;
        	else if(id==-3)
        		id=0;
        	NativeDialogsExtension.context.dispatchStatusEventAsync(NativeDialogsExtension.CLOSED,String.valueOf(id));        
            dialog.dismiss();
            
        }
    	
    }
}



