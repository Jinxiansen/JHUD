//
//  ViewController.m
//  JHudViewDemo
//
//  Created by 晋先森 on 16/7/11.
//  Copyright © 2016年 晋先森. All rights reserved.
//

#import "ViewController.h"
#import "JHUD.h"

@interface ViewController ()

@property (nonatomic) JHUD *hudView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.hudView = [[JHUD alloc]initWithFrame:self.view.bounds];

//    self.hudView.activityViewSize = CGSizeMake(70, 70);
    [self showLoadingActivityView];

    [self.hudView setJHUDExceptionsHandleBlock:^(JHUDLoadingType type) {
        NSLog(@"Loading Type : %lu",(unsigned long)type);
    }];
}

-(void)showLoadingActivityView
{
    self.hudView.messageLabel.text = @"This is a default activityView .";

    [self.hudView showAtView:self.view hudType:JHUDLoadingTypeActivity];
}

-(void)showLoadingCustomAnimations
{
    NSMutableArray * images = [NSMutableArray array];
    for (int index = 0; index<=19; index++) {
        NSString * imageName = [NSString stringWithFormat:@"%d.png",index];
        UIImage *image = [UIImage imageNamed:imageName];
        [images addObject:image];
    }

    self.hudView.customAnimationImages = images;
    self.hudView.messageLabel.text = @"有些时候，我会一个人背着包随处走走，我喜欢独自漫步的感觉，沿着具有传奇色彩的世纪大道，伴着昏黄怀旧的路灯，走过霓虹灯照耀下的外滩，东方明珠塔，金茂大厦。那时候可以静心思考技术疑问，或回忆过往的青葱岁月，也可以感受大上海的日与夜，体验这座城市的广度与深度。或许，风情的上海就是一个属于创造与实现梦想的地方，但是勤奋与努力是你在这里立足的根本，她就像莫斯科一样，不相信眼泪也不同情弱者。";
    [self.hudView showAtView:self.view hudType:JHUDLoadingTypeCustomAnimations];

    // Recommend two web sites
    // http://preloaders.net/en/people_and_animals
    // https://convertio.co/zh/gif-png/
    // http://spiffygif.com
}


-(void)showLoadingNull
{
    self.hudView.messageLabel.text = @"Can't get data, please make sure the interface is correct !";
    [self.hudView.refreshButton setTitle:@"Refresh" forState:UIControlStateNormal];
    self.hudView.topImageView.image = [UIImage imageNamed:@"failed"];

    [self.hudView showAtView:self.view hudType:JHUDLoadingTypeNull];
    
}

-(void)showLoadingFailure
{
     self.hudView.messageLabel.text = @"Failed to get data, please try again later";
     [self.hudView.refreshButton setTitle:@"Refresh ?" forState:UIControlStateNormal];
     self.hudView.topImageView.image = [UIImage imageNamed:@"nullData"];

    [self.hudView showAtView:self.view hudType:JHUDLoadingTypeFailure];

}

- (IBAction)ButtonClick:(UIButton *)sender {

    static int i = 1;

    if (i>3) {
        i=0;
    }

    NSArray * sels = @[@"showLoadingActivityView",
                       @"showLoadingCustomAnimations",
                       @"showLoadingNull",
                       @"showLoadingFailure"];

    SEL sel = NSSelectorFromString(sels[i++]);

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self performSelector:sel withObject:nil];
#pragma clang diagnostic pop

}


- (IBAction)hideButtonClick:(UIButton *)sender {

     [self.hudView hideHudView];
}
 

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
