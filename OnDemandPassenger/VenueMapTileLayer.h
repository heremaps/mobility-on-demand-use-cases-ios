/*
 * Copyright (c) 2017 HERE Europe B.V.
 * All rights reserved.
 */

#import <NMAKit/NMAKit.h>

@interface VenueMapTileLayer : NMAMapTileLayer <NMAMapTileLayerDataSource>

+ (void)addVenueMapTileLayerToMapView:(NMAMapView *)mapView;

@end
