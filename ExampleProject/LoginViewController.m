//
//  LoginViewController.m
//  ExampleProject
//
//  Created by Cannon, Dustin on 3/4/14.
//  Copyright (c) 2014 Cannon, Dustin. All rights reserved.
//

#import "LoginViewController.h"

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.signInButton.enabled = NO;
    self.statusLabel.hidden = YES;
    
    [self.emailField addTarget:self action:@selector(possiblyEnableSignIn) forControlEvents:UIControlEventEditingChanged];
    [self.passwordField addTarget:self action:@selector(possiblyEnableSignIn) forControlEvents:UIControlEventEditingChanged];
}

- (void)possiblyEnableSignIn
{
    if (self.emailField.text.length > 0 && self.passwordField.text.length > 0) {
        self.signInButton.enabled = YES;
    } else {
        self.signInButton.enabled = NO;
    }
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
