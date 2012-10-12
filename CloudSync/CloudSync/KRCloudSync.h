//
//  KRCloudSync.h
//  CloudSync
//
//  Created by allting on 12. 10. 10..
//  Copyright (c) 2012년 allting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KRCloudPreferences.h"
#import "KRCloudFactory.h"

typedef enum {
	KRCloudSynciCloud,
	KRCloudSyncDropbox
}KRCloudSyncCloudType;

typedef void (^KRCloudSyncProgressBlock)(float progress);
typedef void (^KRCloudSyncCompletedBlock)(NSError* error);

@interface KRCloudSync : NSObject
@property (nonatomic) KRCloudPreferences* preferences;
@property (nonatomic) KRCloudService* cloudService;

-(id)initWithFactory:(KRCloudFactory*)factory;

-(BOOL)sync;

-(void)syncUsingBlock:(KRCloudSyncCompletedBlock)completed;

-(void)syncWithiCloudUsingBlocks:(NSURL*)url
		 progressBlock:(KRCloudSyncProgressBlock)progres
		completedBlock:(KRCloudSyncCompletedBlock)completed;

@end
