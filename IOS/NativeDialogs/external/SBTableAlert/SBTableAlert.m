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
//  SBTableAlert.m
//  SBTableAlert
//
//  Created by Simon Blommegård on 2011-04-08.
//  Copyright 2011 Simon Blommegård. All rights reserved.
//

#import "SBTableAlert.h"
#import <QuartzCore/QuartzCore.h>

@interface SBTableViewTopShadowView : UIView {}
@end

@implementation SBTableViewTopShadowView

- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	
	CGContextRef context = UIGraphicsGetCurrentContext();

	// Draw top shadow
	CGFloat colors [] = { 
		0, 0, 0, 0.4,
		0, 0, 0, 0,
	};
	
	CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
	CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace, colors, NULL, 2);
	CGColorSpaceRelease(baseSpace), baseSpace = NULL;
	
	CGPoint startPoint = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMinY(self.bounds));
	CGPoint endPoint = CGPointMake(CGRectGetMidX(self.bounds), 8);
	
	CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
	CGGradientRelease(gradient), gradient = NULL;
}

@end

@interface SBTableView : UITableView {}
@property (nonatomic) SBTableAlertStyle alertStyle;
@end

@implementation SBTableView

@synthesize alertStyle=_alertStyle;

- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	if (_alertStyle == SBTableAlertStyleApple) {
		// Draw background gradient
		CGFloat colors [] = { 
			0.922, 0.925, 0.933, 1,
			0.749, 0.753, 0.761, 1,
		};
		
		CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
		CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace, colors, NULL, 2);
		CGColorSpaceRelease(baseSpace), baseSpace = NULL;
		
		CGPoint startPoint = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMinY(self.bounds));
		CGPoint endPoint = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMaxY(self.bounds));
		
		CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
		CGGradientRelease(gradient), gradient = NULL;
	}
	
	[super drawRect:rect];
}

@end

@interface SBTableAlertCellBackgroundView : UIView
@end

@implementation SBTableAlertCellBackgroundView

- (void)drawRect:(CGRect)r {
    [ SBTableAlertCell drawCellBackgroundView:r];
	//[(SBTableAlertCell *)[self superview] drawCellBackgroundView:r];
}

@end

@implementation SBTableViewSectionHeaderView
@synthesize title=_title;

- (id)initWithTitle:(NSString *)title {
	if ((self = [super initWithFrame:CGRectZero])) {
		[self setTitle:title];
		[self setBackgroundColor:[UIColor colorWithRed:0.165 green:0.224 blue:0.376 alpha:0.85]];
	}
	
	return self;
}

- (void)dealloc {
	[self setTitle:nil];
	[super dealloc];
}

- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	[[UIColor colorWithWhite:0 alpha:0.8] set];
	[_title drawAtPoint:CGPointMake(10, 4) withFont:[UIFont boldSystemFontOfSize:12]];	
	[[UIColor whiteColor] set];
	[_title drawAtPoint:CGPointMake(10, 5) withFont:[UIFont boldSystemFontOfSize:12]];
	
	CGContextSetLineWidth(context, 1.5);
	
	[[UIColor colorWithWhite:1 alpha:0.35] set];
	CGContextMoveToPoint(context, 0, 0);
	CGContextAddLineToPoint(context, self.bounds.size.width, 0);
	CGContextStrokePath(context);
	
	[[UIColor colorWithWhite:0 alpha:0.35] set];
	CGContextMoveToPoint(context, 0, self.bounds.size.height);
	CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height);
	CGContextStrokePath(context);
}

@end

@interface SBTableAlertCell ()
@property (nonatomic, retain) SBTableAlertCellBackgroundView *cellBackgroundView;
@end

@implementation SBTableAlertCell
@synthesize cellBackgroundView = _cellBackgroundView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		CGRect frame = CGRectMake(0.0, 0.0, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
		
		_cellBackgroundView = [[SBTableAlertCellBackgroundView alloc] initWithFrame:frame];
		[_cellBackgroundView setBackgroundColor:[UIColor clearColor]];
		[_cellBackgroundView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
		[self setBackgroundView:_cellBackgroundView];
		[_cellBackgroundView release];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setNeedsDisplay) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
	}
	return self;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super dealloc];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	float editingOffset = 0.;
	if (self.editing)
		editingOffset = -self.contentView.frame.origin.x;
	
	_cellBackgroundView.frame = CGRectMake(editingOffset,
																			_cellBackgroundView.frame.origin.y,
																			self.frame.size.width - editingOffset,
																			_cellBackgroundView.frame.size.height);
	
	[self.textLabel setBackgroundColor:[UIColor clearColor]];
	[self.detailTextLabel setBackgroundColor:[UIColor clearColor]];
	[self setBackgroundColor:[UIColor clearColor]];
	
	[self setNeedsDisplay];
}

- (void)setNeedsDisplay {
	[super setNeedsDisplay];
	[_cellBackgroundView setNeedsDisplay];
}

+ (void)drawCellBackgroundView:(CGRect)r {
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetLineWidth(context, 1.5);
		
	[[UIColor colorWithWhite:1 alpha:0.8] set];
	CGContextMoveToPoint(context, 0, 0);
	CGContextAddLineToPoint(context, r.size.width, 0);
	CGContextStrokePath(context);
		
	[[UIColor colorWithWhite:0 alpha:0.35] set];
	CGContextMoveToPoint(context, 0, r.size.height);
	CGContextAddLineToPoint(context, r.size.width, r.size.height);
	CGContextStrokePath(context);
}

@end

@interface SBTableAlert ()
@property (nonatomic, retain) SBTableViewTopShadowView *shadow;
@property (nonatomic, assign) BOOL presented;

- (id)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelTitle messageFormat:(NSString *)format args:(va_list)args;
- (void)increaseHeightBy:(CGFloat)delta;
- (void)layout;

@end

@implementation SBTableAlert

@synthesize view=_alertView;
@synthesize tableView=_tableView;
@synthesize type=_type;
@synthesize style=_style;
@synthesize maximumVisibleRows=_maximumVisibleRows;
@synthesize rowHeight=_rowHeight;

@synthesize delegate=_delegate;
@synthesize dataSource=_dataSource;

@dynamic tableViewDelegate;
@dynamic tableViewDataSource;
@dynamic alertViewDelegate;

@synthesize shadow = _shadow;
@synthesize presented = _presented;

- (id)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelTitle messageFormat:(NSString *)format args:(va_list)args {
	if ((self = [super init])) {
		NSString *message = format ? [[[NSString alloc] initWithFormat:format arguments:args] autorelease] : nil;
		
		_alertView = [[TSAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:nil];
		
		_maximumVisibleRows = 4;
		_rowHeight = 40.;

		_tableView = [[SBTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
		
		[_tableView setDelegate:self];
		[_tableView setDataSource:self];
		[_tableView setBackgroundColor:[UIColor whiteColor]];
		[_tableView setRowHeight:_rowHeight];
		[_tableView setSeparatorColor:[UIColor lightGrayColor]];
		[_tableView.layer setCornerRadius:kTableCornerRadius];
		
		//[_alertView addSubview:_tableView];
		_alertView.customSubview = _tableView;
        
		_shadow = [[SBTableViewTopShadowView alloc] initWithFrame:CGRectZero];
		[_shadow setBackgroundColor:[UIColor clearColor]];
		[_shadow setHidden:YES];
		[_shadow.layer setCornerRadius:kTableCornerRadius];
		[_shadow.layer setMasksToBounds:YES];
		
		[_alertView addSubview:_shadow];
		[_alertView bringSubviewToFront:_shadow];
		
		//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(layoutAfterSomeTime) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
	}
	
	return self;
}

- (id)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelTitle messageFormat:(NSString *)message, ... {
	va_list list;
	va_start(list, message);
	self = [self initWithTitle:title cancelButtonTitle:cancelTitle messageFormat:message args:list];
	va_end(list);
	return self;
}

+ (id)alertWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelTitle messageFormat:(NSString *)message, ... {
	return [[[SBTableAlert alloc] initWithTitle:title cancelButtonTitle:cancelTitle messageFormat:message] autorelease];
}

- (void)dealloc {
    _alertView.delegate = nil;
	[self setTableView:nil];
	[self setView:nil];
	
	[self setShadow:nil];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	[super dealloc];
}

#pragma mark -

- (void)show {
	[_tableView reloadData];
	[_alertView show];
}

#pragma mark - Properties

- (void)setStyle:(SBTableAlertStyle)style {
	if (style == SBTableAlertStyleApple) {
		[_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
		[(SBTableView *)_tableView setAlertStyle:SBTableAlertStyleApple];
		[_shadow setHidden:NO];
	} else if (style == SBTableAlertStylePlain) {
		[_tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
		[(SBTableView *)_tableView setAlertStyle:SBTableAlertStylePlain];
		[_shadow setHidden:YES];
	}
	_style = style;
}

- (id<UITableViewDelegate>)tableViewDelegate {
	return _tableView.delegate;
}

- (void)setTableViewDelegate:(id<UITableViewDelegate>)tableViewDelegate {
	[_tableView setDelegate:tableViewDelegate];
}

- (id<UITableViewDataSource>)tableViewDataSource {
	return _tableView.dataSource;
}

- (void)setTableViewDataSource:(id<UITableViewDataSource>)tableViewDataSource {
	[_tableView setDataSource:tableViewDataSource];
}

- (id<TSAlertViewDelegate>)alertViewDelegate {
	return _alertView.delegate;
}

- (void)setAlertViewDelegate:(id<TSAlertViewDelegate>)alertViewDelegate {
	[_alertView setDelegate:alertViewDelegate];
}


#pragma mark - Private

- (void)increaseHeightBy:(CGFloat)delta {
	CGPoint c = _alertView.center;
	CGRect r = _alertView.frame;
	r.size.height += delta;
	_alertView.frame = r;
	_alertView.center = c;
	_alertView.frame = CGRectIntegral(_alertView.frame);
	
	for(UIView *subview in [_alertView subviews]) {
		if([subview isKindOfClass:[UIControl class]]) {
			CGRect frame = subview.frame;
			frame.origin.y += delta;
			subview.frame = frame;
		}
	}
}


- (void)layout {
	CGFloat height = 0.;
	NSInteger rows = 0;
	for (NSInteger section = 0; section < [_tableView numberOfSections]; section++) {
		for (NSInteger row = 0; row < [_tableView numberOfRowsInSection:section]; row++) {
			height += [_tableView.delegate tableView:_tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
			rows ++;
		}
	}
	
    CGRect screenRect = [[UIScreen mainScreen] bounds];
	CGFloat avgRowHeight = height / rows;
	CGFloat resultHeigh;
	
    if(height > screenRect.size.height) {
        if(UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation))
            resultHeigh = screenRect.size.height - _alertView.frame.size.height - 65.;
        else
            resultHeigh = screenRect.size.width - _alertView.frame.size.height - 65.;
    }
	else if (_maximumVisibleRows == -1 || rows <= _maximumVisibleRows)
		resultHeigh = _tableView.contentSize.height;
	else
		resultHeigh = (avgRowHeight * _maximumVisibleRows);
	
	[self increaseHeightBy:resultHeigh];
	
	
	[_tableView setFrame:CGRectMake(12,
																	_alertView.frame.size.height - resultHeigh - 65,
																	_alertView.frame.size.width - 24,
																	resultHeigh)];
	
	[_shadow setFrame:CGRectMake(_tableView.frame.origin.x,
															 _tableView.frame.origin.y,
															 _tableView.frame.size.width,
															 8)];
    
    [ _alertView setNeedsLayout ];
}

- (void)layoutAfterSomeTime{
    [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(layout) userInfo:nil repeats:NO];
}

#pragma mark -
#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_delegate respondsToSelector:@selector(tableAlert:heightForRowAtIndexPath:)])
        return [_delegate tableAlert:self heightForRowAtIndexPath:indexPath];

    return _rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (_type == SBTableAlertTypeSingleSelect)
		[_alertView dismissWithClickedButtonIndex:-1 animated:YES];
	
	if ([_delegate respondsToSelector:@selector(tableAlert:didSelectRowAtIndexPath:)])
		[_delegate tableAlert:self didSelectRowAtIndexPath:indexPath];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	if ([_dataSource respondsToSelector:@selector(tableAlert:titleForHeaderInSection:)]) {
		NSString *title = [_dataSource tableAlert:self titleForHeaderInSection:section];
		if (!title)
			return nil;
		
		return [[[SBTableViewSectionHeaderView alloc] initWithTitle:title] autorelease];
	}

	return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	if ([self tableView:tableView viewForHeaderInSection:section])
		return 25.;
	return 0.;
}

#pragma mark -
#pragma mark UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {	
	return [_dataSource tableAlert:self	cellForRowAtIndexPath:indexPath];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [_dataSource tableAlert:self numberOfRowsInSection:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if ([_dataSource respondsToSelector:@selector(numberOfSectionsInTableAlert:)])
		return [_dataSource numberOfSectionsInTableAlert:self];

	return 1;
}

#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertViewCancel:(UIAlertView *)alertView {
	if ([_delegate respondsToSelector:@selector(tableAlertCancel:)])
		[_delegate tableAlertCancel:self];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if ([_delegate respondsToSelector:@selector(tableAlert:clickedButtonAtIndex:)])
		[_delegate tableAlert:self clickedButtonAtIndex:buttonIndex];
}

- (void)willPresentAlertView:(UIAlertView *)alertView {
	if (!_presented)
		[self layout];
	_presented = YES;
	if ([_delegate respondsToSelector:@selector(willPresentTableAlert:)])
		[_delegate willPresentTableAlert:self];
}
- (void)didPresentAlertView:(UIAlertView *)alertView {
	if ([_delegate respondsToSelector:@selector(didPresentTableAlert:)])
		[_delegate didPresentTableAlert:self];
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
	if ([_delegate respondsToSelector:@selector(tableAlert:willDismissWithButtonIndex:)])
		[_delegate tableAlert:self willDismissWithButtonIndex:buttonIndex];
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	_presented = NO;
	if ([_delegate respondsToSelector:@selector(tableAlert:didDismissWithButtonIndex:)])
		[_delegate tableAlert:self didDismissWithButtonIndex:buttonIndex];
}

@end
