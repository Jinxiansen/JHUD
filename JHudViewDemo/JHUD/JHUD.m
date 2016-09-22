//
//  JHUD.m
//  JHudViewDemo
//
//  Created by 晋先森 on 16/7/11.
//  Copyright © 2016年 晋先森. All rights reserved.
//  https://github.com/jinxiansen
//

#import "JHUD.h"
#import "JHUDAnimationView.h"
#import "UIView+JHUD.h"
#import "UIImage+JHUD.h"

#define KLastWindow [[UIApplication sharedApplication].windows lastObject]

//#define JHUDMainThreadAssert() NSAssert([NSThread isMainThread], @"JHUD needs to be accessed on the main thread.");


#pragma mark -  JHUD Class

@interface JHUD ()

@property (nonatomic) JHUDLoadingType hudType;

@property (nonatomic,strong) JHUDAnimationView  *loadingView;

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
    NSAssert(![self isEmptySize], @"啊! JHUD 的 size 没有设置正确 ！self.frame not be nil(JHUD)");
    
    self.hudType = hudType;
    
    [self hide];
    
    [self setupSubViewsWithHudType:hudType];
    
    [self dispatchMainQueue:^{
        
        view ? [view addSubview:self]:[KLastWindow addSubview:self];
        [self.superview bringSubviewToFront:self];
    }];
}

+(void)showAtView:(UIView *)view message:(NSString *)message
{
    [self showAtView:view message:message hudType:JHUDLoadingTypeCircle];
}

+(void)showAtView:(UIView *)view message:(NSString *)message hudType:(JHUDLoadingType)hudType
{
    JHUD * hud = [[self alloc]initWithFrame:view.bounds];
    hud.messageLabel.text = message;

    [hud showAtView:view hudType:hudType];
}

+(void)hideForView:(UIView *)view
{
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:self]) {
            JHUD * hud = (JHUD *)subview;
            [hud hide];
        }
    }
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

-(void)hideAfterDelay:(NSTimeInterval)afterDelay
{
    [self performSelector:@selector(hide) withObject:nil afterDelay:afterDelay];
}

-(void)setGifImageData:(NSData *)gifImageData
{
    _gifImageData = gifImageData;

    UIImage * image = [UIImage jHUDImageWithSmallGIFData:gifImageData scale:1];
    self.imageView.image = image;
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
    hudType == JHUDLoadingTypeFailure ? [self isShowRefreshButton:YES]:
                                        [self isShowRefreshButton:NO];
    
    if ( hudType >2 ) {
        self.imageView.hidden = NO;
        [self.loadingView removeFromSuperview];
        
    }else
    {
        self.imageView.hidden = YES;
        
        //The size of the fixed loadingView .
        self.indicatorViewSize = CGSizeMake(100, 100);

        if (!self.loadingView.superview) {
            [self.indicatorView addSubview:self.loadingView];
        }
    }
    
    switch (hudType) {
        case JHUDLoadingTypeCircle:
            [self.loadingView showAnimationAtView:self animationType:JHUDAnimationTypeCircle];
            break;
        case JHUDLoadingTypeCircleJoin:
            [self.loadingView showAnimationAtView:self animationType:JHUDAnimationTypeCircleJoin];
            break;
        case JHUDLoadingTypeDot:
            [self.loadingView showAnimationAtView:self animationType:JHUDAnimationTypeDot];
            break;
        case JHUDLoadingTypeCustomAnimations:
            break;
        case JHUDLoadingTypeGifImage:
            break;
        case JHUDLoadingTypeFailure:
            break;

        default:
            break;
    }
    
}

#pragma mark  --  Lazy method

-(JHUDAnimationView *)loadingView
{
    if (_loadingView) {
        return _loadingView;
    }
    self.loadingView = [[JHUDAnimationView alloc]init];
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
    self.messageLabel.text = @"Please wait ...";
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
    [self.refreshButton setTitle:@"Refresh" forState:UIControlStateNormal];
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

#pragma mark - other method

-(void)isShowRefreshButton:(BOOL)isShowRefreshButton
{
    if (isShowRefreshButton) {
        
        self.refreshButton.hidden = NO;
    } else {
        self.refreshButton.hidden = YES;
    }
}

// When JHUDLoadingType >2, there will be a "refresh" button, and the method.
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






