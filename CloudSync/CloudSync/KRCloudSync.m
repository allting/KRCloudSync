//
//  KRCloudSync.m
//  CloudSync
//
//  Created by allting on 12. 10. 10..
//  Copyright (c) 2012년 allting. All rights reserved.
//

#import "KRCloudSync.h"
#import "KRResourceLoader.h"
#import "KRResourceComparer.h"
#import "KRSynchronizer.h"
#import "KRiCloudFactory.h"
#import "KRiCloudService.h"

@implementation KRCloudSync

+(BOOL)isAvailableiCloudUsingBlock:(KRiCloudAvailableBlock)availableBlock{
	return [KRiCloudService isAvailableiCloudUsingBlock:availableBlock];
}

-(id)init{
	self = [super init];
	if(self){
		_preferences = [[KRCloudPreferences alloc]init];
		_factory = [[KRiCloudFactory alloc]init];
	}
	return self;
}

-(id)initWithFactory:(KRCloudFactory*)factory{
	self = [super init];
	if(self){
		_factory = factory;
	}
	return self;
}

-(BOOL)sync{
	return YES;
}

-(BOOL)syncUsingBlock:(KRCloudSyncCompletedBlock)completed{
	NSAssert(completed, @"Mustn't be nil");
	NSAssert(_factory, @"Mustn't be nil");
	if(!completed || !_factory)
		return NO;
	
	KRResourceLoader* resourceLoader = [[KRResourceLoader alloc]initWithFactory:_factory];
	[resourceLoader loadUsingBlock:^(NSArray* remoteResources, NSArray* localResources, NSError* error){
		if(error){
			completed(nil, error);
			return;
		}
		
		KRResourceComparer* resourceComparer = [[KRResourceComparer alloc]initWithFactory:_factory];
		[resourceComparer compareUsingBlock:localResources
							remoteResources:remoteResources
							 completedBlock:^(NSArray* syncItems, NSError* error){
			if(error){
				completed(nil, error);
				return;
			}
			
			KRSynchronizer* sync = [[KRSynchronizer alloc]initWithFactory:_factory];
			[sync syncUsingBlock:syncItems completedBlock:^(NSArray* syncItemsResult, NSError* error){
				completed(syncItemsResult, error);
			}];
		}];
	}];
	
	return YES;
}

-(void)syncWithiCloudUsingBlocks:(NSURL*)url
		 progressBlock:(KRCloudSyncProgressBlock)progres
		completedBlock:(KRCloudSyncCompletedBlock)completed{
}
@end
