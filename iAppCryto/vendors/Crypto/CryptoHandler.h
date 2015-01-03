//
//  CryptoHandler.h
//  iAppCryto
//
//  Created by amayoral on 1/2/15.
//  Copyright (c) 2015 vRoutes. All rights reserved.
//

// All rights reserved for || Created by DAVID VEKSLER on 2/4/09.

#import <Foundation/Foundation.h>

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>


#define kChosenCipherBlockSize  kCCBlockSizeAES128
#define kChosenCipherKeySize    kCCKeySizeAES128
#define kChosenDigestLength     CC_SHA1_DIGEST_LENGTH

@interface CryptoHandler : NSObject
{
    NSString *custom_str_iv;
}

@property (nonatomic, retain) NSString *custom_str_iv;

- (NSData *)encrypt:(NSData *)plainText
                key:(NSData *)aSymmetricKey
            padding:(CCOptions *)pkcs7
             initIV:(void *)initIV;

- (NSData *)decrypt:(NSData *)plainText
                key:(NSData *)aSymmetricKey
            padding:(CCOptions *)pkcs7
             initIV:(void *)initIV;

- (NSData *)doCipher:(NSData *)plainText
                 key:(NSData *)aSymmetricKey
             context:(CCOperation)encryptOrDecrypt
             padding:(CCOptions *)pkcs7
              initIV:(void *)initIV;

@end

