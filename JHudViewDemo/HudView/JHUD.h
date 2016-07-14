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
    JHUDLoadingTypeFailure,
};

@interface JHUD : UIView

/**
 *  When JHUDLoadingTypeFailure, there will be a "refresh" button, and the method.
 */
@property (nonatomic,copy)  void(^JHUDReloadButtonClickedBlock)();

@property (nonatomic,strong) UIImageView  *topImageView;

@property (nonatomic,strong) UILabel  *messageLabel;

@property (nonatomic,strong) UIButton * refreshButton;

/**
 *  Only when JHUDLoadingType is JHUDLoadingTypeActivity will only take effect .
 */
@property (nonatomic,strong) UIActivityIndicatorView * activityView;

/**
 *  The default size is CGSizeMake (60, 60) .
 */
@property (nonatomic,assign) CGSize activityViewSize;

/**
 *  The default size is CGSizeMake (100, 100).
 */
@property (nonatomic,assign) CGSize topImageViewSize;

/**
 *  Only when JHUDLoadingType is JHUDLoadingTypeCustomAnimations will only take effect .
 */
@property (nonatomic,strong) NSArray  *customAnimationImages;

-(void)showAtView:(UIView *)view hudType:(JHUDLoadingType)hudType;

-(void)hide;

@end



@interface UIView (JHUDAutoLayout)

- (void)addConstraintWidth:(CGFloat)width
                    height:(CGFloat)height;

- (void)addConstraintCenterXToView:(UIView *)xView
                     centerYToView:(UIView *)yView;

- (NSLayoutConstraint *)addConstraintCenterYToView:(UIView *)yView
                                          constant:(CGFloat)constant;

- (NSLayoutConstraint *)addConstarintWithTopView:(UIView *)topView
                                    toBottomView:(UIView *)bottomView
                                      constarint:(CGFloat)constarint;

- (void)removeConstraintWithAttribte:(NSLayoutAttribute)attribute;

- (void)removeAllConstraints;

@end





