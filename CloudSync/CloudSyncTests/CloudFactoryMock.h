//
//  CloudFactoryMock.h
//  CloudSync
//
//  Created by allting on 12. 10. 12..
//  Copyright (c) 2012년 allting. All rights reserved.
//

#import "KRCloudFactory.h"

@interface CloudFactoryMock : KRCloudFactory

-(id)init;

-(NSArray*)createRemoteResources;
-(NSArray*)createModifiedRemoteResources;
-(NSArray*)createLocalResources;
-(NSArray*)createModifiedLocalResources;

-(NSArray*)createRemoteResourcesWithModifiedTimeInterval:(NSTimeInterval)interval;
-(NSArray*)createLocalResourcesWithModifiedTimeInterval:(NSTimeInterval)interval;

-(NSArray*)createEmptyResources;

-(NSArray*)createSyncItems:(NSArray*)localResources remoteResources:(NSArray*)remoteResources;

@end
