//
//  NativeListDelegate.h
//  NativeDialogs
//
//  Created by Martin Heidegger on 4/17/13.
//
//

#import "FlashRuntimeExtensions.h"

#ifndef NativeDialogs_NativeListDelegate_h
#define NativeDialogs_NativeListDelegate_h

@interface NativeListDelegate : NSObject <UIPickerViewDelegate>


-(NativeListDelegate*) initWithOptions: (FREObject*) options
                                target: (id) changeTarget
                                action: (SEL) changeAction;

-(NativeListDelegate*) initWithMultipleOptions: (FREObject*) options
                                     andWidths:(FREObject*)widths
                                        target: (id) changeTarget
                                        action: (SEL) changeAction;
@end

#endif
