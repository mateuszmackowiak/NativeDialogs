package pl.mateuszmackowiak.nativeANE;

import com.adobe.fre.FREArray;
import com.adobe.fre.FREInvalidObjectException;
import com.adobe.fre.FREObject;
import com.adobe.fre.FRETypeMismatchException;
import com.adobe.fre.FREWrongThreadException;

public class FREUtilities {

	public static CharSequence[] convertFREArrayToCharSequenceArray(FREArray freArray) throws IllegalArgumentException, FREInvalidObjectException, FREWrongThreadException, IllegalStateException, FRETypeMismatchException {
		
    	int lenth= (int)freArray.getLength();
    	if(lenth>0){
    		
    		CharSequence[] csa = new CharSequence[lenth];
        	FREObject obj=null;
        	for (int i = 0; i < lenth; i++) {
        		obj = freArray.getObjectAt(i);
        		csa[i] = obj.getAsString();
			}
        	return csa;
    	}
		return null;
	}

	public static String[] convertFREArrayToStringArray(FREArray freArray) throws IllegalArgumentException, FREInvalidObjectException, FREWrongThreadException, IllegalStateException, FRETypeMismatchException {
		
    	int lenth= (int)freArray.getLength();
    	if(lenth>0){
    		
    		String[] sa = new String[lenth];
        	FREObject obj=null;
        	for (int i = 0; i < lenth; i++) {
        		obj = freArray.getObjectAt(i);
        		sa[i] = obj.getAsString();
			}
        	return sa;
    	}
		return null;
	}
	
	public static boolean[] convertFREArrayToBooleadArray(FREArray freArray) throws IllegalArgumentException, FREInvalidObjectException, FREWrongThreadException, IllegalStateException, FRETypeMismatchException {
		int lenth= (int)freArray.getLength();
    	if(lenth>0){
    		boolean[] ba = new boolean[lenth];
        	FREObject obj = null;
        	for (int i = 0; i < lenth; i++) {
        		obj = freArray.getObjectAt(i);
        		ba[i] = obj.getAsBool();
			}
        	return ba;
    	}
		return null;
	}

}
