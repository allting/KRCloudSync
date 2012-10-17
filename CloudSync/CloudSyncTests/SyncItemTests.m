//
//  SyncItemTests.m
//  CloudSync
//
//  Created by allting on 12. 10. 15..
//  Copyright (c) 2012년 allting. All rights reserved.
//

#import "SyncItemTests.h"
#import "KRSyncItem.h"
#import "KRResourceProperty.h"

@implementation SyncItemTests

-(void)testSyncItemCreate{
	KRSyncItem* syncItemToRemote = [[KRSyncItem alloc]init];
	STAssertEquals(KRSyncItemDirectionNone, syncItemToRemote.direction, @"Must be equal to direction of syncItem");
}

@end
