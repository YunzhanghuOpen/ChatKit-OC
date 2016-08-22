//
//  AppDelegate.m
//  LeanCloudChatKit-iOS
//
//  Created by ElonChan on 16/2/2.
//  Copyright © 2016年 LeanCloud. All rights reserved.
//

#import "AppDelegate.h"
#import "LCCKTabBarControllerConfig.h"
#import "LCCKConstantsDefinition.h"
#import "LCChatKitExample.h"
#import "LCCKUtil.h"
#if __has_include(<ChatKit/LCChatKit.h>)
#import <ChatKit/LCChatKit.h>
#else
#import "LCChatKit.h"
#endif
#import "LCCKLoginViewController.h"
#import "RedpacketConfig.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [LCChatKitExample invokeThisMethodInDidFinishLaunching];
    [self customizeNavigationBar];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    LCCKLoginViewController *loginViewController = [[LCCKLoginViewController alloc] initWithNibName:@"LCCKLoginViewController" bundle:[NSBundle mainBundle]];
    [loginViewController setClientIDHandler:^(NSString *clientID) {
        [LCCKUtil showProgressText:@"open client ..." duration:10.0f];
        [LCChatKitExample invokeThisMethodAfterLoginSuccessWithClientId:clientID success:^{
            [LCCKUtil hideProgress];
            LCCKTabBarControllerConfig *tabBarControllerConfig = [[LCCKTabBarControllerConfig alloc] init];
            self.window.rootViewController = tabBarControllerConfig.tabBarController;
        } failed:^(NSError *error) {
            [LCCKUtil hideProgress];
            NSLog(@"%@",error);
        }];
    }];
    
    [[RedpacketConfig sharedConfig] config];
    self.window.rootViewController = loginViewController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [LCChatKitExample invokeThisMethodInDidRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void)customizeNavigationBar {
    if ([UINavigationBar conformsToProtocol:@protocol(UIAppearanceContainer)]) {
        [UINavigationBar appearance].tintColor = [UIColor whiteColor];
        [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:18], NSForegroundColorAttributeName : [UIColor whiteColor]}];
        [[UINavigationBar appearance] setBarTintColor:NAVIGATION_COLOR];
        [[UINavigationBar appearance] setTranslucent:NO];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [LCChatKitExample invokeThisMethodInApplicationWillResignActive:application];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [LCChatKitExample invokeThisMethodInApplicationWillTerminate:application];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [LCChatKitExample invokeThisMethodInApplication:application didReceiveRemoteNotification:userInfo];
}

@end
