//
//  KRLocalFileService.h
//  CloudSync
//
//  Created by allting on 12. 10. 21..
//  Copyright (c) 2012년 allting. All rights reserved.
//

#import "KRFileService.h"

@interface KRLocalFileService : KRFileService

@property (nonatomic) NSString* documentPath;

-(id)initWithLocalPath:(NSString*)path;

-(NSArray*)load;

@end
