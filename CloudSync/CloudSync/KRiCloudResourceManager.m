//
//  KRiCloudResourceManager.m
//  CloudSync
//
//  Created by allting on 12. 10. 11..
//  Copyright (c) 2012년 allting. All rights reserved.
//

#import "KRiCloudResourceManager.h"

@implementation KRiCloudResourceManager

-(id)initWithURLsAndProperties:(NSArray*)Resources{
	self = [super init];
	if(self){
		_Resources = Resources;
	}
	return self;
}

-(BOOL)hasResource:(NSURL*)url{
	for(KRResourceProperty* res in _Resources){
		if([self isEqualToURL:url otherURL:res.URL])
			return YES;
	}
	return NO;
}

-(KRResourceProperty*)findResource:(NSURL*)url{
	for(KRResourceProperty* res in _Resources){
		if([self isEqualToURL:url otherURL:res.URL])
			return res;
	}
	return nil;
}

-(BOOL)isEqualToURL:(NSURL*)url otherURL:(NSURL*)otherURL{
	NSString* fileName = [url lastPathComponent];
	NSString* otherFileName = [otherURL lastPathComponent];
	if([fileName isEqualToString:otherFileName])
		return YES;
	return NO;
}

-(BOOL)isModified:(KRResourceProperty *)resource otherResource:(KRResourceProperty*)otherResource{
	if(![otherResource.size isEqualToNumber:resource.size])
		return YES;
	if(![self isEqualToDate:otherResource.modifiedDate otherDate:resource.modifiedDate])
		return YES;
	if(![self isEqualToDate:otherResource.createdDate otherDate:resource.createdDate])
		return YES;
	return NO;
}

-(BOOL)isEqualToDate:(NSDate*)date otherDate:(NSDate*)otherDate{
	NSTimeInterval interval = [date timeIntervalSinceDate:otherDate];
	if(1.<interval)
		return NO;
	return YES;
}

@end
