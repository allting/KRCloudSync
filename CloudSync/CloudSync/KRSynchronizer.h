//
//  KRSynchronizer.h
//  CloudSync
//
//  Created by allting on 12. 10. 14..
//  Copyright (c) 2012년 allting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KRCloudFactory.h"

typedef void (^KRSynchronizerCompletedBlock)(NSArray* syncResources, NSError* error);

@interface KRSynchronizer : NSObject

-(id)initWithFactory:(KRCloudFactory*)factory;

-(void)syncUsingBlock:(NSArray*)comparedResources
	   completedBlock:(KRSynchronizerCompletedBlock)completed;

@end
