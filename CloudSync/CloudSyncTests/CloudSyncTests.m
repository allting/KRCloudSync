//
//  CloudSyncTests.m
//  CloudSyncTests
//
//  Created by allting on 12. 10. 10..
//  Copyright (c) 2012년 allting. All rights reserved.
//

#import "CloudSyncTests.h"
#import "KRCloudSync.h"
#import "CloudFactoryMock.h"

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
	KRCloudSync* cloudSync = [[KRCloudSync alloc]init];
    STAssertTrue([cloudSync sync], @"Test sync method");
}

-(void)testSimpleSync{
	KRCloudFactory* factory = [self createiCloudMockFactory];
	KRCloudSync* cloudSync = [[KRCloudSync alloc]initWithFactory:factory];
	
	[cloudSync syncUsingBlock:^(NSArray* syncItems, NSError* error){
	}];
}

-(KRCloudFactory*)createiCloudMockFactory{
	CloudFactoryMock* factory = [[CloudFactoryMock alloc]init];
	return factory;
}

@end
