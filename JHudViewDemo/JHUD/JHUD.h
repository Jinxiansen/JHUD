//
//  JHUD.h
//  JHUDDemo
//
//  Created by 晋先森 on 16/7/11.
//  Copyright © 2016年 晋先森. All rights reserved.
//  https://github.com/jinxiansen
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, JHUDLoadingType) {
    JHUDLoadingTypeCircle           = 0,
    JHUDLoadingTypeCircleJoin       = 1,
    JHUDLoadingTypeDot              = 2,
    JHUDLoadingTypeCustomAnimations = 3,
    JHUDLoadingTypeGifImage         = 4,
    JHUDLoadingTypeFailure          = 5,
};

@interface JHUD : UIView

// When JHUDLoadingTypeFailure, there will be a "refresh" button, and the method.
@property (nonatomic,copy)  void(^JHUDReloadButtonClickedBlock)();

@property (nonatomic,strong) UIView  *indicatorView;

@property (nonatomic,strong) UILabel  *messageLabel;

@property (nonatomic,strong) UIButton * refreshButton;

// Default color is [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.2]
@property (nonatomic,strong) UIColor  *indicatorBackGroundColor;

// Default color is  [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.6]
@property (nonatomic,strong) UIColor  *indicatorForegroundColor;

// Only JHUDLoadingType is JHUDLoadingTypeCustomAnimations or JHUDLoadingTypeFailure, indicatorViewSize values can be changed.
@property (nonatomic,assign) CGSize indicatorViewSize;

// You need to read from the NSbundle GIF image and converted to NSData.
@property (nonatomic) NSData  *gifImageData;

// Only when JHUDLoadingType is JHUDLoadingTypeCustomAnimations will only take effect.
@property (nonatomic,strong) NSArray  *customAnimationImages;

@property (nonatomic,strong) UIImage  *customImage;

#pragma mark - Instance methods
#pragma mark - Show HUD
-(void)showAtView:(UIView *)view hudType:(JHUDLoadingType)hudType;

#pragma mark - Hide HUD
-(void)hide;

/**
 *  Disappear after the afterDelay.
 *
 *  @param afterDelay
 */
-(void)hideAfterDelay:(NSTimeInterval)afterDelay;


#pragma mark - Class methods
#pragma mark - Show HUD

/**
 *  This method of JHUDLoadingType default is JHUDLoadingTypeCircle.
 *
 *  @param view    The parent view JHUD.
 *  @param message The label display content.
 */
+(void)showAtView:(UIView *)view message:(NSString *)message;

+(void)showAtView:(UIView *)view message:(NSString *)message hudType:(JHUDLoadingType)hudType;

#pragma mark - Hide HUD

+(void)hideForView:(UIView *)view;

@end



@interface UIView (MainQueue)

-(void)dispatchMainQueue:(dispatch_block_t)block;

@end







