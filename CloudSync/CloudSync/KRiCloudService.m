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

+(BOOL)isAvailableUsingBlock:(KRiCloudAvailableBlock)availableBlock{
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

+(BOOL)removeFileUsingBlock:(NSString*)fileName completedBlock:(KRiCloudRemoveFileBlock)block{
	NSAssert(block, @"Mustn't be nil");
	if(!block)
		return NO;
	
	KRiCloud* cloud = [KRiCloud sharedInstance];
	[cloud removeFile:fileName completedBlock:^(BOOL succeeded, NSError* error){
		block(succeeded, error);
	}];
	
	return YES;
}

+(BOOL)removeAllFilesUsingBlock:(KRiCloudRemoveFileBlock)block{
	NSAssert(block, @"Mustn't be nil");
	if(!block)
		return NO;
	
	KRiCloud* cloud = [KRiCloud sharedInstance];
	[cloud removeAllFiles:^(BOOL succeeded, NSError* error){
		block(succeeded, error);
	}];
	
	return YES;
}

-(id)initWithLocalPath:(NSString*)path filter:(KRResourceFilter*)filter{
	self = [super init];
	if(self){
		self.documentPath = path;
		self.filter = filter;
		_iCloud = [[KRiCloud alloc]init];
	}
	return self;
}

-(NSString*)documentPath{
	if(0==[_documentPath length])
		return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	
	return _documentPath;
}

-(BOOL)loadResourcesUsingBlock:(KRResourcesCompletedBlock)completed{
	NSAssert(completed, @"Mustn't be nil");
	if(!completed)
		return NO;
	
	NSPredicate *predicate = [self.filter createPredicate];
	
	[_iCloud loadFilesWithPredicate:predicate
				   completedBlock:^(NSMetadataQuery* query, NSError* error){
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
	
	dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	dispatch_async(globalQueue, ^{
		NSError* error = nil;
		KRiCloud* iCloud = [[KRiCloud alloc]init];
		[NSFileCoordinator addFilePresenter:iCloud];
		
		NSFileCoordinator* fileCoordinator = [[NSFileCoordinator alloc]initWithFilePresenter:iCloud];
		for(KRSyncItem* item in syncItems){
			if(KRSyncItemDirectionNone == item.direction)
				continue;
			
			NSError* error = nil;

			if(KRSyncItemDirectionToRemote == item.direction){
				NSURL* remoteURL = item.remoteResource.URL;
				if(!remoteURL)
					remoteURL = [self createRemoteURL:item.localResource.URL];
				NSURL* localURL = item.localResource.URL;
				
				[iCloud saveToUbiquityContainerWithFileCoordinator:fileCoordinator
															   url:localURL
													destinationURL:remoteURL
															 error:&error];
				item.error = error;
			}else{
				NSURL* localURL = item.localResource.URL;
				if(!localURL)
					localURL = [self createLocalURL:item.remoteResource.URL];
				NSURL* remoteURL = item.remoteResource.URL;
				
				[iCloud saveToDocumentWithFileCoordinator:fileCoordinator
													  url:remoteURL
										   destinationURL:localURL
													error:&error];
				item.error = error;
			}
		}
		[NSFileCoordinator removeFilePresenter:iCloud];
		
		dispatch_queue_t mainQueue = dispatch_get_main_queue();
		dispatch_async(mainQueue, ^{
			completed(syncItems, error);
		});
	});
	return YES;
}

-(BOOL)batchSyncUsingBlock:(NSArray*)syncItems
	   completedBlock:(KRSynchronizerCompletedBlock)completed{
	NSAssert(completed, @"Mustn't be nil");
	if(!completed)
		return NO;
	
	dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	dispatch_async(globalQueue, ^{
		
		NSUInteger count = [syncItems count];
		
		NSMutableDictionary* binder = [NSMutableDictionary dictionaryWithCapacity:count];
		
		NSMutableArray* readingURLs = [NSMutableArray arrayWithCapacity:count];
		NSMutableArray* toLocalURLs = [NSMutableArray arrayWithCapacity:count];
		NSMutableArray* writingURLs = [NSMutableArray arrayWithCapacity:count];
		NSMutableArray* fromLocalURLs = [NSMutableArray arrayWithCapacity:count];
		
		for(KRSyncItem* item in syncItems){
			if(KRSyncItemDirectionNone == item.direction)
				continue;
			else if(KRSyncItemDirectionToRemote == item.direction){
				NSURL* remoteURL = item.remoteResource.URL;
				if(!remoteURL)
					remoteURL = [self createRemoteURL:item.localResource.URL];
				
				[writingURLs addObject:remoteURL];
				[fromLocalURLs addObject:item.localResource.URL];
				
				[binder setObject:item forKey:item.localResource.URL];
			}else{
				NSURL* localURL = item.localResource.URL;
				if(!localURL)
					localURL = [self createLocalURL:item.remoteResource.URL];
				
				[readingURLs addObject:item.remoteResource.URL];
				[toLocalURLs addObject:localURL];
				
				[binder setObject:item forKey:item.remoteResource.URL];
			}
		}
		
		NSError* error = nil;
		KRiCloud* iCloud = [[KRiCloud alloc]init];
		[NSFileCoordinator addFilePresenter:iCloud];

		[iCloud batchLockAndSync:readingURLs
					 toLocalURLs:toLocalURLs
					 writingURLs:writingURLs
				   fromLocalURLs:fromLocalURLs
						   error:&error
				  completedBlock:^(NSArray *toLocalURLs, NSArray *toLocalURLErrors,
								 NSArray *fromLocalURLs, NSArray *fromLocalURLErrors) {
					NSUInteger count=[toLocalURLs count];
					for(NSUInteger i=0; i<count; i++){
						NSURL* url = [toLocalURLs objectAtIndex:i];
						KRSyncItem* item = [binder objectForKey:url];
						if([toLocalURLErrors objectAtIndex:i] != [NSNull null])
							item.error = [toLocalURLErrors objectAtIndex:i];
					}
					count = [fromLocalURLs count];
					for(NSUInteger i=0; i<count; i++){
						NSURL* url = [fromLocalURLs objectAtIndex:i];
						KRSyncItem* item = [binder objectForKey:url];
						if([fromLocalURLErrors objectAtIndex:i] != [NSNull null])
							item.error = [fromLocalURLErrors objectAtIndex:i];
					}
				}];

		[NSFileCoordinator removeFilePresenter:iCloud];
		
		dispatch_queue_t mainQueue = dispatch_get_main_queue();
		dispatch_async(mainQueue, ^{
			completed(syncItems, error);
		});
	});
	return YES;
}

-(BOOL)renameFileUsingBlock:(NSString*)fileName
				newFileName:(NSString*)newFileName
			 completedBlock:(KRCloudSyncResultBlock)block{
	NSAssert(block, @"Mustn't be nil");
	if(!block)
		return NO;
	
	if([fileName isEqualToString:newFileName])
		return NO;
	
	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	dispatch_async(queue, ^{
		NSFileManager *fileManager = [NSFileManager defaultManager];
		NSURL *ubiquityContainer = [fileManager URLForUbiquityContainerIdentifier:nil];
		
		NSString* filePath = [NSString stringWithFormat:@"Documents/%@", fileName];
		NSString* newFilePath = [NSString stringWithFormat:@"Documents/%@", newFileName];
		
		NSURL* url = [ubiquityContainer URLByAppendingPathComponent:filePath];
		NSURL* newURL = [ubiquityContainer URLByAppendingPathComponent:newFilePath];

		NSError* error = nil;
		BOOL ret = [_iCloud renameFile:url newURL:newURL error:&error];
		
		dispatch_async(dispatch_get_main_queue(), ^{
			block(ret, error);
		});
	});
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
							NSLog(@"syncToLocal - Error:%@", error);
						}];
}

-(NSURL*)createLocalURL:(NSURL*)url{
	NSString* fileName = [url lastPathComponent];
	NSString* documentPath = self.documentPath;
	NSString* path = [documentPath stringByAppendingPathComponent:fileName];
	return [NSURL fileURLWithPath:path];
}

@end
