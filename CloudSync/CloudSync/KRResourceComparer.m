//
//  KRResourceComparer.m
//  CloudSync
//
//  Created by allting on 12. 10. 14..
//  Copyright (c) 2012년 allting. All rights reserved.
//

#import "KRResourceComparer.h"
#import "KRiCloudResourceManager.h"
#import "KRSyncItem.h"

@implementation KRResourceComparer

-(id)initWithFactory:(KRCloudFactory*)factory{
	self = [super init];
	if(self){
		
	}
	return self;
}

-(NSArray*)compare:(NSArray*)localResources
   remoteResources:(NSArray*)remoteResources{
	return [self compareResourcesAndCreateSyncItems:localResources remoteResources:remoteResources];
}

-(NSArray*)compareResourcesAndCreateSyncItems:(NSArray*)localResources remoteResources:(NSArray*)remoteResources{
	NSSet* keyResources = [self createKeyResources:localResources remoteResources:remoteResources];
	
	NSMutableArray* syncItems = [NSMutableArray arrayWithCapacity:[remoteResources count]];

	for(NSString* key in keyResources){
		KRResourceProperty* localResource = [self findResourceWithKeyInResources:key resources:localResources];
		KRResourceProperty* remoteResource = [self findResourceWithKeyInResources:key resources:remoteResources];
		NSComparisonResult result = NSOrderedSame;
		if(!localResource)
			result = NSOrderedDescending;
		else if(!remoteResource)
			result = NSOrderedAscending;
		else
			result = [localResource compare:remoteResource];
		
		KRSyncItem* item = [[KRSyncItem alloc]initWithResources:localResource
												 remoteResource:remoteResource
											   comparisonResult:result];
		[syncItems addObject:item];
	}
	
	return syncItems;
}

-(NSSet*)createKeyResources:(NSArray*)localResources remoteResources:(NSArray*)remoteResources{
	NSMutableSet* keys = [NSMutableSet setWithCapacity:[localResources count]+[remoteResources count]];
	for(KRResourceProperty* res in localResources){
		NSString* key = [res.URL lastPathComponent];
		[keys addObject:key];
	}
	
	for(KRResourceProperty* res in remoteResources){
		NSString* key = [res.URL lastPathComponent];
		[keys addObject:key];
	}
	return keys;
}

-(KRResourceProperty*)findResourceWithKeyInResources:(NSString*)key resources:(NSArray*)resources{
	for(KRResourceProperty* resource in resources){
		NSString* name = [resource.URL lastPathComponent];
		if([key isEqualToString:name])
			return resource;
	}
	return nil;
}

-(KRSyncItem*)compareResourceAndCreateSyncItem:(KRResourceProperty*)localResource
						 remoteResource:(KRResourceProperty*)remoteResource{
	if([KRiCloudResourceManager isEqualToURL:localResource.URL otherURL:remoteResource.URL]){
		NSComparisonResult result = [localResource compare:remoteResource];
		if(result!=NSOrderedSame){
			return [[KRSyncItem alloc]initWithResources:localResource
													 remoteResource:remoteResource
												   comparisonResult:result];
		}
	}
	return nil;
}

@end
