//
//  PhotoUploader.h
//  ExampleProject
//
//  Created by Cannon, Dustin on 3/19/14.
//  Copyright (c) 2014 Cannon, Dustin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACSignal;

@interface PhotoUploader : NSObject

- (RACSignal *)uploadSignalForAssets:(NSArray *)assets;
- (void)cancelUploads;

@end
