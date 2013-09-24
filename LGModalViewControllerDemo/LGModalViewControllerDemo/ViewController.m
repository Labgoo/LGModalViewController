//
//  ViewController.m
//  LGModalViewControllerDemo
//
//  Created by Minh Tu Le on 9/23/13.
//  Copyright (c) 2013 Minh Tu Le. All rights reserved.
//

#import "ViewController.h"
#import "LGModalViewController.h"

const CGFloat kContentMargin = 20.0;
const CGFloat kTitleFontSize = 30.0;
const CGFloat kTitleMaximumLineHeight = 33.0;
const CGFloat kDescriptionFontSize = 20.0;
const CGFloat kDescriptionMaximumLineHeight = 23.0;
const CGFloat kMaxHeight = 500.0;

@interface ViewController ()

@property(strong, nonatomic) IBOutlet UISwitch *tapOutsideToCloseSwitch;
@property(nonatomic, strong) LGModalViewController *infoViewController;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma event - Events

- (IBAction)showNoAnimation:(UIButton *)sender {
    self.infoViewController = [[LGModalViewController alloc] initWithModalView:[self buildInfoViewWithWidth:450.0]
                                                      tapOutsideToCloseEnabled:self.tapOutsideToCloseSwitch.on];
    [self.infoViewController showAnimated:NO];
}

- (IBAction)showDefaultAnimations:(UIButton *)sender {
    self.infoViewController = [[LGModalViewController alloc] initWithModalView:[self buildInfoViewWithWidth:450.0]
                                                      tapOutsideToCloseEnabled:self.tapOutsideToCloseSwitch.on];
    [self.infoViewController showAnimated:YES];

}

- (IBAction)showCustomAnimations:(UIButton *)sender {
    self.infoViewController = [[LGModalViewController alloc] initWithModalView:[self buildInfoViewWithWidth:450.0]
                                                               backgroundColor:[[UIColor greenColor] colorWithAlphaComponent:0.4]
                                                      tapOutsideToCloseEnabled:self.tapOutsideToCloseSwitch.on];
    self.infoViewController.appearingAnimations = ^(LGModalViewController *modalViewController) {
        UIView *backgroundView = modalViewController.backgroundView;
        UIView *modalView = modalViewController.modalView;
        backgroundView.alpha = 0.0;
        modalView.center = backgroundView.center;
        modalView.alpha = 0.0;
        modalView.transform = CGAffineTransformMakeScale(0.5, 0.5);
        [UIView animateWithDuration:0.35
                         animations:^{
                             backgroundView.alpha = 1.0;
                             modalView.alpha = 1.0;
                             modalView.transform = CGAffineTransformIdentity;
                         }];
    };

    self.infoViewController.disappearingAnimations = ^(LGModalViewController *modalViewController) {
        UIView *backgroundView = modalViewController.backgroundView;
        UIView *modalView = modalViewController.modalView;
        [UIView animateWithDuration:0.35
                         animations:^{
                             backgroundView.alpha = 0.0;
                             modalView.alpha = 0.0;
                             modalView.transform = CGAffineTransformMakeScale(1.3, 1.3);
                         }];
    };

    [self.infoViewController showAnimated:YES];
}

#pragma event - Private Methods

- (UIView *)buildInfoViewWithWidth:(CGFloat)width {

    CGFloat top = kContentMargin;
    CGFloat left = kContentMargin;
    CGFloat contentWidth = width - 2 * kContentMargin;

    // Title
    NSMutableParagraphStyle *titleParagraphStyle = [NSMutableParagraphStyle new];
    titleParagraphStyle.alignment = NSTextAlignmentLeft;
    titleParagraphStyle.maximumLineHeight = kTitleMaximumLineHeight;
    NSDictionary *titleAttributedStringAttributes = @{
            NSParagraphStyleAttributeName : titleParagraphStyle,
    };
    NSAttributedString *titleAttributedString = [[NSAttributedString alloc] initWithString:@"Hello World!"
                                                                                attributes:titleAttributedStringAttributes];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(left, top, contentWidth, kMaxHeight)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.numberOfLines = 0;
    titleLabel.attributedText = titleAttributedString;
    titleLabel.font = [UIFont boldSystemFontOfSize:kTitleFontSize];
    [titleLabel sizeToFit];
    top = titleLabel.frame.origin.y + titleLabel.frame.size.height;

    // Description
    NSMutableParagraphStyle *descriptionParagraphStyle = [NSMutableParagraphStyle new];
    descriptionParagraphStyle.alignment = NSTextAlignmentLeft;
    descriptionParagraphStyle.maximumLineHeight = kDescriptionMaximumLineHeight;
    NSDictionary *descriptionAttributedStringAttributes = @{
            NSParagraphStyleAttributeName : descriptionParagraphStyle,
    };
    NSAttributedString *descriptionAttributedString = [[NSAttributedString alloc] initWithString:@"This popup looks great, huh?!"
                                                                                      attributes:descriptionAttributedStringAttributes];
    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(left, top, contentWidth, kMaxHeight)];
    descriptionLabel.backgroundColor = [UIColor clearColor];
    descriptionLabel.numberOfLines = 0;
    descriptionLabel.attributedText = descriptionAttributedString;
    descriptionLabel.font = [UIFont systemFontOfSize:kDescriptionFontSize];
    [descriptionLabel sizeToFit];
    top = descriptionLabel.frame.origin.y + descriptionLabel.frame.size.height + 15.0;

    // Button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(left, top, 120, 40);
    button.backgroundColor = [UIColor darkGrayColor];
    [button setTitle:@"Close"
            forState:UIControlStateNormal];
    button.titleLabel.textColor = [UIColor whiteColor];
    [button addTarget:self
               action:@selector(buttonPressed:)
     forControlEvents:UIControlEventTouchUpInside];
    top = button.frame.origin.y + button.frame.size.height;

    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, top + kContentMargin)];
    contentView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:titleLabel];
    [contentView addSubview:descriptionLabel];
    [contentView addSubview:button];
    return contentView;
}

- (void)buttonPressed:(UIButton *)button {
    [self.infoViewController dismissAnimated:YES];
}

@end
    