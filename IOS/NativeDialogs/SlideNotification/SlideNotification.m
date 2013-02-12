//
//
//  Created by Mateusz Maćkowiak m@mateuszmackowiak.art.pl on 27.03.2012.
//  Copyright (c) 2012 MateuszMaćkowiak. All rights reserved.
//

#import "SlideNotification.h"


@implementation SlideNotification

@synthesize title = title_;
@synthesize isHidden = isHidden_;


static const float _short = 1;
static const float _long = 3;

static SlideNotification* notification = nil;
static NSMutableArray* notifications = nil;
static float duration_ = 1;



-(id)init
{
    if (self = [super init])
    {
        color = Blue;
        height = 44.0;
    }
    return self;
}


- (id)initWithTitle:(NSString *)title{
    return [self initWithTitle:title withColor:color actionBlock:nil];
}


- (id)initWithTitle:(NSString *)title withColor:(SlideNotificationColor)_color actionBlock:(ActionBlock)action
{
    color = _color;
    self = [super initWithFrame:CGRectMake(0,0,0,0)];
    isHidden_ = YES;
    
    if (self) {
        self.autoresizingMask = (1 << 1);
        
        title_ = [title copy];
        actionBlock_ = action;
        
        [self addTarget:self action:@selector(callActionBlock_:) forControlEvents:(1 << 6)];
        
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged_:)name:@"UIDeviceOrientationDidChangeNotification" object:nil];
    }
    
    return self;
}



-(CGRect)getScreenBoundsForCurrentOrientation
{
    UIScreen *screen = [UIScreen mainScreen];
    CGRect fullScreenRect = screen.bounds; //implicitly in Portrait orientation.
    
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]))
    {
        CGRect temp;
        temp.size.width = fullScreenRect.size.height;
        temp.size.height = fullScreenRect.size.width;
        fullScreenRect = temp;
    }
    return fullScreenRect;
}



-(void)drawLinearGradient:(CGContextRef) context rect:(CGRect) rect startColor:(CGColorRef)startColor endColor:(CGColorRef)endColor {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = [NSArray arrayWithObjects:(id)startColor, (id)endColor, nil];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef) colors, locations);
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    CGContextSaveGState(context);
    CGContextAddRect(context, rect);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}


- (void)drawRect:(CGRect)rect
{

    CGRect screenRect = [self getScreenBoundsForCurrentOrientation];
    
    self.frame = CGRectMake(0.0f, screenRect.size.height-height-20.0f, screenRect.size.width, height);
    
    CGColorRef firstColor, lastColor;
    switch (color) {
		case Yellow:
			firstColor = [UIColor colorWithRed:255.0/255.0 green:215.0/255.0 blue:0.0/255.0 alpha:1.0].CGColor; 
            lastColor = [UIColor colorWithRed:205.0/255.0 green:173.0/255.0 blue:0.0/255.0 alpha:1.0].CGColor;
			break;
		case Red:
			firstColor = [UIColor colorWithRed:255.0/255.0 green:48.0/255.0 blue:48.0/255.0 alpha:1.0].CGColor; 
            lastColor = [UIColor colorWithRed:205.0/255.0 green:38.0/255.0 blue:38.0/255.0 alpha:1.0].CGColor;
			break;
		default:
            firstColor = [UIColor colorWithRed:0.0/255.0 green:191.0/255.0 blue:255.0/255.0 alpha:1.0].CGColor; 
            lastColor = [UIColor colorWithRed:0.0/255.0 green:104.0/255.0 blue:139.0/255.0 alpha:1.0].CGColor;
			break;
	}
    
     CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawLinearGradient:context rect:self.bounds startColor:firstColor endColor:lastColor];

    
    if (title_) {
        CGContextSaveGState(context);
        UIFont *titleFont = [UIFont boldSystemFontOfSize:18.0f];
        CGSize titleSize = [title_ sizeWithFont:titleFont];
        CGFloat titlePointY = lround((self.bounds.size.height - titleSize.height) / 2);
        CGFloat titlePointX = lround((self.bounds.size.width - titleSize.width) / 2);
        
        [[UIColor colorWithWhite:0.0 alpha:0.8] set];
        [title_ drawAtPoint:CGPointMake(titlePointX, titlePointY) withFont:titleFont];
        
        [[UIColor colorWithWhite:1.0 alpha:0.8] set];
        [title_ drawAtPoint:CGPointMake(titlePointX, titlePointY + 0.5) withFont:titleFont];
        CGContextRestoreGState(context);
    }
    
}



- (id)updateTitle:(NSString *)title{
    return [self updateTitle:title actionBlock:actionBlock_];

};

- (id)updateActionBlock:(ActionBlock)action{
    [self removeTarget:self action:@selector(callActionBlock_:) forControlEvents:(1 <<  6)];
    actionBlock_ = action;
    [self addTarget:self action:@selector(callActionBlock_:) forControlEvents:(1 <<  6)];    
    return self;
};


- (id)updateTitle:(NSString *)title  actionBlock:(ActionBlock)action
{
    if(title_ && title_ !=title ){
        if(title_){
            [title_ release];
        }
        title_ = [title copy];
    }else{
        title_ = nil;
    }
    [self updateActionBlock:action];
   
    [self setNeedsDisplay];
    return self;
}


-(id)show{
    if(isHidden_==YES){
        CGRect screenRect = [self getScreenBoundsForCurrentOrientation];
        CGFloat screenWidth = screenRect.size.width;
        CGFloat screenHeight = screenRect.size.height-20.0f;
        
        self.frame = CGRectMake(0.0f, screenHeight, screenWidth, height);
        
        [UIView beginAnimations:nil context:NULL];
        self.frame = CGRectMake(0.0f, screenHeight-height, screenWidth, height);
        [UIView commitAnimations];
        isHidden_ = NO;
    }
    return self;
}
- (id)addAndShowInView:(UIView *)view
{
    if (view) {
        if (self.superview) {
            [self removeFromSuperview];
        }
        [view addSubview:self];
        [self show];
        
        return self;
    }
    return nil;
}

-(id)hideWithAction:(SEL)sel{
    CGRect screenRect = [self getScreenBoundsForCurrentOrientation];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height-20.0f;
    
    self.frame = CGRectMake(0.0f, screenHeight-height, screenWidth, height);
    
    
    [UIView beginAnimations:nil context:NULL];
    self.frame = CGRectMake(0.0f, screenHeight, screenWidth, height);
    [UIView  setAnimationDelegate:self];
    
    [UIView setAnimationDidStopSelector:sel];
    [UIView commitAnimations];
    
    return self;
}


-(id)hide{
    CGRect screenRect = [self getScreenBoundsForCurrentOrientation];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height-20.0f;
    
    self.frame = CGRectMake(0.0f, screenHeight-height, screenWidth, height);
    
    
    [UIView beginAnimations:nil context:NULL];
    self.frame = CGRectMake(0.0f, screenHeight, screenWidth, height);
    [UIView  setAnimationDelegate:self];
    
    [UIView setAnimationDidStopSelector:@selector(hideFinished:finished:context:)];
    [UIView commitAnimations];
    
    return self;
}

-(void)remove{
    [self hideWithAction:@selector(hideForRemoveFinished:finished:context:) ];
}
- (void) hideFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    isHidden_ = YES;
}
- (void) hideForRemoveFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    isHidden_ = YES;
    [self removeFromSuperview];
    [self release];
}








- (void)callActionBlock_:(id)sender {
    if(actionBlock_!=nil)
        actionBlock_();
}

- (void)orientationChanged_:(NSNotification *)notification
{
    if(isHidden_==NO)
        [self setNeedsDisplay];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    
    if(title_){
        [title_ release];
    }
    [super dealloc];
        
}









+(id)showMessage2:(NSString *)message duration:(float)duration{
     SlideNotification*not = [[SlideNotification alloc] initWithTitle:message];
    [not addAndShowInView:[[[[UIApplication sharedApplication] keyWindow]rootViewController]view]];
    [[NSRunLoop mainRunLoop] addTimer:[NSTimer timerWithTimeInterval:duration target:self selector:@selector(hideToast2:) userInfo:not repeats:NO] forMode:@"NSDefaultRunLoopMode"];
    return not;
}
+(void) hideToast2:(NSTimer*) timer{
    [[timer userInfo]remove];
}

+(id)showMessage:(NSString*)message duration:(float)duration{
    if(notification==nil){
        duration_ = duration;
        notification = [[SlideNotification alloc] initWithTitle:message];
        [notification addAndShowInView:[[[[UIApplication sharedApplication] keyWindow]rootViewController]view]];
        [[NSRunLoop mainRunLoop] addTimer:[NSTimer timerWithTimeInterval:duration target:self selector:@selector(hideToast:) userInfo:nil repeats:NO] forMode:@"NSDefaultRunLoopMode"];
    }else {
        if (notification.isHidden) {
            [notification updateTitle:message];
            [notification show];
        }else{
            if(notifications ==nil){
                notifications = [[NSMutableArray alloc] initWithCapacity:1];
                [notifications addObject:message];
            }else {
                [notifications addObject:message];
            }
        }
    }    

	return notification;
}

+ (void) hideToast:(NSTimer*) timer{
    if(notifications==nil || [notifications count] ==0){
        [self cancle];
    }else 
        [notification hideWithAction:@selector( hideToastFinished)];
	
}

-(void)hideToastFinished{
    isHidden_ = YES;
    if(notifications!=nil && [notifications count]>0){
        NSString* message = [notifications objectAtIndex:0];
        [notifications removeObjectAtIndex:0];
        
        [notification updateTitle:message];
        [message release];
        [notification show];
        [[NSRunLoop mainRunLoop] addTimer:[NSTimer timerWithTimeInterval:duration_ target:self selector:@selector(hideLastToast:) userInfo:nil repeats:NO] forMode:@"NSDefaultRunLoopMode"];
    }
}
-(void)hideLastToast:(NSTimer*) timer{
    if(notifications==nil || [notifications count] ==0){
        [SlideNotification cancle];
    }else
        [notification hideWithAction:@selector( hideToastFinished)];
}


+(void)cancle{
    if(notification){
        [notification remove];
        [notifications removeAllObjects];
        [notifications release];
        notification= nil;
        notifications = nil;
    }
}


+(float)SHORT{
    return _short;
};
+(float)LONG{
    return _long;
};



@end
