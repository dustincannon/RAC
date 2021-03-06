//
//  LoginViewController.m
//  ExampleProject
//
//  Created by Cannon, Dustin on 3/4/14.
//  Copyright (c) 2014 Cannon, Dustin. All rights reserved.
//

#import <ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

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
    
    @weakify(self);

    [self.emailField.rac_textSignal subscribeNext:^(NSString *email) {
        @strongify(self);
        self.statusLabel.hidden = YES;
        self.viewModel.email = email;
    }];
    
    [self.passwordField.rac_textSignal subscribeNext:^(NSString *password) {
        @strongify(self);
        self.statusLabel.hidden = YES;
        self.viewModel.password = password;
    }];
    
    [[RACObserve(self.viewModel, loginSuccessful) skip:1] subscribeNext:^(id x) {
        @strongify(self);
        self.statusLabel.hidden = NO;
        BOOL success = [x boolValue];
        if (success) {
            [self performSegueWithIdentifier:@"PrimesViewController" sender:self];
        } else {
            self.statusLabel.text = @"Fail!";
        }
    }];

    self.signInButton.rac_command = self.viewModel.loginCommand;
}

@end
