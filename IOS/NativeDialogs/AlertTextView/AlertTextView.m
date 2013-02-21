//
//  AlertTextView.m
//  test
//
//  Created by Mateusz Maćkowiak mmmackowiak on 16.04.2012.
//  Copyright (c) 2012 Mateusz Maćkowiak. All rights reserved.
//

#import "AlertTextView.h"
#import <objc/runtime.h>


@implementation AlertTextView

@synthesize textFields;
@synthesize buttons;

@synthesize messageField;
@synthesize titleField;



-(id)init
{
    if (self = [super init])
    {
        style = AlertTextViewStyleDefault;
        firstShown = NO;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{

    CGRect rec = self.frame, rec2 = CGRectMake(12.0, 5.0, 260.0, 25.0);
    CGFloat height = 0;
    
    if(messageField!=nil)
        rec2.origin.y = messageField.frame.origin.y+messageField.frame.size.height+5;
    else if(titleField!=nil)
        rec2.origin.y = titleField.frame.origin.y+titleField.frame.size.height+5;

    if(textFields){
        for (UIView*textView in textFields) {
            textView.frame = rec2;
            rec2.origin.y += rec2.size.height+5;
        }
    }
    height = rec2.origin.y;
    if(buttons){
        if(buttons.count<3){
            for (UIButton*button in buttons) {
                rec2 = button.frame;
                rec2.origin.y = height;
                [button setFrame:rec2];
            }
        }else{
            for (UIButton*button in buttons) {
                rec2.size = button.frame.size;
                button.frame = rec2;
                rec2.origin.y += rec2.size.height+5;
            }
        }
    }
    height = 0;
    
    for (UIView*view in self.subviews) {
        if(view.frame.origin.y+view.frame.size.height > height)
            height = view.frame.origin.y+view.frame.size.height;
    }
    if(firstShown){
        rec.size.height= height+40;
        firstShown = NO;
    }else
        rec.size.height= height+20;
    
    
    rec = CGRectMake(rec.origin.x, rec.origin.y, rec.size.width, rec.size.height);

    
    
    [self setFrame:rec];
    [super drawRect:rec];
    
    [self setNeedsDisplay];
    
    
    // Drawing code
}


-(void)setAlertViewStyle:(AlertTextViewStyle)viewStyle{
    
    if(viewStyle == AlertTextViewStyleLoginAndPasswordInput){
        [self addTextField];
        [self addTextField].secureTextEntry=YES;
    }else if(viewStyle== AlertTextViewStylePlainTextInput){
        [self addTextField];
    }
    style = viewStyle;
}
-(AlertTextViewStyle)alertViewStyle{
    return style;
}

-(void)addTextView:(UITextView*)textView{
    if(!textView)
        return;
    
    if(!self.textFields)
        self.textFields = [[NSMutableArray alloc]initWithObjects:textView, nil];
    else
        [self.textFields addObject:textView];
    
    [self addSubview:textView];
    
}

-(UITextField*)addTextField{
    UITextField *t = [[UITextField alloc] init];
    [t setBackgroundColor:[UIColor whiteColor]];
    
    t.borderStyle = UITextBorderStyleNone;
    CALayer* layer = t.layer;
    layer.borderWidth = 1.0f;
    layer.borderColor = [[UIColor grayColor] CGColor];
    layer.cornerRadius = 5.0f;
    
    [self addTextView:(UITextView*)t];
    
    return [t autorelease];
}
-(UILabel*)addAdditionalMessage:(NSString*)message{
    UILabel *t = [[UILabel alloc] init];
    t.textColor = [UIColor whiteColor];
    t.text = message;
    t.textAlignment = UITextAlignmentCenter;
    t.backgroundColor = [UIColor clearColor];
    
    [self addTextView:(UITextView*)t];

    return [t autorelease];
}





-(id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...{
    if (self = [super initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil])
    {
        if(title!=nil && message!=nil){
            self.titleField = [self.subviews objectAtIndex:0];
            self.messageField = [self.subviews objectAtIndex:1];
            
        }else if (title!=nil) {
            self.titleField = [self.subviews objectAtIndex:0];
        }else if(message!=nil){
            self.messageField = [self.subviews objectAtIndex:0];
        }        
        [self setNeedsDisplay];
    }
    return self;
}
-(UITextField*)textFieldAtIndex:(int)index{
    if(textFields){
        int count = 0;
        for (UITextView* textView in textFields) {
            if([textView isKindOfClass:[UITextField class]]){
                if(count==index)
                    return (UITextField*)textView;
                else
                    count++;
            }
        }
        
    }
    
    return nil;
}

-(void)addSubview:(UIView *)view{

    
    if([view isKindOfClass:[UIButton  class]] || strcmp((const char *)"UIThreePartButton", class_getName([view class]))==0){
        if(!buttons)
            self.buttons = [[NSMutableArray alloc]init];
        [self.buttons addObject:view];
        NSLog(@"added to buttons %@",view);
    }

    [super addSubview:view];
}



- (void)show
{
    if(textFields){
        [[textFields objectAtIndex:0] becomeFirstResponder];
    }
    firstShown = YES;
  /*
    [[NSNotificationCenter defaultCenter] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:)name:UIDeviceOrientationDidChangeNotification object:nil];
    */
    [super show];
}
/*
-(void)orientationChanged:(NSNotification *)notification{
}


-(void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [super dismissWithClickedButtonIndex:buttonIndex animated:animated];
}
*/

- (void)dealloc
{

    if(buttons){
        [buttons removeAllObjects];
        [buttons release];
        buttons= nil;
    }
    if(textFields){
        [textFields removeAllObjects];
        [textFields release];
        textFields = nil;
    }
    [super dealloc];
}
@end
