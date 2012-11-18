//
//  KRLocalFileService.h
//  CloudSync
//
//  Created by allting on 12. 10. 21..
//  Copyright (c) 2012년 allting. All rights reserved.
//

#import "KRFileService.h"
#import "KRResourceFilter.h"

@interface KRLocalFileService : KRFileService

@property (nonatomic) NSString* documentPath;
@property (nonatomic) KRResourceFilter* filter;

-(id)initWithLocalPath:(NSString*)path filter:(KRResourceFilter *)filter;

-(NSArray*)load;

@end
