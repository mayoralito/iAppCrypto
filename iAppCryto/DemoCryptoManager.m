//
//  DemoCryptoManager.m
//  iAppCryto
//
//  Created by amayoral on 1/2/15.
//  Copyright (c) 2015 vRoutes. All rights reserved.
//

#import "DemoCryptoManager.h"
#import "NSData+Base64.h"

@implementation DemoCryptoManager

static id shared = NULL;
+(instancetype)sharedInstance{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (NSString *)encryptText:(NSString *)plainText withIV:(NSString *)IV {
    
    // 1.- Encrypt the message
    NSData *dataEncrypted = [self encryptStringToNSData:plainText withIV:(__bridge void *)(IV)];
    
    // 2.- Add base64 to the message
    NSString *messageEncryptedToSend = [self dataToStringWithBase64:dataEncrypted];

    return messageEncryptedToSend;
    
}

- (NSString *)decryptText:(NSData *)encryptedData withIV:(NSString *)IV {
    return [self decryptNSData:encryptedData initIV:(__bridge void *)IV];
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
    NSData *dataEncrypted = [self encryptStringToNSData:plainText withIV:(__bridge void *)(theIV)];
    
    // 2.- Add base64 to the message
    NSString *messageEncryptedToSend = [self dataToStringWithBase64:dataEncrypted];
    
    // 3.- Add base64 to the server or end-point.
//    NSString *IVBase64 = [self stringWithBase64:theIV];
    
    NSLog(@"Plain Message:      %@", plainText);
//    NSLog(@"theIV: %@", theIV);
//    NSLog(@"dataEncrypted: %@", dataEncrypted);
//    NSLog(@"theIVBase64: %@", IVBase64);
//    NSLog(@"messageEncryptedToSend: %@", messageEncryptedToSend);
    
    // This going to be the request that you send to the server
    // message: messageEncryptedToSend
    // iv: IVBase64 this going to be the public-key to decrypt message (messageEncryptedToSend)
    
    // Decode base64 (which should be returned from end-point
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:messageEncryptedToSend options:0];
    
    // If request come from internet, first decode base64
    //[self testOfDecrypt:dataEncrypted withIV:theIV];
    
    [self testOfDecrypt:decodedData withIV:theIV];
    
}

-(void)testOfDecrypt:(NSData*)encryptedData withIV:(NSString *)theIV {
    
    NSString *decrypted = [self decryptNSData:encryptedData initIV:(__bridge void *)theIV];
    
    NSLog(@"Secret Message:     %@", encryptedData);
    NSLog(@"UnSecret Message:   %@", decrypted);
    
}


@end
