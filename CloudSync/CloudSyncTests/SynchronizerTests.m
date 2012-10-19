//
//  SynchronizerTests.m
//  CloudSync
//
//  Created by allting on 12. 10. 19..
//  Copyright (c) 2012년 allting. All rights reserved.
//

#import "SynchronizerTests.h"
#import "KRSyncItem.h"

@implementation SynchronizerTests

-(void)testSynchronizer{
	CloudFactoryMock* factory = [[CloudFactoryMock alloc]init];
	NSArray* localResources = [factory createModifiedLocalResources];
	NSArray* remoteResources = [factory createRemoteResources];
	NSArray* syncItems = [factory createSyncItems:localResources remoteResources:remoteResources];
	
	KRSynchronizer* sync = [[KRSynchronizer alloc]initWithFactory:factory];
	[sync syncUsingBlock:syncItems completedBlock:^(NSArray* syncItems, NSError* error){
		STAssertNil(error, @"Must be nil");
		for(KRSyncItem* item in syncItems){
			STAssertEquals([item result], KRSyncItemResultCompleted, @"Must be equal");
		}
	}];
}

@end
