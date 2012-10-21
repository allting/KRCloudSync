//
//  KRiCloud.h
//  CloudSync
//
//  Created by allting on 12. 10. 21..
//  Copyright (c) 2012년 allting. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^KRiCloudLoadFilesCompletedBlock)(id, NSMetadataQuery*, NSError*);


@interface KRiCloudLoadFilesContext : NSObject
@property (nonatomic) id key;
@property (nonatomic) NSMetadataQuery* query;
@property (nonatomic, copy) KRiCloudLoadFilesCompletedBlock block;
@end

@interface KRiCloud : NSObject{
	NSURL* _ubiquityContainer;
	NSMutableDictionary* _loadFilesContexts;
}

+(KRiCloud*)sharedInstance;

-(BOOL)loadFiles:(id)key predicate:(NSPredicate*)predicate completedBlock:(KRiCloudLoadFilesCompletedBlock)block;

@end
