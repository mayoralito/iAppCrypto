//
//  CryptoManager.h
//  iAppCryto
//
//  Created by amayoral on 1/2/15.
//  Copyright (c) 2015 vRoutes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

@interface CryptoManager : NSObject
+(instancetype)sharedInstance;

/** */
- (NSData*)encryptString:(NSString*)string withIV:(void *)theIV;

/** */
- (NSString*)decryptNSData:(NSData*)dataToDencrypt
                  initIV:(void *)initIV;

/** */
- (NSString*)dataToStringWithBase64:(NSData*)dataValue;

/** */
- (NSString*)stringWithBase64:(NSString*)stringVal;

/** */
- (NSString*)genRandStringLength:(int)len;

/** Set padding to string also added blank spaces if padding is not of 16 chars.  */
- (NSString*)setPaddingToString:(NSString *)stringToPadding
                         length:(int)validLength;

/** Parse JSON String from request into a NSDictionary. */
- (NSDictionary *)parseJSONStringToNativeEquivalent:(NSString *)stringJson;

/** Parse NSDictionary as a valid plain text json format NSString. */
- (NSString *)parseNSDictionary:(NSDictionary *)dictionaryJson;

@end
