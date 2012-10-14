//
//  KRCloudSync.m
//  CloudSync
//
//  Created by allting on 12. 10. 10..
//  Copyright (c) 2012년 allting. All rights reserved.
//

#import "KRCloudSync.h"

@implementation KRCloudSync

-(id)init{
	self = [super init];
	if(self){
		_preferences = [[KRCloudPreferences alloc]init];
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
			completed(error);
			return;
		}
		
		KRResourceComparer* resourceComparer = [[KRResourceComparer alloc]initWithFactory:_factory];
		[resourceComparer compareUsingBlock:^(NSArray* comparedResources, NSError* error){
			if(error){
				completed(error);
				return;
			}
			
			KRSynchronizer* sync = [[KRSynchronizer alloc]initWithFactory:_factory];
			[sync syncUsingBlock:comparedResources completed:^(NSArray* syncResults, NSError* error){
				completed(error);
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
