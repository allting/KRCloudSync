//
//  iCloudSyncTests.m
//  CloudSync
//
//  Created by allting on 12. 10. 11..
//  Copyright (c) 2012년 allting. All rights reserved.
//

#import "iCloudSyncTests.h"
#import "iCloudResourceManager.h"
#import "KRResourceProperty.h"

@implementation iCloudSyncTests

-(void)testURLComparation{
	NSURL* TEST_URL = [NSURL fileURLWithPath:@"/test/test.zip"];
	NSURL* TEST_INVALID_URL = [NSURL fileURLWithPath:@"/test/test5.zip"];
	
	NSDate* TEST_DATE = [NSDate date];
	NSInteger TEST_SIZE = 24012;
	
	NSArray* TEST_RESOURCES = [self createTestResources:TEST_DATE size:TEST_SIZE];
	
	KRiCloudResourceManager* manager = [[KRiCloudResourceManager alloc]initWithURLsAndProperties:TEST_RESOURCES];
	
	STAssertTrue([manager hasResource:TEST_URL], @"Test with file name only");
	STAssertFalse([manager hasResource:TEST_INVALID_URL], @"Must be false with invalid url");
}

-(void)testFileModification{
	NSURL* TEST_URL = [NSURL fileURLWithPath:@"/test/test.zip"];
	NSDate* TEST_DATE = [NSDate date];
	NSInteger TEST_SIZE = 24012;

	NSArray* TEST_RESOURCES = [self createTestResources:TEST_DATE size:TEST_SIZE];

	KRResourceProperty* TEST_RESOURCE = [[KRResourceProperty alloc]initWithProperties:TEST_URL
																		  createdDate:TEST_DATE
																		 modifiedDate:TEST_DATE
																				 size:[NSNumber numberWithInteger:TEST_SIZE]];
	
	KRiCloudResourceManager* manager = [[KRiCloudResourceManager alloc]initWithURLsAndProperties:TEST_RESOURCES];
	
	STAssertTrue([manager isModified:TEST_RESOURCE otherResource:[TEST_RESOURCES objectAtIndex:0]], @"Must be different");
	STAssertFalse([manager isModified:TEST_RESOURCE otherResource:[TEST_RESOURCES objectAtIndex:1]], @"Must be equal");
	STAssertTrue([manager isModified:TEST_RESOURCE otherResource:[TEST_RESOURCES objectAtIndex:2]], @"Must be different");
}

-(NSArray*)createTestResources:(NSDate*)date size:(NSInteger)size{
	NSURL* TEST_URL1 = [NSURL fileURLWithPath:@"/var/private/test1.zip"];
	NSURL* TEST_URL2 = [NSURL fileURLWithPath:@"/var/private/test.zip"];
	NSURL* TEST_URL3 = [NSURL fileURLWithPath:@"/var/private/test3.zip"];
	
	NSNumber* TEST_SIZE1 = [NSNumber numberWithInteger:39282];
	NSNumber* TEST_SIZE2 = [NSNumber numberWithInteger:size];
	NSNumber* TEST_SIZE3 = [NSNumber numberWithInteger:24848];
	
	KRResourceProperty* resource1 = [[KRResourceProperty alloc]initWithProperties:TEST_URL1
																	  createdDate:date
																	 modifiedDate:date
																			 size:TEST_SIZE1];
	KRResourceProperty* resource2 = [[KRResourceProperty alloc]initWithProperties:TEST_URL2
																	  createdDate:date
																	 modifiedDate:date
																			 size:TEST_SIZE2];
	KRResourceProperty* resource3 = [[KRResourceProperty alloc]initWithProperties:TEST_URL3
																	  createdDate:date
																	 modifiedDate:date
																			 size:TEST_SIZE3];
	
	NSArray* TEST_SAMPLE_URLS_AND_PROPERTIES = @[
	resource1, resource2, resource3
	];

	return TEST_SAMPLE_URLS_AND_PROPERTIES;
}

@end
