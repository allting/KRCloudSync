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
#import "KRCloudSyncBlocks.h"

typedef enum {
	KRCloudSynciCloud,
	KRCloudSyncDropbox
}KRCloudSyncCloudType;

@interface KRCloudSync : NSObject

@property (nonatomic) KRCloudPreferences* preferences;
@property (nonatomic) KRCloudFactory* factory;

+(BOOL)isAvailableiCloudUsingBlock:(KRiCloudAvailableBlock)availableBlock;
+(BOOL)removeAlliCloudFileUsingBlock:(KRiCloudRemoveAllFilesBlock)block;

-(id)initWithFactory:(KRCloudFactory*)factory;

-(BOOL)sync;
-(BOOL)syncUsingBlock:(KRCloudSyncCompletedBlock)completed;
-(BOOL)syncUsingBlocks:(KRCloudSyncStartBlock)startBlock
		 progressBlock:(KRCloudSyncProgressBlock)progresBlock
		completedBlock:(KRCloudSyncCompletedBlock)completedBlock;

@end
