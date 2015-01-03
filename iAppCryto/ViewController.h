//
//  ViewController.h
//  iAppCryto
//
//  Created by amayoral on 1/1/15.
//  Copyright (c) 2015 vRoutes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITextViewDelegate>

@property (nonatomic, strong) IBOutlet UITextView  *txtViewPlainText;
@property (nonatomic, strong) IBOutlet UITextView  *txtViewEncrypted;
@property (nonatomic, strong) IBOutlet UITextView  *txtViewDecrypted;

@end

