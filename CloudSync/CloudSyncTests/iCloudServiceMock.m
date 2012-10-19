//
//  iCloudServiceMock.m
//  CloudSync
//
//  Created by allting on 12. 10. 12..
//  Copyright (c) 2012년 allting. All rights reserved.
//

#import "iCloudServiceMock.h"
#import "KRSyncItem.h"

@implementation iCloudServiceMock

-(BOOL)syncUsingBlock:(NSArray*)syncItems
	   completedBlock:(KRSynchronizerCompletedBlock)completed{
	NSAssert(completed, @"Mustn't be nil");
	if(!completed)
		return NO;
	
	for(KRSyncItem* item in syncItems){
		item.result = KRSyncItemResultCompleted;
	}
	
	completed(syncItems, nil);
	return YES;
}

@end
