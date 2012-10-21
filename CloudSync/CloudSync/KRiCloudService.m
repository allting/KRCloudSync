//
//  KRiCloudService.m
//  CloudSync
//
//  Created by allting on 12. 10. 21..
//  Copyright (c) 2012년 allting. All rights reserved.
//

#import "KRiCloudService.h"

@implementation KRiCloudService

-(BOOL)loadResourcesUsingBlock:(KRResourcesCompletedBlock)completed{
	NSAssert(completed, @"Mustn't be nil");
	if(!completed)
		return NO;
	
	completed(nil, nil);
	return YES;
}

-(BOOL)syncUsingBlock:(NSArray*)syncItems
	   completedBlock:(KRSynchronizerCompletedBlock)completed{
	NSAssert(completed, @"Mustn't be nil");
	if(!completed)
		return NO;
	
	completed(syncItems, nil);
	return YES;
}

@end
