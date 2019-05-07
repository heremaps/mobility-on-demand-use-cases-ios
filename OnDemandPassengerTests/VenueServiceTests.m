/*
 * Copyright (c) 2017 HERE Europe B.V.
 * All rights reserved.
 */

#import <Quick/Quick.h>
#import <Expecta/Expecta.h>
#import <OHHTTPStubs/OHHTTPStubs.h>
#import "OHHTTPStubsResponse+JSON.h"
#import "VenueService.h"

QuickSpecBegin(VenueServiceTests)

describe(@"VenueServiceTests", ^{
    context(@"requestSignature", ^{
        __block VenueService *service;
        beforeEach(^{
            service = [VenueService new];
            [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                return [request.URL.host isEqualToString:@"signature.venue.maps.cit.api.here.com"];
            } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
                NSDictionary* obj = @{ @"SignedQueryString": @"test" };
                return [OHHTTPStubsResponse responseWithJSONObject:obj statusCode:200 headers:@{@"Content-Type":@"application/json"}];
            }];
        });

        it(@"should request the signature", ^{
            
            XCTestExpectation* expect = [self expectationWithDescription:@"VenueService will receive a signature and store it once"];
             
            __block NSString* signature = nil;
            [service requestSignature:dispatch_get_main_queue() completionBlock:^(NSString *signedQueryString) {
                signature = signedQueryString;
                [expect fulfill];
            }];
            
            [self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {
                expect(signature).to.notTo.beNull();
            }];
            
        });
        
        afterEach(^{
            [OHHTTPStubs removeAllStubs];
        });
    });
});

QuickSpecEnd
