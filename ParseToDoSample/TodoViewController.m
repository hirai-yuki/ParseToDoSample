//
//  TodoViewController.m
//  ParseToDoSample
//
//  Created by hirai.yuki on 2014/02/10.
//  Copyright (c) 2014年 hirai.yuki. All rights reserved.
//

#import "TodoViewController.h"

#import <Parse/Parse.h>

@interface TodoViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation TodoViewController

#pragma UIViewController lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    if (self.todo) {
        self.title = @"Update Todo";
        self.textField.text = self.todo[@"name"];
    } else {
        self.title = @"Create Todo";
    }
}

#pragma mark - Action methods

- (IBAction)doneButtonTapped:(id)sender
{
    PFObject *todo;
    
    if (self.todo) {
        todo = self.todo;
    } else {
        todo = [PFObject objectWithClassName:@"Todo"];
    }

    todo[@"name"] = self.textField.text;
    
    [todo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!succeeded) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"エラー"
                                                                message:error.localizedDescription
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
            
            return;
        }
        
        [self dismissViewControllerAnimated:YES completion:NULL];
    }];
}

- (IBAction)cancelButtonTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UITextField delegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.doneButton.enabled = (self.textField.text.length > 0);
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    self.doneButton.enabled = (self.textField.text.length > 0);
    
    return YES;
}


@end
