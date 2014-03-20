//
//  PhotoUploader.m
//  ExampleProject
//
//  Created by Cannon, Dustin on 3/19/14.
//  Copyright (c) 2014 Cannon, Dustin. All rights reserved.
//

#import <ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

#import "PhotoUploader.h"

#define UPLOAD_BATCH_SIZE (5)

@implementation PhotoUploader

// Returns array of signals that each do an individual upload
- (NSArray *)uploadSignalsForAssetBatch:(NSArray *)assetBatch
{
    NSMutableArray *signals = [NSMutableArray new];
    for (id a in assetBatch) {
        RACSignal *signalForUpload = [RACSignal startLazilyWithScheduler:[RACScheduler scheduler] block:^(id<RACSubscriber> subscriber) {
            // Upload code here
            NSLog(@"uploading: %@", a);
            sleep(2);
            // Not actually uploading yet so just send next and complete
            [subscriber sendNext:a];
            [subscriber sendCompleted];
        }];
        [signals addObject:signalForUpload];
    }
    
    return signals;
}

// Merges an array of upload signals into a single stream. Uploads execute concurrently and get delivered to the stream
// as they complete.
- (RACSignal *)uploadSignalForBatch:(NSArray *)batch
{
    return [RACSignal merge:[self uploadSignalsForAssetBatch:batch]];
}

// Subscribe to each signal sequentially (subscribe to next signal when the previous signal completes)
- (void)uploadBatches:(NSMutableArray *)arrayOfSignals racSubscriber:(id<RACSubscriber>)subscriber
{
    if (arrayOfSignals.count == 0) {
        [subscriber sendCompleted];
        return;
    }

    RACSignal *signal = [arrayOfSignals objectAtIndex:0];
    [arrayOfSignals removeObjectAtIndex:0];

    NSLog(@"starting upload batch");

    [signal subscribeNext:^(id x) {
        NSLog(@"next: %@", x);
        [subscriber sendNext:x];
    } completed:^{
        NSLog(@"finished upload batch");
        [self uploadBatches:arrayOfSignals racSubscriber:subscriber];
    }];
}

// Return a signal that uploads batches sequentially and delivers assets as their uploads complete
- (RACSignal *)uploadSignalForAssets:(NSArray *)assets
{
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        
        // create upload batches
        NSUInteger batchSize = UPLOAD_BATCH_SIZE;
        NSUInteger residue = assets.count % batchSize;
        NSMutableArray *batches = [NSMutableArray new];

        NSUInteger i;
        for (i = 0; i < assets.count; i += batchSize) {
            NSMutableArray *batch = [NSMutableArray arrayWithCapacity:batchSize];
            for (NSUInteger j = i; (j < (i + batchSize)) && (j < assets.count); j++) {
                [batch addObject:assets[j]];
            }
            [batches addObject:[self uploadSignalForBatch:batch]];
        }

        // Final batch
        NSMutableArray *batch = [NSMutableArray arrayWithCapacity:residue];
        for (NSUInteger j = i; j < residue; j++) {
            [batch addObject:assets[j]];
        }
        [batches addObject:[self uploadSignalForBatch:batch]];
        
        // upload batches sequentially
        [self uploadBatches:batches racSubscriber:subscriber];

        return nil;
    }];
}

@end
