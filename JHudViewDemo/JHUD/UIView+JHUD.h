//
//  UIView+JHUD.h
//  JHudViewDemo
//
//  Created by 晋先森 on 16/7/16.
//  Copyright © 2016年 晋先森. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (JHUD)

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