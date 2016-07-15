//
//  JHUD.m
//  JHudViewDemo
//
//  Created by 晋先森 https://github.com/jinxiansen on 16/7/11.
//  Copyright © 2016年 晋先森. All rights reserved.
//

#import "JHUD.h"

#define KLastWindow [[UIApplication sharedApplication].windows lastObject]

//#define JHUDMainThreadAssert() NSAssert([NSThread isMainThread], @"JHUD needs to be accessed on the main thread.");

#pragma mark -  JHUD Class

@interface JHUD ()

@property (nonatomic) JHUDLoadingType hudType;

@property (nonatomic,strong) JHUDLoadingAnimationView  *loadingView;

@property (nonatomic,strong) UIImageView  *imageView;

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

-(void)configureBaseInfo
{
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.indicatorViewSize = CGSizeMake(100, 100);
}

-(void)configureSubViews
{
    [self addSubview:self.indicatorView];
    
    [self addSubview:self.messageLabel];

    [self addSubview:self.refreshButton];

    [self.indicatorView addSubview:self.loadingView];
    [self.indicatorView addSubview:self.imageView];
}

#pragma mark - show method 

-(void)showAtView:(UIView *)view hudType:(JHUDLoadingType)hudType
{
    NSAssert(![self isEmptySize], @"啊! self 的 size 没有设置正确 ！self.frame not be nil(JHudView)");

    self.hudType = hudType;

    [self hide];

    [self setupSubViewsWithHudType:hudType];

    [self dispatchMainQueue:^{

        view ? [view addSubview:self]:[KLastWindow addSubview:self];
        [self.superview bringSubviewToFront:self];
    }];
}

-(void)hide
{
    [self dispatchMainQueue:^{
        if (self.superview) {
            [self removeFromSuperview];
            [self.loadingView removeSubLayer];
        }
    }];

}


-(void)setindicatorViewSize:(CGSize)indicatorViewSize
{
    _indicatorViewSize = indicatorViewSize;

    [self setNeedsUpdateConstraints];
}

-(void)setCustomAnimationImages:(NSArray *)customAnimationImages
{
    _customAnimationImages = customAnimationImages;

     if (customAnimationImages.count>1) {
         self.imageView.animationImages = _customAnimationImages;
         [self.imageView startAnimating];
     }
    [self setNeedsUpdateConstraints];
    [self setNeedsLayout];
}

-(void)setCustomImage:(UIImage *)customImage
{
    _customImage = customImage;

    [self.imageView stopAnimating];

    self.imageView.image = customImage;
}

-(void)setIndicatorBackGroundColor:(UIColor *)indicatorBackGroundColor
{
    _indicatorBackGroundColor = indicatorBackGroundColor;
    self.loadingView.defaultBackGroundColor = _indicatorBackGroundColor;

}

-(void)setIndicatorForegroundColor:(UIColor *)indicatorForegroundColor
{
    _indicatorForegroundColor = indicatorForegroundColor;

    self.loadingView.foregroundColor = _indicatorForegroundColor;

}

+(BOOL)requiresConstraintBasedLayout
{
    return YES;
}

- (void)setupSubViewsWithHudType:(JHUDLoadingType)hudType
{
    hudType == JHUDLoadingTypeFailure ?
    [self isShowRefreshButton:YES]:
    [self isShowRefreshButton:NO];

    if ((hudType == JHUDLoadingTypeCustomAnimations) | (hudType == JHUDLoadingTypeFailure) ) {
        self.imageView.hidden = NO;
        [self.loadingView removeFromSuperview];

    }else
    {
       self.imageView.hidden = YES;
       self.indicatorViewSize = CGSizeMake(100, 100);
       if (!self.loadingView.superview) {
         [self.indicatorView addSubview:self.loadingView];
       }
    }

    switch (hudType) {
        case JHUDLoadingTypeCircle:
        {
            [self.loadingView showAnimationAtView:self animationType:JHUDAnimationTypeCircle];
            break;
        }
        case JHUDLoadingTypeCircleJoin:
        {
            [self.loadingView showAnimationAtView:self animationType:JHUDAnimationTypeCircleJoin];

            break;
        }
        case JHUDLoadingTypeDot:
        {
            [self.loadingView showAnimationAtView:self animationType:JHUDAnimationTypeDot];

            break;
        }
        case JHUDLoadingTypeCustomAnimations:
        {

            break;
        }
        case JHUDLoadingTypeFailure:
        {
            [self remind];
            break;
        }

        default:
            break;
    }

}

-(void)remind
{
    if (!self.messageLabel.text.length) {
         NSLog(@"Please set the messageLabel text.(JHUD)");
    }
    if (!self.refreshButton.titleLabel.text.length) {
         NSLog(@"Please set the refreshButton.titleLabel text.(JHUD)");
    }
}


#pragma mark  --  Lazy method

-(JHUDLoadingAnimationView *)loadingView
{
    if (_loadingView) {
        return _loadingView;
    }
    self.loadingView = [[JHUDLoadingAnimationView alloc]init];
    self.loadingView.translatesAutoresizingMaskIntoConstraints = NO;
    self.loadingView.backgroundColor = [UIColor clearColor];

    return self.loadingView;
}

-(UIView *)indicatorView
{
    if (_indicatorView) {
        return _indicatorView;
    }
    self.indicatorView = [[UIView alloc]init];
    self.indicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    self.indicatorView.backgroundColor = [UIColor clearColor];

    return self.indicatorView;
}

-(UIImageView *)imageView
{
    if (_imageView) {
        return _imageView;
    }
    self.imageView = [[UIImageView alloc]init];
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO ;
    self.imageView.animationDuration = 1;
    self.imageView.animationRepeatCount = 0;

    return self.imageView;
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
    [self.refreshButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.refreshButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    self.refreshButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.refreshButton.titleLabel.font = [UIFont systemFontOfSize:18];

    self.refreshButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.refreshButton.layer.borderWidth = 0.5;
    [self.refreshButton addTarget:self action:@selector(refreshButtonClick) forControlEvents:UIControlEventTouchUpInside];

    return self.refreshButton;
}


#pragma mark  --  updateConstraints 

-(void)updateConstraints
{

    [self removeAllConstraints];

    [self.refreshButton removeAllConstraints];
    [self.messageLabel removeConstraintWithAttribte:NSLayoutAttributeWidth];
    [self.indicatorView removeAllConstraints];
    [self.loadingView removeAllConstraints];
    [self.imageView removeAllConstraints];

    // messageLabel.constraint
    [self addConstraintCenterXToView:self.messageLabel centerYToView:self.messageLabel];
    [self.messageLabel addConstraintWidth:250 height:0];

    // indicatorView.constraint
    [self addConstraintCenterXToView:self.indicatorView centerYToView:nil];
    [self addConstarintWithTopView:self.indicatorView toBottomView:self.messageLabel constarint:10];
    [self.indicatorView addConstraintWidth:self.indicatorViewSize.width height:self.indicatorViewSize.height];

    // imageView.constraint
    [self.indicatorView addConstraintCenterXToView:self.imageView centerYToView:self.imageView];
    [self.imageView addConstraintWidth:self.indicatorViewSize.width height:self.indicatorViewSize.height];

    // loadingView.constraint
    if (self.loadingView.superview) {
        [self.indicatorView addConstraintCenterXToView:self.loadingView centerYToView:self.loadingView];
        [self.loadingView addConstraintWidth:self.indicatorViewSize.width height:self.indicatorViewSize.height];

    }
    // refreshButton..constraint
    [self addConstraintCenterXToView:self.refreshButton centerYToView:nil];
    [self addConstarintWithTopView:self.messageLabel toBottomView:self.refreshButton constarint:10];
    [self.refreshButton addConstraintWidth:100 height:35];

//    NSLog(@"self.constraint.count %lu ",self.constraints.count);

    [super updateConstraints];
}

-(void)layoutSubviews
{
    [super layoutSubviews];

}


#pragma mark  --  Other method

-(void)isShowRefreshButton:(BOOL)isShowRefreshButton
{
    if (isShowRefreshButton) {

        self.refreshButton.hidden = NO;
    } else {
        self.refreshButton.hidden = YES;
    }
    
}

// When JHUDLoadingTypeFailure, there will be a "refresh" button, and the method.
-(void)refreshButtonClick
{
    [self.loadingView removeSubLayer];

    if (self.JHUDReloadButtonClickedBlock) {
        self.JHUDReloadButtonClickedBlock();
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

#pragma mark - UIView (MainQueue)

@implementation UIView (MainQueue)

-(void)dispatchMainQueue:(dispatch_block_t)block
{
    dispatch_async(dispatch_get_main_queue(), ^{
        block();
    });
}

@end


#pragma mark - JHUDAutoLayout Class

@implementation UIView (JHUDAutoLayout)

- (void)addConstraintWidth:(CGFloat)width height:(CGFloat)height
{
    if (width > 0) {
        [self addConstraint:[NSLayoutConstraint
                             constraintWithItem:self
                             attribute:NSLayoutAttributeWidth
                             relatedBy:NSLayoutRelationEqual
                             toItem:nil
                             attribute:0
                             multiplier:1
                             constant:width]];
    }

    if (height > 0) {
        [self addConstraint:[NSLayoutConstraint
                             constraintWithItem:self
                             attribute:NSLayoutAttributeHeight
                             relatedBy:NSLayoutRelationEqual
                             toItem:nil
                             attribute:0
                             multiplier:1
                             constant:height]];
    }
}
- (void)addConstraintCenterXToView:(UIView *)xView
                     centerYToView:(UIView *)yView
{
    if (xView) {
        [self addConstraint:[NSLayoutConstraint
                             constraintWithItem:xView
                             attribute:NSLayoutAttributeCenterX
                             relatedBy:NSLayoutRelationEqual
                             toItem:self
                             attribute:NSLayoutAttributeCenterX
                             multiplier:1.0
                             constant:0]];
    }

    if (yView) {
        [self addConstraint:[NSLayoutConstraint
                             constraintWithItem:yView
                             attribute:NSLayoutAttributeCenterY
                             relatedBy:NSLayoutRelationEqual
                             toItem:self
                             attribute:NSLayoutAttributeCenterY
                             multiplier:1.0
                             constant:0]];
    }
}

- (NSLayoutConstraint *)addConstraintCenterYToView:(UIView *)yView
                                          constant:(CGFloat)constant;
{
    if (yView) {
        NSLayoutConstraint *centerYConstraint = [NSLayoutConstraint
                                                 constraintWithItem:yView
                                                 attribute:NSLayoutAttributeCenterY
                                                 relatedBy:NSLayoutRelationEqual
                                                 toItem:self
                                                 attribute:NSLayoutAttributeCenterY
                                                 multiplier:1.0
                                                 constant:constant];
        [self addConstraint:centerYConstraint];
        return centerYConstraint;
    }
    return nil;
}

- (NSLayoutConstraint *)addConstarintWithTopView:(UIView *)indicatorView
                                    toBottomView:(UIView *)bottomView
                                      constarint:(CGFloat)constarint
{
    NSLayoutConstraint *topButtomConstraint =[NSLayoutConstraint
                                              constraintWithItem:indicatorView
                                              attribute:NSLayoutAttributeBottom
                                              relatedBy:NSLayoutRelationEqual
                                              toItem:bottomView
                                              attribute:NSLayoutAttributeTop
                                              multiplier:1
                                              constant:-constarint];
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


#pragma mark -  JHUDLoadingAnimationView Class

#define JHUDDefaultBackGroundColor [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.2]
#define JHUDForegroundColor [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.6]

@interface JHUDLoadingAnimationView ()

@property (nonatomic,strong) CAReplicatorLayer * replicatorLayer ;

@property (nonatomic,strong) CALayer * mylayer;

@property (nonatomic,strong) CABasicAnimation  * basicAnimation;

@property (nonatomic) JHUDAnimationType type ;

@end


@implementation JHUDLoadingAnimationView

- (instancetype)init
{
    self = [super init];
    if (self) {

        self.defaultBackGroundColor = JHUDDefaultBackGroundColor;
        self.foregroundColor = JHUDForegroundColor;
        self.count = 10;
    }
    return self;
}

-(CAReplicatorLayer *)replicatorLayer
{
    if (_replicatorLayer) {
        return _replicatorLayer;
    }
    self.replicatorLayer = [CAReplicatorLayer layer];
    self.replicatorLayer.cornerRadius = 10.0;

    return self.replicatorLayer;
}

-(CALayer *)mylayer
{
    if (_mylayer) {
        return _mylayer;
    }
    self.mylayer = [CALayer layer];
    self.mylayer.masksToBounds = YES;
    return self.mylayer;
}

-(CABasicAnimation *)basicAnimation
{
    if (_basicAnimation) {
        return _basicAnimation;
    }
    self.basicAnimation = [CABasicAnimation animation];
    self.basicAnimation.repeatCount = MAXFLOAT;
    self.basicAnimation.removedOnCompletion = NO;
    self.basicAnimation.fillMode = kCAFillModeForwards;

    return self.basicAnimation;
}

-(void)setDefaultBackGroundColor:(UIColor *)defaultBackGroundColor
{
    _defaultBackGroundColor = defaultBackGroundColor;

    self.replicatorLayer.backgroundColor = defaultBackGroundColor.CGColor;

}

-(void)setForegroundColor:(UIColor *)foregroundColor
{
    _foregroundColor = foregroundColor;

    self.mylayer.backgroundColor = foregroundColor.CGColor;

}

#pragma mark - ShowAnimation method

-(void)showAnimationAtView:(UIView *)view animationType:(JHUDAnimationType)animationType
{

    [self dispatchMainQueue:^{
        [self removeSubLayer];
    }];

    self.type = animationType;

    switch (animationType) {
        case JHUDAnimationTypeCircle:

            self.count = 10;
            [self configCircle];
            break;
        case JHUDAnimationTypeCircleJoin:

            self.count = 100;
            [self configCircle];
            break;
        case JHUDAnimationTypeDot:

            self.count = 3;
            [self configDot];
            break;
        default:
            break;
    }

    [self dispatchMainQueue:^{
         [self addSubLayer];
    }];

}


-(void)configCircle
{
    CGFloat width = 10;

    self.mylayer.frame = CGRectMake(0, 0, width, width);
    self.mylayer.cornerRadius = width / 2;
    self.mylayer.transform = CATransform3DMakeScale(0.01, 0.01, 0.01);

    self.replicatorLayer.instanceCount = self.count;

    CGFloat angle = 2 * M_PI / self.count;
    self.replicatorLayer.instanceTransform = CATransform3DMakeRotation(angle, 0, 0, 1);
    self.replicatorLayer.instanceDelay = 1.0 / self.count;

    self.basicAnimation.keyPath = @"transform.scale";
    self.basicAnimation.duration = 1;
    self.basicAnimation.fromValue = @1;
    self.basicAnimation.toValue = @0.1;

}


-(void)configDot
{
    CGFloat width = 15 ;

    self.mylayer.frame = CGRectMake(0, 0, width, width);
    self.mylayer.transform = CATransform3DMakeScale(0, 0, 0);
    self.mylayer.cornerRadius = width / 2;
    self.replicatorLayer.instanceCount = self.count;

    self.replicatorLayer.instanceTransform = CATransform3DMakeTranslation(100/3, 0, 0);
    self.replicatorLayer.instanceDelay = 0.8 / self.count;

    self.basicAnimation.keyPath = @"transform.scale";
    self.basicAnimation.duration = 0.8;
    self.basicAnimation.fromValue = @1;
    self.basicAnimation.toValue = @0;

}

-(void)removeSubLayer
{
    [self.replicatorLayer removeFromSuperlayer];
    [self.mylayer removeFromSuperlayer];
    [self.mylayer removeAnimationForKey:@"JHUD"];

}

-(void)addSubLayer
{
    [self.layer addSublayer:self.replicatorLayer];
    [self.replicatorLayer addSublayer:self.mylayer];
    [self.mylayer addAnimation:self.basicAnimation forKey:@"JHUD"];

}

-(void)layoutSubviews
{
    [super layoutSubviews];

    self.replicatorLayer.frame = self.bounds;
    self.replicatorLayer.position = self.center;

    switch (self.type) {
        case JHUDAnimationTypeCircle:
        case JHUDAnimationTypeCircleJoin:
             self.mylayer.position = CGPointMake(50,20);
            break;

        case JHUDAnimationTypeDot:
            self.mylayer.position = CGPointMake(15, 50);
            break;
            
        default:
            break;
    }
}



@end





