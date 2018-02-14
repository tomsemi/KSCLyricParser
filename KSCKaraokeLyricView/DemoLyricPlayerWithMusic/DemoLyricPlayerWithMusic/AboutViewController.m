//
//  ViewController.m
//  DemoLyricPlayerWithMusic
//
//  Created by Mich on 08/02/2018.
//  Copyright (c) 2018 Mich. All rights reserved.
//

#import "AboutViewController.h"
#import "KSCLyricPlayerView.h"
#import "KSCKaraokeLyricView.h"

@interface AboutViewController ()<KSCLyricPlayerViewDataSource>
{
    NSDictionary *contents;
    NSArray *keysTiming;
}
@property (weak, nonatomic) IBOutlet KSCLyricPlayerView *lyricPlayerView;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lyricPlayerView.dataSource = self;
    
    contents = @{
                 @"0.0" : @"Hello everybody",
                 @"1.0" : @"I am Mich",
                 @"2.5" : @"",
                 @"4.5": @"Just use my engine for free",
                 @"7.0": @"Contact me for any question",
                 @"11.5": @"",
                 @"13.0": @"dianhong.ge@gmail.com",
                 @"15.0": @""
                 };
    
    // sort key from nsdictionary
    NSArray* keys = [contents allKeys];
    keysTiming = [keys sortedArrayUsingComparator:^(id a, id b) {
        return [a compare:b options:NSNumericSearch];
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.lyricPlayerView prepareToPlay];
    [self.lyricPlayerView start];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Implement data source
- (NSArray* )timesForLyricPlayerView:(KSCLyricPlayerView *)lpv {
    
    return keysTiming;
}

- (KSCKaraokeLyricView *)lyricPlayerView:(KSCLyricPlayerView *)lpv lyricAtIndex:(NSInteger)index {
    
    KSCKaraokeLyricView *lyricView = [lpv reuseLyricView];
    // Config lyric view
    lyricView.textColor = [UIColor whiteColor];
    [lyricView setFillTextColor:[UIColor redColor]];
    lyricView.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17.0];
    
    NSString *key = [keysTiming objectAtIndex:index];
    lyricView.text = [contents objectForKey:key];
    
    return lyricView;
}

- (BOOL)lyricPlayerView:(KSCLyricPlayerView *)lpv allowLyricAnimationAtIndex:(NSInteger)index {
    return YES;
}


@end
