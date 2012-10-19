//
//  KRResourceProperty.h
//  CloudSync
//
//  Created by allting on 12. 10. 11..
//  Copyright (c) 2012년 allting. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KRResourceProperty : NSObject
@property (nonatomic) NSURL* URL;
@property (nonatomic) NSDate* createdDate;
@property (nonatomic) NSDate* modifiedDate;
@property (nonatomic) NSNumber* size;

-(id)initWithProperties:(NSURL*)url
			createdDate:(NSDate*)createDate
		   modifiedDate:(NSDate*)modifiedDate
				   size:(NSNumber*)size;

-(NSComparisonResult)compare:(KRResourceProperty*)anotherResource;

@end
