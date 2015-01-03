//
//  ViewController.m
//  iAppCryto
//
//  Created by amayoral on 1/1/15.
//  Copyright (c) 2015 vRoutes. All rights reserved.
//

#import "ViewController.h"
#import "DemoCryptoManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    DemoCryptoManager *__manager = [DemoCryptoManager sharedInstance];
    
    [__manager testOfEncryption];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
