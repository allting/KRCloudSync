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
		_createdDate = createDate;
		_modifiedDate = modifiedDate;
		_size = size;
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
	NSTimeInterval interval = [date timeIntervalSinceDate:anotherDate];
	int roundInterval = lroundf(interval);
	if(1<=roundInterval)
		return NSOrderedAscending;
	else if(roundInterval<=-1)
		return NSOrderedDescending;
	return NSOrderedSame;
}

@end
