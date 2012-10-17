//
//  KRSyncItem.m
//  CloudSync
//
//  Created by allting on 12. 10. 15..
//  Copyright (c) 2012년 allting. All rights reserved.
//

#import "KRSyncItem.h"

@implementation KRSyncItem

-(id)initWithResources:(KRResourceProperty*)localResource
		remoteResource:(KRResourceProperty*)remoteResource
	  comparisonResult:(NSComparisonResult)result{
	self = [super init];
	if(self){
		_localResource = localResource;
		_remoteResource = remoteResource;
		_direction = [self comparisonResultTosyncItemDirection:result];
	}
	return self;
}

-(KRSyncItemDirection)comparisonResultTosyncItemDirection:(NSComparisonResult)result{
	if(NSOrderedAscending == result)
		return KRSyncItemDirectionToRemote;
	else if(NSOrderedDescending == result)
		return KRSyncItemDirectionToLocal;
	return KRSyncItemDirectionNone;
}

@end
