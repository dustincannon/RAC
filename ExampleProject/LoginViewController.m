//
//  LoginViewController.m
//  ExampleProject
//
//  Created by Cannon, Dustin on 3/4/14.
//  Copyright (c) 2014 Cannon, Dustin. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginViewModel.h"

static void *LoggingInObservationContext = &LoggingInObservationContext;

@interface LoginViewController ()
@property (strong, nonatomic) LoginViewModel *loginViewModel;
@end

@implementation LoginViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _loginViewModel = [LoginViewModel new];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.signInButton.enabled = NO;
    self.statusLabel.hidden = YES;
    
    self.emailField.delegate = self;
    self.passwordField.delegate = self;
    
    [self.emailField addTarget:self action:@selector(possiblyEnableSignIn) forControlEvents:UIControlEventEditingChanged];
    [self.passwordField addTarget:self action:@selector(possiblyEnableSignIn) forControlEvents:UIControlEventEditingChanged];
    
    [self.loginViewModel addObserver:self
                          forKeyPath:@"isLoggingIn"
                             options:NSKeyValueObservingOptionInitial
                             context:&LoggingInObservationContext];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    self.statusLabel.hidden = YES;
    return YES;
}

- (void)possiblyEnableSignIn
{
    BOOL bothFieldsHaveText = self.emailField.text.length > 0 && self.passwordField.text.length > 0;
    if (!self.loginViewModel.isLoggingIn && bothFieldsHaveText) {
        self.signInButton.enabled = YES;
    } else {
        self.signInButton.enabled = NO;
    }
}

- (IBAction)signIn:(id)sender
{
    [self.loginViewModel loginWithEmail:self.emailField.text andPassword:self.passwordField.text success:^{
        [self performSegueWithIdentifier:@"PrimesViewController" sender:self];
    } failure:^{
        self.statusLabel.text = @"Fail!";
        self.statusLabel.hidden = NO;
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == LoggingInObservationContext) {
        [self possiblyEnableSignIn];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
@end
