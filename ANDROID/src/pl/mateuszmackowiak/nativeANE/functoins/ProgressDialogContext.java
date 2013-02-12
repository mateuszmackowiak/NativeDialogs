package pl.mateuszmackowiak.nativeANE.functoins;

import java.util.HashMap;
import java.util.Map;

import pl.mateuszmackowiak.nativeANE.NativeDialogsExtension;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.text.Html;
import android.util.Log;
import android.view.animation.Animation;
import android.view.animation.CycleInterpolator;
import android.view.animation.TranslateAnimation;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

public class ProgressDialogContext extends FREContext {

	public static final String KEY = "ProgressContext";
	
	private ProgressDialog dialog = null;
	private int MAX_PROGRESS = 100;
	
	
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
		functionMap.put(updateMessage.KEY, new updateMessage());
		functionMap.put(setIndeterminate.KEY, new setIndeterminate());
		functionMap.put(updateSecondary.KEY, new updateSecondary());
		functionMap.put(updateProgress.KEY, new updateProgress());
		functionMap.put(setMax.KEY, new setMax());
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
				    
				}
			}catch (Exception e){
	        	//context.dispatchStatusEventAsync(NativeDialogsExtension.ERROR_EVENT,String.valueOf(e));
	            e.printStackTrace();
	        }
			return null;
	    }
	}
	
	public class setMax implements FREFunction{
		public static final String KEY = "setMax";
		
		@Override
	    public FREObject call(FREContext context, FREObject[] args)
	    {
			
			try{
				int max=0;
				max= args[0].getAsInt();
				if(max>=1)
					MAX_PROGRESS = max;
				if(dialog!=null && dialog.isIndeterminate()==false)
					dialog.setMax(max);
				
			}catch (Exception e){
	        	context.dispatchStatusEventAsync(NativeDialogsExtension.ERROR_EVENT,String.valueOf(e));
	            e.printStackTrace();
	        }
			return null;
	    }
	}
	
	
	public class updateProgress implements FREFunction{
		public static final String KEY = "updateProgress";
		
		@Override
	    public FREObject call(FREContext context, FREObject[] args)
	    {
			
			try{
				Integer progress = null;
				progress= args[0].getAsInt();
				if(dialog!=null && dialog.isIndeterminate()==false)
					dialog.setProgress(progress.intValue());
				
			}catch (Exception e){
	        	context.dispatchStatusEventAsync(NativeDialogsExtension.ERROR_EVENT,String.valueOf(e));
	            e.printStackTrace();
	        }
			return null;
	    }
	}
	
	public class updateSecondary implements FREFunction{
		public static final String KEY = "updateSecondary";
		
		@Override
	    public FREObject call(FREContext context, FREObject[] args)
	    {
			
			try{
				Integer secondaryProgress = null;
				secondaryProgress= args[0].getAsInt();
				if(dialog!=null && dialog.isIndeterminate()==false)
					dialog.setSecondaryProgress(secondaryProgress);
				
			}catch (Exception e){
	        	context.dispatchStatusEventAsync(NativeDialogsExtension.ERROR_EVENT,String.valueOf(e));
	            e.printStackTrace();
	        }
			return null;
	    }
	}
	
	
	public class setIndeterminate implements FREFunction{
		public static final String KEY = "setIndeterminate";
		
		@Override
	    public FREObject call(FREContext context, FREObject[] args)
	    {
			
			try{
				boolean indeterminate =false;
				indeterminate = args[0].getAsBool();
				if(dialog!=null)
					dialog.setIndeterminate(indeterminate);
				
			}catch (Exception e){
	        	context.dispatchStatusEventAsync(NativeDialogsExtension.ERROR_EVENT,String.valueOf(e));
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
	public class updateMessage implements FREFunction{
		public static final String KEY = "updateMessage";
		
		@Override
	    public FREObject call(FREContext context, FREObject[] args)
	    {
			try{
				String message="";
				message = args[0].getAsString();
				
				dialog.setMessage(message);
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
		public static final String KEY = "showProgressPopup";
		
		@Override
	    public FREObject call(FREContext context, FREObject[] args)
	    {
			try{
				String title="", message="";
				int style = ProgressDialog.STYLE_HORIZONTAL , theme = 0;
				Integer secondaryProgress = null,progress=null;
				int maxProgress;
				boolean cancleble = false,indeterminate =false;
				
				progress= args[0].getAsInt();
				secondaryProgress = args[1].getAsInt();
				style = args[2].getAsInt();
				title = args[3].getAsString();
				message = args[4].getAsString();
				
				maxProgress = args[5].getAsInt();
				cancleble = args[6].getAsBool();
				indeterminate = args[7].getAsBool();
				theme = args[8].getAsInt();
				if(dialog==null)
					dialog = createProgressDialog(context,style,progress,secondaryProgress,title,message,maxProgress,theme,cancleble,indeterminate);
				else{
					if(title!=null && !"".equals(title))
						dialog.setTitle(Html.fromHtml(title));
					if(message!=null && !"".equals(message))
						dialog.setTitle(Html.fromHtml(message));
					dialog.setProgress(progress);
					dialog.setCancelable(cancleble);
					if(cancleble==true)
						dialog.setOnCancelListener(new CancelListener());
					dialog.setIndeterminate(indeterminate);
					if(!indeterminate){
						if( maxProgress>=1)
							dialog.setMax(maxProgress);
			        	else
			        		dialog.setMax(MAX_PROGRESS);
					}
				}
				context.dispatchStatusEventAsync(NativeDialogsExtension.OPENED,"-1");
				dialog.show();
				
			    
			    
			}catch (Exception e){
	        	context.dispatchStatusEventAsync(NativeDialogsExtension.ERROR_EVENT,String.valueOf(e));
	            e.printStackTrace();
	        }
			return null;
	    }
	}
	
	
	
	
	public ProgressDialog createProgressDialog(FREContext context,int style,Integer progress,Integer secondaryProgress,String title,String message,int maxProgress,int theme,boolean cancleble,boolean indeterminate) {
		
		ProgressDialog mDialog = (android.os.Build.VERSION.SDK_INT<11)?new ProgressDialog(context.getActivity()):new ProgressDialog(context.getActivity(),theme);
		try{
			if(title!=null && !"".equals(title))
				mDialog.setTitle(Html.fromHtml(title));
			if(message!=null && !"".equals(message))
				mDialog.setMessage(Html.fromHtml(message));
			
	        mDialog.setProgressStyle(style);
	        if(style==ProgressDialog.STYLE_HORIZONTAL){
		        if(indeterminate==true){
		        	mDialog.setIndeterminate(indeterminate);
		        }else{
		        	if(maxProgress>=1)
		        		mDialog.setMax(maxProgress);
		        	else
		        		mDialog.setMax(MAX_PROGRESS);
		        	if(progress!=null)
		        		mDialog.setProgress(progress.intValue());
		        	if(secondaryProgress!=null)
			       		mDialog.setSecondaryProgress(secondaryProgress);
		        }
	        }
	       	mDialog.setCancelable(cancleble);
	       	
	       	mDialog.setOnCancelListener(new CancelListener());
		}catch (Exception e){
        	context.dispatchStatusEventAsync(NativeDialogsExtension.ERROR_EVENT,KEY+"   "+e.toString());
            e.printStackTrace();
        }
       	return mDialog;
	}
	
	private class CancelListener implements DialogInterface.OnCancelListener{
 
        @Override
		public void onCancel(DialogInterface dialog) 
        {
        	NativeDialogsExtension.context.dispatchStatusEventAsync(NativeDialogsExtension.CANCELED,"-1");
            dialog.dismiss();
        }
    }
}
