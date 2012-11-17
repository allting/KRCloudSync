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

@property (nonatomic) NSString* documentPath;

+(BOOL)isAvailableUsingBlock:(KRiCloudAvailableBlock)availableBlock;
+(BOOL)removeAllFilesUsingBlock:(KRiCloudRemoveAllFilesBlock)block;
					   
-(id)initWithLocalPath:(NSString*)path;

-(BOOL)loadResourcesUsingBlock:(KRResourcesCompletedBlock)completed;

-(BOOL)syncUsingBlock:(NSArray*)syncItems
	   completedBlock:(KRSynchronizerCompletedBlock)completed;

@end
