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
{
    NSMutableArray *options;
    uint32_t options_len;
    SEL action;
    id target;
    
}
-(NativeListDelegate*) initWithOptions: (FREObject*) options
                                target: changeTarget
                                action: (SEL) changeAction;
@end

#endif
