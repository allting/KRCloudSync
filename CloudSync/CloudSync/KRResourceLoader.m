//
//  KRResourceLoader.m
//  CloudSync
//
//  Created by allting on 12. 10. 14..
//  Copyright (c) 2012년 allting. All rights reserved.
//

#import "KRResourceLoader.h"

@implementation KRResourceLoader

-(id)initWithFactory:(KRCloudFactory*)factory{
	self = [super init];
	if(self){
		
	}
	return self;
}

-(void)loadUsingBlock:(KRResourceLoaderCompletedBlock)completed{
	NSAssert(completed, @"Mustn't be nil");
	if(!completed)
		return;
	
}

@end
