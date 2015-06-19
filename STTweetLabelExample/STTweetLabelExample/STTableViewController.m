//
//  STTableViewController.m
//  STTweetLabelExample
//
//  Created by Stanislav Derpoliuk on 6/19/15.
//  Copyright (c) 2015 Sebastien Thiebaud. All rights reserved.
//

#import "STTableViewController.h"
#import "STTweetLabel.h"

@interface Cell : UITableViewCell

@property (weak, nonatomic) IBOutlet STTweetLabel *tweetLabel;

@end

@implementation Cell

@end

@interface STTableViewController ()

@property (nonatomic) NSArray *dataSource;

@end

@implementation STTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *array = [NSMutableArray new];
    for (int i = 0; i < 500; i++) {
        [array addObject:[self randomLoremIpsum]];
    }
    self.dataSource = [array copy];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 80;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.tweetLabel.text = self.dataSource[indexPath.row];
    const double tweetLabelLeftIndent = 58.0;
    cell.tweetLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.tableView.frame) - tweetLabelLeftIndent;
    return cell;
}

#pragma mark - Custom Methods

// Taken from https://github.com/smileyborg/TableViewCellWithAutoLayoutiOS8
- (NSString *)randomLoremIpsum
{
    NSString *loremIpsum = @"@Lorem https://t.co/pQXDoiYA #ipsum #dolor sit amet, consectetur adipiscing elit. Praesent non quam ac massa viverra semper. Maecenas mattis justo ac augue volutpat congue. Maecenas laoreet, nulla eu faucibus gravida, felis orci dictum risus, sed sodales sem eros eget risus. Morbi imperdiet sed diam et sodales. Vestibulum ut est id mauris ultrices gravida. Nulla malesuada metus ut erat malesuada, vitae ornare neque semper. Aenean a commodo justo, vel placerat odio. Curabitur vitae consequat tortor. Aenean eu magna ante. Integer tristique elit ac augue laoreet, eget pulvinar lacus dictum. Cras eleifend lacus eget pharetra elementum. Etiam fermentum eu felis eu tristique. Integer eu purus vitae turpis blandit consectetur. Nulla facilisi. Praesent bibendum massa eu metus pulvinar, quis tristique nunc commodo. Ut varius aliquam elit, a tincidunt elit aliquam non. Nunc ac leo purus. Proin condimentum placerat ligula, at tristique neque scelerisque ut. Suspendisse ut congue enim. Integer id sem nisl. Nam dignissim, lectus et dictum sollicitudin, libero augue ullamcorper justo, nec consectetur dolor arcu sed justo. Proin rutrum pharetra lectus, vel gravida ante venenatis sed. Mauris lacinia urna vehicula felis aliquet venenatis. Suspendisse non pretium sapien. Proin id dolor ultricies, dictum augue non, euismod ante. Vivamus et luctus augue, a luctus mi. Maecenas sit amet felis in magna vestibulum viverra vel ut est. Suspendisse potenti. Morbi nec odio pretium lacus laoreet volutpat sit amet at ipsum. Etiam pretium purus vitae tortor auctor, quis cursus metus vehicula. Integer ultricies facilisis arcu, non congue orci pharetra quis. Vivamus pulvinar ligula neque, et vehicula ipsum euismod quis.";
    
    // Split lorum ipsum words into an array
    //
    NSArray *lorumIpsumArray = [loremIpsum componentsSeparatedByString:@" "];
    
    // Randomly choose words for variable length
    //
    int r = arc4random() % [lorumIpsumArray count];
    r = MAX(3, r); // no less than 3 words
    NSArray *lorumIpsumRandom = [lorumIpsumArray objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, r)]];
    
    // Array to string. Adding '!!!' to end of string to ensure all text is visible.
    //
    return [NSString stringWithFormat:@"%@!!!", [lorumIpsumRandom componentsJoinedByString:@" "]];
}

@end
