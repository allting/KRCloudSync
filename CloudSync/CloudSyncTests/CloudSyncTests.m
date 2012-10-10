//
//  CloudSyncTests.m
//  CloudSyncTests
//
//  Created by allting on 12. 10. 10..
//  Copyright (c) 2012년 allting. All rights reserved.
//

#import "CloudSyncTests.h"
#import "CloudSync.h"

@implementation CloudSyncTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testCloudSync
{
	CloudSync* cloudSync = [[CloudSync alloc]init];
    STAssertTrue([cloudSync sync], @"Test sync method");
}

@end
