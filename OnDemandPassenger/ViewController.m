/*
 * Copyright (c) 2017 HERE Europe B.V.
 * All rights reserved.
 */

#import "ViewController.h"
#import <NMAKit/NMAKit.h>
#import "VenueMapTileLayer.h"
#import "SearchViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet NMAMapView *mapView;
@property (weak, nonatomic) UIView *segueSender;
@property (weak, nonatomic) IBOutlet UIButton *fromButton;
@property (weak, nonatomic) IBOutlet UIButton *toButton;
@property (weak, nonatomic) IBOutlet UIButton *launchDirectionsButton;

@property (nonatomic) NMAPlaceLink *fromPlaceLink;
@property (nonatomic) NMAPlaceLink *toPlaceLink;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateLaunchDirectionsButton)
                                                 name:NMAPositioningManagerDidUpdatePositionNotification
                                               object:[NMAPositioningManager sharedPositioningManager]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateLaunchDirectionsButton)
                                                 name:NMAPositioningManagerDidLosePositionNotification
                                               object:[NMAPositioningManager sharedPositioningManager]];
    NSLog(@"Started positioning: %d",[[NMAPositioningManager sharedPositioningManager] startPositioning]);
    [NMAMapView class];

    // Set geo center
    NMAGeoCoordinates *geoCoordCenter =
    [[NMAGeoCoordinates alloc] initWithLatitude:37.784681 longitude:-122.406667];
    [self.mapView setGeoCenter:geoCoordCenter withAnimation:NMAMapAnimationNone];
    self.mapView.copyrightLogoPosition = NMALayoutPositionBottomCenter;
    [self.mapView.positionIndicator setVisible:YES];

    // Set zoom level
    self.mapView.zoomLevel = 17;

    // Add venue maps tile layer
    [VenueMapTileLayer addVenueMapTileLayerToMapView:self.mapView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
    SearchViewController *sourceVC = segue.sourceViewController;
    NSString *title = sourceVC.selectedResult.name;
    if (title) {
        if (self.segueSender == self.fromButton) {
            [self.fromButton setTitle:[NSString stringWithFormat:@"From: %@", title] forState:UIControlStateNormal];
            self.fromPlaceLink = sourceVC.selectedResult;
        } else if (self.segueSender == self.toButton) {
            [self.toButton setTitle:[NSString stringWithFormat:@"To: %@", title] forState:UIControlStateNormal];
            self.toPlaceLink = sourceVC.selectedResult;
        }
        [self updateLaunchDirectionsButton];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    self.segueSender = sender;
    UIViewController* destination = segue.destinationViewController;
    if ([destination isKindOfClass:[SearchViewController class]]) {
        SearchViewController* svc = (SearchViewController *) destination;
        svc.mapCenter = _mapView.geoCenter;
    }
}

- (void)updateLaunchDirectionsButton {
    self.launchDirectionsButton.enabled = self.fromPlaceLink && self.toPlaceLink;
}

- (IBAction)openHereApp:(id)sender {
    NSString *fromLocation = self.fromPlaceLink.uniqueId;
    NSString *toLocation = self.toPlaceLink.uniqueId;
    // Build url to use HERE App for route calculation and navigation
    // Parameter m=w stands for mode = walk (in a Driver app, we would use be
    // m=d, short for mode = drive)
    NSString *urlString = [NSString
        stringWithFormat:@"https://share.here.com/r/%@/%@?m=w", fromLocation, toLocation];
    NSURL *myURL = [NSURL URLWithString:urlString];

    [[UIApplication sharedApplication] openURL:myURL];
}

@end
