//
//  KRResourceComparer.m
//  CloudSync
//
//  Created by allting on 12. 10. 14..
//  Copyright (c) 2012년 allting. All rights reserved.
//

#import "KRResourceComparer.h"
#import "KRiCloudResourceManager.h"

@implementation KRResourceComparer

-(id)initWithFactory:(KRCloudFactory*)factory{
	self = [super init];
	if(self){
		
	}
	return self;
}

-(void)compareUsingBlock:(NSArray*)remoteResources
		  localResources:(NSArray*)localResources
		  completedBlock:(KRResourceComparerCompletedBlock)completed{
	NSAssert(completed, @"Mustn't be nil");
	if(!completed)
		return;

	NSMutableArray* array = [NSMutableArray arrayWithCapacity:[remoteResources count]];
	
	KRiCloudResourceManager* resourceManager = [[KRiCloudResourceManager alloc]init];
	
	for(KRResourceProperty* resource in remoteResources){
		for(KRResourceProperty* otherResource in localResources){
			if([resourceManager isEqualToURL:resource.URL otherURL:otherResource.URL]){
				BOOL modified = [resourceManager isModified:resource otherResource:otherResource];
				if(modified){
					[array addObject:resource];
				}
			}
		}
	}
	
	completed(array, nil);
}

@end
