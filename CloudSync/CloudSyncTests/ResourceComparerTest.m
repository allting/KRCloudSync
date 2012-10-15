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
				 completedBlock:^(NSArray *comparedResources, NSError *error) {
					 STAssertTrue(0==[comparedResources count], @"Must be equal");
				 }];
}

-(NSArray*)createRemoteResources{
	NSArray* TEST_URLS = @[
		[NSURL fileURLWithPath:@"/private/test/documents/test1.zip"],
		[NSURL fileURLWithPath:@"/private/test/documents/test2.zip"],
		[NSURL fileURLWithPath:@"/private/test/documents/test3.zip"],
		[NSURL fileURLWithPath:@"/private/test/documents/test4.zip"],
		[NSURL fileURLWithPath:@"/private/test/documents/test5.zip"],
		[NSURL fileURLWithPath:@"/private/test/documents/test6.zip"]
	];
	NSArray* TEST_CREATED_DATE = @[
		[NSDate dateWithTimeIntervalSinceNow:1000],
		[NSDate dateWithTimeIntervalSinceNow:2000],
		[NSDate dateWithTimeIntervalSinceNow:3000],
		[NSDate dateWithTimeIntervalSinceNow:4000],
		[NSDate dateWithTimeIntervalSinceNow:5000],
		[NSDate dateWithTimeIntervalSinceNow:6000]
	];
	NSArray* TEST_MODIFIED_DATE = @[
		[NSDate dateWithTimeIntervalSinceNow:1000],
		[NSDate dateWithTimeIntervalSinceNow:2000],
		[NSDate dateWithTimeIntervalSinceNow:3000],
		[NSDate dateWithTimeIntervalSinceNow:4000],
		[NSDate dateWithTimeIntervalSinceNow:5000],
		[NSDate dateWithTimeIntervalSinceNow:6000]
	];
	NSArray* TEST_SIZES = @[
		[NSNumber numberWithInteger:20000],
		[NSNumber numberWithInteger:30000],
		[NSNumber numberWithInteger:40000],
		[NSNumber numberWithInteger:50000],
		[NSNumber numberWithInteger:60000],
		[NSNumber numberWithInteger:70000]
	];
	
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
	NSArray* TEST_URLS = @[
		[NSURL fileURLWithPath:@"/Users/test/documents/test1.zip"],
		[NSURL fileURLWithPath:@"/Users/test/documents/test2.zip"],
		[NSURL fileURLWithPath:@"/Users/test/documents/test3.zip"],
		[NSURL fileURLWithPath:@"/Users/test/documents/test4.zip"],
		[NSURL fileURLWithPath:@"/Users/test/documents/test5.zip"],
		[NSURL fileURLWithPath:@"/Users/test/documents/test6.zip"]
	];
	NSArray* TEST_CREATED_DATE = @[
		[NSDate dateWithTimeIntervalSinceNow:1000],
		[NSDate dateWithTimeIntervalSinceNow:2000],
		[NSDate dateWithTimeIntervalSinceNow:3000],
		[NSDate dateWithTimeIntervalSinceNow:4000],
		[NSDate dateWithTimeIntervalSinceNow:5000],
		[NSDate dateWithTimeIntervalSinceNow:6000]
	];
	NSArray* TEST_MODIFIED_DATE = @[
		[NSDate dateWithTimeIntervalSinceNow:1000],
		[NSDate dateWithTimeIntervalSinceNow:2000],
		[NSDate dateWithTimeIntervalSinceNow:3000],
		[NSDate dateWithTimeIntervalSinceNow:4000],
		[NSDate dateWithTimeIntervalSinceNow:5000],
		[NSDate dateWithTimeIntervalSinceNow:6000]
	];
	NSArray* TEST_SIZES = @[
		[NSNumber numberWithInteger:20000],
		[NSNumber numberWithInteger:30000],
		[NSNumber numberWithInteger:40000],
		[NSNumber numberWithInteger:50000],
		[NSNumber numberWithInteger:60000],
		[NSNumber numberWithInteger:70000]
	];

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

@end
