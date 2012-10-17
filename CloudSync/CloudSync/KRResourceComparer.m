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

-(void)compareUsingBlock:(NSArray*)localResources
		  remoteResources:(NSArray*)remoteResources
		  completedBlock:(KRResourceComparerCompletedBlock)completed{
	NSAssert(completed, @"Mustn't be nil");
	if(!completed)
		return;

	NSArray* syncItems = [self compareResourcesAndCreateSyncItems:localResources remoteResources:remoteResources];
	completed(syncItems, nil);
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
