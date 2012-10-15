//
//  SyncEntryTests.m
//  CloudSync
//
//  Created by allting on 12. 10. 15..
//  Copyright (c) 2012년 allting. All rights reserved.
//

#import "SyncEntryTests.h"
#import "KRSyncEntry.h"
#import "KRResourceProperty.h"

@implementation SyncEntryTests

-(void)testSyncEntryCreate{
	KRSyncEntry* syncEntryToRemote = [[KRSyncEntry alloc]init];
	STAssertEquals(KRSyncEntryDirectionNone, syncEntryToRemote.direction, @"Must be equal to direction of syncEntry");
}

@end
