//
//  TodoViewController.h
//  ParseToDoSample
//
//  Created by hirai.yuki on 2014/02/10.
//  Copyright (c) 2014年 hirai.yuki. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PFObject;

/**
 ToDo作成・編集画面
 */
@interface TodoViewController : UITableViewController

/**
 編集するToDoオブジェクト
 */
@property (strong, nonatomic) PFObject *todo;

@end
