package pl.mateuszmackowiak.nativeANE.functoins;

import java.util.HashMap;
import java.util.Map;

import pl.mateuszmackowiak.nativeANE.NativeDialogsExtension;

import android.content.Context;
import android.text.Html;
import android.util.Log;
import android.widget.Toast;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

public class ToastContext extends FREContext{

	public static final String KEY = "ToastContext";
	
	
	@Override
	public void dispose() {
		Log.d(KEY, "Disposing Extension Context");
		
		NativeDialogsExtension.context = null;
	}

	@Override
	public Map<String, FREFunction> getFunctions() {
		
		Log.d(KEY, "Registering Extension Functions");
		Map<String, FREFunction> functionMap = new HashMap<String, FREFunction>();
		functionMap.put(showToast.KEY, new showToast());
		
		// add other functions here
		return functionMap;	
	}
	
	
	public class showToast implements FREFunction{
		public static final String KEY = "Toast";
		
		@Override
	    public FREObject call(FREContext freContext, FREObject[] args)
	    {
			
			try{
				String text = "";
				int duration = Toast.LENGTH_SHORT;
				Integer gravity=null;
				int xOffset=0,yOffset=0;
			
				text = args[0].getAsString();
				if(args.length>1 && args[1]!=null)
					duration = args[1].getAsInt();
				if(args.length>2){
					gravity = args[2].getAsInt();
					xOffset = args[3].getAsInt();
					yOffset = args[4].getAsInt();
				}
				
				Context context = freContext.getActivity().getApplicationContext();

				Toast toast = Toast.makeText(context, Html.fromHtml(text), duration);
				if(gravity!=null)
					toast.setGravity(gravity.intValue(), xOffset, yOffset);
			
				toast.show();
			}catch (Exception e){
				freContext.dispatchStatusEventAsync(NativeDialogsExtension.ERROR_EVENT,String.valueOf(e));
	            e.printStackTrace();
	        }
			return null;
	    }
	}
}
