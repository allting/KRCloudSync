//
//  ResourceComparerTest.m
//  CloudSync
//
//  Created by allting on 12. 10. 14..
//  Copyright (c) 2012년 allting. All rights reserved.
//

#import "ResourceComparerTest.h"
#import "KRResourceComparer.h"
#import "KRCloudFactory.h"
#import "KRResourceProperty.h"
#import "KRResourceLoader.h"
#import "KRSyncItem.h"

#import "CloudFactoryMock.h"

@implementation ResourceComparerTest

-(void)testResourceComparer{
	CloudFactoryMock* factory = [[CloudFactoryMock alloc]init];
	NSArray* remoteResources = [factory createRemoteResources];
	NSArray* localResources = [factory createLocalResources];
	
	KRResourceComparer* comparer = [[KRResourceComparer alloc]initWithFactory:factory];
	STAssertNotNil(comparer, @"Mustn't be nil");
	
	[comparer compareUsingBlock:localResources
				 remoteResources:remoteResources
				 completedBlock:^(NSArray *syncItems, NSError *error) {
					 STAssertTrue(0==[syncItems count], @"Must be equal");
				 }];
}

-(void)testLocalResourceModified{
	CloudFactoryMock* factory = [[CloudFactoryMock alloc]init];
	NSArray* remoteResources = [factory createRemoteResources];
	NSArray* localResources = [factory createModifiedLocalResources];
	
	KRResourceComparer* comparer = [[KRResourceComparer alloc]initWithFactory:factory];
	STAssertNotNil(comparer, @"Mustn't be nil");
	
	[comparer compareUsingBlock:localResources
				remoteResources:remoteResources
				 completedBlock:^(NSArray *syncItems, NSError *error) {
					 STAssertTrue([localResources count]==[syncItems count], @"Must be equal");
					 for(KRSyncItem* item in syncItems){
						 STAssertEquals([item direction], KRSyncItemDirectionToRemote, @"Must be equal to RemoteDirection");
					 }
				 }];
}

-(void)testRemoteResourceModified{
	CloudFactoryMock* factory = [[CloudFactoryMock alloc]init];
	NSArray* remoteResources = [factory createModifiedRemoteResources];
	NSArray* localResources = [factory createLocalResources];
	
	KRResourceComparer* comparer = [[KRResourceComparer alloc]initWithFactory:factory];
	STAssertNotNil(comparer, @"Mustn't be nil");
	
	[comparer compareUsingBlock:localResources
				remoteResources:remoteResources
				 completedBlock:^(NSArray *syncItems, NSError *error) {
					 STAssertTrue([localResources count]==[syncItems count], @"Must be equal");
					 for(KRSyncItem* item in syncItems){
						 STAssertEquals([item direction], KRSyncItemDirectionToLocal, @"Must be equal to LocalDirection");
					 }
				 }];
}


@end
