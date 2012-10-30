//
//  ViewController.m
//  CloudSyncSample
//
//  Created by allting on 12. 10. 21..
//  Copyright (c) 2012년 allting. All rights reserved.
//

#import "ViewController.h"
#import "KRCloudSync.h"
#import "KRiCloudFactory.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	[self syncDocumentFiles];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)syncDocumentFiles{
	[KRCloudSync isAvailableiCloudUsingBlock:^(BOOL available){
		if(!available){
			NSLog(@"Can't use iCloud");
		}else{
			KRCloudFactory* factory = [self createFactoryWithLocalPath:@"iCloud"];
			
			KRCloudSync* syncer = [[KRCloudSync alloc]initWithFactory:factory];
			[syncer syncUsingBlock:^(NSArray* syncItems, NSError* error){
				if(error)
					NSLog(@"Failed to sync : %@", error);
				else
					NSLog(@"Succeeded to sync - item count:%d", [syncItems count]);
			}];
		}
	}];
}

-(KRiCloudFactory*)createFactoryWithLocalPath:(NSString*)path{
	NSString* iCloudDocumentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	iCloudDocumentPath = [iCloudDocumentPath stringByAppendingPathComponent:path];
	return [[KRiCloudFactory alloc]initWithLocalPath:iCloudDocumentPath];
}

@end
