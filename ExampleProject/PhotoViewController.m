//
//  PhotoViewController.m
//  ExampleProject
//
//  Created by Cannon, Dustin on 3/18/14.
//  Copyright (c) 2014 Cannon, Dustin. All rights reserved.
//

#import "PhotoViewController.h"
#import "PhotoCollectionViewController.h"
#import <ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

@interface PhotoViewController ()
@end

@implementation PhotoViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        _photoCollectionVC = [[PhotoCollectionViewController alloc] initWithCollectionViewLayout:layout];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.photoCollectionContainerView addSubview:self.photoCollectionVC.collectionView];

    @weakify(self);
    self.uploadButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSLog(@"Upload Camera Roll!");
            @strongify(self);
            [self fetchCameraRollAssets];
            return nil;
        }];
    }];
}

- (void)fetchCameraRollAssets
{
    [self.photoCollectionVC fetchCameraRollAssets];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
