//
//  LoginViewModel.m
//  ExampleProject
//
//  Created by Cannon, Dustin on 3/12/14.
//  Copyright (c) 2014 Cannon, Dustin. All rights reserved.
//

#import "LoginViewModel.h"
#import <ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

@implementation LoginViewModel

- (id)init
{
    self = [super init];
    if (self) {
        RACSignal *emailSignal = RACObserve(self, email);
        RACSignal *passwordSignal = RACObserve(self, password);

        RAC(self, formIsValid) = [RACSignal combineLatest:@[emailSignal, passwordSignal] reduce:^id(NSString *email, NSString *password){
            if (([email length] > 0) && ([password length] > 0)) {
                return @(YES);
            }
            return @(NO);
        }];
    }
    return self;
}

- (BOOL)authenticate
{
    if ([self.email isEqualToString:@"dustin"] && [self.password isEqualToString:@"test123"]) {
        return YES;
    }
    return NO;
}

//- (void)setEmail:(NSString *)email
//{
//    NSLog(@"email: %@", email);
//    _email = email;
//}
//
//- (void)setPassword:(NSString *)password
//{
//    NSLog(@"password: %@", password);
//    _password = password;
//}

@end
