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

-(NSComparisonResult)compare:(KRResourceProperty*)anohterResource{
	NSComparisonResult result = [self isEqualToDate:_modifiedDate anotherDate:anohterResource.modifiedDate];
	if(result != NSOrderedSame)
		return result;
	return [self isEqualToDate:_createdDate anotherDate:anohterResource.createdDate];
}

-(NSComparisonResult)isEqualToDate:(NSDate*)date anotherDate:(NSDate*)anotherDate{
	NSTimeInterval interval = [date timeIntervalSinceDate:anotherDate];
	if(1.f<=interval)
		return NSOrderedAscending;
	else if(interval<=-1.f)
		return NSOrderedDescending;
	return NSOrderedSame;
}

@end
