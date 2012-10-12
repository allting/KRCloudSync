//
//  CloudFactoryMock.m
//  CloudSync
//
//  Created by allting on 12. 10. 12..
//  Copyright (c) 2012년 allting. All rights reserved.
//

#import "CloudFactoryMock.h"
#import "iCloudServiceMock.h"

@implementation CloudFactoryMock

-(id)init{
	self = [super init];
	if(self){
		self.cloudService = [[iCloudServiceMock alloc]init];
	}
	return self;
}

@end