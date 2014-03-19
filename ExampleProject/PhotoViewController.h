//
//  PhotoViewController.h
//  ExampleProject
//
//  Created by Cannon, Dustin on 3/18/14.
//  Copyright (c) 2014 Cannon, Dustin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotoCollectionViewController;

@interface PhotoViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *photoCollectionContainerView;
@property (weak, nonatomic) IBOutlet UIButton *uploadButton;

@property (strong, nonatomic) PhotoCollectionViewController *photoCollectionVC;

@end
