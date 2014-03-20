//
//  PhotoViewController.m
//  ExampleProject
//
//  Created by Cannon, Dustin on 3/18/14.
//  Copyright (c) 2014 Cannon, Dustin. All rights reserved.
//

#import <ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import "PhotoViewController.h"
#import "PhotoCollectionViewController.h"
#import "AssetStore.h"
#import "PhotoUploader.h"

@interface PhotoViewController ()

@property (strong, nonatomic) ALAssetsLibrary *assetsLibrary;
@property (strong, nonatomic) NSMutableArray *cameraRollAssets;
@property (strong, nonatomic) AssetStore *assetStore;
@property (strong, nonatomic) PhotoUploader *photoUploader;

@end

@implementation PhotoViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        _assetsLibrary = [ALAssetsLibrary new];
        _cameraRollAssets = [NSMutableArray new];
        _assetStore = [AssetStore new];
        _photoUploader = [PhotoUploader new];
        _photoCollectionVC = [[PhotoCollectionViewController alloc] initWithCollectionViewLayout:layout];
        _photoCollectionVC.assetStore = _assetStore;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.photoCollectionVC.collectionView.frame = self.photoCollectionContainerView.bounds;
    [self.photoCollectionContainerView addSubview:self.photoCollectionVC.collectionView];

    self.uploadButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSLog(@"Upload Camera Roll!");
            [self fetchCameraRollAssets];
            return nil;
        }];
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.photoUploader cancelUploads];
}

- (void)fetchCameraRollAssets
{
    [self.cameraRollAssets removeAllObjects];
    
    @weakify(self);
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        @strongify(self);
        if (group) {
            // Store assets
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                @strongify(self);
                if (result) {
                    NSLog(@"adding asset: %@", result);
                    [self.cameraRollAssets addObject:result];
                } else {
                    NSLog(@"done enumerating assets");
                }
            }];
        } else {
            // Done enumerating asset groups
            // Upload photos and add them to the store as the uploads complete
            RACSignal *uploadSignal = [self.photoUploader uploadSignalForAssets:self.cameraRollAssets];
            [uploadSignal subscribeNext:^(id x) {
                [self.assetStore addAsset:x];
            } completed:^{
                NSLog(@"finished with all photos");
            }];
        }
    } failureBlock:^(NSError *error) {
        //
    }];
}

@end
