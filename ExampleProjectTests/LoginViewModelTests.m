//
//  LoginViewModelTests.m
//  ExampleProject
//
//  Created by Cannon, Dustin on 3/12/14.
//  Copyright (c) 2014 Cannon, Dustin. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LoginViewModel.h"
#import <ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

@interface LoginViewModelTests : XCTestCase
@property (strong, nonatomic) LoginViewModel *viewModel;
@end

@implementation LoginViewModelTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    self.viewModel = [LoginViewModel new];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

@end
