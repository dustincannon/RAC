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
    _emailField.delegate = self;
    _passwordField.delegate = self;
    _signInButton.enabled = NO;
    _statusLabel.hidden = YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    self.statusLabel.hidden = YES;

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

- (IBAction)signIn:(id)sender
{
    if ([self.emailField.text isEqualToString:@"dustin"] && [self.passwordField.text isEqualToString:@"test123"]) {
        [self performSegueWithIdentifier:@"PrimesViewController" sender:self];
    } else {
        self.statusLabel.text = @"Fail!";
        self.statusLabel.hidden = NO;
    }
}
@end
