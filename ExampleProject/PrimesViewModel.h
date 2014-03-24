//
//  PrimesViewModel.h
//  ExampleProject
//
//  Created by Cannon, Dustin on 3/24/14.
//  Copyright (c) 2014 Cannon, Dustin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACCommand;

@interface PrimesViewModel : NSObject

@property (strong, nonatomic) NSString *from;
@property (strong, nonatomic) NSString *to;
@property (strong, nonatomic) NSString *result;
@property (assign, nonatomic) NSInteger latestPrime;
@property (strong, nonatomic) RACCommand *sumPrimes;

@end
