//
//  AssetStore.m
//  ExampleProject
//
//  Created by Cannon, Dustin on 3/19/14.
//  Copyright (c) 2014 Cannon, Dustin. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>

#import "AssetStore.h"

@interface AssetStore ()

@property (strong, nonatomic) NSMutableArray *assets;

@end

@implementation AssetStore

- (id)init
{
    self = [super init];
    if (self) {
        _assets = [NSMutableArray new];
    }
    return self;
}

- (void)addAsset:(ALAsset *)asset
{
    @synchronized(self) {
        [self.assets addObject:asset];
    }
}

- (ALAsset *)assetAtIndex:(NSUInteger)i
{
    @synchronized(self) {
        if (i >= self.assets.count) {
            return nil;
        }
        return self.assets[i];
    }
}

- (NSUInteger)numAssets
{
    @synchronized(self) {
        return self.assets.count;
    }
}

@end
