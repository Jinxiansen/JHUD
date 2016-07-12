//
//  JHUD.h
//  JHUDDemo
//
//  Created by 晋先森 https://github.com/jinxiansen on 16/7/11.
//  Copyright © 2016年 晋先森. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, JHUDLoadingType) {
    JHUDLoadingTypeActivity = 0,
    JHUDLoadingTypeCustomAnimations,
    JHUDLoadingTypeNull,
    JHUDLoadingTypeFailure,
};

@interface JHUD : UIView

/**
 *  When JHUDLoadingTypeNull and JHUDLoadingTypeFailure, there will be a "refresh" button, and the method.
 */
@property (nonatomic)  void(^JHUDExceptionsHandleBlock)(JHUDLoadingType hudType); 

@property (nonatomic) UIImageView  *topImageView;

@property (nonatomic) UILabel  *messageLabel;

@property (nonatomic) UIButton * refreshButton;

/**
 *  Only when JHUDLoadingType is JHUDLoadingTypeActivity will only take effect .
 */
@property (nonatomic) UIActivityIndicatorView * activityView;

@property (nonatomic) CGSize activityViewSize;

/**
 *  Only when JHUDLoadingType is JHUDLoadingTypeCustomAnimations will only take effect .
 */
@property (nonatomic) NSArray  *customAnimationImages;

-(void)showAtView:(UIView *)view hudType:(JHUDLoadingType)hudType;

-(void)hideHudView;

@end


@interface UIView (JHUDAutoLayout)

- (void)addConstraintWidth:(CGFloat)width height:(CGFloat)height;

- (void)addConstraintCenterXToView:(UIView *)xView centerYToView:(UIView *)yView;

- (NSLayoutConstraint *)addConstraintCenterYToView:(UIView *)yView constant:(CGFloat)constant;

- (NSLayoutConstraint *)addConstarintWithTopView:(UIView *)topView toBottomView:(UIView *)bottomView constarint:(CGFloat)constarint;

- (void)removeConstraintWithAttribte:(NSLayoutAttribute)attribute;

- (void)removeAllConstraints;

@end








