//
//  ViewController.m
//  CloudSyncSample
//
//  Created by allting on 12. 10. 21..
//  Copyright (c) 2012년 allting. All rights reserved.
//

#import "ViewController.h"
#import "KRCloudSync.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	KRCloudSync* syncer = [[KRCloudSync alloc]init];
	[syncer syncUsingBlock:^(NSError* error){
		if(error)
			NSLog(@"Failed to sync : %@", error);
		else
			NSLog(@"Succeeded to sync : %@", error);
	}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
