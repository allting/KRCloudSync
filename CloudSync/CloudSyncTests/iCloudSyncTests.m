//
//  iCloudSyncTests.m
//  CloudSync
//
//  Created by allting on 12. 10. 11..
//  Copyright (c) 2012년 allting. All rights reserved.
//

#import "iCloudSyncTests.h"
#import "KRiCloudResourceManager.h"
#import "KRResourceProperty.h"

@implementation iCloudSyncTests

- (void)setUp{
    [super setUp];

	self.testURL = [NSURL fileURLWithPath:@"/test/test.zip"];
	self.testShouldNotFoundURL = [NSURL fileURLWithPath:@"/test/notfound.zip"];
	
	self.testDate = [NSDate date];
	self.testSize = [NSNumber numberWithInteger:24012];
	
	self.testResources = [self createTestResources:_testDate size:_testSize];
}

-(void)testURLComparation{
	KRiCloudResourceManager* manager = [[KRiCloudResourceManager alloc]initWithURLsAndProperties:_testResources];
	
	STAssertTrue([manager hasResource:_testURL], @"Test with file name only");
	STAssertFalse([manager hasResource:_testShouldNotFoundURL], @"Must be false with invalid url");
}

-(void)testFileModification{
	KRResourceProperty* TEST_RESOURCE = [[KRResourceProperty alloc]initWithProperties:_testURL
																		  createdDate:_testDate
																		 modifiedDate:_testDate
																				 size:_testSize];
	
	KRiCloudResourceManager* manager = [[KRiCloudResourceManager alloc]initWithURLsAndProperties:_testResources];
	
	STAssertTrue([manager isModified:TEST_RESOURCE anohterResource:[_testResources objectAtIndex:0]], @"Must be different");
	STAssertFalse([manager isModified:TEST_RESOURCE anohterResource:[_testResources objectAtIndex:1]], @"Must be equal");
	STAssertTrue([manager isModified:TEST_RESOURCE anohterResource:[_testResources objectAtIndex:2]], @"Must be different");
}

-(void)testFindResource{
	KRiCloudResourceManager* manager = [[KRiCloudResourceManager alloc]initWithURLsAndProperties:_testResources];
	
	STAssertNotNil([manager findResource:_testURL], @"Must be exist");
	STAssertNil([manager findResource:_testShouldNotFoundURL], @"Mustn't be exist");
}

-(NSArray*)createTestResources:(NSDate*)date size:(NSNumber*)size{
	NSURL* TEST_URL1 = [NSURL fileURLWithPath:@"/var/private/test1.zip"];
	NSURL* TEST_URL2 = [NSURL fileURLWithPath:@"/var/private/test.zip"];
	NSURL* TEST_URL3 = [NSURL fileURLWithPath:@"/var/private/test3.zip"];
	
	NSNumber* TEST_SIZE1 = [NSNumber numberWithInteger:39282];
	NSNumber* TEST_SIZE2 = size;
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
