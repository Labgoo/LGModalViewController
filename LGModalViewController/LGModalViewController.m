//
//  LGModalViewController.m
//  LGModalViewControllerDemo
//
//  Created by Minh Tu Le on 9/23/13.
//  Copyright (c) 2013 Minh Tu Le. All rights reserved.
//

#import "LGModalViewController.h"

const CGFloat kDefaultBackgroundBlackAlphaValue = 0.6;
const CGFloat kDefaultAppearingAnimationsDuration = 0.3;
const CGFloat kDefaultDisappearingAnimationsDuration = 0.3;

@interface LGModalViewController () <UIGestureRecognizerDelegate>

@property(nonatomic, strong) LGModalViewController *retainedSelf;
@property(nonatomic, strong) UIView *backgroundView;
@property(nonatomic, strong) UIView *modalView;
@property(nonatomic, strong) UIColor *backgroundColor;
@property(nonatomic) BOOL tapOutsideToCloseEnabled;

@end


@implementation LGModalViewController

#pragma mark - Inits, Getters and Setters

- (id)initWithModalView:(UIView *)modalView {
    return [self initWithModalView:modalView
            backgroundColor:[[UIColor blackColor] colorWithAlphaComponent:kDefaultBackgroundBlackAlphaValue]
          tapOutsideToCloseEnabled:NO];
}

- (id)initWithModalView:(UIView *)modalView
        tapOutsideToCloseEnabled:(BOOL)tapOutsideToCloseEnabled {
    return [self initWithModalView:modalView
                   backgroundColor:[[UIColor blackColor] colorWithAlphaComponent:kDefaultBackgroundBlackAlphaValue]
          tapOutsideToCloseEnabled:tapOutsideToCloseEnabled];
}

- (id)initWithModalView:(UIView *)modalView
        backgroundColor:(UIColor *)backgroundColor
tapOutsideToCloseEnabled:(BOOL)tapOutsideToCloseEnabled {
    self = [super init];
    if (self) {
        self.modalView = modalView;
        self.backgroundColor = backgroundColor;
        self.tapOutsideToCloseEnabled = tapOutsideToCloseEnabled;
        // Keep object alive until it is dismissed by retaining cycle
        self.retainedSelf = self;
    }
    return self;
}

- (void)viewDidLoad {
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;

    self.view = [[UIView alloc] initWithFrame:rootViewController.view.bounds];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.view.backgroundColor = [UIColor clearColor];
    [rootViewController.view addSubview:self.view];

    self.backgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.backgroundView.backgroundColor = self.backgroundColor;
    [self.view addSubview:self.backgroundView];

    self.modalView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin
            | UIViewAutoresizingFlexibleRightMargin
            | UIViewAutoresizingFlexibleTopMargin
            | UIViewAutoresizingFlexibleBottomMargin;
    self.modalView.center = self.view.center;
    [self.view addSubview:self.modalView];

    if (self.tapOutsideToCloseEnabled) {
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                               action:@selector(tapOutsideToClose:)];
        tapGestureRecognizer.delegate = self;
        [self.view addGestureRecognizer:tapGestureRecognizer];
    }

    if (self.appearingAnimations == nil) {
        self.appearingAnimations = ^(LGModalViewController *modalViewController) {
            UIView *backgroundView = modalViewController.backgroundView;
            UIView *modalView = modalViewController.modalView;
            modalView.center = CGPointMake(
                    backgroundView.center.x,
                    backgroundView.frame.size.height + modalView.frame.size.height/2.0);
            [UIView animateWithDuration:kDefaultAppearingAnimationsDuration
                             animations:^{
                                 backgroundView.alpha = 1.0;
                                 modalView.center = backgroundView.center;
                             }];
        };
    }

    if (self.disappearingAnimations == nil) {
        self.disappearingAnimations = ^(LGModalViewController *modalViewController) {
            UIView *backgroundView = modalViewController.backgroundView;
            UIView *modalView = modalViewController.modalView;
            [UIView animateWithDuration:kDefaultDisappearingAnimationsDuration
                             animations:^{
                                 backgroundView.alpha = 0.0;
                                 modalView.center = CGPointMake(
                                         backgroundView.center.x,
                                         backgroundView.frame.size.height + modalView.frame.size.height/2.0);
                             }];
        };
    }
}

- (void)dealloc {
    [self dismissAnimated:NO];
}

#pragma mark - Public APIs

- (void)showAnimated:(BOOL)animated {
    // Build the view before showing, calling viewDidLoad if needed
    [self view];
    
    if (animated) {
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }];
        self.appearingAnimations(self);
        [CATransaction commit];
    } else {
        self.modalView.center = self.view.center;
    }
}

- (void)dismissAnimated:(BOOL)animated {
    if (self.view.isHidden) {
        return;
    }

    if (animated) {
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            [self cleanUp];
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }];
        self.disappearingAnimations(self);
        [CATransaction commit];
    } else {
        [self cleanUp];
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch {
    if (touch.view == self.backgroundView) {
        return YES;
    }
    return NO;
}

#pragma mark - Private Methods

- (void)tapOutsideToClose:(id)sender {
    [self dismissAnimated:YES];
}

- (void)cleanUp {
    [self.modalView removeFromSuperview];
    [self.backgroundView removeFromSuperview];
    [self.view removeFromSuperview];
    // Break the retaining cycle to release the object.
    self.retainedSelf = nil;
}

@end