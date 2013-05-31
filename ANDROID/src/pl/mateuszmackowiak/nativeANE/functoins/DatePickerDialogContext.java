package pl.mateuszmackowiak.nativeANE.functoins;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;
import pl.mateuszmackowiak.nativeANE.FREUtilities;
import pl.mateuszmackowiak.nativeANE.NativeDialogsExtension;
import android.app.AlertDialog;
import android.app.DatePickerDialog;
import android.app.TimePickerDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.text.Html;
import android.util.Log;
import android.view.animation.Animation;
import android.view.animation.CycleInterpolator;
import android.view.animation.TranslateAnimation;
import android.widget.DatePicker;
import android.widget.TimePicker;

import com.adobe.fre.FREArray;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

public class DatePickerDialogContext extends FREContext {

	public static final String KEY = "DatePickerDialogContext";

	private AlertDialog _dialog = null;
	



	
	@Override
	public void dispose() 
	{
		Log.d(KEY, "Disposing Extension Context");
		
		if(_dialog!=null){
			_dialog.dismiss();
			_dialog = null;
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
		functionMap.put(updateMessage.KEY, new updateMessage());
		functionMap.put(updateTitle.KEY, new updateTitle());
		functionMap.put(shake.KEY, new shake());
		functionMap.put(setDate.KEY, new setDate());
		
		// add other functions here
		return functionMap;	
	}
	
	

	
	public class setDate implements FREFunction{
		public static final String KEY = "setDate";
		
		@Override
	    public FREObject call(FREContext context, FREObject[] args)
	    {
			
			try{
				if(_dialog!=null){
					String []date = args[0].getAsString().split(",");
					
					if(_dialog instanceof DatePickerDialog){
						((DatePickerDialog)_dialog).updateDate(Integer.valueOf(date[0]).intValue()
								, Integer.valueOf(date[1]).intValue()
								, Integer.valueOf(date[2]).intValue());
					}else if(_dialog instanceof TimePickerDialog){
						((TimePickerDialog)_dialog).updateTime(Integer.valueOf(date[3]).intValue()
								, Integer.valueOf(date[4]).intValue());
					}
				}
			}catch (Exception e){
	        	context.dispatchStatusEventAsync(NativeDialogsExtension.ERROR_EVENT,String.valueOf(e));
	            e.printStackTrace();
	        }
			return null;
	    }
	}
	
	
	public class shake implements FREFunction{
		public static final String KEY = "shake";
		
		@Override
	    public FREObject call(FREContext context, FREObject[] args)
	    {
			
			try{
				if(_dialog!=null){
					
					Animation shake = new TranslateAnimation(0, 5, 0, 0);
				    shake.setInterpolator(new CycleInterpolator(5));
				    shake.setDuration(300);
				    _dialog.getCurrentFocus().startAnimation(shake);
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
				if(_dialog!=null){
					int v = args[0].getAsInt();
					context.dispatchStatusEventAsync(NativeDialogsExtension.CLOSED,String.valueOf(v));        
					_dialog.dismiss();
					_dialog = null;
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
				if(_dialog!=null && _dialog.isShowing()){
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
				if(_dialog!=null){
					String message="";
					message = args[0].getAsString();
					_dialog.setMessage(message);

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
				if(_dialog!=null){
					String title="";
					title = args[0].getAsString();
					
					_dialog.setTitle(title);
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
		    String title="",message="";
	        boolean cancelable=false, is24HourView = false;
	        String buttons[] = null;
	        int theme=1;
	        String date = "",style;
	        try{

	            title = args[0].getAsString();
	            message = args[1].getAsString();
	            date = args[2].getAsString();
	            
		        buttons = FREUtilities.convertFREArrayToStringArray((FREArray)args[3]);
		        
		        style = args[4].getAsString();
		        is24HourView = args[5].getAsBool();
			    cancelable = args[6].getAsBool();
				theme = args[7].getAsInt();
				if(_dialog!=null){
					_dialog.dismiss();
				}
				boolean hasMinMax = args.length >= 10;
				long minDate = -1;
				long maxDate = -1;
				if(hasMinMax)
				{
					minDate = (long) args[8].getAsDouble();
					maxDate = (long) args[9].getAsDouble();
				}
				_dialog = creatDateDialog(context,title,message,date,buttons,style,is24HourView,cancelable,theme,hasMinMax,minDate,maxDate);
			    _dialog.show();
			    
			    context.dispatchStatusEventAsync(NativeDialogsExtension.OPENED,"-1");
			    
	        }catch (Exception e){
	        	context.dispatchStatusEventAsync(NativeDialogsExtension.ERROR_EVENT,String.valueOf(e));
	            e.printStackTrace();
	        }    
	        return null;
	    }
	}
	
	
	private static final AlertDialog creatDateDialog(FREContext freContext,String title,String message,String date,String buttons[], String style, boolean is24HourView,boolean cancelable,int theme,boolean hasMinMax,long minDate,long maxDate)
    {
		try{
			String[] dateArr = date.split(",");
			
			AlertDialog dialog = null;
			int year = Integer.valueOf(dateArr[0]).intValue();
			int month = Integer.valueOf(dateArr[1]).intValue();
			int day = Integer.valueOf(dateArr[2]).intValue();
			int hour = Integer.valueOf(dateArr[3]).intValue();
			int minute = Integer.valueOf(dateArr[4]).intValue();
			
			if("time".equals(style)){
				if(android.os.Build.VERSION.SDK_INT<11){
					dialog = new MyTimePickerDialog(freContext,freContext.getActivity(), hour, minute, is24HourView);
				}else{
					dialog = new MyTimePickerDialog(freContext,freContext.getActivity(), hour, minute, is24HourView, theme);
				}
			}else{
				if(android.os.Build.VERSION.SDK_INT<11){
					dialog = new MyDatePickerDialog(freContext,freContext.getActivity(), year, month, day, hasMinMax, minDate, maxDate);
				}else{
					dialog = new MyDatePickerDialog(freContext,freContext.getActivity(), year, month, day, hasMinMax, minDate, maxDate, theme);
				}
			}
			
			if(title!=null && !"".equals(title))
        		dialog.setTitle(Html.fromHtml(title));
			
			if(message!=null && !"".equals(message))
        		dialog.setMessage(Html.fromHtml(message));
			
			if(buttons!=null && buttons.length>0){
				dialog.setButton(DatePickerDialog.BUTTON_POSITIVE, buttons[0], new ConfitmListener(freContext,0));
				if(buttons.length>1){
					dialog.setButton(DatePickerDialog.BUTTON_NEUTRAL, buttons[1], new ConfitmListener(freContext,1));
				}
				if(buttons.length>2){
					dialog.setButton(DatePickerDialog.BUTTON_NEGATIVE, buttons[2], new ConfitmListener(freContext,2));
				}
			}else
				dialog.setButton(DatePickerDialog.BUTTON_POSITIVE,"OK", new ConfitmListener(freContext,0));
			
			
			dialog.setCancelable(cancelable);
			if(cancelable==true)
				dialog.setOnCancelListener(new CancelListener(freContext));
			
			return dialog;
	    }catch(Exception e){
			freContext.dispatchStatusEventAsync(NativeDialogsExtension.ERROR_EVENT,KEY+"   "+e.toString());
		}
		return null;
    }
	
	private static class MyTimePickerDialog extends TimePickerDialog{

		FREContext freContext;
		
		public MyTimePickerDialog(FREContext freContext,Context context, int hourOfDay, int minute,boolean is24HourView, int theme) {
			super(context, theme, null, hourOfDay, minute, is24HourView);
			this.freContext = freContext;
		}
		public MyTimePickerDialog(FREContext freContext,Context context, int hourOfDay, int minute,boolean is24HourView) {
			super(context, null, hourOfDay, minute, is24HourView);
			this.freContext = freContext;
		}
		
		public void onTimeChanged(TimePicker view, int hourOfDay, int minute) {
			super.onTimeChanged(view, hourOfDay, minute);
			String returnDateString = "time,"+String.valueOf(hourOfDay)+","+String.valueOf(minute);
			freContext.dispatchStatusEventAsync(NativeDialogsExtension.DATE_CHANGED,returnDateString);
		}
	}
	
	private static class MyDatePickerDialog extends DatePickerDialog{

		private long minDate;
		private long maxDate;
		private boolean hasMinMax;
		private FREContext freContext;
		
		public MyDatePickerDialog (FREContext freContext,Context context, int year, int monthOfYear, int dayOfMonth, boolean hasMinMax, long minDate, long maxDate){
			super(context,null,year,monthOfYear,dayOfMonth);
			setMinMax(hasMinMax, minDate, maxDate);
			this.freContext = freContext;
		}

		public MyDatePickerDialog (FREContext freContext,Context context, int year, int monthOfYear, int dayOfMonth, boolean hasMinMax, long minDate, long maxDate,int theme){
			super(context,theme,null,year,monthOfYear,dayOfMonth);
			setMinMax(hasMinMax, minDate, maxDate);
			this.freContext = freContext;
		} 
		
		private void setMinMax(boolean hasMinMax, long minDate, long maxDate) {
			this.hasMinMax = hasMinMax;
			this.minDate = minDate;
			this.maxDate = maxDate;
		}

		@Override
		public void onDateChanged(DatePicker view, int year, int month, int day) {
			Calendar date = validate(year, month, day);
			int newYear = date.get(Calendar.YEAR);
			int newMonth = date.get(Calendar.MONTH);
			int newDay = date.get(Calendar.DAY_OF_MONTH);
			if(newYear != year || newMonth != month || newDay != day)
			{
				view.updateDate(newYear, newMonth, newDay);
			}
			else
			{
				String returnDateString = "day,"+String.valueOf(year)+","+String.valueOf(month)+","+String.valueOf(day);
				freContext.dispatchStatusEventAsync(NativeDialogsExtension.DATE_CHANGED,returnDateString);
			}
		}
		
		private Calendar validate(int year, int month, int day) {
			Calendar cal = (Calendar) Calendar.getInstance().clone();
			cal.set(Calendar.YEAR, year);
			cal.set(Calendar.MONTH, month);
			cal.set(Calendar.DAY_OF_MONTH, day);
			if(hasMinMax)
			{
				Long calTime = cal.getTimeInMillis();
				if(calTime < minDate)
				{
					cal.setTimeInMillis(minDate);
				}
				else if(calTime > maxDate)
				{
					cal.setTimeInMillis(maxDate);
				}
			}
			return cal;
		}
	}
	
	private static class CancelListener implements DialogInterface.OnCancelListener{
		FREContext freContext;
		
		/**
		 * 
		 */
		public CancelListener(FREContext freContext) {
			this.freContext = freContext;
		}
        @Override
		public void onCancel(DialogInterface dialog) 
        {
        	Log.e(KEY,"onCancle");
        	freContext.dispatchStatusEventAsync(NativeDialogsExtension.CANCELED,String.valueOf(-1));   
     	   dialog.dismiss();
        }
    }
	
	private static class ConfitmListener implements DialogInterface.OnClickListener{
    	private int index;
    	FREContext freContext;
    	
    	
    	ConfitmListener(FREContext freContext,int index)
    	{
    		this.index = index;
    		this.freContext = freContext;
    	}
 
        @Override
		public void onClick(DialogInterface dialog,int id) 
        {
        	freContext.dispatchStatusEventAsync(NativeDialogsExtension.CLOSED,String.valueOf(index));//Math.abs(id-1)));
        	dialog.dismiss();
        }
    }
	

}
