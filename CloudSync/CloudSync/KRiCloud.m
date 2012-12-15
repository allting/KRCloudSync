//
//  KRiCloud.m
//  CloudSync
//
//  Created by allting on 12. 10. 21..
//  Copyright (c) 2012년 allting. All rights reserved.
//

#import "KRiCloud.h"

@implementation KRiCloudContext

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
		_presentedItemURL = nil;
		dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
		dispatch_async(queue, ^{
			NSFileManager* fileManager = [NSFileManager defaultManager];
			NSURL* url = [fileManager URLForUbiquityContainerIdentifier:nil];
			dispatch_async(dispatch_get_main_queue(), ^{
				_presentedItemURL = url;
			});
		});
		
		_query = [[NSMetadataQuery alloc] init];
		[_query setSearchScopes:[NSArray arrayWithObject:NSMetadataQueryUbiquitousDocumentsScope]];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(queryDidFinishGatheringForLoading:)
													 name:NSMetadataQueryDidFinishGatheringNotification
												   object:_query];
		
		_queryContexts = [NSMutableDictionary dictionaryWithCapacity:3];
		_presentedItemOperationQueue = [[NSOperationQueue alloc] init];
		[_presentedItemOperationQueue setName:[NSString stringWithFormat:@"presenter queue -- %@", self]];
		[_presentedItemOperationQueue setMaxConcurrentOperationCount:1];
	}
	return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSMetadataQueryDidFinishGatheringNotification
                                                  object:_query];
	[_query disableUpdates];
    [_query stopQuery];
	_query = nil;

	_presentedItemURL = nil;
	_queryContexts = nil;
	_presentedItemOperationQueue = nil;
}

#pragma mark - loadFiles
-(BOOL)loadFilesWithPredicate:(NSPredicate*)predicate completedBlock:(KRiCloudCompletedBlock)block{
	NSAssert(block, @"Mustn't be nil");
	if(!block)
		return NO;

	if([_query isStarted]){
		block(_query, nil);
		return YES;
	}
	
	_block = block;

	[_query setPredicate:predicate];
	[_query startQuery];
	
	return YES;
}

- (void)queryDidFinishGatheringForLoading:(NSNotification *)notification {
	if(_block)
		_block(_query, nil);
}

-(void)raiseCompletedBlock:(KRiCloudContext*)context{
	NSMetadataQuery* query = context.query;
	context.block(query, nil);
}

#pragma mark - renameFile
-(BOOL)renameFile:(NSURL*)sourceURL
		   newURL:(NSURL*)destinationURL
			error:(NSError**)error{
	NSError* outError = nil;
	__block BOOL result = NO;
	NSFileCoordinator* fileCoordinator = [[NSFileCoordinator alloc] initWithFilePresenter:self];
    [fileCoordinator coordinateWritingItemAtURL:sourceURL
										options:NSFileCoordinatorWritingForMoving
							   writingItemAtURL:destinationURL
										options:NSFileCoordinatorWritingForReplacing
										  error:&outError
									 byAccessor:^(NSURL *newURL1, NSURL* newURL2) {
										 NSFileManager* fileManager = [NSFileManager defaultManager];
										 result = [fileManager moveItemAtURL:newURL1 toURL:newURL2 error:error];
										 if(result)
											 [fileCoordinator itemAtURL:newURL1 didMoveToURL:newURL2];
									 }];
	if([outError code]){
		*error = outError;
		return NO;
	}
	
    return result;
}

#pragma mark - monitorFiles
-(BOOL)monitorFilesWithPredicate:(NSPredicate*)predicate completedBlock:(KRiCloudCompletedBlock)block{
	NSAssert(block, @"Mustn't be nil");
	if(!block)
		return NO;
	
	NSMetadataQuery* query = [[NSMetadataQuery alloc] init];
	[query setSearchScopes:[NSArray arrayWithObject:NSMetadataQueryUbiquitousDocumentsScope]];
	[query setPredicate:predicate];
	
	KRiCloudContext* context = [[KRiCloudContext alloc]init];
	context.query = query;
	context.block = block;
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(queryDidUpdateNotification:)
												 name:NSMetadataQueryDidUpdateNotification
											   object:query];
	
	[query startQuery];
	
	NSValue* value = [NSValue valueWithNonretainedObject:query];
	[_queryContexts setObject:context forKey:value];
	return YES;
}

-(void)queryDidUpdateNotification:(NSNotification *)notification {
	NSMetadataQuery* query = [notification object];
    [query disableUpdates];
    [query stopQuery];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSMetadataQueryDidUpdateNotification
                                                  object:query];
    
	NSValue* value = [NSValue valueWithNonretainedObject:query];
	KRiCloudContext* context = [_queryContexts objectForKey:value];
    [self raiseCompletedBlock:context];
	
	[_queryContexts removeObjectForKey:query];
}

#pragma mark - batch sync
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
	
#ifdef DEBUG
	if([readingURLs count])
		NSLog(@"readingURLs:%@", readingURLs);
	if([writingURLs count])
		NSLog(@"writingURLs:%@", writingURLs);
#endif
	
	NSMutableArray* toLocalErrors = [NSMutableArray arrayWithCapacity:[readingURLs count]];
	NSMutableArray* fromLocalErrors = [NSMutableArray arrayWithCapacity:[writingURLs count]];
	
	NSFileCoordinator* fileCoordinator = [[NSFileCoordinator alloc]initWithFilePresenter:self];
	[fileCoordinator prepareForReadingItemsAtURLs:readingURLs options:NSFileCoordinatorReadingWithoutChanges
							   writingItemsAtURLs:writingURLs options:NSFileCoordinatorWritingForReplacing
											error:outError
									   byAccessor:^(void(^prepareCompletionHandler)(void)){
										   
										   [self batchSync:fileCoordinator
											   readingURLs:readingURLs toLocalURLs:toLocalURLs toLocalErrors:toLocalErrors
											   writingURLs:writingURLs fromLocalURLs:fromLocalURLs fromLocalErrors:fromLocalErrors];
										   
										   block(readingURLs, toLocalErrors, fromLocalURLs, fromLocalErrors);
									   }];
	
	return YES;
}

-(void)batchSync:(NSFileCoordinator*)fileCoordinator
	 readingURLs:(NSArray*)readingURLs toLocalURLs:(NSArray*)toLocalURLs toLocalErrors:(NSMutableArray*)toLocalErrors
	 writingURLs:(NSArray*)writingURLs fromLocalURLs:(NSArray*)fromLocalURLs fromLocalErrors:(NSMutableArray*)fromLocalErrors{
	
	NSUInteger count = [readingURLs count];
	for(NSUInteger i=0; i<count; i++){
		NSError* error = nil;
		BOOL ret = [self saveToDocumentWithFileCoordinator:fileCoordinator
												  url:[readingURLs objectAtIndex:i]
									   destinationURL:[toLocalURLs objectAtIndex:i]
												error:&error];
		if(!ret || [error code])
			[toLocalErrors addObject:error];
		else
			[toLocalErrors addObject:[NSNull null]];
	}
	NSAssert([toLocalURLs count] == [toLocalErrors count], @"Must be equl");
	
	count = [writingURLs count];
	for(NSUInteger i=0; i<count; i++){
		NSError* error = nil;
		BOOL ret = [self saveToUbiquityContainerWithFileCoordinator:fileCoordinator
																url:[fromLocalURLs objectAtIndex:i]
													 destinationURL:[writingURLs objectAtIndex:i]
															  error:&error];
		if(!ret || [error code])
			[fromLocalErrors addObject:error];
		else
			[fromLocalErrors addObject:[NSNull null]];
	}
	NSAssert([fromLocalURLs count] == [fromLocalErrors count], @"Must be equl");
}

#pragma mark - save
-(BOOL)saveToUbiquityContainer:(id)key url:(NSURL*)url destinationURL:(NSURL*)destinationURL completedBlock:(KRiCloudSaveFileCompletedBlock)block{
	NSAssert(block, @"Mustn't be nil");
	if(!block)
		return NO;

	NSError* error = nil;
    NSFileCoordinator* fc = [[NSFileCoordinator alloc] initWithFilePresenter:self];
	return [self saveToUbiquityContainerWithFileCoordinator:fc url:url destinationURL:destinationURL error:&error];
}

-(BOOL)saveToUbiquityContainerWithFileCoordinator:(NSFileCoordinator*)fileCoordinator url:(NSURL*)url destinationURL:(NSURL*)destinationURL error:(NSError**)error{
	__block NSError* innerError = nil;
	__block BOOL ret = NO;
	NSError* outError = nil;
    [fileCoordinator coordinateWritingItemAtURL:destinationURL
										options:NSFileCoordinatorWritingForReplacing
										  error:&outError
									 byAccessor:^(NSURL *updatedURL) {
										 ret = [self checkIn:url toURL:updatedURL error:&innerError];
									 }];
	if([outError code]){
		*error = outError;
		return NO;
	}
	if(!ret){
		*error = innerError;
		return NO;
	}
	
    return YES;
}


-(BOOL)checkIn:(NSURL*)url toURL:(NSURL*)toURL error:(NSError**)outError{
	NSFileManager* fileManager = [NSFileManager defaultManager];
	BOOL ret = NO;
	if([fileManager fileExistsAtPath:[toURL path]]){
		ret = [fileManager replaceItemAtURL:toURL withItemAtURL:url backupItemName:nil options:NSFileManagerItemReplacementUsingNewMetadataOnly resultingItemURL:&toURL error:outError];
	}else{
		ret = [fileManager moveItemAtURL:url toURL:toURL error:outError];
	}
	
	return ret;
}

-(BOOL)saveToDocument:(id)key url:(NSURL*)url destinationURL:(NSURL*)destinationURL completedBlock:(KRiCloudSaveFileCompletedBlock)block{
	NSAssert(block, @"Mustn't be nil");
	if(!block)
		return NO;
	
	NSError* error = nil;
	NSFileManager* fileManager = [NSFileManager defaultManager];
	BOOL ret = [fileManager startDownloadingUbiquitousItemAtURL:url error:&error];
	NSLog(@"startDownloadingUbiquitousItemAtURL - ret:%@, error:%@", ret?@"YES":@"NO", error);

    NSFileCoordinator* fc = [[NSFileCoordinator alloc] initWithFilePresenter:self];
	return [self saveToDocumentWithFileCoordinator:fc url:url destinationURL:destinationURL error:&error];
}

-(BOOL)saveToDocumentWithFileCoordinator:(NSFileCoordinator*)fileCoordinator
									 url:(NSURL*)url
						  destinationURL:(NSURL*)destinationURL
								   error:(NSError**)error{
	__block NSError* innerError = nil;
	NSError* outError = nil;
    [fileCoordinator coordinateReadingItemAtURL:url
										options:NSFileCoordinatorReadingWithoutChanges
										  error:&outError
									 byAccessor:^(NSURL *updatedURL) {
										 [self checkOut:updatedURL toURL:destinationURL error:&innerError];
									 }];
	if([outError code]){
		*error = outError;
		return NO;
	}
	if([innerError code]){
		*error = innerError;
		return NO;
	}
	
    return YES;
}

-(BOOL)checkOut:(NSURL*)url toURL:(NSURL*)toURL error:(NSError**)outError{
	NSFileManager* fileManager = [NSFileManager defaultManager];
	if([fileManager fileExistsAtPath:[toURL path]]){
		BOOL ret = [fileManager removeItemAtURL:toURL error:outError];
		if(!ret)
			return ret;
	}
	
	return [fileManager copyItemAtURL:url toURL:toURL error:outError];
}

#pragma mark - remove files
-(BOOL)removeFile:(NSString*)fileName completedBlock:(KRiCloudRemoveFileCompletedBlock)block{
	NSAssert(block, @"Mustn't be nil");
	if(!block)
		return NO;

	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(%K == %@)", NSMetadataItemFSNameKey, fileName];
	
	[self loadFilesWithPredicate:predicate
				  completedBlock:^(NSMetadataQuery* query, NSError* error){
					  [self removeFilesWithItems:[query results] block:block];
				  }];
	return YES;
}

-(BOOL)removeAllFiles:(KRiCloudRemoveFileCompletedBlock)block{
	NSAssert(block, @"Mustn't be nil");
	if(!block)
		return NO;
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(%K like '*')", NSMetadataItemFSNameKey];
	
	[self loadFilesWithPredicate:predicate
				  completedBlock:^(NSMetadataQuery* query, NSError* error){
		  [self removeFilesWithItems:[query results] block:block];
	}];

	return YES;
}

-(BOOL)removeFilesWithItems:(NSArray*)metadataItems block:(KRiCloudRemoveFileCompletedBlock)block{
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

#pragma mark NSFilePresenter protocol

- (NSURL *)presentedItemURL{
	if(!_presentedItemURL){
		NSFileManager* fileManager = [NSFileManager defaultManager];
		_presentedItemURL = [fileManager URLForUbiquityContainerIdentifier:nil];
	}
	return _presentedItemURL;
}

- (NSOperationQueue *)presentedItemOperationQueue{
	NSLog(@"presentedItemOperationQueue");
    return _presentedItemOperationQueue;
}

- (void)relinquishPresentedItemToReader:(void (^)(void (^reacquirer)(void))) reader{
	NSLog(@"relinquishPresentedItemToReader");
}
- (void)relinquishPresentedItemToWriter:(void (^)(void (^reacquirer)(void)))writer;{
	NSLog(@"relinquishPresentedItemToWriter");
}

- (void)savePresentedItemChangesWithCompletionHandler:(void (^)(NSError *errorOrNil))completionHandler{
    NSLog(@"savePresentedItemChangesWithCompletionHandler");
}

- (void)accommodatePresentedItemDeletionWithCompletionHandler:(void (^)(NSError *errorOrNil))completionHandler{
    NSLog(@"accommodatePresentedItemDeletionWithCompletionHandler");
}

- (void)presentedItemDidMoveToURL:(NSURL *)newURL;{
    NSLog(@"presentedItemDidMoveToURL: %@", newURL);
}

// This gets called for local coordinated writes and for unsolicited incoming edits from iCloud. From the header, "Your NSFileProvider may be sent this message without being sent -relinquishPresentedItemToWriter: first. Make your application do the best it can in that case."
- (void)presentedItemDidChange;{
    NSLog(@"presentedItemDidChange");
}

- (void)presentedItemDidGainVersion:(NSFileVersion *)version;{
    NSLog(@"presentedItemDidGainVersion");
}

- (void)presentedItemDidLoseVersion:(NSFileVersion *)version;{
    NSLog(@"presentedItemDidLoseVersion");
}

- (void)presentedItemDidResolveConflictVersion:(NSFileVersion *)version;{
    NSLog(@"presentedItemDidResolveConflictVersion");
}

- (void)presentedSubitemAtURL:(NSURL *)url didGainVersion:(NSFileVersion *)version{
	NSLog(@"presentedSubitemAtURL-url:%@, didGainVersion:%@", url, version);
}

- (void)presentedSubitemAtURL:(NSURL *)url didLoseVersion:(NSFileVersion *)version{
	NSLog(@"presentedSubitemAtURL-url:%@, didLoseVersion:%@", url, version);
}

- (void)presentedSubitemAtURL:(NSURL *)url didResolveConflictVersion:(NSFileVersion *)version{
	NSLog(@"presentedSubitemAtURL-url:%@, didResolveConflictVersion:%@", url, version);
}

- (void)accommodatePresentedSubitemDeletionAtURL:(NSURL *)url completionHandler:(void (^)(NSError *errorOrNil))completionHandler{
	NSLog(@"accommodatePresentedSubitemDeletionAtURL-url:%@", url);
}

- (void)presentedSubitemDidAppearAtURL:(NSURL *)url{
	NSLog(@"presentedSubitemDidAppearAtURL:%@", url);
}

- (void)presentedSubitemAtURL:(NSURL *)oldURL didMoveToURL:(NSURL *)newURL{
	NSLog(@"presentedSubitemAtURL - oldURL:%@, didMoveToURL:%@", oldURL, newURL);
}

- (void)presentedSubitemDidChangeAtURL:(NSURL *)url{
	NSLog(@"presentedSubitemDidChangeAtURL:%@", url);
}

@end
