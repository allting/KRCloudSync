//
//  CloudSync.h
//  CloudSync
//
//  Created by allting on 12. 10. 10..
//  Copyright (c) 2012년 allting. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	CloudSynciCloud,
	CloudSyncDropbox
}CloudSyncCloudType;

typedef void (^CloudSyncProgressBlock)(float progress);
typedef void (^CloudSyncCompletedBlock)(NSError* error);

@interface CloudSync : NSObject

-(BOOL)sync;
-(void)syncWithiCloudUsingBlocks:(NSURL*)url
		 progressBlock:(CloudSyncProgressBlock)progres
		completedBlock:(NSError*)error;

@end
