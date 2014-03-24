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
                return @(YES);
            }
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
        @strongify(self);
        for (NSInteger i = start; i <= end; i++) {
            if (prime(i)) {
                self.latestPrime = i;
                [subscriber sendNext:@(i)];
            }
        }
        [subscriber sendCompleted];
        return nil;
    }];
}

#pragma mark - Prime Number Test

BOOL divides(NSInteger d, NSInteger n)
{
    return n % d == 0;
}

NSInteger ldf(NSInteger k, NSInteger n)
{
    if (divides(k, n)) {
        return k;
    } else if (k*k > n) {
        return n;
    }
    return ldf(k + 1, n);
}

NSInteger ld(NSInteger n)
{
    return ldf(2, n);
}

BOOL prime(NSInteger n)
{
    if (n < 1) {
        NSLog(@"error");
        return NO;
    }
    if (n == 1) {
        return NO;
    }
    return ld(n) == n;
}

@end
