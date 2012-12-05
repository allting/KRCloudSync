//
//  KRCloudService.m
//  CloudSync
//
//  Created by allting on 12. 10. 12..
//  Copyright (c) 2012년 allting. All rights reserved.
//

#import "KRCloudService.h"

@implementation KRCloudService

-(BOOL)loadResourcesUsingBlock:(KRResourcesCompletedBlock)completed{
	return NO;
}

-(BOOL)syncUsingBlock:(NSArray*)syncItems
	   completedBlock:(KRSynchronizerCompletedBlock)completed{
	NSAssert(completed, @"Mustn't be nil");
	if(!completed)
		return NO;
	
	completed(syncItems, nil);
	return YES;
}

-(BOOL)renameFileUsingBlock:(NSString*)fileName
				newFileName:(NSString*)newFileName
			 completedBlock:(KRCloudSyncResultBlock)block{
	return NO;
}

@end
