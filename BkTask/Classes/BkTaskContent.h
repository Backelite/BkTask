//
//  BkTaskContent.h
//  BkCore
//
//  Created by Pierre Monod-Broca on 02/03/12.
//  Copyright (c) 2012 Backelite. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BkTaskContent : NSObject <NSCopying>

- (id) contentValueForKey:(NSString *)key;
- (void) setContentValue:(id)value forKey:(NSString *)key;

@property (nonatomic, copy) NSData *bodyData;
@property (nonatomic, strong) id bodyObject;
@property (nonatomic, strong, readonly) NSError *lastError;
@property (nonatomic, strong) NSArray *errors; // NSError[]
- (void) pushError:(NSError *)anError;

@end

extern NSString * const BkTaskContentBodyData;
extern NSString * const BkTaskContentBodyObject;

