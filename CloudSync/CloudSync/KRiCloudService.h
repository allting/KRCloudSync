//
//  KRiCloudService.h
//  CloudSync
//
//  Created by allting on 12. 10. 21..
//  Copyright (c) 2012년 allting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KRCloudService.h"
#import "KRCloudSyncBlocks.h"

@interface KRiCloudService : KRCloudService

+(BOOL)isAvailableiCloudUsingBlock:(KRiCloudAvailableBlock)availableBlock;

-(BOOL)loadResourcesUsingBlock:(KRResourcesCompletedBlock)completed;

-(BOOL)syncUsingBlock:(NSArray*)syncItems
	   completedBlock:(KRSynchronizerCompletedBlock)completed;

@end
