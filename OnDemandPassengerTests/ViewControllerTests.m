/*
 * Copyright (c) 2017 HERE Europe B.V.
 * All rights reserved.
 */

#import <Quick/Quick.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <NMAKit/NMAKit.h>
#import "ViewController.h"
#import "SearchViewController.h"

@interface ViewController (Tests)

@property (nonatomic) NMAPlaceLink *fromPlaceLink;
@property (nonatomic) NMAPlaceLink *toPlaceLink;
@property (weak, nonatomic) UIView *segueSender;
@property (weak, nonatomic) IBOutlet UIButton *fromButton;
@property (weak, nonatomic) IBOutlet UIButton *toButton;
@property (weak, nonatomic) IBOutlet UIButton *launchDirectionsButton;

- (IBAction)openHereApp:(id)sender;
- (IBAction)prepareForUnwind:(UIStoryboardSegue *)segue;

@end

QuickSpecBegin(ViewControllerTests)

describe(@"ViewController", ^{
    __block ViewController *viewController;
    __block UIStoryboard *storyboard;
    beforeEach(^{
        storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        viewController = [storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
        [viewController view];
    });
    context(@"-openHereApp", ^{
        it(@"should open url", ^{
            id mockApplication = OCMClassMock([UIApplication class]);
            OCMStub([mockApplication sharedApplication]).andReturn(mockApplication);
            OCMStub([mockApplication canOpenURL:OCMOCK_ANY]).andReturn(YES);
            NMAPlaceLink *fromPlaceLink = OCMClassMock([NMAPlaceLink class]);
            OCMStub(fromPlaceLink.position).andReturn([[NMAGeoCoordinates alloc] initWithLatitude:10.0 longitude:11.0]);
            viewController.fromPlaceLink = fromPlaceLink;
            NMAPlaceLink *toPlaceLink = OCMClassMock([NMAPlaceLink class]);
            OCMStub(toPlaceLink.position).andReturn([[NMAGeoCoordinates alloc] initWithLatitude:12.0 longitude:13.0]);
            viewController.toPlaceLink = toPlaceLink;
            [viewController openHereApp:nil];
            OCMVerify([mockApplication openURL:OCMOCK_ANY options:OCMOCK_ANY completionHandler:nil]);
        });
    });
    context(@"-launch direction button", ^{
        __block UIStoryboardSegue *segue;
        beforeEach(^{
            SearchViewController *searchViewController = [storyboard instantiateViewControllerWithIdentifier:@"SearchViewController"];
            NMAPlaceLink *place = OCMClassMock([NMAPlaceLink class]);
            OCMStub([place name]).andReturn(@"name");
            searchViewController.selectedResult = place;
            segue = [UIStoryboardSegue segueWithIdentifier:@"unwindToMap" source:searchViewController destination:viewController performHandler:^{}];
        });
        it(@"should be disabled by default", ^{
            expect(viewController.launchDirectionsButton.enabled).to.beFalsy();
        });
        it(@"should be disabled when only 'from' is selected", ^{
            viewController.segueSender = viewController.fromButton;
            [viewController prepareForUnwind:segue];
            expect(viewController.launchDirectionsButton.enabled).to.beFalsy();
        });
        it(@"should be disabled when only 'to' is selected", ^{
            viewController.segueSender = viewController.toButton;
            [viewController prepareForUnwind:segue];
            expect(viewController.launchDirectionsButton.enabled).to.beFalsy();
        });
        it(@"should be enabled when 'from' and 'to' are selected", ^{
            viewController.segueSender = viewController.fromButton;
            [viewController prepareForUnwind:segue];
            viewController.segueSender = viewController.toButton;
            [viewController prepareForUnwind:segue];
            expect(viewController.launchDirectionsButton.enabled).to.beTruthy();
        });
    });
});

QuickSpecEnd
