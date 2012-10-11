//
//  KRCloudSync.m
//  CloudSync
//
//  Created by allting on 12. 10. 10..
//  Copyright (c) 2012년 allting. All rights reserved.
//

#import "CloudSync.h"

@implementation KRCloudSync

-(BOOL)sync{
	return YES;
}

-(void)syncWithiCloudUsingBlocks:(NSURL*)url
		 progressBlock:(KRCloudSyncProgressBlock)progres
		completedBlock:(KRCloudSyncCompletedBlock)completed{
}
@end
