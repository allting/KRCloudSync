//
//  KRiCloud.h
//  CloudSync
//
//  Created by allting on 12. 10. 21..
//  Copyright (c) 2012년 allting. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^KRiCloudCompletedBlock)(NSMetadataQuery*, NSError*);
typedef void (^KRiCloudSaveFileCompletedBlock)(id, NSError*);
typedef void (^KRiCloudRemoveFileCompletedBlock)(BOOL, NSError*);
typedef void (^KRiCloudBatchSyncCompeletedBlock)
				(NSArray* toLocalURLs, NSArray* toLocalURLErrors,
					NSArray* fromLocalURLs, NSArray* fromLocalURLErrors);

@interface KRiCloudContext : NSObject
@property (nonatomic) id key;
@property (nonatomic) NSMetadataQuery* query;
@property (nonatomic, copy) KRiCloudCompletedBlock block;
@end

@interface KRiCloud : NSObject<NSFilePresenter>{
	NSURL* _ubiquityContainer;
	NSMutableDictionary* _queryContexts;
	NSOperationQueue* _presentedItemOperationQueue;
}

+(KRiCloud*)sharedInstance;

-(BOOL)loadFilesWithPredicate:(NSPredicate*)predicate
			   completedBlock:(KRiCloudCompletedBlock)block;

-(BOOL)monitorFilesWithPredicate:(NSPredicate*)predicate
				  completedBlock:(KRiCloudCompletedBlock)block;

-(BOOL)saveToUbiquityContainer:(id)key
						   url:(NSURL*)url
				destinationURL:(NSURL*)destinationURL
				completedBlock:(KRiCloudSaveFileCompletedBlock)block;

-(BOOL)saveToDocument:(id)key
				  url:(NSURL*)url
	   destinationURL:(NSURL*)destinationURL
	   completedBlock:(KRiCloudSaveFileCompletedBlock)block;

-(BOOL)removeFile:(NSString*)fileName completedBlock:(KRiCloudRemoveFileCompletedBlock)block;
-(BOOL)removeAllFiles:(KRiCloudRemoveFileCompletedBlock)block;

-(BOOL)batchLockAndSync:(NSArray*)readingURLs toLocalURLs:(NSArray*)toLocalURLs
			writingURLs:(NSArray*)writingURLs fromLocalURLs:(NSArray*)fromLocalURLs
				  error:(NSError**)outError
		 completedBlock:(KRiCloudBatchSyncCompeletedBlock)block;

@end
