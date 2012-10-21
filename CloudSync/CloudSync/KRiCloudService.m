//
//  KRiCloudService.m
//  CloudSync
//
//  Created by allting on 12. 10. 21..
//  Copyright (c) 2012년 allting. All rights reserved.
//

#import "KRiCloudService.h"
#import "KRiCloud.h"

@implementation KRiCloudService

-(BOOL)loadResourcesUsingBlock:(KRResourcesCompletedBlock)completed{
	NSAssert(completed, @"Mustn't be nil");
	if(!completed)
		return NO;
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(%K like '*.*')", NSMetadataItemFSNameKey];
	
	KRiCloud* cloud = [KRiCloud sharedInstance];
	[cloud loadFiles:nil predicate:predicate completedBlock:^(id key, NSMetadataQuery* query, NSError* error){
		NSLog(@"Map Count:%d", [query resultCount]);
		for(NSMetadataItem *item in [query results]){
			NSLog(@"Map:%@", item);
		}
		completed(nil, nil);
	}];
	
	return YES;
}

-(BOOL)syncUsingBlock:(NSArray*)syncItems
	   completedBlock:(KRSynchronizerCompletedBlock)completed{
	NSAssert(completed, @"Mustn't be nil");
	if(!completed)
		return NO;
	
	completed(syncItems, nil);
	return YES;
}

@end
