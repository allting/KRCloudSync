//
//  KRLocalFileService.m
//  CloudSync
//
//  Created by allting on 12. 10. 21..
//  Copyright (c) 2012년 allting. All rights reserved.
//

#import "KRLocalFileService.h"
#import "KRResourceProperty.h"

@implementation KRLocalFileService

-(id)initWithLocalPath:(NSString*)path filter:(KRResourceFilter*)filter{
	self = [super init];
	if(self){
		self.documentPath = path;
		self.filter = filter;
	}
	return self;
}

-(NSString*)documentPath{
	if(0==[_documentPath length])
		return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	
	return _documentPath;
}

-(NSArray*)load{
	NSString* documentPath = self.documentPath;
	NSFileManager* fileManager = [NSFileManager defaultManager];
	
	NSError* error = nil;
	NSArray* files = [fileManager contentsOfDirectoryAtPath:documentPath error:&error];
	if([error code]!=0)
		return nil;
	
	NSMutableArray* resources = [NSMutableArray arrayWithCapacity:[files count]];
	for(NSString* file in files){
		NSString* path = [documentPath stringByAppendingPathComponent:file];
		if(![_filter shouldPass:path])
			continue;
		
		NSError* error = nil;
		NSDictionary* attributes = [fileManager attributesOfItemAtPath:path error:&error];
		if([error code])
			continue;
		
		NSURL* url = [NSURL fileURLWithPath:path];
		NSDate* createdDate = [attributes objectForKey:NSFileCreationDate];
		NSDate* modifiedDate = [attributes objectForKey:NSFileModificationDate];
		NSNumber* size = [attributes objectForKey:NSFileSize];
		
		KRResourceProperty* resource = [[KRResourceProperty alloc]initWithProperties:url createdDate:createdDate modifiedDate:modifiedDate size:size];
		[resources addObject:resource];
	}
	
	return resources;
}

@end
