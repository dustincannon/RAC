//
//  PrimesViewModel.m
//  ExampleProject
//
//  Created by Cannon, Dustin on 3/24/14.
//  Copyright (c) 2014 Cannon, Dustin. All rights reserved.
//

#import <ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

#import "PrimesViewModel.h"

@interface PrimesViewModel ()

@property (strong, nonatomic) RACSignal *enabledSignal;
@property (strong, nonatomic) RACSignal *findPrimesSignal;
@property (assign, nonatomic) NSInteger sumOfPrimes;

@end

@implementation PrimesViewModel

- (id)init
{
    self = [super init];
    if (self) {
        @weakify(self);
        self.enabledSignal = [RACSignal combineLatest:@[RACObserve(self, from), RACObserve(self, to)]
                                               reduce:^id (NSString *from, NSString *to) {
            @strongify(self);
            if (self.from.length > 0 && self.to.length > 0) {
                NSLog(@"enabled");
                return @(YES);
            }
            NSLog(@"disabled");
            return @(NO);
        }];
    }
    return self;
}

- (RACCommand *)findPrimes
{
    @weakify(self);
    RACCommand *command = [[RACCommand alloc] initWithEnabled:self.enabledSignal signalBlock:^RACSignal *(id input) {
        RACSignal *findPrimesSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSLog(@"command execute!");
            
            @strongify(self);
            
            self.latestPrime = -1;
            
            NSInteger start = [self.from integerValue];
            NSUInteger end = [self.to integerValue];
            
            self.sumOfPrimes = 0;
            self.findPrimesSignal = [self findPrimesFrom:start to:end];
            [self.findPrimesSignal subscribeNext:^(id x) {
                self.sumOfPrimes += [x integerValue];
            } completed:^{
                self.result = [NSString stringWithFormat:@"%ld", self.sumOfPrimes];
            }];
            [subscriber sendCompleted];
            return nil;
        }];
        return findPrimesSignal;
    }];
    return command;
}

- (RACSignal *)findPrimesFrom:(NSInteger)start to:(NSInteger)end
{
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"finding primes in range: [%ld, %ld]", start, end);
        @strongify(self);
        for (NSInteger i = start; i <= end; i++) {
            NSLog(@"found prime: %ld", i);
            self.latestPrime = i;
            [subscriber sendNext:@(i)];
        }
        [subscriber sendCompleted];
        return nil;
    }];
}

@end
