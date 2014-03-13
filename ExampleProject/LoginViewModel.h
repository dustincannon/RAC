//
//  LoginViewModel.h
//  ExampleProject
//
//  Created by Cannon, Dustin on 3/12/14.
//  Copyright (c) 2014 Cannon, Dustin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACSignal;
@class RACCommand;

@interface LoginViewModel : NSObject

@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) RACCommand *loginCommand;
@property (assign, nonatomic) BOOL loginSuccessful;
@property (assign, nonatomic) BOOL loginEnabled;

@end
