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

-(id)initWithLocalPath:(NSString*)path filters:(NSArray*)filters{
	self = [super init];
	if(self){
		KRResourceExtensionFilter* filter = [[KRResourceExtensionFilter alloc]initWithFilters:filters];
		self.cloudService = [[KRiCloudService alloc]initWithLocalPath:path filter:filter];
		self.fileService = [[KRLocalFileService alloc]initWithLocalPath:path filter:filter];
	}
	return self;
}


@end
