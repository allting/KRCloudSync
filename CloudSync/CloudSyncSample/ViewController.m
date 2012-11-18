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
	[self sync];
//	[self removeAllFiles];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)removeAllFiles{
	[KRCloudSync isAvailableiCloudUsingBlock:^(BOOL available){
		if(!available){
			NSLog(@"Can't use iCloud");
		}else{
			[self removeAlliCloudFiles];
		}
	}];
}

-(void)removeAlliCloudFiles{
	[KRCloudSync removeAlliCloudFileUsingBlock:^(BOOL succeeded, NSError* error){
		if(succeeded){
			NSLog(@"Succeeded to remove files");
		}else{
			NSLog(@"Failed to remove files");
		}
	}];
}

-(void)sync{
	[KRCloudSync isAvailableiCloudUsingBlock:^(BOOL available){
		if(!available){
			NSLog(@"Can't use iCloud");
		}else{
			[self syncDocumentFiles];
		}
	}];
}

-(void)syncDocumentFiles{
	KRCloudFactory* factory = [self createFactoryAndDirectory:@"iCloud"];
	
	KRCloudSync* syncer = [[KRCloudSync alloc]initWithFactory:factory];
	[syncer syncUsingBlock:^(NSArray* syncItems, NSError* error){
		if(error)
			NSLog(@"Failed to sync : %@", error);
		else{
			NSLog(@"Succeeded to sync - item count:%d", [syncItems count]);
			NSLog(@"syncItems - %@", syncItems);
		}
	}];
}

-(KRiCloudFactory*)createFactoryAndDirectory:(NSString*)path{
	NSString* iCloudDocumentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	iCloudDocumentPath = [iCloudDocumentPath stringByAppendingPathComponent:path];
	
	[self createDirectory:iCloudDocumentPath];
	
	return [[KRiCloudFactory alloc]initWithLocalPath:iCloudDocumentPath filters:@[@"png"]];
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
