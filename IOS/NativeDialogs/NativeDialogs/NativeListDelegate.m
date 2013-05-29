//
//  NativeListDelegate.c
//  NativeDialogs
//
//  Created by Martin Heidegger on 4/17/13.
//
//
#import "FlashRuntimeExtensions.h"
#import "NativeListDelegate.h"


@interface NativeListDelegate () 
{
    BOOL multipleOptions;
    NSMutableArray *options;
    NSMutableArray *widths;
    SEL action;
    id target;
    
}

@end

@implementation NativeListDelegate

- (NativeListDelegate*)initWithOptions:(FREObject*)opts
                               target:(id)changeTarget
                               action:(SEL)changeAction
{
    self = [super init];
    if (self) {
        multipleOptions = NO;
        action = changeAction;
        target = changeTarget;
        
        options = [self parseList:opts];
    }
    return self;
}


-(NativeListDelegate*) initWithMultipleOptions: (FREObject*) opts
                                     andWidths:(FREObject*)wds
                                        target: (id) changeTarget
                                        action: (SEL) changeAction{
    self = [super init];
    if (self) {
        multipleOptions = YES;
        action = changeAction;
        target = changeTarget;
        options = [[NSMutableArray alloc] init];
        widths = [NSMutableArray array];
        uint32_t options_len;
        if (FREGetArrayLength(opts, &options_len) == FRE_OK)
        {
            for(int i=0; i<options_len; ++i)
            {
                FREObject item;
                if(FREGetArrayElementAt(opts, i, &item) == FRE_OK){
                    [options addObject:[self parseList:item]];
                }else{
                    NSLog(@"Could not parse one of the list");
                }
                
                if(FREGetArrayElementAt(wds, i, &item) == FRE_OK){
                    double width = 300;
                    if (FREGetObjectAsDouble(item, &width)==FRE_OK) {
                        [widths addObject:[NSNumber numberWithDouble:width]];
                    }else{
                        [widths addObject:[NSNumber numberWithDouble:300/options_len]];
                    }
                    
                }else{
                    NSLog(@"Could not parse one of the list");
                }
            }
        }
    }
    return self;
}

-(NSMutableArray*) parseList:(FREObject*)list{
    NSMutableArray* encodedList = [[NSMutableArray alloc] init];
    uint32_t options_len;
    if (FREGetArrayLength(list, &options_len) == FRE_OK)
    {
        
        for(int i=0; i<options_len; ++i)
        {
            FREObject item;
            FREResult result = FREGetArrayElementAt(list, i, &item);
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
            [encodedList addObject:text];
        }
    }
    
    return encodedList;
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
    if (multipleOptions) {
        [inv setArgument:&component atIndex:4];
    }
    [inv invoke];
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (multipleOptions) {
        return ((NSArray*)[options objectAtIndex:component]).count;
    }
    return options.count;
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (multipleOptions) {
        return options.count;
    }
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (multipleOptions) {
        return [((NSArray*)[options objectAtIndex:component]) objectAtIndex:row];
    }
    return [options objectAtIndex:row];
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (multipleOptions) {
        return ((NSNumber*)[widths objectAtIndex:component]).floatValue;
    }
    return 300;
}

- (void)dealloc
{
    [options release];
    [super dealloc];
}

@end

