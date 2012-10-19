//
//  CloudFactoryMock.m
//  CloudSync
//
//  Created by allting on 12. 10. 12..
//  Copyright (c) 2012년 allting. All rights reserved.
//

#import "CloudFactoryMock.h"
#import "iCloudServiceMock.h"
#import "FileServiceMock.h"
#import "KRResourceProperty.h"
#import "KRSyncItem.h"
#import "KRiCloudResourceManager.h"

@implementation CloudFactoryMock

-(id)init{
	self = [super init];
	if(self){
		self.cloudService = [[iCloudServiceMock alloc]init];
		self.fileService = [[FileServiceMock alloc]init];
	}
	return self;
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

-(NSArray*)createSyncItems:(NSArray*)localResources remoteResources:(NSArray*)remoteResources{
	return [self compareResourcesAndCreateSyncItems:localResources remoteResources:remoteResources];
}

-(NSArray*)compareResourcesAndCreateSyncItems:(NSArray*)localResources remoteResources:(NSArray*)remoteResources{
	NSMutableArray* syncItems = [NSMutableArray arrayWithCapacity:[remoteResources count]];
	
	for(KRResourceProperty* resource in localResources){
		for(KRResourceProperty* remoteResource in remoteResources){
			[self compareResourceAndCreateSyncItem:resource remoteResource:remoteResource array:syncItems];
		}
	}
	
	return syncItems;
}

-(void)compareResourceAndCreateSyncItem:(KRResourceProperty*)localResource
						 remoteResource:(KRResourceProperty*)remoteResource
								  array:(NSMutableArray*)syncItems{
	if([KRiCloudResourceManager isEqualToURL:localResource.URL otherURL:remoteResource.URL]){
		NSComparisonResult result = [localResource compare:remoteResource];
		if(result!=NSOrderedSame){
			KRSyncItem* item = [[KRSyncItem alloc]initWithResources:localResource
													 remoteResource:remoteResource
												   comparisonResult:result];
			[syncItems addObject:item];
		}
	}
}

@end
