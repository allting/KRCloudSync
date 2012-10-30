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
			KRCloudFactory* factory = [self createFactoryAndDirectory:@"iCloud"];
			
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

-(KRiCloudFactory*)createFactoryAndDirectory:(NSString*)path{
	NSString* iCloudDocumentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	iCloudDocumentPath = [iCloudDocumentPath stringByAppendingPathComponent:path];
	
	[self createDirectory:iCloudDocumentPath];
	
	return [[KRiCloudFactory alloc]initWithLocalPath:iCloudDocumentPath];
}

-(BOOL)createDirectory:(NSString*)path{
	NSError* error = nil;
	BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:path
											 withIntermediateDirectories:YES
															  attributes:nil
																   error:&error];
	if(!success || error)
		return NO;
	return YES;
}


@end
