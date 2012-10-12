//
//  KRCloudSync.m
//  CloudSync
//
//  Created by allting on 12. 10. 10..
//  Copyright (c) 2012년 allting. All rights reserved.
//

#import "KRCloudSync.h"

@implementation KRCloudSync

-(BOOL)sync{
	return YES;
}

-(void)syncUsingBlock:(KRCloudSyncCompletedBlock)completed{
//	if(completed){
//		NSError* error = [NSError errorWithDomain:@"com.mindhd.app" code:1000 userInfo:nil];
//		completed(error);
//	}
}

-(void)syncWithiCloudUsingBlocks:(NSURL*)url
		 progressBlock:(KRCloudSyncProgressBlock)progres
		completedBlock:(KRCloudSyncCompletedBlock)completed{
}
@end
