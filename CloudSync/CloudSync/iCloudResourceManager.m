//
//  iCloudResourceManager.m
//  CloudSync
//
//  Created by allting on 12. 10. 11..
//  Copyright (c) 2012년 allting. All rights reserved.
//

#import "iCloudResourceManager.h"

@implementation iCloudResourceManager

-(id)initWithURLs:(NSArray*)URLs{
	self = [super init];
	if(self){
		_URLs = URLs;
	}
	return self;
}

-(BOOL)hasResource:(NSURL*)resource{
	for(NSURL* url in _URLs){
		NSString* component = [url lastPathComponent];
		NSString* fileName = [resource lastPathComponent];
		if([component isEqualToString:fileName])
			return YES;
	}
	return NO;
}

@end
