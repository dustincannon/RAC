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

- (RACSignal *)uploadSignalForAssets:(NSArray *)assets
{
    return [RACSignal startLazilyWithScheduler:[RACScheduler scheduler] block:^(id<RACSubscriber> subscriber) {
        NSUInteger batchSize = UPLOAD_BATCH_SIZE;
        NSUInteger residue = assets.count % batchSize;
        
        NSLog(@"signal executing on thread: %@", [NSThread currentThread]);
        
        // Send in batches
        for (NSUInteger i = 0; i < assets.count; i += batchSize) {
            NSLog(@"starting batch: %lu", (unsigned long)i);
            for (NSUInteger j = i; (j < (i + batchSize)) && (j < assets.count); j++) {
                [subscriber sendNext:assets[j]];
            }
            NSLog(@"finished batch: %lu", (unsigned long)i);
            sleep(1);
        }
        
        // Send remainder
        for (NSUInteger i = 0; i < residue; i++) {
            [subscriber sendNext:assets[i]];
        }
        
        [subscriber sendCompleted];
    }];
}

@end
