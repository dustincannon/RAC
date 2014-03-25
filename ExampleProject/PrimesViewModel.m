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
        self.latestPrime = -1;
        
        NSInteger start = [self.from integerValue];
        NSUInteger end = [self.to integerValue];
        return [[[[self primesFrom:start to:end] doNext:^(id x) {
            @strongify(self);
            self.latestPrime = [x integerValue];
            self.sumOfPrimes += self.latestPrime;
        }] doCompleted:^{
            @strongify(self);
            self.result = [NSString stringWithFormat:@"%ld", self.sumOfPrimes];
        }] subscribeOn:[RACScheduler scheduler]];


    }];
    return command;
}

- (NSArray *)signalsForPrimesFrom:(NSInteger)start to:(NSUInteger)end
{
    NSMutableArray *arrayOfSignals = [NSMutableArray new];
    for (NSInteger i = start; i <= end; i++) {
        RACSignal *isPrimeSignal = [RACSignal startLazilyWithScheduler:[RACScheduler scheduler] block:^(id<RACSubscriber> subscriber) {
            if (prime(i)) {
                NSLog(@"found prime: %ld", (long)i);
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
    return [RACSignal merge:[self signalsForPrimesFrom:start to:end]];
}

- (RACSignal *)sumPrimesFrom:(NSInteger)start to:(NSInteger)end
{
    @weakify(self);
    RACSignal *primes = [[self primesFrom:start to:end] doNext:^(id x) {
        @strongify(self);
        self.latestPrime = [x integerValue];
        self.sumOfPrimes += self.latestPrime;
    }];
    return primes;
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
