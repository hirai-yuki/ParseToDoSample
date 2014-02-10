//
//  TodoListViewController.m
//  ParseToDoSample
//
//  Created by hirai.yuki on 2014/02/10.
//  Copyright (c) 2014年 hirai.yuki. All rights reserved.
//

#import "TodoListViewController.h"

#import <Parse/Parse.h>
#import "TodoViewController.h"

@interface TodoListViewController ()

@property (strong, nonatomic) NSMutableArray *todoList;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;

@end

@implementation TodoListViewController

#pragma UIViewController lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    // 通信が終了するまで追加ボタンは無効
    self.addButton.enabled = NO;
    
    // 作成日時順にToDoリストを取得する
    PFQuery *query = [PFQuery queryWithClassName:@"Todo"];
    [query orderByAscending:@"_created_at"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"エラー"
                                                                message:error.localizedDescription
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
            
            return;
        }
        
        
        self.todoList = [objects mutableCopy];
        [self.tableView reloadData];
        
        // 追加ボタンを有効に
        self.addButton.enabled = YES;
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // 編集画面に遷移する場合は、選択したToDoオブジェクトを遷移先にセットする
    if ([segue.identifier isEqualToString:@"updateTodoSegue"]) {
        UITableViewCell *cell = (UITableViewCell *)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        PFObject *todo = self.todoList[indexPath.row];
        
        UINavigationController *navigationController = (UINavigationController *)segue.destinationViewController;
        TodoViewController *todoViewController = (TodoViewController *)navigationController.topViewController;
        todoViewController.todo = todo;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.todoList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TodoCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    PFObject *todo = self.todoList[indexPath.row];
    cell.textLabel.text = todo[@"name"];
    
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        PFObject *todo = self.todoList[indexPath.row];
        
        [todo deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!succeeded) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"エラー"
                                                                    message:error.localizedDescription
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                [alertView show];

                return;
            }
            
            [self.todoList removeObject:todo];

            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }];
    }
}

@end
