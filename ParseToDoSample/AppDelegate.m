//
//  AppDelegate.m
//  ParseToDoSample
//
//  Created by hirai.yuki on 2014/02/10.
//  Copyright (c) 2014年 hirai.yuki. All rights reserved.
//

#import "AppDelegate.h"

#import <Parse/Parse.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Parse setApplicationId:@"your_application_id" clientKey:@"your_client_key"];

    [PFUser enableAutomaticUser];
    
    PFACL *defaultACL = [PFACL ACL];
    
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];

    return YES;
}

@end
