//
//  PrimesViewController.h
//  ExampleProject
//
//  Created by Cannon, Dustin on 3/24/14.
//  Copyright (c) 2014 Cannon, Dustin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PrimesViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *fromField;
@property (weak, nonatomic) IBOutlet UITextField *toField;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UIButton *findPrimesButton;
@property (weak, nonatomic) IBOutlet UITextView *primesLog;
@property (weak, nonatomic) IBOutlet UIButton *swapCommandButton;
@property (weak, nonatomic) IBOutlet UILabel *implementationLabel;


@end
