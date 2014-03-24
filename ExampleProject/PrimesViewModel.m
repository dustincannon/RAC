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

- (RACCommand *)sumPrimes
{
    @weakify(self);
    RACCommand *command = [[RACCommand alloc] initWithEnabled:self.enabledSignal signalBlock:^RACSignal *(id input) {
        RACSignal *findPrimesSignal = [RACSignal startLazilyWithScheduler:[RACScheduler scheduler]
                                                                    block:^(id<RACSubscriber> subscriber) {

            @strongify(self);
            
            self.latestPrime = -1;
            
            NSInteger start = [self.from integerValue];
            NSUInteger end = [self.to integerValue];
            
            [[self sumPrimesFrom:start to:end] subscribeNext:^(id x) {
                self.result = [NSString stringWithFormat:@"%d", [x integerValue]];
            }];
            [subscriber sendCompleted];

            return;
        }];
        return findPrimesSignal;
    }];
    return command;
}

- (NSArray *)signalsForPrimesFrom:(NSInteger)start to:(NSUInteger)end
{
    NSMutableArray *arrayOfSignals = [NSMutableArray new];
    for (NSInteger i = start; i <= end; i++) {
        RACSignal *isPrimeSignal = [RACSignal startLazilyWithScheduler:[RACScheduler scheduler] block:^(id<RACSubscriber> subscriber) {
            if (prime(i)) {
                NSLog(@"found prime: %d", i);
                [subscriber sendNext:@(i)];
            }
            [subscriber sendCompleted];
        }];
        [arrayOfSignals addObject:isPrimeSignal];
    }
    return arrayOfSignals;
}

- (RACSignal *)primesFrom:(NSInteger)start to:(NSInteger)end
{
    NSArray *signals = [self signalsForPrimesFrom:start to:end];
    return [RACSignal merge:signals];
}

- (RACSignal *)sumPrimesFrom:(NSInteger)start to:(NSInteger)end
{
    RACSignal *primes = [self primesFrom:start to:end];
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        self.sumOfPrimes = 0;
        [primes subscribeNext:^(id x) {
            @strongify(self);
            self.latestPrime = [x integerValue];
            self.sumOfPrimes += self.latestPrime;
        } completed:^{
            @strongify(self);
            [subscriber sendNext:@(self.sumOfPrimes)];
            [subscriber sendCompleted];
        }];
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
