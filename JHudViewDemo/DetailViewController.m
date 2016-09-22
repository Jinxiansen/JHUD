//
//  DetailViewController.m
//  JHudViewDemo
//
//  Created by 晋先森 on 16/7/15.
//  Copyright © 2016年 晋先森. All rights reserved.
//

#import "DetailViewController.h"

#import "JHUD.h"

// 格式 0xff3737
#define JHUDRGBHexAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

#define JHUDRGBA(r,g,b,a)     [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

@interface DetailViewController ()

@property (nonatomic,strong) UIButton *rightButton;

@property (nonatomic) JHUD *hudView;

@property (nonatomic) CGRect orignalRect;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = self.selName;
    self.view.backgroundColor = [UIColor lightGrayColor];

    // 建议基类中Lazy创建，进行二次封装，使用时直接调用，避免子类中频繁创建产生冗余代码的问题。
    self.hudView = [[JHUD alloc]initWithFrame:self.view.bounds];

    __weak typeof(self)  _self = self;
    [self.hudView setJHUDReloadButtonClickedBlock:^() {
        NSLog(@"refreshButton");
        [_self loadingCustomAnimations];
    }];

    SEL sel = NSSelectorFromString(self.selName);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self performSelector:sel withObject:nil];
#pragma clang diagnostic pop

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightButton];

}

-(void)rightButtonClick:(UIButton *)button
{
    button.selected = !button.selected;
    button.selected ? [self hide] : [self loadingFailure];
}

-(UIButton *)rightButton
{
    if (_rightButton) {
        return _rightButton;
    }
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightButton.frame = CGRectMake(0, 0,45, 35);
    [self.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.rightButton setTitle:@"Hide" forState:UIControlStateNormal];
    [self.rightButton setTitle:@"Show" forState:UIControlStateSelected];
    self.rightButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [self.rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];

    return self.rightButton;
}

-(void)loadingCircleAnimation
{
    self.hudView.messageLabel.text = @"Hello ,this is a circle animation";
    self.hudView.indicatorBackGroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.1];
    self.hudView.indicatorForegroundColor = [UIColor lightGrayColor];
    [self.hudView showAtView:self.view hudType:JHUDLoadingTypeCircle];
}

-(void)loadingCircleJoinAnimation
{
    self.hudView.messageLabel.text = @"Hello ,this is a circleJoin animation";
    self.hudView.indicatorForegroundColor = JHUDRGBA(60, 139, 246, .5);
    self.hudView.indicatorBackGroundColor = JHUDRGBA(185, 186, 200, 0.3);
    [self.hudView showAtView:self.view hudType:JHUDLoadingTypeCircleJoin];
}

-(void)loadingDotAnimation
{
    self.hudView.messageLabel.text = @"Hello ,this is a dot animation";
    self.hudView.indicatorBackGroundColor = [UIColor whiteColor];
    self.hudView.indicatorForegroundColor = [UIColor orangeColor];
    [self.hudView showAtView:self.view hudType:JHUDLoadingTypeDot];
}


-(void)loadingCustomAnimations
{
    NSMutableArray * images = [NSMutableArray array];
    for (int index = 0; index<=19; index++) {
        NSString * imageName = [NSString stringWithFormat:@"%d.png",index];
        UIImage *image = [UIImage imageNamed:imageName];
        [images addObject:image];
    }

    self.hudView.indicatorViewSize = CGSizeMake(80, 80);
    self.hudView.customAnimationImages = images;
    self.hudView.messageLabel.text = @"无人问我粥可温\n无人与我共黄昏";
    [self.hudView showAtView:self.view hudType:JHUDLoadingTypeCustomAnimations];

    // Recommend two web sites
    // http://preloaders.net/en/people_and_animals
    // https://convertio.co/zh/gif-png/
    // http://spiffygif.com
}

-(void)loadingGifAnimations
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"loadinggif3" ofType:@"gif"];
    NSData *data = [NSData dataWithContentsOfFile:path];

    self.hudView.gifImageData = data;
    self.hudView.indicatorViewSize = CGSizeMake(110, 110); // Maybe you can try to use (100,250);😂
    self.hudView.messageLabel.text = @"Hello ,this is a gif animation";
    [self.hudView showAtView:self.view hudType:JHUDLoadingTypeGifImage];
}


-(void)loadingFailure
{
    self.hudView.indicatorViewSize = CGSizeMake(100, 100);
    self.hudView.messageLabel.text = @"Can't get data, please make sure the interface is correct !";
    [self.hudView.refreshButton setTitle:@"Refresh" forState:UIControlStateNormal];
    self.hudView.customImage = [UIImage imageNamed:@"null"];

    [self.hudView showAtView:self.view hudType:JHUDLoadingTypeFailure];

}

-(void)loadingFailure2
{
    self.hudView.indicatorViewSize = CGSizeMake(150, 150);
    self.hudView.messageLabel.text = @"Failed to get data, please try again later";
    [self.hudView.refreshButton setTitle:@"Refresh ?" forState:UIControlStateNormal];
    self.hudView.customImage = [UIImage imageNamed:@"nullData"];

    [self.hudView showAtView:self.view hudType:JHUDLoadingTypeFailure];

}

-(void)classMethod
{
    self.rightButton.hidden = YES;

    [JHUD showAtView:self.view message:@"I'm a class method."];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [JHUD hideForView:self.view];
    });
    
}

// 横竖屏适配的话，只需在此更新hudView本身的frame即可。
-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    CGFloat padding = 0;
    self.hudView.frame = CGRectMake(padding,
                                    padding,
                                    self.view.frame.size.width - padding*2,
                                    self.view.frame.size.height - padding*2);
}

-(void)hide
{
    [self.hudView hide];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
