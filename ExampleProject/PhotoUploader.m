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

#define UPLOAD_BATCH_SIZE (10)

@implementation PhotoUploader

//- (RACSignal *)uploadSignalForAssets:(NSArray *)assets
//{
//    return [RACSignal startLazilyWithScheduler:[RACScheduler scheduler] block:^(id<RACSubscriber> subscriber) {
//        NSUInteger batchSize = UPLOAD_BATCH_SIZE;
//        NSUInteger residue = assets.count % batchSize;
//        
//        NSLog(@"signal executing on thread: %@", [NSThread currentThread]);
//        
//        // Send in batches
//        for (NSUInteger i = 0; i < assets.count; i += batchSize) {
//            NSLog(@"starting batch: %lu", (unsigned long)i);
//            for (NSUInteger j = i; (j < (i + batchSize)) && (j < assets.count); j++) {
//                [subscriber sendNext:assets[j]];
//            }
//            NSLog(@"finished batch: %lu", (unsigned long)i);
//            sleep(1);
//        }
//        
//        // Send remainder
//        for (NSUInteger i = 0; i < residue; i++) {
//            [subscriber sendNext:assets[i]];
//        }
//        
//        [subscriber sendCompleted];
//    }];
//}


//- (RACSignal *)uploadSignalForAssets:(NSArray *)assets
//{
//    NSMutableArray *uploadSignals = [NSMutableArray new];
//    
//    NSUInteger batchSize = UPLOAD_BATCH_SIZE;
//    NSUInteger residue = assets.count % batchSize;
//
//    NSLog(@"signal executing on thread: %@", [NSThread currentThread]);
//
//    // Send in batches
//    for (NSUInteger i = 0; i < assets.count; i += batchSize) {
//        
//        NSLog(@"starting batch: %lu", (unsigned long)i);
//        NSMutableArray *batch = [NSMutableArray arrayWithCapacity:batchSize];
//        for (NSUInteger j = i; (j < (i + batchSize)) && (j < assets.count); j++) {
//            [batch addObject:assets[j]];
//        }
//        NSLog(@"finished batch: %lu", (unsigned long)i);
//        
//        [uploadSignals addObjectsFromArray:[self uploadSignalsForAssetBatch:batch]];
//    }
//
//    // Final batch
//    NSMutableArray *batch = [NSMutableArray arrayWithCapacity:residue];
//    for (NSUInteger i = 0; i < residue; i++) {
//        [uploadSignals addObjectsFromArray:[self uploadSignalsForAssetBatch:batch]];
//    }
//    
//    return [RACSignal merge:uploadSignals];
//}

// Returns array of signals that each do an individual upload
- (NSArray *)uploadSignalsForAssetBatch:(NSArray *)assetBatch
{
    NSMutableArray *signals = [NSMutableArray new];
    for (id a in assetBatch) {
        RACSignal *signalForUpload = [RACSignal startLazilyWithScheduler:[RACScheduler scheduler] block:^(id<RACSubscriber> subscriber) {
            // Upload code here
            NSLog(@"uploading: %@", a);
            sleep(5);
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
    if (signal) {
        NSLog(@"starting upload batch");
        [arrayOfSignals removeObjectAtIndex:0];
    
        [signal subscribeNext:^(id x) {
            NSLog(@"next: %@", x);
            [subscriber sendNext:x];
        } completed:^{
            NSLog(@"finished upload batch");
            [self uploadBatches:arrayOfSignals racSubscriber:subscriber];
        }];
    }
}

// Return a signal that uploads batches sequentially and delivers assets as their uploads complete
- (RACSignal *)uploadSignalForAssets:(NSArray *)assets
{
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        // create upload batches
        // for now, 1 batch consisting of all photos
        NSMutableArray *batches = [@[[self uploadSignalForBatch:assets]] mutableCopy];
        
        // upload batches sequentially
        [self uploadBatches:batches racSubscriber:subscriber];
        return nil;
    }];
}

@end
