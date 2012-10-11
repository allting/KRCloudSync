//
//  KRiCloudResourceManager.h
//  CloudSync
//
//  Created by allting on 12. 10. 11..
//  Copyright (c) 2012년 allting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KRResourceProperty.h"

@interface KRiCloudResourceManager : NSObject

@property (nonatomic) NSArray* URLs;
@property (nonatomic) NSArray* Resources;

-(id)initWithURLsAndProperties:(NSArray*)Resources;

-(BOOL)hasResource:(NSURL*)url;

-(KRResourceProperty*)findResource:(NSURL*)url;
-(BOOL)isModified:(KRResourceProperty *)resource otherResource:(KRResourceProperty*)otherResource;

@end
