//
//  iCloudSyncTests.m
//  CloudSync
//
//  Created by allting on 12. 10. 11..
//  Copyright (c) 2012년 allting. All rights reserved.
//

#import "iCloudSyncTests.h"
#import "iCloudResourceManager.h"

@implementation iCloudSyncTests

-(void)testURLComparation{
	NSArray* TEST_SAMPLE_URLS = @[[NSURL fileURLWithPath:@"/private/mobile/test3.zip"],
	[NSURL fileURLWithPath:@"/private/mobile/test2.zip"],
	[NSURL fileURLWithPath:@"/private/mobile/test.zip"],
	[NSURL fileURLWithPath:@"/private/mobile/test1.zip"]
	];
	NSURL* TEST_URL = [NSURL fileURLWithPath:@"/test/test.zip"];
	
	iCloudResourceManager* manager = [[iCloudResourceManager alloc]initWithURLs:TEST_SAMPLE_URLS];
	STAssertTrue([manager hasResource:TEST_URL], @"Test with file name only");
}
@end
