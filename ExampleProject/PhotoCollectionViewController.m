//
//  PhotoCollectionViewController.m
//  ExampleProject
//
//  Created by Cannon, Dustin on 3/18/14.
//  Copyright (c) 2014 Cannon, Dustin. All rights reserved.
//

#import "PhotoCollectionViewController.h"
#import <ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface PhotoCollectionViewController ()
@property (strong, nonatomic) ALAssetsLibrary *assetsLibrary;
@property (strong, nonatomic) NSMutableArray *cameraRollAssets;
@end

@implementation PhotoCollectionViewController

- (id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        _assetsLibrary = [ALAssetsLibrary new];
        _cameraRollAssets = [NSMutableArray new];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"PhotoCell"];
    
    self.collectionView.backgroundColor = [UIColor greenColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchCameraRollAssets
{
    [self.cameraRollAssets removeAllObjects];
    
    @weakify(self);
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
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
            NSLog(@"done enumerating groups");
            [self.collectionView reloadData];
        }
    } failureBlock:^(NSError *error) {
        //
    }];
}


#pragma mark - Collection View Data Source methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.cameraRollAssets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Fetch thumbnail for asset
    ALAsset *asset = self.cameraRollAssets[indexPath.row];
    UIImage *image = [UIImage imageWithCGImage:[asset thumbnail]];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
    NSLog(@"fetching cell for indexPath: %@", indexPath);
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UICollectionViewCell alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    }
    
    if ([indexPath row] % 2) {
        cell.backgroundColor = [UIColor grayColor];
    } else {
        cell.backgroundColor = [UIColor brownColor];
    }
    
    imageView.frame = cell.contentView.bounds;
    [cell.contentView addSubview:imageView];
    
    return cell;
}

@end
