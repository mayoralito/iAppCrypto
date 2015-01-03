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
{
    DemoCryptoManager   *__manager;
    NSString            *__IV;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    __manager = [DemoCryptoManager sharedInstance];
    //[__manager testOfEncryption];
    
    _txtViewPlainText.delegate = self;
    _txtViewEncrypted.delegate = self;
    _txtViewDecrypted.delegate = self;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doCryptText:(id)sender {
    // Get string from Storyboards
    NSString *text = [_txtViewPlainText text];
    
    // Set random value for this message.
    __IV = [__manager genRandStringLength:16];
    
    NSString *result = [__manager encryptText:text withIV:__IV];
    
    // Put result into the view
    [_txtViewEncrypted setText:result];
}

- (IBAction)doDecryptrText:(id)sender {
    // Get string value of data from Storyboards and decode the base64
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:[_txtViewEncrypted text] options:0];
    
    // Decode the result
    NSString *result = [__manager decryptText:decodedData withIV:__IV];
    
    // Put result into the view
    [_txtViewDecrypted setText:result];
}

#pragma mark - UITextViewDelegate
- (BOOL) textFieldShouldReturn:(UITextField *)theTextField
{
    NSLog(@"textFieldShouldReturn Fired :)");
    [theTextField resignFirstResponder];

    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    [textView resignFirstResponder];
    
    return YES;
}



@end
