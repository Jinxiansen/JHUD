//
//  AppDelegate.m
//  JHudViewDemo
//
//  Created by 晋先森 on 16/7/11.
//  Copyright © 2016年 晋先森. All rights reserved.
//

#import "AppDelegate.h"

// 格式 0xff3737
#define JHUDRGBHexAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    UINavigationBar *appearance =[UINavigationBar appearance];
    appearance.barStyle = UIBarStyleBlack;
    [appearance setBackgroundImage:[UIImage new] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    appearance.shadowImage = [UIImage new];
    appearance.tintColor = [UIColor whiteColor];
    appearance.barTintColor = JHUDRGBHexAlpha(0x189cfb, 1);
    appearance.translucent = NO;
    appearance.clipsToBounds = NO;
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=8.2) {
        appearance.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:17 weight:UIFontWeightLight]};
    }else
    {
        appearance.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    }

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
