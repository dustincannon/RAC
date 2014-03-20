//
//  AssetStore.h
//  ExampleProject
//
//  Created by Cannon, Dustin on 3/19/14.
//  Copyright (c) 2014 Cannon, Dustin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ALAsset;
@class RACSignal;

@interface AssetStore : NSObject

- (void)addAsset:(ALAsset *)asset;
- (ALAsset *)assetAtIndex:(NSUInteger)i;
- (NSUInteger)numAssets;

- (RACSignal *)assetAddedSignal;

@end
