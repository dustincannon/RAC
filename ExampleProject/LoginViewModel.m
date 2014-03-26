//
//  LoginViewModel.m
//  ExampleProject
//
//  Created by Cannon, Dustin on 3/12/14.
//  Copyright (c) 2014 Cannon, Dustin. All rights reserved.
//

#import <ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

#import "LoginViewModel.h"

@implementation LoginViewModel

- (id)init
{
    self = [super init];
    if (self) {
        _isLoggingIn = NO;
    }
    return self;
}

- (void)loginWithEmail:(NSString *)email
           andPassword:(NSString *)password
               success:(void (^)())successBlock
               failure:(void (^)())failureBlock
{
    self.isLoggingIn = YES;
    if ([email isEqualToString:@"dustin"] && [password isEqualToString:@"test123"]) {
        if (successBlock) {
            successBlock();
        }
    } else {
        if (failureBlock) {
            failureBlock();
        }
    }
    self.isLoggingIn = NO;
}

@end
