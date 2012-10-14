//
//  KRSynchronizer.m
//  CloudSync
//
//  Created by allting on 12. 10. 14..
//  Copyright (c) 2012년 allting. All rights reserved.
//

#import "KRSynchronizer.h"

@implementation KRSynchronizer

-(id)initWithFactory:(KRCloudFactory*)factory{
	self = [super init];
	if(self){
		
	}
	return self;
}

-(void)syncUsingBlock:(NSArray*)comparedResources
	   completedBlock:(KRSynchronizerCompletedBlock)completed{
	NSAssert(completed, @"Mustn't be nil");
	if(!completed)
		return;

}

@end
