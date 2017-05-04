/*
 * Copyright (c) 2017 HERE Europe B.V.
 * All rights reserved.
 */

#import <Quick/Quick.h>
#import <OCMock/OCMock.h>
#import <NMAKit/NMAKit.h>
#import "ViewController.h"

@interface ViewController (Tests)

@property (nonatomic) NMAPlaceLink *fromPlaceLink;
@property (nonatomic) NMAPlaceLink *toPlaceLink;
- (IBAction)openHereApp:(id)sender;

@end

QuickSpecBegin(ViewControllerTests)

describe(@"ViewController", ^{
    __block ViewController *viewController;
    beforeEach(^{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        viewController = [storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    });
    context(@"-openHereApp", ^{
        it(@"should open url", ^{
            id mockApplication = OCMClassMock([UIApplication class]);
            OCMStub([mockApplication sharedApplication]).andReturn(mockApplication);
            OCMStub([mockApplication canOpenURL:OCMOCK_ANY]).andReturn(YES);
            NMAPlaceLink *fromPlaceLink = [[NMAPlaceLink alloc] init];
            OCMStub(fromPlaceLink.position).andReturn([[NMAGeoCoordinates alloc] initWithLatitude:10.0 longitude:11.0]);
            viewController.fromPlaceLink = fromPlaceLink;
            NMAPlaceLink *toPlaceLink = [[NMAPlaceLink alloc] init];
            OCMStub(toPlaceLink.position).andReturn([[NMAGeoCoordinates alloc] initWithLatitude:12.0 longitude:13.0]);
            viewController.toPlaceLink = toPlaceLink;
            [viewController openHereApp:nil];
            OCMVerify([mockApplication openURL:OCMOCK_ANY options:OCMOCK_ANY completionHandler:nil]);
        });
    });
});

QuickSpecEnd
