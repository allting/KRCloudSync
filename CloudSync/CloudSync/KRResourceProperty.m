//
//  KRResourceProperty.m
//  CloudSync
//
//  Created by allting on 12. 10. 11..
//  Copyright (c) 2012년 allting. All rights reserved.
//

#import "KRResourceProperty.h"

@implementation KRResourceProperty

-(id)initWithProperties:(NSURL*)url
			createdDate:(NSDate*)createDate
		   modifiedDate:(NSDate*)modifiedDate
				   size:(NSNumber*)size{
	self = [super init];
	if(self){
		_URL = url;
		_displayName = [url lastPathComponent];
		_createdDate = createDate;
		_modifiedDate = modifiedDate;
		_size = size;
	}
	return self;
}

-(id)initWithMetadataItem:(NSMetadataItem*)item{
	self = [super init];
	if(self){
		_URL = [item valueForAttribute:NSMetadataItemURLKey];
		_displayName = [item valueForAttribute:NSMetadataItemDisplayNameKey];
		_createdDate = [item valueForAttribute:NSMetadataItemFSCreationDateKey];
		_modifiedDate = [item valueForAttribute:NSMetadataItemFSContentChangeDateKey];
		_size = [item valueForAttribute:NSMetadataItemFSSizeKey];
	}
	return self;
}

-(NSComparisonResult)compare:(KRResourceProperty*)anotherResource{
	NSComparisonResult result = [self isEqualToDate:_modifiedDate anotherDate:anotherResource.modifiedDate];
	if(result != NSOrderedSame)
		return result;
	return [self isEqualToDate:_createdDate anotherDate:anotherResource.createdDate];
}

-(NSComparisonResult)isEqualToDate:(NSDate*)date anotherDate:(NSDate*)anotherDate{
	if(!anotherDate)
		return NSOrderedSame;
	
	NSTimeInterval interval = [date timeIntervalSinceDate:anotherDate];
	int roundInterval = lroundf(interval);
	if(1<=roundInterval)
		return NSOrderedAscending;
	else if(roundInterval<=-1)
		return NSOrderedDescending;
	return NSOrderedSame;
}

-(NSString*)description{
	return [NSString stringWithFormat:@"URL:%@,DisplayName:%@,CreatedDate:%@,ModifiedDate:%@,Size:%@",
											_URL, _displayName, _createdDate, _modifiedDate, _size];
}

@end
