//
//  AppDelegate.m
//  peripheralDeviceTest
//
//  Created by chairman on 16/5/7.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self registerLocalNotification];
    return YES;
}

- (void)registerLocalNotification {
    //* 第一个动作 */
    //创建消息上面要添加的动作
    UIMutableUserNotificationAction *praiseUserNTAction = [[UIMutableUserNotificationAction alloc] init];
    praiseUserNTAction.identifier = kNotificationActionIdentifierStar;
    praiseUserNTAction.title = @"赞";
    //* 当点击的时候不启动程序,在后台处理 */
    praiseUserNTAction.activationMode = UIUserNotificationActivationModeBackground;
    //* 需要解锁才能处理(意思就是如果在锁屏界面收到通知，并且用户设置了屏幕锁，用户点击了赞不会直接进入我们的回调进行处理，而是需要用户输入屏幕锁密码之后才进入我们的回调)，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略； */
    praiseUserNTAction.authenticationRequired = YES;
    /*destructive属性设置后，在通知栏或锁屏界面左划，按钮颜色会变为红色
     如果两个按钮均设置为YES，则均为红色（略难看）
     如果两个按钮均设置为NO，即默认值，则第一个为蓝色，第二个为浅灰色
     如果一个YES一个NO，则都显示对应的颜色，即红蓝双色 (CP色)。*/
    praiseUserNTAction.destructive = NO;
    
    //* 第二个动作 */
    UIMutableUserNotificationAction *commentUserNTAction = [[UIMutableUserNotificationAction alloc] init];
    commentUserNTAction.identifier = kNotificationActionIdentifileComment;
    commentUserNTAction.title = @"评论";
    commentUserNTAction.activationMode = UIUserNotificationActivationModeBackground;
    //设置了behavior属性为 UIUserNotificationActionBehaviorTextInput 的话，则用户点击了该按钮会出现输入框供用户输入
    commentUserNTAction.behavior = UIUserNotificationActionBehaviorTextInput;
    //这个字典定义了当用户点击了评论按钮后，输入框右侧的按钮名称，如果不设置该字典，则右侧按钮名称默认为 “发送”
    commentUserNTAction.parameters = @{UIUserNotificationTextInputActionButtonTitleKey:@"评论"};
    
    //* 创建动作(按钮)的类别集合 */
    UIMutableUserNotificationCategory *category = [[UIMutableUserNotificationCategory alloc] init];
    //* 这组动作的唯一标示 */
    category.identifier = kNotificationCategoryIdentifile;
    //* 最多添加两个,如果添加更多的话,后面的将会自动忽略 */
    [category setActions:nil forContext:UIUserNotificationActionContextMinimal];
    
    //创建UIUserNotificationSettings，并设置消息的显示类类型
    UIUserNotificationSettings *uns = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound) categories:[NSSet setWithObject:category]];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:uns];
    
    
}
//* 本地通知回调函数,当应用程序在前台调用 */
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
    badge -= notification.applicationIconBadgeNumber;
    badge = badge >= 0 ? badge : 0;
    [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
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
