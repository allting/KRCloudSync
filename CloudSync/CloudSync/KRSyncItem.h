//
//  KRSyncItem.h
//  CloudSync
//
//  Created by allting on 12. 10. 15..
//  Copyright (c) 2012년 allting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KRResourceProperty.h"

typedef enum {
	KRSyncItemDirectionNone,
	KRSyncItemDirectionToRemote,
	KRSyncItemDirectionToLocal
}KRSyncItemDirection;

@interface KRSyncItem : NSObject

@property (nonatomic, assign) KRSyncItemDirection direction;
@property (nonatomic) KRResourceProperty* localResource;
@property (nonatomic) KRResourceProperty* remoteResource;

-(id)initWithResources:(KRResourceProperty*)localResource
		remoteResource:(KRResourceProperty*)remoteResource
	  comparisonResult:(NSComparisonResult)result;

@end
