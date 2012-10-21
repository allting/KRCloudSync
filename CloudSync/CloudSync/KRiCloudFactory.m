//
//  KRiCloudFactory.m
//  CloudSync
//
//  Created by allting on 12. 10. 21..
//  Copyright (c) 2012년 allting. All rights reserved.
//

#import "KRiCloudFactory.h"
#import "KRiCloudService.h"
#import "KRLocalFileService.h"

@implementation KRiCloudFactory

-(id)init{
	self = [super init];
	if(self){
		self.cloudService = [[KRiCloudService alloc]init];
		self.fileService = [[KRLocalFileService alloc]init];
	}
	return self;
}

@end
