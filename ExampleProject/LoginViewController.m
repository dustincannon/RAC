//
//  LoginViewController.m
//  ExampleProject
//
//  Created by Cannon, Dustin on 3/4/14.
//  Copyright (c) 2014 Cannon, Dustin. All rights reserved.
//

#import "LoginViewController.h"
#import <ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import "LoginViewModel.h"

@interface LoginViewController ()
@end

@implementation LoginViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        //self.viewModel = [LoginViewModel new];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    @weakify(self);
    
    RAC(self.emailField, text) = RACObserve(self.viewModel, email);
    [self.emailField.rac_textSignal subscribeNext:^(NSString *email) {
        @strongify(self);
        self.viewModel.email = email;
    }];
    
    RAC(self.passwordField, text) = RACObserve(self.viewModel, password);
    [self.passwordField.rac_textSignal subscribeNext:^(NSString *password) {
        @strongify(self);
        self.viewModel.password = password;
    }];
    
    RAC(self.signInButton, enabled) = RACObserve(self.viewModel, formIsValid);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
