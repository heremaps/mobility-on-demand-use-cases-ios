/*
 * Copyright (c) 2017 HERE Europe B.V.
 * All rights reserved.
 */

#import "VenueMapTileLayerUtility.h"


@implementation VenueMapTileLayerUtility

/**
 * This operation transforms a set of tile x and y coordinates and a zoomlevel into a quadkey for use with the Venue Tile API
 */
+ (NSString *)quadKeyFromX:(NSUInteger)tileX
                         y:(NSUInteger)tileY
                 zoomLevel:(NSUInteger)zoomLevel {
  NSMutableString *quadKey = [NSMutableString string];
  for (NSInteger i = zoomLevel; i > 0; i--) {
    int digit = 0;
    NSUInteger mask = 1 << (i - 1);
    NSUInteger maskedX = tileX & mask;
    if (maskedX != 0) {
      digit++;
    }
    NSUInteger maskedY = tileY & mask;
    if (maskedY != 0) {
      digit++;
      digit++;
    }
    [quadKey appendFormat:@"%d", digit];
  }
  return quadKey;
}



@end
