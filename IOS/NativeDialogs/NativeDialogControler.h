//
//  NativeAlertControler.h
//  NativeDialogs
//
//  Created by Mateusz Mackowiak on 02.02.2013.
//
//
#import "FlashRuntimeExtensions.h"
#import "SBTableAlert.h"
#import "NativeListDelegate.h"

@interface NativeDialogControler : NSObject <UIAlertViewDelegate,SBTableAlertDelegate,SBTableAlertDataSource,UIActionSheetDelegate,UIPopoverControllerDelegate,UIPickerViewDelegate>
{
    UIPopoverController     *popover;
    UIActionSheet           *actionSheet;
    BOOL                    cancelable;
    NativeListDelegate      *delegate;
    UIPickerView            *picker;
    
    CGFloat oldX;
}

@property ( nonatomic, assign ) FREContext      *freContext;
@property ( nonatomic, retain ) NSMutableArray  *tableItemList;
@property ( nonatomic, retain ) UIAlertView     *alert;
@property ( nonatomic, retain ) SBTableAlert    *sbAlert;
@property ( nonatomic, retain ) UIProgressView  *progressView;


-(void)createMultiChoice;

-(void)showAlertWithTitle: (NSString *)title
                  message: (NSString*)message
                andButtons:(FREObject *)buttons;

-(void)showAlertWithTitle: (NSString *)title
                  message: (NSString*)message
               closeLabel: (NSString*)closeLabel
              otherLabels: (NSString*)otherLabels;


-(BOOL)isShowing;
-(void)updateMessage:(NSString*)message;
-(void)updateTitle:(NSString*)title;
-(void)shake;
-(void)dismissWithButtonIndex:(int32_t)index;

-(void)updateProgress: (CGFloat)perc;

-(void)showSelectDialogWithTitle: (NSString *)title
                         message: (NSString*)message
                            type: (uint32_t)type
                         options: (FREObject*)options
                         checked: (FREObject*)checked
                         buttons: (FREObject*)buttons;

-(void)showTextInputDialog: (NSString *)title
                   message: (NSString*)message
                textInputs: (FREObject*)textInputs
                   buttons: (FREObject*)buttons;

-(void)showProgressPopup: (NSString *)title
                   style: (int32_t)style
                 message: (NSString*)message
                progress: (NSNumber*)progress
            showActivity: (Boolean)showActivity
               cancleble: (Boolean)cancleble;

-(void)showDatePickerWithTitle:(NSString *)title
                    andMessage:(NSString *)message
                       andDate:(double)date
                      andStyle:(const uint8_t*)style
                    andButtons:(FREObject*)buttons
                  andHasMinMax:(bool)hasMinMax
                        andMin:(double)min
                        andMax:(double)max;

-(void)updateDateWithTimestamp:(double)timeStamp;
-(void)setCancelable:(uint32_t)cancelable;


-(void)showPickerWithOptions:(FREObject*)options
                  andIndexes:(FREObject*)indexes
                   withTitle:(NSString*)titleString
                  andMessage:(NSString*)messageString
                  andButtons:(FREObject*)buttons
                    andWidths:(FREObject*)widths;

-(void)setSelectedRow:(NSInteger)index andSection:(NSInteger)section;
@end
