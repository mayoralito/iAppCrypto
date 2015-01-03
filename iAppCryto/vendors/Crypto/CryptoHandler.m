//
//  CryptoHandler.m
//  iAppCryto
//
//  Created by amayoral on 1/2/15.
//  Copyright (c) 2015 vRoutes. All rights reserved.
//

#import "CryptoHandler.h"
#import "NSData+Base64.h"

#if DEBUG
#define LOGGING_FACILITY(X, Y)  \
NSAssert(X, Y);

#define LOGGING_FACILITY1(X, Y, Z)      \
NSAssert1(X, Y, Z);
#else
#define LOGGING_FACILITY(X, Y)  \
if(!(X)) {                      \
NSLog(Y);               \
exit(-1);               \
}

#define LOGGING_FACILITY1(X, Y, Z)      \
if(!(X)) {                              \
NSLog(Y, Z);            \
exit(-1);                       \
}
#endif

@implementation CryptoHandler

@synthesize custom_str_iv;

- (NSData *)encrypt:(NSData *)plainText
                key:(NSData *)aSymmetricKey
            padding:(CCOptions *)pkcs7
             initIV:(void *)initIV
{
    return [self doCipher:plainText key:aSymmetricKey context:kCCEncrypt padding:pkcs7 initIV:initIV];
}

- (NSData *)decrypt:(NSData *)plainText
                key:(NSData *)aSymmetricKey
            padding:(CCOptions *)pkcs7
             initIV:(void *)initIV
{
    return [self doCipher:plainText key:aSymmetricKey context:kCCDecrypt padding:pkcs7 initIV:initIV];
}

- (NSData *)doCipher:(NSData *)plainText
                 key:(NSData *)aSymmetricKey
             context:(CCOperation)encryptOrDecrypt
             padding:(CCOptions *)pkcs7
              initIV:(void *)initIV
{
    CCCryptorStatus ccStatus = kCCSuccess;
    // Symmetric crypto reference.
    CCCryptorRef thisEncipher = NULL;
    // Cipher Text container.
    NSData * cipherOrPlainText = nil;
    // Pointer to output buffer.
    uint8_t * bufferPtr = NULL;
    // Total size of the buffer.
    size_t bufferPtrSize = 0;
    // Remaining bytes to be performed on.
    size_t remainingBytes = 0;
    // Number of bytes moved to buffer.
    size_t movedBytes = 0;
    // Length of plainText buffer.
    size_t plainTextBufferSize = 0;
    // Placeholder for total written.
    size_t totalBytesWritten = 0;
    // A friendly helper pointer.
    uint8_t * ptr;
    
    // Initialization vector; dummy in this case 0's.
    //uint8_t iv[kChosenCipherBlockSize];
    //memset((void *) iv, 0x0, (size_t) sizeof(iv));
    if ( initIV != nil ){
        self.custom_str_iv = (__bridge NSString *)(initIV);
    }else{
        self.custom_str_iv = @"1234567890123456";
    }
    
    //const void *vkey = (const void *) [self.custom_str_iv UTF8String];
    const void *vinitVec = (const void *) [self.custom_str_iv UTF8String];
    
    //NSLog(@"doCipher: plaintext: %@", plainText);
    //NSLog(@"doCipher: key length: %d", [aSymmetricKey length]);
    
    //LOGGING_FACILITY(plainText != nil, @"PlainText object cannot be nil." );
    //LOGGING_FACILITY(aSymmetricKey != nil, @"Symmetric key object cannot be nil." );
    //LOGGING_FACILITY(pkcs7 != NULL, @"CCOptions * pkcs7 cannot be NULL." );
    //LOGGING_FACILITY([aSymmetricKey length] == kChosenCipherKeySize, @"Disjoint choices for key size." );
    
    plainTextBufferSize = [plainText length];
    
    //LOGGING_FACILITY(plainTextBufferSize > 0, @"Empty plaintext passed in." );
    
    //NSLog(@"pkcs7: %d", *pkcs7);
    // We don't want to toss padding on if we don't need to
    if(encryptOrDecrypt == kCCEncrypt) {
        if(*pkcs7 != kCCOptionECBMode) {
            if((plainTextBufferSize % kChosenCipherBlockSize) == 0) {
                *pkcs7 = 0x0000;
            } else {
                *pkcs7 = kCCOptionPKCS7Padding;
            }
        }
    } else if(encryptOrDecrypt != kCCDecrypt) {
        NSLog(@"Invalid CCOperation parameter [%d] for cipher context.", *pkcs7 );
    }
    
    // Create and Initialize the crypto reference.
    ccStatus = CCCryptorCreate(encryptOrDecrypt,
                               kCCAlgorithmAES128,
                               *pkcs7,
                               (const void *)[aSymmetricKey bytes],
                               kChosenCipherKeySize,
                               vinitVec, //(const void *)iv,
                               &thisEncipher
                               );
    if(ccStatus != kCCSuccess){
        NSLog(@"Problem creating the context, ccStatus == %d.", ccStatus);
    }
    //LOGGING_FACILITY1( ccStatus == kCCSuccess, @"Problem creating the context, ccStatus == %d.", ccStatus );
    
    // Calculate byte block alignment for all calls through to and including final.
    bufferPtrSize = CCCryptorGetOutputLength(thisEncipher, plainTextBufferSize, true);
    
    // Allocate buffer.
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t) );
    
    // Zero out buffer.
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    // Initialize some necessary book keeping.
    
    ptr = bufferPtr;
    
    // Set up initial size.
    remainingBytes = bufferPtrSize;
    
    // Actually perform the encryption or decryption.
    ccStatus = CCCryptorUpdate(thisEncipher,
                               (const void *) [plainText bytes],
                               plainTextBufferSize,
                               ptr,
                               remainingBytes,
                               &movedBytes
                               );
    
    if(ccStatus != kCCSuccess){
        NSLog(@"Problem with CCCryptorUpdate, ccStatus == %d.", ccStatus);
    }
    //LOGGING_FACILITY1( ccStatus == kCCSuccess, @"Problem with CCCryptorUpdate, ccStatus == %d.", ccStatus );
    
    // Handle book keeping.
    ptr += movedBytes;
    remainingBytes -= movedBytes;
    totalBytesWritten += movedBytes;
    
    /* From CommonCryptor.h:
     
     @enum      CCCryptorStatus
     @abstract  Return values from CommonCryptor operations.
     
     @constant  kCCSuccess          Operation completed normally.
     @constant  kCCParamError       Illegal parameter value.
     @constant  kCCBufferTooSmall   Insufficent buffer provided for specified operation.
     @constant  kCCMemoryFailure    Memory allocation failure.
     @constant  kCCAlignmentError   Input size was not aligned properly.
     @constant  kCCDecodeError      Input data did not decode or decrypt properly.
     @constant  kCCUnimplemented    Function not implemented for the current algorithm.
     
     enum {
     kCCSuccess          = 0,
     kCCParamError       = -4300,
     kCCBufferTooSmall   = -4301,
     kCCMemoryFailure    = -4302,
     kCCAlignmentError   = -4303,
     kCCDecodeError      = -4304,
     kCCUnimplemented    = -4305
     };
     typedef int32_t CCCryptorStatus;
     */
    
    // Finalize everything to the output buffer.
    ccStatus = CCCryptorFinal(thisEncipher,
                              ptr,
                              remainingBytes,
                              &movedBytes
                              );
    
    totalBytesWritten += movedBytes;
    
    if(thisEncipher) {
        (void) CCCryptorRelease(thisEncipher);
        thisEncipher = NULL;
    }
    
    //LOGGING_FACILITY1( ccStatus == kCCSuccess, @"Problem with encipherment ccStatus == %d", ccStatus );
    
    if (ccStatus == kCCSuccess)
        cipherOrPlainText = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)totalBytesWritten];
    else
        cipherOrPlainText = nil;
    
    if(bufferPtr) free(bufferPtr);
    
    return cipherOrPlainText;
    
}

@end

