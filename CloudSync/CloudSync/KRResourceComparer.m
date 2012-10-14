//
//  KRResourceComparer.m
//  CloudSync
//
//  Created by allting on 12. 10. 14..
//  Copyright (c) 2012년 allting. All rights reserved.
//

#import "KRResourceComparer.h"

@implementation KRResourceComparer

-(id)initWithFactory:(KRCloudFactory*)factory{
	self = [super init];
	if(self){
		
	}
	return self;
}

-(void)compareUsingBlock:(NSArray*)remoteResources
		  localResources:(NSArray*)localResources
		  completedBlock:(KRResourceComparerCompletedBlock)completed{
	NSAssert(completed, @"Mustn't be nil");
	if(!completed)
		return;

}

@end
