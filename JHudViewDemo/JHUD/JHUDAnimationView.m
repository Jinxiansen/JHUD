//
//  JHUDAnimationView.m
//  JHudViewDemo
//
//  Created by 晋先森 on 16/7/16.
//  Copyright © 2016年 晋先森. All rights reserved.
//

#import "JHUDAnimationView.h"
#import "JHUD.h"

#pragma mark -  JHUDLoadingAnimationView Class

#define JHUDDefaultBackGroundColor [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.2]
#define JHUDForegroundColor [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.6]

@interface JHUDAnimationView ()

@property (nonatomic,strong) CAReplicatorLayer * replicatorLayer ;

@property (nonatomic,strong) CALayer * mylayer;

@property (nonatomic,strong) CABasicAnimation  * basicAnimation;

@property (nonatomic) JHUDAnimationType type ;

@end


@implementation JHUDAnimationView

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