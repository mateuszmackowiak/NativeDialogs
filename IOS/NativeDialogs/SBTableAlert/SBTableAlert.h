//
//  --------------------------------------------
//  Copyright (C) 2011 by Simon Blommegård
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//  --------------------------------------------
//
//  SBTableAlert.h
//  SBTableAlert
//
//  Created by Simon Blommegård on 2011-04-08.
//  Copyright 2011 Simon Blommegård. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kTableCornerRadius 5.

typedef enum {
	SBTableAlertTypeSingleSelect, // dismiss alert with button index -1 and animated (default)
	SBTableAlertTypeMultipleSelct, // dismiss handled by user eg. [alert.view dismiss...];
} SBTableAlertType;

typedef enum {
	SBTableAlertStylePlain, // plain white BG and clear FG (default)
	SBTableAlertStyleApple, // same style as apple in the alertView for slecting wifi-network (Use SBTableAlertCell)
} SBTableAlertStyle;

// use this class if you would like to use the custom section headers by yourself
@interface SBTableViewSectionHeaderView : UIView {}
@property (nonatomic, copy) NSString *title;
@end

@interface SBTableAlertCell : UITableViewCell {}
- (void)drawCellBackgroundView:(CGRect)r;
@end

@class SBTableAlert;

@protocol SBTableAlertDelegate <NSObject>
@optional

- (CGFloat)tableAlert:(SBTableAlert *)tableAlert heightForRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)tableAlert:(SBTableAlert *)tableAlert didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableAlertCancel:(SBTableAlert *)tableAlert;

- (void)tableAlert:(SBTableAlert *)tableAlert clickedButtonAtIndex:(NSInteger)buttonIndex;

- (void)willPresentTableAlert:(SBTableAlert *)tableAlert;
- (void)didPresentTableAlert:(SBTableAlert *)tableAlert;

- (void)tableAlert:(SBTableAlert *)tableAlert willDismissWithButtonIndex:(NSInteger)buttonIndex;
- (void)tableAlert:(SBTableAlert *)tableAlert didDismissWithButtonIndex:(NSInteger)buttonIndex;

@end

@protocol SBTableAlertDataSource <NSObject>
@required

- (UITableViewCell *)tableAlert:(SBTableAlert *)tableAlert cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)tableAlert:(SBTableAlert *)tableAlert numberOfRowsInSection:(NSInteger)section;

@optional

- (NSInteger)numberOfSectionsInTableAlert:(SBTableAlert *)tableAlert; // default 1
- (NSString *)tableAlert:(SBTableAlert *)tableAlert titleForHeaderInSection:(NSInteger)section;

@end

@interface SBTableAlert : NSObject <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate> {}

@property (nonatomic, retain) UIAlertView *view;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic) SBTableAlertType type;
@property (nonatomic) SBTableAlertStyle style;
@property (nonatomic) NSInteger maximumVisibleRows; // default 4, (nice in both orientations w/ rowHeigh == 40), if -1 is passed it will display the whole table.
@property (nonatomic) CGFloat rowHeight; // default 40, (default in UITableView == 44)

@property (nonatomic, assign) id <SBTableAlertDelegate> delegate;
@property (nonatomic, assign) id <SBTableAlertDataSource> dataSource;

@property (nonatomic, assign) id <UITableViewDelegate> tableViewDelegate; // default self, (set other for more advanded use)
@property (nonatomic, assign) id <UITableViewDataSource> tableViewDataSource; // default self, (set other for more advanded use)
@property (nonatomic, assign) id <UIAlertViewDelegate> alertViewDelegate; // default self, (set other for more advanded use)

- (id)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelTitle messageFormat:(NSString *)message, ...;
+ (id)alertWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelTitle messageFormat:(NSString *)message, ...;

- (void)show;

@end
