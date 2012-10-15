//
//  KRSyncEntry.m
//  CloudSync
//
//  Created by allting on 12. 10. 15..
//  Copyright (c) 2012년 allting. All rights reserved.
//

#import "KRSyncEntry.h"

@implementation KRSyncEntry

-(id)initWithResources:(KRResourceProperty*)localResource
		remoteResource:(KRResourceProperty*)remoteResource
	  comparisonResult:(NSComparisonResult)result{
	self = [super init];
	if(self){
		_localResource = localResource;
		_remoteResource = remoteResource;
		_direction = [self comparisonResultToSyncEntryDirection:result];
	}
	return self;
}

-(KRSyncEntryDirection)comparisonResultToSyncEntryDirection:(NSComparisonResult)result{
	if(NSOrderedAscending == result)
		return KRSyncEntryDirectionToRemote;
	else if(NSOrderedDescending == result)
		return KRSyncEntryDirectionToLocal;
	return KRSyncEntryDirectionNone;
}

@end
