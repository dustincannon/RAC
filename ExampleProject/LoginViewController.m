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

@interface LoginViewController ()
@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    @weakify(self);

    // When the login signal executes we authenticate
    RACSignal *loginSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        if ([self.emailField.text isEqualToString:@"dustin"] && [self.passwordField.text isEqualToString:@"test123"]) {
            [subscriber sendNext:@(YES)];
            [subscriber sendCompleted];
        } else {
            [subscriber sendNext:@(NO)];
            [subscriber sendCompleted];
        }
        
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"Done with login");
        }];
    }];
    
    // Enable signInButton if forms are valid
    RACSignal *formValid = [RACSignal combineLatest:@[self.emailField.rac_textSignal, self.passwordField.rac_textSignal]
                                             reduce:^id (NSString *email, NSString *password) {
                                                 @strongify(self);
                                                 BOOL valid = NO;
                                                 self.statusLabel.hidden = YES;
                                                 if (email.length > 0 && password.length > 0) {
                                                     valid = YES;
                                                 }
                                                 return @(valid);
                                             }];
    
    // Authenticate if signInButton is tapped
    RACCommand *loginCommand = [[RACCommand alloc] initWithEnabled:formValid signalBlock:^RACSignal *(id input) {
        NSLog(@"Login Attempt!");
        return loginSignal;
    }];

    // Subscribe to the execution of the login command which is executed when we hit the signInButton
    [[loginCommand executionSignals] subscribeNext:^(id loginSignal) {
        
        // When the signInButton is tapped we re-subscribe to the login signal that is sent when we authenticate
        [loginSignal subscribeNext:^(id loginResult) {
            @strongify(self);
            NSLog(@"next: %@", loginResult);
            BOOL loginSuccessful = [loginResult boolValue];
            if (loginSuccessful) {
                self.statusLabel.text = @"Success!";
            } else {
                self.statusLabel.text = @"Failed :(";
            }
            self.statusLabel.hidden = NO;
        } completed:^{
            NSLog(@"login signal complete");
        }];
    }];
    
    self.signInButton.rac_command = loginCommand;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
