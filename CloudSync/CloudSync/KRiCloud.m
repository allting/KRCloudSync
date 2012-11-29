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
		_ubiquityContainer = nil;
		_queryContexts = [NSMutableDictionary dictionaryWithCapacity:3];
		_presentedItemOperationQueue = [[NSOperationQueue alloc] init];
		[_presentedItemOperationQueue setName:[NSString stringWithFormat:@"presenter queue -- %@", self]];
		[_presentedItemOperationQueue setMaxConcurrentOperationCount:1];
	}
	return self;
}

-(void)dealloc{
	_ubiquityContainer = nil;
	_queryContexts = nil;
	_presentedItemOperationQueue = nil;
}

#pragma mark - loadFiles
-(BOOL)loadFilesWithPredicate:(NSPredicate*)predicate completedBlock:(KRiCloudCompletedBlock)block{
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
											 selector:@selector(queryDidFinishGatheringForLoading:)
												 name:NSMetadataQueryDidFinishGatheringNotification
											   object:query];
	
	[query startQuery];
	
	NSValue* value = [NSValue valueWithNonretainedObject:query];
	[_queryContexts setObject:context forKey:value];
	return YES;
}

- (void)queryDidFinishGatheringForLoading:(NSNotification *)notification {
	NSMetadataQuery* query = [notification object];
    [query disableUpdates];
    [query stopQuery];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSMetadataQueryDidFinishGatheringNotification
                                                  object:query];
    
	NSValue* value = [NSValue valueWithNonretainedObject:query];
	KRiCloudContext* context = [_queryContexts objectForKey:value];
    [self raiseCompletedBlock:context];
	
	[_queryContexts removeObjectForKey:query];
}

- (void)raiseCompletedBlock:(KRiCloudContext*)context{
	if(context.block){
		context.block(context.query, nil);
	}
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

#pragma mark - save
-(BOOL)saveToUbiquityContainer:(id)key url:(NSURL*)url destinationURL:(NSURL*)destinationURL completedBlock:(KRiCloudSaveFileCompletedBlock)block{
	NSAssert(block, @"Mustn't be nil");
	if(!block)
		return NO;

    NSFileCoordinator* fc = [[NSFileCoordinator alloc] initWithFilePresenter:self];
	return [self saveToUbiquityContainerWithFileCoordinator:fc key:key url:url destinationURL:destinationURL completedBlock:block];
}

-(BOOL)saveToUbiquityContainerWithFileCoordinator:(NSFileCoordinator*)fileCoordinator key:(id)key url:(NSURL*)url destinationURL:(NSURL*)destinationURL completedBlock:(KRiCloudSaveFileCompletedBlock)block{
	NSAssert(block, @"Mustn't be nil");
	if(!block)
		return NO;
	
	NSError* outError = nil;
    [fileCoordinator coordinateWritingItemAtURL:destinationURL
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
	
    NSFileCoordinator* fc = [[NSFileCoordinator alloc] initWithFilePresenter:self];
	return [self saveToDocumentWithFileCoordinator:fc key:key url:url destinationURL:destinationURL completedBlock:block];
}

-(BOOL)saveToDocumentWithFileCoordinator:(NSFileCoordinator*)fileCoordinator key:(id)key url:(NSURL*)url destinationURL:(NSURL*)destinationURL completedBlock:(KRiCloudSaveFileCompletedBlock)block{
	NSAssert(block, @"Mustn't be nil");
	if(!block)
		return NO;
	
	NSError* outError = nil;
    [fileCoordinator coordinateReadingItemAtURL:url
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
									   }];
		
	block(readingURLs, toLocalErrors, fromLocalURLs, fromLocalErrors);

	return YES;
}

-(void)batchSync:(NSFileCoordinator*)fileCoordinator
	 readingURLs:(NSArray*)readingURLs toLocalURLs:(NSArray*)toLocalURLs toLocalErrors:(NSMutableArray*)toLocalErrors
	 writingURLs:(NSArray*)writingURLs fromLocalURLs:(NSArray*)fromLocalURLs fromLocalErrors:(NSMutableArray*)fromLocalErrors{
	
	NSUInteger count = [readingURLs count];
	for(NSUInteger i=0; i<count; i++){
		[self saveToDocumentWithFileCoordinator:fileCoordinator key:nil
											url:[readingURLs objectAtIndex:i]
								 destinationURL:[toLocalURLs objectAtIndex:i]
								 completedBlock:^(id key, NSError *error) {
									 if([error code])
										 [toLocalErrors addObject:error];
									 else
										 [toLocalErrors addObject:[NSNull null]];
								 }];
	}
	
	count = [writingURLs count];
	for(NSUInteger i=0; i<count; i++){
		[self saveToUbiquityContainerWithFileCoordinator:fileCoordinator key:nil
													 url:[fromLocalURLs objectAtIndex:i]
										  destinationURL:[writingURLs objectAtIndex:i]
										  completedBlock:^(id key, NSError *error) {
											  if([error code])
												  [fromLocalErrors addObject:error];
											  else
												  [fromLocalErrors addObject:[NSNull null]];
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
