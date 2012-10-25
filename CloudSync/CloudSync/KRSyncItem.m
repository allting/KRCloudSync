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
		_result = KRSyncItemResultNone;
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

-(NSString*)description{
	NSString* direction = nil;
	if(_direction==KRSyncItemDirectionNone)
		direction = @"None";
	else if(_direction==KRSyncItemDirectionToLocal)
		direction = @"ToLocal";
	else
		direction = @"ToRemote";
	
	NSString* result = nil;
	if(KRSyncItemResultNone==_result)
		result = @"None";
	else if(KRSyncItemResultConflicted==_result)
		result = @"Conflicted";
	else
		result = @"Completed";
	
	return [NSString stringWithFormat:@"direction:%@,result:%@,localResources:%@,remoteResources:%@",
										direction, result, _localResource, _remoteResource];
}

@end
