//
//  KRResourceLoader.h
//  CloudSync
//
//  Created by allting on 12. 10. 14..
//  Copyright (c) 2012년 allting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KRCloudFactory.h"

typedef void (^KRResourceLoaderCompletedBlock)(NSArray* remoteResources, NSArray* localResources, NSError* error);

@interface KRResourceLoader : NSObject

-(id)initWithFactory:(KRCloudFactory*)factory;

-(void)loadUsingBlock:(KRResourceLoaderCompletedBlock)completed;

@end
