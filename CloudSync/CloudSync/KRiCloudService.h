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
#import "KRResourceFilter.h"

@interface KRiCloudService : KRCloudService

@property (nonatomic) NSString* documentPath;
@property (nonatomic) KRResourceFilter* filter;

+(BOOL)isAvailableUsingBlock:(KRiCloudAvailableBlock)availableBlock;
+(BOOL)removeAllFilesUsingBlock:(KRiCloudRemoveAllFilesBlock)block;
					   
-(id)initWithLocalPath:(NSString*)path filter:(KRResourceFilter*)filter;

-(BOOL)loadResourcesUsingBlock:(KRResourcesCompletedBlock)completed;

-(BOOL)syncUsingBlock:(NSArray*)syncItems
	   completedBlock:(KRSynchronizerCompletedBlock)completed;

@end
