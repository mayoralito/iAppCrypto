//
//  DemoCryptoManager.h
//  iAppCryto
//
//  Created by amayoral on 1/2/15.
//  Copyright (c) 2015 vRoutes. All rights reserved.
//

#import "CryptoManager.h"

@interface DemoCryptoManager : CryptoManager
+(instancetype)sharedInstance;

/** Encryption of NSString */
- (NSString *)encryptText:(NSString *)plainText withIV:(NSString *)IV;

/** Decrypt NSData using IV */
- (NSString *)decryptText:(NSData *)encryptedData withIV:(NSString *)IV;

/** This is a test of encryption */
- (void)testOfEncryption;

/** This is a test of decryption */
-(void)testOfDecrypt:(NSData*)messageEncrypted withIV:(NSString *)theIV;

@end
