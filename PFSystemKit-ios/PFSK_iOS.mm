//
//  PFSK_iOS.m
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 19/04/15.
//  Copyright (c) 2015 Perceval FARAMAZ. All rights reserved.
//

#import "PFSK_iOS.h"
#import <sys/sysctl.h>
#import <CoreFoundation/CoreFoundation.h>
#import <string>
#import <vector>
#import "PFSKHelper.h"
#import "PFSystemKitPlatformReport.h"

@implementation PFSystemKit
#pragma mark - Singleton pattern
/**
 * PFSystemKit singleton instance retrieval method with error handling
 */
+(instancetype) investigateWithError:(NSError Ind2_NUAR)error {
    static PFSystemKit* sharedInstance;
    static dispatch_once_t onceToken;
    //BOOL __block succ;
    //NSError* __block err;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        [sharedInstance updatePlatformReport:error];
    });
    return sharedInstance;
}

/**
 * PFSystemKit singleton instance retrieval method
 */
+(instancetype) investigate {
    static PFSystemKit* sharedInstance;
    static dispatch_once_t onceToken;
    //BOOL __block succ;
    //NSError* __block err;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        [sharedInstance updatePlatformReport:nil]; // Purposefully not giving a damn about whether it succeeded : if the user wants so, he/she uses +investigateWithError
    });
    return sharedInstance;
}

-(BOOL) updatePlatformReport:(NSError Ind2_NUAR)locError {
    PFSystemKitDeviceFamily fam;
    PFSystemKitDeviceVersion ver;
    PFSystemKitEndianness end;
    NSString* mod;
    NSNumber* memSize;
    BOOL isjb;
    BOOL state = true;
    BOOL res = [self.class deviceFamily:&fam error:locError];
    if (!res)
        state = false;
    res = [self.class deviceVersion:&ver error:locError];
    if (!res)
        state = false;
    res = [self.class deviceEndianness:&end error:locError];
    if (!res)
        state = false;
    res = [self.class deviceModel:&mod error:locError];
    if (!res)
        state = false;
    res = [PFSystemKitRAMReport size:&memSize error:locError];
    if (!res)
        state = false;
    res = [self.class isJailbroken:&isjb error:locError];
    if (!res)
        state = false;
    
    platformReport = [PFSystemKitPlatformReport.alloc initWithFamily:fam version:ver endianness:end model:mod memorySize:memSize isJailbroken:isjb];
    return state;
}

-(BOOL) ramReport:(NSError Ind2_NUAR)err {
    if (ramReport == nil) {
        ramReport = [PFSystemKitRAMReport.alloc initWithError:err];
        if (err)
            return false;
        else
            return true;
    } else
        return true;
}

-(PFSystemKitRAMReport*) ramReport {
    if (ramReport == nil) {
        ramReport = [PFSystemKitRAMReport.alloc initWithError:nil];
        return ramReport;
    } else
        return ramReport;
}

-(BOOL) cpuReport:(NSError Ind2_NUAR)err {
    if (cpuReport == nil) {
        cpuReport = [PFSystemKitCPUReport.alloc initWithError:err];
        if (err)
            return false;
        else
            return true;
    } else
        return true;
}

-(PFSystemKitCPUReport*) cpuReport {
    if (cpuReport == nil) {
        cpuReport = [PFSystemKitCPUReport.alloc initWithError:nil];
        return cpuReport;
    } else
        return cpuReport;
}

-(BOOL) platformReport:(NSError Ind2_NUAR)err {
    if (platformReport == nil) {
        platformReport = [PFSystemKitPlatformReport.alloc initWithError:err];
        if (err)
            return false;
        else
            return true;
    } else
        return true;
}

-(PFSystemKitPlatformReport*) platformReport {
    if (platformReport == nil) {
        platformReport = [PFSystemKitPlatformReport.alloc initWithError:nil];
        return platformReport;
    } else
        return platformReport;
}

#pragma mark - Getters
@synthesize cpuReport;
@synthesize platformReport;

#pragma mark - NSObject std methods
-(void) finalize { //cleanup everything
    [super finalize];
    return;
}

-(instancetype) init {
    if (!(self = [super init])) {
        return nil;
    }
    _error = PFSKReturnUnknown;
    _extError = 0;
    return self;
}
@end
