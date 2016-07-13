//
//  JHUD.m
//  JHudViewDemo
//
//  Created by 晋先森 https://github.com/jinxiansen on 16/7/11.
//  Copyright © 2016年 晋先森. All rights reserved.
//

#import "JHUD.h"

// 格式 0xff3737
#define RGBHexAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

#define KLastWindow [[UIApplication sharedApplication].windows lastObject]

#define JHUDMainThreadAssert() NSAssert([NSThread isMainThread], @"JHUD needs to be accessed on the main thread.");

@interface JHUD ()

@property (nonatomic) JHUDLoadingType hudType;

@end

@implementation JHUD

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

      [self configureBaseInfo];
      [self configureSubViews];

    }
    return self;
}

//
-(void)showAtView:(UIView *)view hudType:(JHUDLoadingType)hudType
{
    NSAssert(![self isEmptySize], @"啊! self 的 size 没有设置正确 ！self.frame not be nil(JHudView)");
    JHUDMainThreadAssert();

    self.hudType = hudType;

    [self setupSubViewsWithHudType:hudType];
    [self showHudAtView:view];
}

-(void)configureBaseInfo
{
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.activityViewSize = CGSizeMake(60, 60);
}

-(void)configureSubViews
{
    // self.topImageView and self.activityView as well as the constraint.
    // Both will not appear at the same time .
    [self addSubview:self.topImageView];
    [self addSubview:self.activityView];

    [self addSubview:self.messageLabel];

    [self addSubview:self.refreshButton];

}

-(void)setActivityViewSize:(CGSize)activityViewSize
{
    _activityViewSize = activityViewSize;

}

-(void)showHudAtView:(UIView *)view
{
    view ? [view addSubview:self]:[KLastWindow addSubview:self];
}

-(void)setCustomAnimationImages:(NSArray *)customAnimationImages
{
    _customAnimationImages = customAnimationImages;

    if (customAnimationImages.count>1) {
        self.topImageView.animationImages = _customAnimationImages;
    }
}

- (void)setupSubViewsWithHudType:(JHUDLoadingType)hudType
{
    switch (hudType) {
        case JHUDLoadingTypeActivity:
        {
            [self updateActivityHidden:NO refreshButtonHidden:YES isCustomAnimation:NO];
            break;
        }
        case JHUDLoadingTypeCustomAnimations:
        {
            [self updateActivityHidden:YES refreshButtonHidden:YES isCustomAnimation:YES];
            break;
        }
        case JHUDLoadingTypeNull:
        {
             [self updateActivityHidden:YES refreshButtonHidden:NO isCustomAnimation:NO];

            break;
        }
        case JHUDLoadingTypeFailure:
        {
             [self updateActivityHidden:YES refreshButtonHidden:NO isCustomAnimation:NO];
            break;
        }

        default:
            break;
    }
}


-(UIActivityIndicatorView *)activityView
{
    if (_activityView) {
        return _activityView;
    }
    self.activityView = [[UIActivityIndicatorView alloc]init];
    self.activityView.translatesAutoresizingMaskIntoConstraints = NO ;

    // There are three kinds of style, WhiteLarge,White and Gray .
    self.activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge ;//
    self.activityView.backgroundColor = [UIColor colorWithRed:(40/255.0f) green:(40/255.0f) blue:(40/255.0f) alpha:0.6f];
    self.activityView.layer.cornerRadius = 5;
    [self.activityView startAnimating];

    return self.activityView;
}

-(UIImageView *)topImageView
{
    if (_topImageView) {
        return _topImageView;
    }
    self.topImageView = [[UIImageView alloc]init];
    self.topImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.topImageView.animationDuration = 1;
    self.topImageView.animationRepeatCount = 0;

    return self.topImageView;
}

-(UILabel *)messageLabel
{
    if (_messageLabel) {
        return _messageLabel;
    }

    self.messageLabel = [UILabel new];
    self.messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.messageLabel.textAlignment = NSTextAlignmentCenter ;
    self.messageLabel.textColor = [UIColor lightGrayColor];
    self.messageLabel.font = [UIFont systemFontOfSize:16];
    self.messageLabel.backgroundColor = [UIColor clearColor];
    self.messageLabel.text = @"Please wait...";
    self.messageLabel.numberOfLines = 0;

    return self.messageLabel;
}

-(UIButton *)refreshButton
{
    if (_refreshButton) {
        return _refreshButton;
    }

    self.refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.refreshButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.refreshButton.tintColor = RGBHexAlpha(0x189cfb, 1);
    [self.refreshButton setTitle:@"Refresh" forState:UIControlStateNormal];
    [self.refreshButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.refreshButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    self.refreshButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.refreshButton.titleLabel.font = [UIFont systemFontOfSize:18];

    [self.refreshButton addTarget:self action:@selector(refreshButtonClick) forControlEvents:UIControlEventTouchUpInside];

    return self.refreshButton;
}

-(void)hideHudView
{
    JHUDMainThreadAssert();

    if (self.superview) {

        [UIView animateWithDuration:.2 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
             [self removeFromSuperview];
             self.alpha = 1;
        }];
    }
}


-(void)updateConstraints
{
    [super updateConstraints];

    [self removeAllConstraints];

    [self.refreshButton removeAllConstraints];
    [self.messageLabel removeConstraintWithAttribte:NSLayoutAttributeWidth];

    // messageLabel.constraint
    [self addConstraintCenterXToView:self.messageLabel centerYToView:self.messageLabel];
    [self.messageLabel addConstraintWidth:250 height:0];

    // activity.constraint
    [self addConstraintCenterXToView:self.activityView centerYToView:nil];
    [self addConstarintWithTopView:self.activityView toBottomView:self.messageLabel constarint:10];
    [self.activityView addConstraintWidth:self.activityViewSize.width height:self.activityViewSize.height];

    // topImageView..constraint
    [self addConstraintCenterXToView:self.topImageView centerYToView:nil];
    [self addConstarintWithTopView:self.topImageView toBottomView:self.messageLabel constarint:10];

    // refreshButton..constraint
    [self addConstraintCenterXToView:self.refreshButton centerYToView:nil];
    [self addConstarintWithTopView:self.messageLabel toBottomView:self.refreshButton constarint:0];
    [self.refreshButton addConstraintWidth:250 height:40];

//    NSLog(@"self.constraint.count %lu ",self.constraints.count);
//     NSLog(@"self.messageLabel.constraint.count %lu ",self.messageLabel.constraints.count);
//     NSLog(@"self.topImageView.constraints.count %lu ",self.topImageView.constraints.count);
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

-(void)updateActivityHidden:(BOOL)isActivityHidden refreshButtonHidden:(BOOL)isRefreshButtonHidden isCustomAnimation:(BOOL)isCustomAnimation
{
    isActivityHidden ? [self actiVityStopAnimating] :[self activityStartAnimating] ;
    isCustomAnimation ? [self topImageViewStartAnimating]:[self topImageViewStopAnimating];

    self.activityView.hidden = isActivityHidden;
    self.refreshButton.hidden = isRefreshButtonHidden;
}

-(void)topImageViewStartAnimating
{
    [self.topImageView startAnimating];
}

-(void)topImageViewStopAnimating
{
    self.topImageView.animationImages = nil;
}

-(void)actiVityStopAnimating
{
    self.activityView.hidden = YES;
    [self.activityView stopAnimating];

    self.topImageView.hidden = NO;
}

-(void)activityStartAnimating
{
    self.activityView.hidden = NO;
    [self.activityView startAnimating];

    self.topImageView.hidden = YES;
}


// When JHUDLoadingTypeNull and JHUDLoadingTypeFailure, there will be a "refresh" button, and the method.
-(void)refreshButtonClick
{
    if (self.JHUDExceptionsHandleBlock) {
        self.JHUDExceptionsHandleBlock(self.hudType);
    }
}

-(BOOL)isEmptySize
{
    if (self.frame.size.width>0 && self.frame.size.height >0) {
        return NO;
    }
    return YES;
}

@end



@implementation UIView (JHudAutoLayout)

- (void)addConstraintWidth:(CGFloat)width height:(CGFloat)height
{
    if (width > 0) {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:width]];
    }

    if (height > 0) {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:height]];
    }
}
- (void)addConstraintCenterXToView:(UIView *)xView centerYToView:(UIView *)yView
{
    if (xView) {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:xView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    }

    if (yView) {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:yView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    }
}

- (NSLayoutConstraint *)addConstraintCenterYToView:(UIView *)yView constant:(CGFloat)constant;
{
    if (yView) {
        NSLayoutConstraint *centerYConstraint = [NSLayoutConstraint constraintWithItem:yView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:constant];
        [self addConstraint:centerYConstraint];
        return centerYConstraint;
    }
    return nil;
}

- (NSLayoutConstraint *)addConstarintWithTopView:(UIView *)topView toBottomView:(UIView *)bottomView constarint:(CGFloat)constarint
{
    NSLayoutConstraint *topButtomConstraint =[NSLayoutConstraint constraintWithItem:topView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:bottomView attribute:NSLayoutAttributeTop multiplier:1 constant:-constarint];
    [self addConstraint:topButtomConstraint];
    return topButtomConstraint;
}

- (void)removeConstraintWithAttribte:(NSLayoutAttribute)attribute
{
    for (NSLayoutConstraint *constraint in self.constraints) {
        if (constraint.firstAttribute == attribute) {
            [self removeConstraint:constraint];
            break;
        }
    }
}

- (void)removeAllConstraints
{
    [self removeConstraints:self.constraints];
}


@end





