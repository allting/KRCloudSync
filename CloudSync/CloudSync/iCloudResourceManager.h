//
//  iCloudResourceManager.h
//  CloudSync
//
//  Created by allting on 12. 10. 11..
//  Copyright (c) 2012년 allting. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface iCloudResourceManager : NSObject

@property (nonatomic) NSArray* URLs;

-(id)initWithURLs:(NSArray*)URLs;

-(BOOL)hasResource:(NSURL*)url;

@end
