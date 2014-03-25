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
        RACSignal *emailSignal = RACObserve(self, email);
        RACSignal *passwordSignal = RACObserve(self, password);

        RAC(self, loginEnabled) = [RACSignal
                                   combineLatest:@[emailSignal, passwordSignal]
                                   reduce:^id(NSString *email, NSString *password){
                                       
                                       if (([email length] > 0) && ([password length] > 0)) {
                                           return @(YES);
                                       }
                                       return @(NO);
        }];

        @weakify(self);

        _loginCommand = [[RACCommand alloc] initWithEnabled:RACObserve(self, loginEnabled) signalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                
                @strongify(self);
                
                if ([self.email isEqualToString:@"dustin"] && [self.password isEqualToString:@"test123"]) {
                    NSLog(@"Login Successful");
                    self.loginSuccessful = YES;
                } else {
                    NSLog(@"Login Failed");
                    self.loginSuccessful = NO;
                }
                [subscriber sendCompleted];

                return nil;
            }];
        }];
    }
    return self;
}

@end
