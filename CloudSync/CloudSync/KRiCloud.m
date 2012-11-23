//
//  KRiCloud.m
//  CloudSync
//
//  Created by allting on 12. 10. 21..
//  Copyright (c) 2012년 allting. All rights reserved.
//

#import "KRiCloud.h"

@implementation KRiCloudLoadFilesContext

@end


@implementation KRiCloud

+(KRiCloud*)sharedInstance{
	static KRiCloud* cloud = nil;
	if(cloud == nil){
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            cloud = [[KRiCloud alloc] init];
        });
	}
	
	return cloud;
}

-(KRiCloud*)init{
	self = [super init];
	if(self){
		_ubiquityContainer = nil;
		_loadFilesContexts = [NSMutableDictionary dictionaryWithCapacity:3];
		_presentedItemOperationQueue = [[NSOperationQueue alloc] init];
		[_presentedItemOperationQueue setName:[NSString stringWithFormat:@"presenter queue -- %@", self]];
		[_presentedItemOperationQueue setMaxConcurrentOperationCount:1];
	}
	return self;
}

-(void)dealloc{
	_ubiquityContainer = nil;
	_loadFilesContexts = nil;
	_presentedItemOperationQueue = nil;
}

-(BOOL)loadFiles:(id)key predicate:(NSPredicate*)predicate completedBlock:(KRiCloudLoadFilesCompletedBlock)block{
	NSAssert(block, @"Mustn't be nil");
	if(!block)
		return NO;
	
	NSMetadataQuery* query = [[NSMetadataQuery alloc] init];
	[query setSearchScopes:[NSArray arrayWithObject:NSMetadataQueryUbiquitousDocumentsScope]];
	[query setPredicate:predicate];
	
	KRiCloudLoadFilesContext* context = [[KRiCloudLoadFilesContext alloc]init];
	context.key = key;
	context.query = query;
	context.block = block;
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(queryDidFinishGatheringForLoading:)
												 name:NSMetadataQueryDidFinishGatheringNotification
											   object:query];
	
	[query startQuery];
	
	NSValue* value = [NSValue valueWithNonretainedObject:query];
	[_loadFilesContexts setObject:context forKey:value];
	return YES;
}

#pragma mark - loadFiles internal methods
- (void)queryDidFinishGatheringForLoading:(NSNotification *)notification {
	NSMetadataQuery* query = [notification object];
    [query disableUpdates];
    [query stopQuery];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSMetadataQueryDidFinishGatheringNotification
                                                  object:query];
    
	NSValue* value = [NSValue valueWithNonretainedObject:query];
	KRiCloudLoadFilesContext* context = [_loadFilesContexts objectForKey:value];
    [self raiseLoadFilesBlock:context];
	
	[_loadFilesContexts removeObjectForKey:query];
}

- (void)raiseLoadFilesBlock:(KRiCloudLoadFilesContext*)context{
	if(context.block){
		context.block(context.key, context.query, nil);
	}
}

-(BOOL)saveToUbiquityContainer:(id)key url:(NSURL*)url destinationURL:(NSURL*)destinationURL completedBlock:(KRiCloudSaveFileCompletedBlock)block{
	NSAssert(block, @"Mustn't be nil");
	if(!block)
		return NO;

	NSError* outError = nil;
    NSFileCoordinator* fc = [[NSFileCoordinator alloc] initWithFilePresenter:self];
    [fc coordinateWritingItemAtURL:destinationURL
                           options:NSFileCoordinatorWritingForReplacing
                             error:&outError
                        byAccessor:^(NSURL *updatedURL) {
							NSError* error = nil;
							
							[self overwriteFile:url destinationURL:updatedURL error:&error];
							
							block(key, error);
						}];

    return YES;
}

-(BOOL)saveToDocument:(id)key url:(NSURL*)url destinationURL:(NSURL*)destinationURL completedBlock:(KRiCloudSaveFileCompletedBlock)block{
	NSAssert(block, @"Mustn't be nil");
	if(!block)
		return NO;
	
	NSError* outError = nil;
    NSFileCoordinator* fc = [[NSFileCoordinator alloc] initWithFilePresenter:self];
    [fc coordinateReadingItemAtURL:url
                           options:NSFileCoordinatorReadingWithoutChanges
                             error:&outError
                        byAccessor:^(NSURL *updatedURL) {
							NSError* error = nil;

							[self overwriteFile:updatedURL destinationURL:destinationURL error:&error];
							
							block(key, error);
						}];
	
    return YES;
}

-(BOOL)overwriteFile:(NSURL*)sourceURL destinationURL:(NSURL*)destinationURL error:(NSError**)outError{
	NSError* error = nil;
	NSFileManager* fileManager = [NSFileManager defaultManager];
	
	if([fileManager fileExistsAtPath:[destinationURL path]])
		[fileManager removeItemAtURL:destinationURL error:&error];
	
	return [fileManager copyItemAtURL:sourceURL toURL:destinationURL error:&error];
}

-(BOOL)removeAllFiles:(KRiCloudRemoveAllFilesCompletedBlock)block{
	NSAssert(block, @"Mustn't be nil");
	if(!block)
		return NO;
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(%K like '*')", NSMetadataItemFSNameKey];
	
	[self loadFiles:nil
		  predicate:predicate
	 completedBlock:^(id key, NSMetadataQuery* query, NSError* error){
		  [self removeFilesWithItems:[query results] block:block];
	}];

	return YES;
}

-(BOOL)removeFilesWithItems:(NSArray*)metadataItems block:(KRiCloudRemoveAllFilesCompletedBlock)block{
	NSAssert(block, @"Mustn't be nil");
	if(!block)
		return NO;
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
		for(NSMetadataItem *item in metadataItems){
			NSURL* fileURL = [item valueForAttribute:NSMetadataItemURLKey];
			
			NSFileCoordinator* fileCoordinator = [[NSFileCoordinator alloc] initWithFilePresenter:nil];
			[fileCoordinator coordinateWritingItemAtURL:fileURL
												options:NSFileCoordinatorWritingForDeleting
												  error:nil
											 byAccessor:^(NSURL* writingURL) {
												 NSError* error = nil;
												 NSFileManager* fileManager = [[NSFileManager alloc] init];
												 [fileManager removeItemAtURL:writingURL error:&error];
												 if([error code]){
													 block(NO, error);
													 return;
												 }
			}];
		}
		
		block(YES, nil);
	});
	
	return YES;
}

-(BOOL)batchLockAndSync:(NSArray*)readingURLs toLocalURLs:(NSArray*)toLocalURLs
			writingURLs:(NSArray*)writingURLs fromLocalURLs:(NSArray*)fromLocalURLs
				  error:(NSError**)outError
		 completedBlock:(KRiCloudBatchSyncCompeletedBlock)block{
	NSAssert(block, @"Mustn't be nil");
	if(!block)
		return NO;
	
	NSAssert([readingURLs count]==[toLocalURLs count], @"Must be equal");
	NSAssert([writingURLs count]==[fromLocalURLs count], @"Must be equal");
	if([readingURLs count]!=[toLocalURLs count])
		return NO;
	if([writingURLs count]!=[fromLocalURLs count])
		return NO;
	
	__block NSMutableArray* toLocalErrors = [NSMutableArray arrayWithCapacity:[readingURLs count]];
	__block NSMutableArray* fromLocalErrors = [NSMutableArray arrayWithCapacity:[writingURLs count]];
	
	NSFileCoordinator* fileCoordinator = [[NSFileCoordinator alloc]initWithFilePresenter:self];
	[fileCoordinator prepareForReadingItemsAtURLs:readingURLs options:NSFileCoordinatorReadingWithoutChanges
							   writingItemsAtURLs:writingURLs options:NSFileCoordinatorWritingForReplacing
											error:outError
									   byAccessor:^(void(^prepareCompletionHandler)(void)){

										   [self batchSync:readingURLs toLocalURLs:toLocalURLs toLocalErrors:toLocalErrors
														writingURLs:writingURLs fromLocalURLs:fromLocalURLs fromLocalErrors:fromLocalErrors];
									   }];
		
	block(readingURLs, toLocalErrors, fromLocalURLs, fromLocalErrors);

	return YES;
}

-(void)batchSync:(NSArray*)readingURLs toLocalURLs:(NSArray*)toLocalURLs toLocalErrors:(NSMutableArray*)toLocalErrors
	 writingURLs:(NSArray*)writingURLs fromLocalURLs:(NSArray*)fromLocalURLs fromLocalErrors:(NSMutableArray*)fromLocalErrors{
	
	NSUInteger count = [readingURLs count];
	for(NSUInteger i=0; i<count; i++){
		[self saveToDocument:nil
						 url:[readingURLs objectAtIndex:i]
			  destinationURL:[toLocalURLs objectAtIndex:i]
			  completedBlock:^(id key, NSError *error) {
				  [toLocalErrors addObject:error];
		}];
	}
	
	count = [writingURLs count];
	for(NSUInteger i=0; i<count; i++){
		[self saveToUbiquityContainer:nil
								  url:[fromLocalURLs objectAtIndex:i]
					   destinationURL:[writingURLs objectAtIndex:i]
					   completedBlock:^(id key, NSError *error) {
						   [fromLocalErrors addObject:error];
					   }];
	}
}

#pragma mark NSFilePresenter protocol

- (NSURL *)presentedItemURL{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	return [fileManager URLForUbiquityContainerIdentifier:nil];
}

- (NSOperationQueue *)presentedItemOperationQueue{
    return _presentedItemOperationQueue;
}


@end
