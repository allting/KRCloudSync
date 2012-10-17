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

	NSMutableArray* array = [NSMutableArray arrayWithCapacity:[remoteResources count]];
	
	KRiCloudResourceManager* resourceManager = [[KRiCloudResourceManager alloc]init];
	
	for(KRResourceProperty* resource in localResources){
		for(KRResourceProperty* remoteResource in remoteResources){
			if([resourceManager isEqualToURL:resource.URL otherURL:remoteResource.URL]){
				NSComparisonResult result = [resource compare:remoteResource];
				if(result!=NSOrderedSame){
					KRSyncItem* entry = [[KRSyncItem alloc]initWithResources:resource
																remoteResource:remoteResource
															  comparisonResult:result];
					[array addObject:entry];
				}
			}
		}
	}
	
	completed(array, nil);
}

@end
