//
//  CryptoManager.m
//  iAppCryto
//
//  Created by amayoral on 1/2/15.
//  Copyright (c) 2015 vRoutes. All rights reserved.
//

#import "CryptoManager.h"
#import "NSData+Base64.h"

// Import base handler to crypto
#import "CryptoHandler.h"

@implementation CryptoManager
{
    CryptoHandler       *__crypto;
}

// This key should be the same on your app and int the end-point.
const unsigned char keyBytes[] = {7, 5, 3, -14, -11, -13, 17, -20, 16, -101, 33, 65, 7, 26, 40, 12};

NSData          *_key = nil;
CCOptions       cKKPadding = 0x0000; //kCCOptionPKCS7Padding;

static id shared = NULL;
+(instancetype)sharedInstance {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        shared = [[self alloc] init];
    });
    
    return shared;
}

-(id)init {
    if(self = [super init]) {
        __crypto = [[CryptoHandler alloc] init];
    }
    
    return self;
}

#pragma mark - Crypto / Decript
- (NSData*)encryptStringToNSData:(NSString*)string
                  withIV:(void *)theIV
{
    // Set padding to text encryption
    string = [self setPaddingToString:string length:16];
    
    // Parse the key unsigned char of bytes into NSData var.
    _key = [self dataForKeyEncryption:keyBytes];
    
    // NSData using UTF-8 Encoding.
    NSData *_secretData = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    // Return Encrypted NSData
    return [__crypto encrypt:_secretData key:_key padding:&cKKPadding initIV:theIV];
}

- (NSString*)decryptNSData:(NSData*)dataToDencrypt
                    initIV:(void*)initIV
{
    // Parse the key unsigned char of bytes into NSData var.
    _key = [self dataForKeyEncryption:keyBytes];
    
    NSData *decryptedData = [__crypto decrypt:dataToDencrypt key:_key padding:&cKKPadding initIV:initIV];
    
    NSString *str = [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
    
    return str;
}

#pragma mark - General Workflow

- (NSString*)setPaddingToString:(NSString *)stringToPadding
                         length:(int)validLength
{
    
    NSUInteger length = [stringToPadding lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    NSUInteger padding = 16-(length%16);
    NSString *finalStr = nil;
    
    finalStr = stringToPadding;
    if ( padding != 16 ){
        finalStr = stringToPadding;
        for(int x=0; x<padding; x++){
            finalStr = [finalStr stringByAppendingString:@" "];
        }
    }
    
    return finalStr;
    
}

- (NSData*)dataForKeyEncryption:(const void*)__key {
    // _key = [NSData dataWithBytes:(const void *)keyBytes length:sizeof(unsigned char)*16];
    NSUInteger lengthOfKey = sizeof(unsigned char)*16;
    return [NSData dataWithBytes:(const void*)__key length:lengthOfKey];
}

- (NSString*)dataToStringWithBase64:(NSData *)dataValue
{
    return [dataValue base64EncodingWithLineLength:0];
}

- (NSString*)stringWithBase64:(NSString*)stringVal
{
    return [[stringVal dataUsingEncoding:NSUTF8StringEncoding] base64EncodedString];
}

- (NSString*)genRandStringLength:(int)len
{
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    }
    
    return randomString;
}

#pragma mark - JSON handler to native object
- (NSDictionary *)parseJSONStringToNativeEquivalent:(NSString *)stringJson
{
    NSError *error;
    NSData *resultData = [stringJson dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableLeaves error:&error ];
    return result;
}

- (NSString *)parseNSDictionary:(NSDictionary *)dictionaryJson
{
    NSData *resultData = [NSJSONSerialization dataWithJSONObject:dictionaryJson options:NSJSONWritingPrettyPrinted error:nil];
    NSString *result = [[NSString alloc] initWithData:resultData encoding:NSASCIIStringEncoding];
    return result;
}

@end
