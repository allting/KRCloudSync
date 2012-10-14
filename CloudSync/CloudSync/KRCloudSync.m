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
		_cloudService = [factory cloudService];
		_fileService = [factory fileService];
	}
	return self;
}

-(BOOL)sync{
	return YES;
}

-(void)syncUsingBlock:(KRCloudSyncCompletedBlock)completed{
	NSAssert(_cloudService, @"Mustn't be nil");
	NSAssert(_fileService, @"Mustn't be nil");
	if(!_cloudService || !_fileService)
		return;
	
//	NSArray* localResources = [self.fileService resources];
//	
//	[_cloudService resourcesUsingBlock:^(NSArray* remoteResouces){
//		[self syncWithResources:remoteResouces local]
//	}];
}

-(void)syncWithiCloudUsingBlocks:(NSURL*)url
		 progressBlock:(KRCloudSyncProgressBlock)progres
		completedBlock:(KRCloudSyncCompletedBlock)completed{
}
@end
