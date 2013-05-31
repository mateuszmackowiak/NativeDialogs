/**
 * 
 */
package pl.mateuszmackowiak.nativeANE.functoins;

import java.util.HashMap;
import java.util.Map;

import kankan.wheel.widget.OnWheelChangedListener;
import kankan.wheel.widget.WheelView;
import kankan.wheel.widget.adapters.ArrayWheelAdapter;

import pl.mateuszmackowiak.nativeANE.FREUtilities;
import pl.mateuszmackowiak.nativeANE.NativeDialogsExtension;


import android.annotation.SuppressLint;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.text.Html;
import android.util.Log;
import android.view.Gravity;
import android.view.ViewGroup.LayoutParams;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;

import com.adobe.fre.FREASErrorException;
import com.adobe.fre.FREArray;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREInvalidObjectException;
import com.adobe.fre.FRENoSuchNameException;
import com.adobe.fre.FREObject;
import com.adobe.fre.FRETypeMismatchException;
import com.adobe.fre.FREWrongThreadException;


/**
* @author Mateusz Mackowiak
*/
@SuppressLint("NewApi")
public class NativePickerDialogContext extends FREContext{

	public static final String KEY = "PickerDialogContext";
	
	private AlertDialog dialog = null;
	private PickerDialog pickerDialog = null;
	
	@Override
	public void dispose() 
	{
		Log.d(KEY, "Disposing Extension Context");
		pickerDialog = null;
		if(dialog!=null){
			dialog.dismiss();
			dialog = null;
		}
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
		functionMap.put(setCancelable.KEY, new setCancelable());
		functionMap.put(updateTitle.KEY, new updateTitle());
		// add other functions here
		return functionMap;	
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
	
	
	public class setSelectedIndex implements FREFunction {
		public static final String KEY = "setSelectedIndex";

		@Override
		public FREObject call(FREContext context, FREObject[] args) {
			try {
				int pickerIndex = args[0].getAsInt();
				int index = args[1].getAsInt();
				
				if(pickerDialog!=null){
					WheelView[] pickers = pickerDialog.getPickers();
					if(pickers!=null && pickerIndex>=0 && pickerIndex<pickers.length){
						pickers[pickerIndex].setCurrentItem(index);
					}
				}
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
	
	public class show implements FREFunction{
		public static final String KEY = "show";
		
		@Override
	    public FREObject call(FREContext frecontext, FREObject[] args)
	    {
	        String message="",title="";
	        String buttons[] = null;
	        FREArray options;
	        int[] selections;
	        double[] widths;
	        
	        boolean cancelable=false;
	        int theme=1;  
	        try{

	            title = args[0].getAsString();
	            message = args[1].getAsString();
	            buttons = FREUtilities.convertFREArrayToStringArray((FREArray)args[2]);
	            options = (FREArray)args[3];
	            selections =FREUtilities.convertFREArrayToIntArray((FREArray)args[4]);
	            widths = FREUtilities.convertFREArrayToDoubleArray((FREArray)args[5]);
	            cancelable= args[6].getAsBool();
				theme= args[7].getAsInt();
	           
				
				
				PickerDialog pickerDialog = (android.os.Build.VERSION.SDK_INT<11)?
						new PickerDialog(frecontext,frecontext.getActivity(),title, message,options,selections,widths,theme)
						:new PickerDialog(frecontext,frecontext.getActivity(),title, message,options,selections,widths,theme);

				if(title!=null)
					pickerDialog.setTitle(Html.fromHtml(title));
				
			    pickerDialog.setCancelable(cancelable);
			    if(cancelable==true)
			    	pickerDialog.setOnCancelListener(new CancelListener(frecontext));

			    if(buttons!=null && buttons.length>0){
			    	pickerDialog.setPositiveButton(buttons[0], new ClickListener(frecontext,0));
					if(buttons.length>1)
						pickerDialog.setNeutralButton(buttons[1], new ClickListener(frecontext,1));
					if(buttons.length>2)
						pickerDialog.setNegativeButton(buttons[2], new ClickListener(frecontext,2));
				}else
					pickerDialog.setPositiveButton("OK",new ClickListener(frecontext,0));
			    
			    if(dialog!=null){
			    	dialog.dismiss();
			    }
			    dialog = pickerDialog.create();
			    frecontext.dispatchStatusEventAsync(NativeDialogsExtension.OPENED,"-1");
			    dialog.show();
			    
			    frecontext.dispatchStatusEventAsync(NativeDialogsExtension.OPENED,"-1");
			    
	        }catch (Exception e){
	        	frecontext.dispatchStatusEventAsync(NativeDialogsExtension.ERROR_EVENT,String.valueOf(e));
	            e.printStackTrace();
	        }    
	        return null;
	    }
	}
	
	
	public class setCancelable implements FREFunction{
		public static final String KEY = "setCancelable";
		
		@Override
	    public FREObject call(FREContext frecontext, FREObject[] args)
	    {
			try{
				if(dialog!=null){
					boolean cancelable = args[0].getAsBool();
					dialog.setCancelable(cancelable);
					 if(cancelable==true){
						 dialog.setOnCancelListener(new CancelListener(frecontext));
					 }
				}
			}catch (Exception e){
	        	frecontext.dispatchStatusEventAsync(NativeDialogsExtension.ERROR_EVENT,String.valueOf(e));
	            e.printStackTrace();
	        }
			return null;
	    }
	}
	
	
	private static class CancelListener implements DialogInterface.OnCancelListener{
		FREContext frecontext;
		public CancelListener(FREContext frecontext)
		{
			super();
			this.frecontext = frecontext;
		}
        @Override
		public void onCancel(DialogInterface dialog) 
        {
        	Log.e(KEY,"onCancle");
        	frecontext.dispatchStatusEventAsync(NativeDialogsExtension.CANCELED,String.valueOf(-1));   
        }
    }
	
	private class ClickListener implements DialogInterface.OnClickListener
	{
    	private int index;
    	FREContext frecontext;
    	
    	
    	
    	ClickListener(FREContext frecontext,int index)
    	{
    		this.index = index;
    		this.frecontext = frecontext;
    	}
 
        @Override
		public void onClick(DialogInterface dialog,int id) 
        {
        	try{
	        	frecontext.dispatchStatusEventAsync(NativeDialogsExtension.CLOSED,String.valueOf(index));//Math.abs(id)));
	            dialog.dismiss();
        	}catch(Exception e){
        		frecontext.dispatchStatusEventAsync(NativeDialogsExtension.ERROR_EVENT,e.toString());
                e.printStackTrace();
        	}
        	//_freContext = null;
        }
    }
	
	
	private class PickerDialog extends AlertDialog.Builder{

		private WheelView [] pickers;
		
		public PickerDialog(FREContext freContext,Context context ,String title,String message,FREArray pickerLists, int[] selections , double [] widths) throws IllegalArgumentException, FREInvalidObjectException, FREWrongThreadException, IllegalStateException, FRETypeMismatchException, FREASErrorException, FRENoSuchNameException 
		{
			super(context);
			createContent(freContext,context,title, message,pickerLists,selections,widths,-1);
		}
		public PickerDialog(FREContext freContext,Context context,String title,String message,FREArray pickerLists, int[] selections , double [] widths, int theme) throws IllegalArgumentException, FREInvalidObjectException, FREWrongThreadException, IllegalStateException, FRETypeMismatchException, FREASErrorException, FRENoSuchNameException 
		{
			super(context,theme);
			createContent(freContext,context,title, message,pickerLists,selections,widths,theme);
		}
		
		public WheelView [] getPickers(){
			return pickers;
		}
		
		public void createContent(FREContext freContext,Context context,String title,String message,FREArray pickerLists, int[] selections , double [] widths, int theme) throws IllegalArgumentException, FREInvalidObjectException, FREWrongThreadException, IllegalStateException, FRETypeMismatchException, FREASErrorException, FRENoSuchNameException 
		{
			if(title!=null){
				this.setTitle(title);
			}
			RelativeLayout rl = new RelativeLayout(context);
			
			
			LinearLayout ll = new LinearLayout(context);
			ll.setLayoutParams(new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT));
			ll.setOrientation(LinearLayout.HORIZONTAL);
			ll.setGravity(Gravity.CENTER_HORIZONTAL);
			
			int length = (int)pickerLists.getLength();
			
			pickers = new WheelView [length];
			
			WheelView pickerView;
			ArrayWheelAdapter<String> adapter;
			String [] values;
			int selectedValue = -1;
			
			for (int i = 0; i < length; i++) {
				values = FREUtilities.convertFREArrayToStringArray((FREArray)pickerLists.getObjectAt(i));
				pickerView = new WheelView(context);
				
				
				pickers[i] = pickerView;
				
				adapter = new ArrayWheelAdapter<String>(context, values);
				adapter.setTextSize(18);
				pickerView.setViewAdapter(adapter);
				
				
				if(theme==AlertDialog.THEME_HOLO_DARK || theme== AlertDialog.THEME_DEVICE_DEFAULT_DARK){
					pickerView.setSelectionOverlineVisible(false);
					pickerView.setShadowVisible(false);
					pickerView.setSelectionLineColor(0xFF33B5E5);
					
					adapter.setTextColor(0xFFFFFFFF);
				
				}else if(theme==AlertDialog.THEME_HOLO_LIGHT || theme== AlertDialog.THEME_DEVICE_DEFAULT_LIGHT){
					pickerView.setSelectionLineColor(0xFF33B5E5);
					pickerView.setSelectionOverlineVisible(false);
					pickerView.setShadowVisible(false);
				}else{
					adapter.setTextColor(0xFFC4C4C4);
					pickerView.setShadowVisible(false);
				}
				
				selectedValue = selections[i];
				if(selectedValue>-1){
					pickerView.setCurrentItem(selectedValue);
				}
				
				pickerView.addChangingListener(new onMyWeelChangeListener(freContext,i));
				LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams((int)widths[i], LayoutParams.WRAP_CONTENT);
				lp.setMargins(5, 0, 5, 0);
			
				ll.addView(pickerView,lp);
			}
			rl.addView(ll);
			setView(rl);
		}
	}
	
	
	private class onMyWeelChangeListener implements OnWheelChangedListener{
	
		private int index;
		FREContext freContext;
		
		public onMyWeelChangeListener(FREContext freContext,int index) 
		{
			this.index = index;
			this.freContext = freContext;
		}
		public void onChanged(WheelView wheel, int oldValue, int newValue) {
			try{
				freContext.dispatchStatusEventAsync(NativeDialogsExtension.LIST_CHANGE,String.valueOf(index)+"_"+String.valueOf(newValue));
			}catch (Exception e){
				freContext.dispatchStatusEventAsync(NativeDialogsExtension.ERROR_EVENT,String.valueOf(e));
	            e.printStackTrace();
	        }
        }
	}
	
	
}
