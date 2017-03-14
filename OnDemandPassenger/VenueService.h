/*
 * Copyright (c) 2017 HERE Europe B.V.
 * All rights reserved.
 */

#import <Foundation/Foundation.h>

@interface VenueService : NSObject

+ (VenueService *)sharedVenueService;
- (void)requestSignature:(dispatch_queue_t)completionQueue completionBlock:(void (^)(NSString *signedQueryString))completionBlock;

@end
