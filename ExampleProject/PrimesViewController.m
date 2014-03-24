//
//  PrimesViewController.m
//  ExampleProject
//
//  Created by Cannon, Dustin on 3/24/14.
//  Copyright (c) 2014 Cannon, Dustin. All rights reserved.
//
#import <ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

#import "PrimesViewController.h"
#import "PrimesViewModel.h"

@interface PrimesViewController ()
@property (strong, nonatomic) PrimesViewModel *primesViewModel;
@end

@implementation PrimesViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _primesViewModel = [PrimesViewModel new];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.fromField.rac_textSignal subscribeNext:^(id x) {
        self.primesViewModel.from = x;
    }];
    
    [self.toField.rac_textSignal subscribeNext:^(id x) {
        self.primesViewModel.to = x;
    }];

    RAC(self.resultLabel, text) = RACObserve(self.primesViewModel, result);
    
    self.findPrimesButton.rac_command = self.primesViewModel.findPrimes;
}

@end
