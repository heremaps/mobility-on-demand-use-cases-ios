/*
 * Copyright (c) 2017 HERE Europe B.V.
 * All rights reserved.
 */

#import "SearchViewController.h"

@interface SearchViewController() <UISearchResultsUpdating, UISearchControllerDelegate>

@property (nonatomic) UISearchController *searchController;
@property (nonatomic) NSArray<NMAPlaceLink *> *results;
@property (nonatomic) NSDate *lastSearchTextUpdate;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Started positioning: %d",[[NMAPositioningManager sharedPositioningManager] startPositioning]);
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.definesPresentationContext = YES;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.searchController.delegate = self;
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    self.lastSearchTextUpdate = [NSDate dateWithTimeIntervalSinceNow:0];
    if (searchController.searchBar.text.length >= 3) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if([self.lastSearchTextUpdate timeIntervalSinceNow] <= -1) {
                [self updateSearchResults:searchController];
            }
        });
    }
}

- (void)updateSearchResults:(UISearchController *)searchController {
    NSString* searchText = searchController.searchBar.text;
    NMADiscoveryRequest* request = [[NMAPlaces sharedPlaces] createSearchRequestWithLocation:self.mapCenter query:searchText];
    [request startWithBlock:^(NMARequest *request, id data, NSError *error) {
        if (error == nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self handleSearchResult:(NMADiscoveryPage *)data];
            });
        } else {
            NSLog(@"Error occurred while searching: %@", error);
        }
    }];
}

- (void)handleSearchResult:(NMADiscoveryPage *)resultPage {
    self.results = [resultPage.discoveryResults filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"class == %@", [NMAPlaceLink class]]];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.results count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchResultCell" forIndexPath:indexPath];
    NMAPlaceLink *place = [self.results objectAtIndex:indexPath.row];

    [cell.textLabel setText:place.name];
    [cell.detailTextLabel setText:place.vicinityDescription];

    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedResult = self.results[indexPath.row];
    [self.searchController.searchBar resignFirstResponder];
    [self.searchController setActive:NO];
}

#pragma mark - UISearchControllerDelegate

- (void)didDismissSearchController:(UISearchController *)searchController {
    [self performSegueWithIdentifier:@"unwindToMap" sender:searchController];
}

@end
