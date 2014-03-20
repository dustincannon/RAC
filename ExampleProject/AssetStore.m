//
//  AssetStore.m
//  ExampleProject
//
//  Created by Cannon, Dustin on 3/19/14.
//  Copyright (c) 2014 Cannon, Dustin. All rights reserved.
//

#import <ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import "AssetStore.h"

@interface AssetStore ()

@property (strong, nonatomic) NSMutableArray *assets;
@property (strong, nonatomic) RACSubject *assetAddedSubject;

@end

@implementation AssetStore

- (id)init
{
    self = [super init];
    if (self) {
        _assets = [NSMutableArray new];
        _assetAddedSubject = [RACSubject subject];
    }
    return self;
}

- (void)addAsset:(ALAsset *)asset
{
    @synchronized(self) {
        [self.assets addObject:asset];
    }
    [self.assetAddedSubject sendNext:asset];
}

- (RACSignal *)assetAddedSignal
{
    return self.assetAddedSubject;
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
