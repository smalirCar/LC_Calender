//
//  AppDelegate.h
//  LC_Calender
//
//  Created by 上海雷默广告有限公司 on 2017/1/20.
//  Copyright © 2017年 liCheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

