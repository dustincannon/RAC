//
//  LoginViewModel.h
//  ExampleProject
//
//  Created by Cannon, Dustin on 3/12/14.
//  Copyright (c) 2014 Cannon, Dustin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginViewModel : NSObject

@property (assign, nonatomic) BOOL isLoggingIn;

- (void)loginWithEmail:(NSString *)email
           andPassword:(NSString *)password
               success:(void (^)())successBlock
               failure:(void (^)())failureBlock;

@end
