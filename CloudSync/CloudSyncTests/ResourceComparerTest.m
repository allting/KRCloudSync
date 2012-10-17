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
	NSArray* remoteResources = [self createRemoteResources];
	NSArray* localResources = [self createLocalResources];
	
	CloudFactoryMock* factory = [[CloudFactoryMock alloc]init];
	KRResourceComparer* comparer = [[KRResourceComparer alloc]initWithFactory:factory];
	STAssertNotNil(comparer, @"Mustn't be nil");
	
	[comparer compareUsingBlock:localResources
				 remoteResources:remoteResources
				 completedBlock:^(NSArray *syncItems, NSError *error) {
					 STAssertTrue(0==[syncItems count], @"Must be equal");
				 }];
}

-(void)testLocalResourceModified{
	NSArray* remoteResources = [self createRemoteResources];
	NSArray* localResources = [self createModifiedLocalResources];
	
	CloudFactoryMock* factory = [[CloudFactoryMock alloc]init];
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
	NSArray* remoteResources = [self createModifiedRemoteResources];
	NSArray* localResources = [self createLocalResources];
	
	CloudFactoryMock* factory = [[CloudFactoryMock alloc]init];
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


-(NSArray*)createRemoteResources{
	NSArray* TEST_URLS = [self createDefaultRemoteURLs];
	NSArray* TEST_CREATED_DATE = [self createDateArrayWithTimeInterval:1];
	NSArray* TEST_MODIFIED_DATE = [self createDateArrayWithTimeInterval:1];
	NSArray* TEST_SIZES = [self createDefaultFileSize];
	NSMutableArray* array = [NSMutableArray arrayWithCapacity:[TEST_URLS count]];
	for(NSInteger i=0; i<[TEST_URLS count]; i++){
		KRResourceProperty* resource = [[KRResourceProperty alloc]initWithProperties:[TEST_URLS objectAtIndex:i]
																		 createdDate:[TEST_CREATED_DATE objectAtIndex:i]
																		modifiedDate:[TEST_MODIFIED_DATE objectAtIndex:i]
																				size:[TEST_SIZES objectAtIndex:i]];
		
		[array addObject:resource];
	}
	return array;
}

-(NSArray*)createModifiedRemoteResources{
	NSArray* TEST_URLS = [self createDefaultRemoteURLs];
	NSArray* TEST_CREATED_DATE = [self createDateArrayWithTimeInterval:1];
	NSArray* TEST_MODIFIED_DATE = [self createDateArrayWithTimeInterval:2];
	NSArray* TEST_SIZES = [self createDefaultFileSize];
	NSMutableArray* array = [NSMutableArray arrayWithCapacity:[TEST_URLS count]];
	for(NSInteger i=0; i<[TEST_URLS count]; i++){
		KRResourceProperty* resource = [[KRResourceProperty alloc]initWithProperties:[TEST_URLS objectAtIndex:i]
																		 createdDate:[TEST_CREATED_DATE objectAtIndex:i]
																		modifiedDate:[TEST_MODIFIED_DATE objectAtIndex:i]
																				size:[TEST_SIZES objectAtIndex:i]];
		
		[array addObject:resource];
	}
	return array;
}

-(NSArray*)createLocalResources{
	NSArray* TEST_URLS = [self createDefaultLocalURLs];
	NSArray* TEST_CREATED_DATE = [self createDateArrayWithTimeInterval:1];
	NSArray* TEST_MODIFIED_DATE = [self createDateArrayWithTimeInterval:1];
	NSArray* TEST_SIZES = [self createDefaultFileSize];

	NSMutableArray* array = [NSMutableArray arrayWithCapacity:[TEST_URLS count]];
	for(NSInteger i=0; i<[TEST_URLS count]; i++){
		KRResourceProperty* resource = [[KRResourceProperty alloc]initWithProperties:[TEST_URLS objectAtIndex:i]
																		 createdDate:[TEST_CREATED_DATE objectAtIndex:i]
																		modifiedDate:[TEST_MODIFIED_DATE objectAtIndex:i]
																				size:[TEST_SIZES objectAtIndex:i]];
		
		[array addObject:resource];
	}
	return array;
}

-(NSArray*)createModifiedLocalResources{
	NSArray* TEST_URLS = [self createDefaultLocalURLs];
	NSArray* TEST_CREATED_DATE = [self createDateArrayWithTimeInterval:1];
	NSArray* TEST_MODIFIED_DATE = [self createDateArrayWithTimeInterval:2];
	NSArray* TEST_SIZES = [self createDefaultFileSize];
	
	NSMutableArray* array = [NSMutableArray arrayWithCapacity:[TEST_URLS count]];
	for(NSInteger i=0; i<[TEST_URLS count]; i++){
		KRResourceProperty* resource = [[KRResourceProperty alloc]initWithProperties:[TEST_URLS objectAtIndex:i]
																		 createdDate:[TEST_CREATED_DATE objectAtIndex:i]
																		modifiedDate:[TEST_MODIFIED_DATE objectAtIndex:i]
																				size:[TEST_SIZES objectAtIndex:i]];
		
		[array addObject:resource];
	}
	return array;
}

-(NSArray*)createDefaultRemoteURLs{
	NSArray* urls = @[
		[NSURL fileURLWithPath:@"/private/test/documents/test1.zip"],
		[NSURL fileURLWithPath:@"/private/test/documents/test2.zip"],
		[NSURL fileURLWithPath:@"/private/test/documents/test3.zip"],
		[NSURL fileURLWithPath:@"/private/test/documents/test4.zip"],
		[NSURL fileURLWithPath:@"/private/test/documents/test5.zip"],
		[NSURL fileURLWithPath:@"/private/test/documents/test6.zip"]
	];
	return urls;
}

-(NSArray*)createDefaultLocalURLs{
	NSArray* urls = @[
		[NSURL fileURLWithPath:@"/Users/test/documents/test1.zip"],
		[NSURL fileURLWithPath:@"/Users/test/documents/test2.zip"],
		[NSURL fileURLWithPath:@"/Users/test/documents/test3.zip"],
		[NSURL fileURLWithPath:@"/Users/test/documents/test4.zip"],
		[NSURL fileURLWithPath:@"/Users/test/documents/test5.zip"],
		[NSURL fileURLWithPath:@"/Users/test/documents/test6.zip"]
	];
	return urls;
}

-(NSArray*)createDateArrayWithTimeInterval:(NSTimeInterval)seconds{
	NSArray* date = @[
		[NSDate dateWithTimeIntervalSinceNow:seconds],
		[NSDate dateWithTimeIntervalSinceNow:seconds+1],
		[NSDate dateWithTimeIntervalSinceNow:seconds+2],
		[NSDate dateWithTimeIntervalSinceNow:seconds+3],
		[NSDate dateWithTimeIntervalSinceNow:seconds+4],
		[NSDate dateWithTimeIntervalSinceNow:seconds+5]
	];
	return date;
}

-(NSArray*)createDefaultFileSize{
	NSArray* sizes = @[
		[NSNumber numberWithInteger:20000],
		[NSNumber numberWithInteger:30000],
		[NSNumber numberWithInteger:40000],
		[NSNumber numberWithInteger:50000],
		[NSNumber numberWithInteger:60000],
		[NSNumber numberWithInteger:70000]
	];
	return sizes;
}

@end
