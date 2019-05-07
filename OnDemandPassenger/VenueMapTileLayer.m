/*
 * Copyright (c) 2017 HERE Europe B.V.
 * All rights reserved.
 */

#import "VenueMapTileLayer.h"
#import "VenueMapTileLayerUtility.h"
#import "VenueService.h"

@interface VenueMapTileLayer ()

@property (nonatomic) NSString *signedQueryString;

@end

@implementation VenueMapTileLayer

+ (void)addVenueMapTileLayerToMapView:(NMAMapView *)mapView {
    VenueMapTileLayer *tileLayer = [[VenueMapTileLayer alloc] init];
    // Using the Venue API requires adding a signature to queries
    // For demo purposes, we request the signature whenever we add the Venue
    // tile layer to the map
    // However, the signature has an expiration date, so it's possible to store
    // it and only request a new one when it expires
    [[VenueService sharedVenueService] requestSignature:dispatch_get_main_queue() completionBlock:^(NSString *signedQueryString) {
           tileLayer.signedQueryString = signedQueryString;
           [mapView addMapTileLayer:tileLayer];
    }];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // Set the data source
        self.dataSource = self;

        // Enable caching
        self.cacheTimeToLive = 60 * 60 * 24;    // 24 hours
        self.cacheSizeLimit = 1024 * 1024 * 64; // 64MB
        [self setCacheEnabled:YES withIdentifier:@"VenueMapTileLayer"];
    }
    return self;
}


- (NSString *)mapTileLayer:(NMAMapTileLayer *)mapTileLayer
             urlForTileAtX:(NSUInteger)tileX
                         y:(NSUInteger)tileY
                 zoomLevel:(NSUInteger)zoomLevel {
    // Distribute load between servers 1-4 based on x and y being odd or even
    int server = 1 + (tileX % 2) + 2 * (tileY % 2);
    NSString* url = [NSString stringWithFormat:@"https://static-%d.venue.maps.cit.api.here.com/0/tiles-png/L0/%@.png%@",
                     server,
                     [VenueMapTileLayerUtility quadKeyFromX:tileX y:tileY zoomLevel:zoomLevel],
                     self.signedQueryString];
    return url;
}

@end
