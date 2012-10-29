//
//  KRiCloudService.m
//  CloudSync
//
//  Created by allting on 12. 10. 21..
//  Copyright (c) 2012년 allting. All rights reserved.
//

#import "KRiCloudService.h"
#import "KRiCloud.h"
#import "KRResourceProperty.h"
#import "KRSyncItem.h"

@implementation KRiCloudService

+(BOOL)isAvailableiCloudUsingBlock:(KRiCloudAvailableBlock)availableBlock{
	NSAssert(availableBlock, @"Mustn't be nil");
	if(!availableBlock)
		return NO;
	
	dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	dispatch_async(globalQueue, ^{
		NSFileManager *fileManager = [NSFileManager defaultManager];
		NSURL *ubiquityContainer = [fileManager URLForUbiquityContainerIdentifier:nil];
		
		dispatch_queue_t mainQueue = dispatch_get_main_queue();
		dispatch_async(mainQueue, ^{
			if(ubiquityContainer)
				availableBlock(YES);
			else
				availableBlock(NO);
		});
	});
	return YES;
}

-(BOOL)loadResourcesUsingBlock:(KRResourcesCompletedBlock)completed{
	NSAssert(completed, @"Mustn't be nil");
	if(!completed)
		return NO;
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(%K like '*')", NSMetadataItemFSNameKey];
	
	KRiCloud* cloud = [KRiCloud sharedInstance];
	[cloud loadFiles:nil
		   predicate:predicate
	  completedBlock:^(id key, NSMetadataQuery* query, NSError* error){
		NSMutableArray* resources  = [NSMutableArray arrayWithCapacity:[query resultCount]];
		for(NSMetadataItem *item in [query results]){
			KRResourceProperty* resource = [[KRResourceProperty alloc]initWithMetadataItem:item];
			[resources addObject:resource];
		}
		
		completed(resources, nil);
	}];
	
	return YES;
}

-(BOOL)syncUsingBlock:(NSArray*)syncItems
	   completedBlock:(KRSynchronizerCompletedBlock)completed{
	NSAssert(completed, @"Mustn't be nil");
	if(!completed)
		return NO;
	
	for(KRSyncItem* item in syncItems){
		if(KRSyncItemDirectionNone == item.direction)
			continue;
		else if(KRSyncItemDirectionToRemote == item.direction)
			[self syncToRemote:item];
		else
			[self syncToLocal:item];
	}
	completed(syncItems, nil);
	return YES;
}

-(void)syncToRemote:(KRSyncItem*)item{
	NSURL* remoteURL = [self createRemoteURL:item.localResource.URL];
	
	KRiCloud* cloud = [KRiCloud sharedInstance];
	[cloud saveToUbiquityContainer:nil url:item.localResource.URL
						destinationURL:remoteURL
						completedBlock:^(id key, NSError* error) {
		NSLog(@"syncToRemote - Error:%@", error);
	}];
}

-(NSURL*)createRemoteURL:(NSURL*)localURL{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSURL *ubiquityContainer = [fileManager URLForUbiquityContainerIdentifier:nil];

	NSString* filePath = [NSString stringWithFormat:@"Documents/%@", [localURL lastPathComponent]];
	return [ubiquityContainer URLByAppendingPathComponent:filePath];
}

-(void)syncToLocal:(KRSyncItem*)item{
	NSURL* localURL = [self createLocalURL:item.remoteResource.URL];
	
	KRiCloud* cloud = [KRiCloud sharedInstance];
	[cloud saveToDocument:nil url:item.remoteResource.URL
						 destinationURL:localURL
						 completedBlock:^(id key, NSError* error) {
							NSLog(@"syncToRemote - Error:%@", error);
						}];
}

-(NSURL*)createLocalURL:(NSURL*)url{
	NSString* fileName = [url lastPathComponent];
	NSString* documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString* path = [documentPath stringByAppendingPathComponent:fileName];
	return [NSURL fileURLWithPath:path];
}

@end
