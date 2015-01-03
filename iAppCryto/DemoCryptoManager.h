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

/** This is a test of encryption */
- (void)testOfEncryption;

/** This is a test of decryption */
-(void)testOfDecrypt:(NSString*)messageEncrypted withIV:(NSString *)theIV;

@end
