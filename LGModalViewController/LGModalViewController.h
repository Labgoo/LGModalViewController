//
//  LGModalViewController.h
//  LGModalViewControllerDemo
//
//  Created by Minh Tu Le on 9/23/13.
//  Copyright (c) 2013 Minh Tu Le. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LGModalViewController;

typedef void (^LGModalViewControllerAnimations)(LGModalViewController *modalViewController);

@interface LGModalViewController : UIViewController

@property(nonatomic, strong, readonly) UIView *backgroundView;
@property(nonatomic, strong, readonly) UIView *modalView;
@property(nonatomic, copy) LGModalViewControllerAnimations appearingAnimations;
@property(nonatomic, copy) LGModalViewControllerAnimations disappearingAnimations;

- (id)initWithModalView:(UIView *)modalView;

- (id)initWithModalView:(UIView *)modalView
tapOutsideToCloseEnabled:(BOOL)tapOutsideToCloseEnabled;


- (id)initWithModalView:(UIView *)modalView
         backgroundColor:(UIColor *)backgroundColor
tapOutsideToCloseEnabled:(BOOL)tapOutsideToCloseEnabled;

- (void)showAnimated:(BOOL)animated;

- (void)dismissAnimated:(BOOL)animated;

@end
