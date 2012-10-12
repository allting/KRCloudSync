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
	KRCloudSync* cloudSync = [[KRCloudSync alloc]init];
	
	[cloudSync syncUsingBlock:^(NSError* error){
	}];
}

-(void)testCloudServiceWithFactory{
	KRCloudFactory* factory = [self createiCloudMockFactory];
	KRCloudSync* cloudSync = [[KRCloudSync alloc]initWithFactory:factory];
	
	STAssertNotNil([cloudSync cloudService], @"Mustn't be nil");
}

-(KRCloudFactory*)createiCloudMockFactory{
	CloudFactoryMock* factory = [[CloudFactoryMock alloc]init];
	return factory;
}

-(void)testSyncUsingBlock{
	NSURL* url = [NSURL fileURLWithPath:@"/test/test.zip"];
	
	KRCloudSync* cloudSync = [[KRCloudSync alloc]init];
	KRCloudSyncProgressBlock progress = ^(float progress){
		
	};
	KRCloudSyncCompletedBlock completed = ^(NSError* error){
		
	};
	
	[cloudSync syncWithiCloudUsingBlocks:url
					   progressBlock:progress
					  completedBlock:completed];
}
@end
