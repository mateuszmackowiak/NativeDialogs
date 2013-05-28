//
//  NativeListDelegate.c
//  NativeDialogs
//
//  Created by Martin Heidegger on 4/17/13.
//
//
#import "FlashRuntimeExtensions.h"
#import "NativeListDelegate.h"


@implementation NativeListDelegate

- (NativeListDelegate*)initWithOptions:(FREObject*)opts
                               target:(id)changeTarget
                               action:(SEL)changeAction
{
    self = [super init];
    action = changeAction;
    target = changeTarget;
    options = [[NSMutableArray alloc] init];
    if (FREGetArrayLength(opts, &options_len) == FRE_OK)
    {
        for(int i=0; i<options_len; ++i)
        {
            FREObject item;
            FREResult result = FREGetArrayElementAt(opts, i, &item);
            NSString *text;
            if(result == FRE_OK){
                
                uint32_t labelLength;
                const uint8_t *label;
                if(FREGetObjectAsUTF8(item, &labelLength, &label) == FRE_OK)
                {
                    text = [NSString stringWithUTF8String:(char*)label];
                }else{
                    text = @"Error getting label";
                }
            }
            else
            {
                text = [NSString stringWithFormat:@"%@ %X", @"Item couldn't be read", result];
            }
            [options addObject:text];
        }
    }
    return self;
}


#pragma mark - List Dialog

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSMethodSignature *sig = [target methodSignatureForSelector:action];
    NSInvocation *inv = [NSInvocation invocationWithMethodSignature:sig];
    NSLog(@"Row %D", row);
    [inv setTarget:target];
    [inv setSelector:action];
    [inv setArgument:&pickerView atIndex:2]; //arguments 0 and 1 are self and _cmd respectively, automatically set by NSInvocation
    [inv setArgument:&row atIndex:3];
    [inv invoke];
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return options_len;
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [options objectAtIndex:row];
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 300;
}

- (void)dealloc
{
    [options release];
    [super dealloc];
}

@end

