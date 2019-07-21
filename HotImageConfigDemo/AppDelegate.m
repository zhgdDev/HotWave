//
//  AppDelegate.m
//  HotImageConfigDemo
//
//  Created by Dubai on 2019/4/26.
//  Copyright © 2019 Dubai. All rights reserved.
//

#import "AppDelegate.h"

#import "HotPointViewController.h"
#import "HotImageModel.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
        
    //马甲热图SDK技术方法demo
    NSDictionary *jsonData = [self mj_readLocalFileWithName:@"showSource"];
    NSLog(@"iOS DEBUG HW %@",jsonData);
    
    HotPointViewController *vc = [[HotPointViewController alloc] init];
    UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:vc];
    [vc hw_renderData:jsonData];
    vc.clickBlock = ^(HotActivityAreaModel * _Nonnull clickModel) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"跳转信息" message:clickModel.jumpUrl delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    };
    
    self.window.rootViewController = nv;

    return YES;
}


//解析数据源
- (HotImageModel *)mj_parseData:(NSDictionary *)sourceData
{
    HotImageModel *imageListModel = [HotImageModel mj_objectWithKeyValues:sourceData];
    return imageListModel;
}


- (NSDictionary *)mj_readLocalFileWithName:(NSString *)name
{
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"json"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
}


- (void)applicationWillEnterForeground:(UIApplication *)application
{
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
}


- (void)applicationWillTerminate:(UIApplication *)application
{
}


@end
