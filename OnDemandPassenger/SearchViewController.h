/*
 * Copyright (c) 2017 HERE Europe B.V.
 * All rights reserved.
 */

#import "NMAKit/NMAKit.h"
#import <UIKit/UIKit.h>

@interface SearchViewController : UITableViewController

@property (nonatomic) NMAPlaceLink *selectedResult;
@property (nonatomic) NMAGeoCoordinates *mapCenter;

@end
