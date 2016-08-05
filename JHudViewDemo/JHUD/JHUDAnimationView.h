//
//  JHUDAnimationView.h
//  JHudViewDemo
//
//  Created by 晋先森 on 16/7/16.
//  Copyright © 2016年 晋先森. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, JHUDAnimationType) {
    JHUDAnimationTypeCircle = 0,
    JHUDAnimationTypeCircleJoin,
    JHUDAnimationTypeDot,
};

@interface JHUDAnimationView : UIView

@property (nonatomic,assign) NSInteger  count;

@property (nonatomic) UIColor  *defaultBackGroundColor;//

@property (nonatomic) UIColor  *foregroundColor;

- (void)showAnimationAtView:(UIView *)view animationType:(JHUDAnimationType)animationType;

-(void)removeSubLayer;

@end

