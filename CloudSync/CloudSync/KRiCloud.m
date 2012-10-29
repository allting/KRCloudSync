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
							NSFileManager* fileManager = [NSFileManager defaultManager];
							
							if([fileManager fileExistsAtPath:[updatedURL path]])
								[fileManager removeItemAtURL:updatedURL error:&error];
							
							[fileManager copyItemAtURL:url toURL:updatedURL error:&error];
							
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
							NSFileManager* fileManager = [NSFileManager defaultManager];
							
							if([fileManager fileExistsAtPath:[destinationURL path]])
								[fileManager removeItemAtURL:destinationURL error:&error];
							
							[fileManager copyItemAtURL:updatedURL toURL:destinationURL error:&error];
							
							block(key, error);
						}];
	
    return YES;
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
