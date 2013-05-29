/**
 * 
 */
package pl.mateuszmackowiak.nativeANE.functoins;

import java.util.HashMap;
import java.util.Map;

import pl.mateuszmackowiak.nativeANE.NativeDialogsExtension;

import android.app.Dialog;
import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

/**
* @author Mateusz Mackowiak
*/
public class NativePickerDialogContext extends FREContext{

	public static final String KEY = "NativePickerDialogContext";
	
	private Dialog dialog = null;

	
	@Override
	public void dispose() 
	{
		Log.d(KEY, "Disposing Extension Context");
		
		if(dialog!=null){
			dialog.dismiss();
			dialog = null;
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
		functionMap.put(show.KEY, new show());
		functionMap.put(dismiss.KEY, new dismiss());
		functionMap.put(isShowing.KEY, new isShowing());
		functionMap.put(setSelectedIndex.KEY, new setSelectedIndex());
		// add other functions here
		return functionMap;	
	}
	
	
	
	public class setSelectedIndex implements FREFunction {
		public static final String KEY = "setSelectedIndex";

		@Override
		public FREObject call(FREContext context, FREObject[] args) {
			try {
//TODO:
				

			} catch (Exception e) {
				context.dispatchStatusEventAsync(NativeDialogsExtension.ERROR_EVENT, KEY +String.valueOf(e));
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
	
	public class show implements FREFunction{
		public static final String KEY = "show";
		
		@Override
	    public FREObject call(FREContext context, FREObject[] args)
	    {
	        String message="",title="";
	        boolean cancelable=false;
	        int theme=1;  
	        try{

	            title = args[0].getAsString();
	            message = args[1].getAsString();
	            
	            cancelable= args[4].getAsBool();
				theme= args[5].getAsInt();
	           
				if(dialog!=null){
					dialog.dismiss();
				}
				dialog = creatAlert(context,message,title,cancelable,theme);
				dialog.show();
			    
			    context.dispatchStatusEventAsync(NativeDialogsExtension.OPENED,"-1");
			    
	        }catch (Exception e){
	        	context.dispatchStatusEventAsync(NativeDialogsExtension.ERROR_EVENT,String.valueOf(e));
	            e.printStackTrace();
	        }    
	        return null;
	    }
	}
	
	
	
	
	
	
	private static Dialog creatAlert(FREContext context,String message,String title  ,boolean cancelable,int theme)
	{
		Dialog d = new Dialog(context.getActivity());
		return d;
	}
}
