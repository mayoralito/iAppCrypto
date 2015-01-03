//
//  DemoCryptoManager.m
//  iAppCryto
//
//  Created by amayoral on 1/2/15.
//  Copyright (c) 2015 vRoutes. All rights reserved.
//

#import "DemoCryptoManager.h"

@implementation DemoCryptoManager

static id shared = NULL;
+(instancetype)sharedInstance{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        shared = [[self alloc] init];
    });
    return shared;
}


-(void)testOfEncryption {
    
    // Get string of message to encrypt
    NSString *plainText = [self parseNSDictionary:@{
                                                    @"my value":@"id1",
                                                    @"my value 2": @"id2",
                                                    }];
    
    plainText = @"Hola este es mi mensaje super secreto!";
    
    // Set random value for this message.
    NSString *theIV = [self genRandStringLength:16];
    
    // 1.- Encrypt the message
    NSData *dataEncrypted = [self encryptString:plainText withIV:(__bridge void *)(theIV)];
    
    // 2.- Add base64 to the message
    NSString *messageEncryptedToSend = [self dataToStringWithBase64:dataEncrypted];
    
    // 3.- Add base64 to the server or end-point.
    NSString *IVBase64 = [self stringWithBase64:theIV];
    
    NSLog(@"plainText: %@", plainText);
    NSLog(@"theIV: %@", theIV);
    NSLog(@"dataEncrypted: %@", dataEncrypted);
    NSLog(@"theIVBase64: %@", IVBase64);
    NSLog(@"messageEncryptedToSend: %@", messageEncryptedToSend);
    
    [self testOfDecrypt:messageEncryptedToSend withIV:theIV];
    
    // This going to be the request that you send to the server
    // message: messageEncryptedToSend
    // iv: IVBase64 this going to be the public-key to decrypt message (messageEncryptedToSend)
    
}

-(void)testOfDecrypt:(NSString*)messageEncrypted withIV:(NSString *)theIV {
    NSLog(@"Try to resolve this message: %@", messageEncrypted);
    
    // Get string and remove base64
    // NSData using UTF-8 Encoding.
    NSData *_secretData = [messageEncrypted dataUsingEncoding:NSUTF8StringEncoding];
    
    
    NSString *decrypted = [self decryptNSData:_secretData initIV:(__bridge void *)theIV];
    
    NSLog(@"This will be the value decrypted!: %@", decrypted);
}

@end
