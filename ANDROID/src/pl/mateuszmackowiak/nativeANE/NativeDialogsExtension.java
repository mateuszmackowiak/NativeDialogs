package pl.mateuszmackowiak.nativeANE;

import pl.mateuszmackowiak.nativeANE.functoins.DatePickerDialogContext;
import pl.mateuszmackowiak.nativeANE.functoins.ListDialogContext;
import pl.mateuszmackowiak.nativeANE.functoins.NativeAlertContext;
import pl.mateuszmackowiak.nativeANE.functoins.NativePickerDialogContext;
import pl.mateuszmackowiak.nativeANE.functoins.ProgressDialogContext;
import pl.mateuszmackowiak.nativeANE.functoins.TextInputContext;
import pl.mateuszmackowiak.nativeANE.functoins.ToastContext;
import android.content.pm.PackageInfo;
import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;

public class NativeDialogsExtension implements FREExtension 
{
	
	public static final String ERROR_EVENT = "error";
	
	
	public static final String CLOSED ="nativeDialog_closed";
	public static final String OPENED ="nativeDialog_opened";
	public static final String CANCELED ="nativeDialog_canceled";
	
	public static final String LIST_CHANGE = "nativeListDialog_change";
	
	public static final String DATE_CHANGED = "change";
	
	
	private static String TAG = "[NativeDialogs]";

	public FREContext context;
	
	/**
	 * Create the context (AS to Java).
	 */
	public FREContext createContext(String extId)
	{
		Log.d(TAG, "Extension.createContext extId: " + extId);
		System.setProperty("log.tag."+DatePickerDialogContext.KEY, "VERBOSE");

		if(ProgressDialogContext.KEY.equals(extId))
			return context = new ProgressDialogContext();
		
		else if(ToastContext.KEY.equals(extId))
			return context = new ToastContext();
		
		else if(TextInputContext.KEY.equals(extId))
			return context = new TextInputContext();
		
		else if(ListDialogContext.KEY.equals(extId))
			return context = new ListDialogContext();
		
		else if(ListDialogContext.KEY.equals(extId))
			return context = new ListDialogContext();
		
		else if(DatePickerDialogContext.KEY.equals(extId))
			return context = new DatePickerDialogContext();
		
		else if(NativePickerDialogContext.KEY.equals(extId))
			return context = new NativePickerDialogContext();
		
		else
			return context = new NativeAlertContext();
		
	}

	
	
	public static Boolean isDebbuger(FREContext context){
		try {
			PackageInfo pInfo = context.getActivity().getPackageManager().getPackageInfo(context.getActivity().getPackageName(), 0);
	    	if(pInfo.packageName.indexOf("debug")>-1)
	    		return true;
		} catch (Exception e) {
			Log.d(TAG, e.toString());
			
		}
    	return false;
	}
	/**
	 * Dispose the context.
	 */
	public void dispose() 
	{
		Log.d(TAG, "Extension.dispose");
		if(context!=null)
			context.dispose();
		context = null;
	}
	
	/**
	 * Initialize the context.
	 * Doesn't do anything for now.
	 */
	public void initialize() 
	{
		Log.d(TAG, "Extension.initialize");
	}
}
