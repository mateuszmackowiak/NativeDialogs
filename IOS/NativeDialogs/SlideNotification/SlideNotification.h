//
//
//  Created by Mateusz Maćkowiak m@mateuszmackowiak.art.pl on 27.03.2012.
//  Copyright (c) 2012 MateuszMaćkowiak. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ActionBlock)();

typedef enum 
{
    Red = 0,
    Blue= 1,
    Yellow = 2
} SlideNotificationColor;


@interface SlideNotification : UIControl {
    ActionBlock actionBlock_;
    SlideNotificationColor color;
    int8_t height;
}

@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, readonly) BOOL isHidden;

- (id)initWithTitle:(NSString *)title;
- (id)initWithTitle:(NSString *)title withColor:(SlideNotificationColor)_color actionBlock:(ActionBlock)action;


- (id)updateTitle:(NSString *)title;
- (id)updateTitle:(NSString *)title actionBlock:(ActionBlock)action;
- (id)updateActionBlock:(ActionBlock)action;

- (id)addAndShowInView:(UIView *)view;


-(id)show;
-(id)hide;

-(void)remove;
/*
* shows Toast message
*/
+(id)showMessage2:(NSString *)message duration:(float)duration;
/**
 *shows toast message and adds to que 
 */
+(id)showMessage:(NSString*)message duration:(float)duration;

+(float)SHORT;
+(float)LONG;

+(void)cancle;

@end
