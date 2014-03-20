//
//  PhotoCollectionViewController.m
//  ExampleProject
//
//  Created by Cannon, Dustin on 3/18/14.
//  Copyright (c) 2014 Cannon, Dustin. All rights reserved.
//

#import <ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import "PhotoCollectionViewController.h"
#import "PhotoUploader.h"
#import "AssetStore.h"

@interface PhotoCollectionViewController ()

@end

@implementation PhotoCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"PhotoCell"];
    
    self.collectionView.backgroundColor = [UIColor grayColor];
    
    [[[self.assetStore assetAddedSignal] deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
        NSLog(@"asset store sent: %@", x);
        [self.collectionView reloadData];
    }];
}

#pragma mark - Collection View Data Source methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.assetStore numAssets];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Fetch thumbnail for asset
    ALAsset *asset = [self.assetStore assetAtIndex:[indexPath row]];
    UIImage *image = [UIImage imageWithCGImage:[asset thumbnail]];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UICollectionViewCell alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    }
    
    imageView.frame = cell.contentView.bounds;
    [cell.contentView addSubview:imageView];
    
    return cell;
}

@end
