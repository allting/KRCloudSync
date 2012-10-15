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

-(BOOL)isEqualToURL:(NSURL*)url otherURL:(NSURL*)otherURL;
-(KRResourceProperty*)findResource:(NSURL*)url;
-(BOOL)isModified:(KRResourceProperty *)resource anohterResource:(KRResourceProperty*)anohterResource;

@end
