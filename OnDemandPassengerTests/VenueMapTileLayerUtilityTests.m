/*
 * Copyright (c) 2017 HERE Europe B.V.
 * All rights reserved.
 */

#import <Quick/Quick.h>
#import <Expecta/Expecta.h>
#import "VenueMapTileLayerUtility.h"

QuickSpecBegin(VenueMapTileLayerUtilityTests)

describe(@"VenueMapTileLayerUtilityTests", ^{
    context(@"quadKeyFrom", ^{
        it(@"should correctly calculate the quadkey for the all zero case", ^{
            NSString* finalString = @"00000";
            NSString* testString = [VenueMapTileLayerUtility quadKeyFromX:0 y:0 zoomLevel:5];
            expect(testString).to.equal(finalString);
        });
        
        it(@"should correctly calculate the quadkey for a normal case", ^{
            NSString* finalString = @"10102323";
            NSString* testString = [VenueMapTileLayerUtility quadKeyFromX:0b10100101 y:0b00001111 zoomLevel:8];
            expect(testString).to.equal(finalString);
        });
    });
});

QuickSpecEnd
