//
//  KRiCloud.h
//  CloudSync
//
//  Created by allting on 12. 10. 21..
//  Copyright (c) 2012년 allting. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^KRiCloudLoadFilesCompletedBlock)(id, NSMetadataQuery*, NSError*);
typedef void (^KRiCloudSaveFileCompletedBlock)(id, NSError*);
typedef void (^KRiCloudRemoveAllFilesCompletedBlock)(BOOL, NSError*);

@interface KRiCloudLoadFilesContext : NSObject
@property (nonatomic) id key;
@property (nonatomic) NSMetadataQuery* query;
@property (nonatomic, copy) KRiCloudLoadFilesCompletedBlock block;
@end

@interface KRiCloud : NSObject<NSFilePresenter>{
	NSURL* _ubiquityContainer;
	NSMutableDictionary* _loadFilesContexts;
	NSOperationQueue* _presentedItemOperationQueue;
}

+(KRiCloud*)sharedInstance;

-(BOOL)loadFiles:(id)key
	   predicate:(NSPredicate*)predicate
  completedBlock:(KRiCloudLoadFilesCompletedBlock)block;

-(BOOL)saveToUbiquityContainer:(id)key
						   url:(NSURL*)url
				destinationURL:(NSURL*)destinationURL
				completedBlock:(KRiCloudSaveFileCompletedBlock)block;

-(BOOL)saveToDocument:(id)key
				  url:(NSURL*)url
	   destinationURL:(NSURL*)destinationURL
	   completedBlock:(KRiCloudSaveFileCompletedBlock)block;

-(BOOL)removeAllFiles:(KRiCloudRemoveAllFilesCompletedBlock)block;

@end
