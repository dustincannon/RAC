//
//  PhotoCollectionViewController.h
//  ExampleProject
//
//  Created by Cannon, Dustin on 3/18/14.
//  Copyright (c) 2014 Cannon, Dustin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AssetStore;

@interface PhotoCollectionViewController : UICollectionViewController

@property (strong, nonatomic) AssetStore *assetStore;

@end
