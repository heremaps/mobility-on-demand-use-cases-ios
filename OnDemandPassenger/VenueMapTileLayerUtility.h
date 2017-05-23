/*
 * Copyright (c) 2017 HERE Europe B.V.
 * All rights reserved.
 */

#import <NMAKit/NMAKit.h>

@interface VenueMapTileLayerUtility : NSObject

+ (NSString *)quadKeyFromX:(NSUInteger)tileX y:(NSUInteger)tileY zoomLevel:(NSUInteger)zoomLevel;

@end
