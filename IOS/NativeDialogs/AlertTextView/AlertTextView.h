//
//  UIAlertTextView.h
//  test
//
//  Created by Mateusz Maćkowiak mmmackowiak on 16.04.2012.
//  Copyright (c) 2012 Mateusz Maćkowiak. All rights reserved.
//



typedef enum {
	AlertTextViewStylePlainTextInput,
	AlertTextViewStyleLoginAndPasswordInput,
    AlertTextViewStyleDefault
} AlertTextViewStyle;

@interface AlertTextView : UIAlertView {
    AlertTextViewStyle style;
    BOOL firstShown;
}


@property (nonatomic, retain) NSMutableArray *textFields;
@property (nonatomic, retain) NSMutableArray *buttons;

@property (nonatomic, retain) UILabel *messageField;
@property (nonatomic, retain) UILabel *titleField;

-(UITextField*)addTextField;

-(UILabel*)addAdditionalMessage:(NSString*)message;

-(UITextField*)textFieldAtIndex:(int)index;

-(void)setAlertViewStyle:(AlertTextViewStyle)style;
-(AlertTextViewStyle)alertViewStyle;
@end
