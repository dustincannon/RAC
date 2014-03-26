//
//  LoginViewController.m
//  ExampleProject
//
//  Created by Cannon, Dustin on 3/4/14.
//  Copyright (c) 2014 Cannon, Dustin. All rights reserved.
//

#import <ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import <ReactiveCocoa/RACEXTKeyPathCoding.h>

#import "LoginViewController.h"
#import "LoginViewModel.h"

@implementation LoginViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.viewModel = [LoginViewModel new];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
//    
//    @weakify(self);
//
//    [self.emailField.rac_textSignal subscribeNext:^(NSString *email) {
//        @strongify(self);
//        self.statusLabel.hidden = YES;
//        self.viewModel.email = email;
//    }];
//    
//    [self.passwordField.rac_textSignal subscribeNext:^(NSString *password) {
//        @strongify(self);
//        self.statusLabel.hidden = YES;
//        self.viewModel.password = password;
//    }];
//    
//    [[RACObserve(self.viewModel, loginSuccessful) skip:1] subscribeNext:^(id x) {
//        @strongify(self);
//        self.statusLabel.hidden = NO;
//        BOOL success = [x boolValue];
//        if (success) {
//            [self performSegueWithIdentifier:@"PrimesViewController" sender:self];
//        } else {
//            self.statusLabel.text = @"Fail!";
//        }
//    }];
//
//    self.signInButton.rac_command = self.viewModel.loginCommand;

    _emailField.delegate = self;
    _passwordField.delegate = self;
    _signInButton.enabled = NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"began editing: %@", textField);
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"ended editing: %@", textField);
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.emailField) {
        // editing email field
        if (self.passwordField.text.length > 0) {
            // and password field is not empty
            if (string.length) {
                // and we are adding a character
                self.signInButton.enabled = YES;
            } else if (self.emailField.text.length == 1) {
                // deleting last character in email field
                self.signInButton.enabled = NO;
            }
        } else {
            // password field is empty
            self.signInButton.enabled = NO;
        }
    }
    
    if (textField == self.passwordField) {
        // editing password field
        if (self.emailField.text.length > 0) {
            // and email field is not empty
            if (string.length) {
                // and we are adding a character
                self.signInButton.enabled = YES;
            } else if (self.passwordField.text.length == 1) {
                // deleting last character in password field
                self.signInButton.enabled = NO;
            }
        } else {
            // email field is empty
            self.signInButton.enabled = NO;
        }
    }
    
    
    return YES;
}

@end
