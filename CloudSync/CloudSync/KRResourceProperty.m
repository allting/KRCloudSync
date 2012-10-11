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

@end
