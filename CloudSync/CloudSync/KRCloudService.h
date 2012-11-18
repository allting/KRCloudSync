//
//  KRCloudService.h
//  CloudSync
//
//  Created by allting on 12. 10. 12..
//  Copyright (c) 2012년 allting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KRCloudSyncBlocks.h"

@interface KRCloudService : NSObject
@property (nonatomic) NSArray* filters;

-(BOOL)loadResourcesUsingBlock:(KRResourcesCompletedBlock)completed;

-(BOOL)syncUsingBlock:(NSArray*)syncItems
	   completedBlock:(KRSynchronizerCompletedBlock)completed;

@end
