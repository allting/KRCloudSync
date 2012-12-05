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
#import "KRiCloudService.h"
#import "KRiCloud.h"

@interface ViewController ()
@property (nonatomic) KRiCloud* iCloudForMonitor;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
//	[self monitoriCloudFiles];
	
	[self sync];
//	[self removeAllFiles];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)monitoriCloudFiles{
	KRiCloud* iCloud = [[KRiCloud alloc]init];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(%K like '*')", NSMetadataItemFSNameKey];
	
	[iCloud monitorFilesWithPredicate:predicate completedBlock:^(NSMetadataQuery *query, NSError *error) {
		NSLog(@"MonitorFiles:%@, count:%d", query, [query resultCount]);
		for(NSMetadataItem* item in [query results]){
			NSLog(@"Item:%@", item);
		}
	}];
	
	self.iCloudForMonitor = iCloud;
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
	KRCloudFactory* factory = [self createFactoryAndDirectory:@"iCloud"];
	self.cloudSync = [[KRCloudSync alloc]initWithFactory:factory];
	
	[KRCloudSync isAvailableiCloudUsingBlock:^(BOOL available){
		if(!available){
			NSLog(@"Can't use iCloud");
		}else{
//			[self syncDocumentFiles];
			
			[self syncFilesAndCheckProgress];
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

-(void)syncFilesAndCheckProgress{
	KRCloudSyncStartBlock startBlock = ^(NSArray* syncItems){
		NSLog(@"-------Start sync with items:%d-----------", [syncItems count]);
//		for(KRSyncItem* item in syncItems){
//			NSLog(@"item:%@", item);
//		}
	};
	KRCloudSyncProgressBlock progressBlock = ^(KRSyncItem* item, float progress){
		NSLog(@"item:%@, progress:%f", item, progress);
	};
	
	[_cloudSync syncUsingBlocks:startBlock
				 progressBlock:progressBlock
				completedBlock:^(NSArray* syncItems, NSError* error){
					if(error){
						NSLog(@"Failed to sync : %@", error);
						return;
					}
					
					NSLog(@"Succeeded to sync - item count:%d", [syncItems count]);
					NSLog(@"syncItems - %@", syncItems);
					
					KRCloudService* service = [_cloudSync service];
					[service renameFileUsingBlock:@"test1.png"
									  newFileName:@"test2.png"
								   completedBlock:^(BOOL succeeded, NSError* error){
						NSLog(@"%@ to rename - error:%@", succeeded?@"Succeeded":@"Failed", error);
					}];
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
