//
//  KRCloudSyncBlocks.h
//  CloudSync
//
//  Created by allting on 12. 10. 19..
//  Copyright (c) 2012년 allting. All rights reserved.
//

#ifndef CloudSync_KRCloudSyncBlocks_h
#define CloudSync_KRCloudSyncBlocks_h

typedef void (^KRCloudSyncProgressBlock)(float progress);
typedef void (^KRCloudSyncCompletedBlock)(NSArray* syncItems, NSError* error);

typedef void (^KRResourcesCompletedBlock)(NSArray* resources, NSError* error);
typedef void (^KRSynchronizerCompletedBlock)(NSArray* syncResources, NSError* error);

typedef void (^KRiCloudAvailableBlock)(BOOL available);

#endif
