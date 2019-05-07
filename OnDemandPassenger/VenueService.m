/*
 * Copyright (c) 2017 HERE Europe B.V.
 * All rights reserved.
 */

#import "VenueService.h"
#import "Constants.h"

@implementation VenueService {
    dispatch_semaphore_t _semaphore;
    dispatch_queue_t _queue;
}

static NSString* signedQueryString;

+ (VenueService *)sharedVenueService {
    static VenueService *_sharedVenueService = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
      _sharedVenueService = [[VenueService alloc] init];
    });
    return _sharedVenueService;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _semaphore = dispatch_semaphore_create(1);
        _queue = dispatch_queue_create("com.here.OnDemandPassenger.VenueApiSignatureQueue", NULL);
    }
    return self;
}

- (void)requestSignature:(dispatch_queue_t)completionQueue completionBlock:(void (^)(NSString *signedQueryString))completionBlock {
    dispatch_async(_queue, ^{
        // Only need to request signature once, then we store it locally, so using a semaphore here to wait for the single signature request to return.
        dispatch_semaphore_wait(self->_semaphore, DISPATCH_TIME_FOREVER);
        if (signedQueryString) {
            dispatch_semaphore_signal(self->_semaphore);
            dispatch_async(completionQueue, ^{
                completionBlock(signedQueryString);
            });
        } else {
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://signature.venue.maps.cit.api.here.com/venues/signature/v1?app_id=%@&app_code=%@", APP_ID, APP_CODE]]];
            [request setHTTPMethod:@"GET"];

            NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
            [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                NSString *jsonString = json[@"SignedQueryString"];
                if (jsonString && ![[NSNull null] isEqual:jsonString]) {
                    signedQueryString = jsonString;
                }
                // Signature has been stored, we can release the semaphore because any waiting threads will be able to just reuse this signature and won't perform a new request
                dispatch_semaphore_signal(self->_semaphore);
                dispatch_async(completionQueue, ^{
                    completionBlock(signedQueryString);
                });
            }] resume];
        }
    });
}

@end
