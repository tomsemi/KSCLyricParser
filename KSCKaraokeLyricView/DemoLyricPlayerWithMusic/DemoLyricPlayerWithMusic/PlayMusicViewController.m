//
//  PlayMusicViewController.m
//  DemoLyricPlayerWithMusic
//
//  Created by Mich on 08/02/2018.
//  Copyright (c) 2018 Mich. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import "PlayMusicViewController.h"
#import "KSCLyricPlayerView.h"
#import "KSCKaraokeLyricView.h"
#import "KSCLyric.h"
#import "Sentence.h"

@interface PlayMusicViewController ()<KSCLyricPlayerViewDataSource, KSCLyricPlayerViewDelegate, AVAudioPlayerDelegate> {
    AVAudioPlayer *audioPlayer;
    NSArray *keysTiming;
    
    NSTimer *playerTimer;
}
@property (weak, nonatomic) IBOutlet UIButton *toogleButton;
@property (weak, nonatomic) IBOutlet KSCLyricPlayerView *lyricPlayer;
@property (weak, nonatomic) IBOutlet UISlider *slider;


@end

@implementation PlayMusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lyricPlayer.dataSource = self;
    self.lyricPlayer.delegate = self;
    
    audioPlayer.delegate = self;
    // sort key from nsdictionary
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (Sentence *sentence in self.lyric.sentences) {
        [tempArray addObject:sentence.startTime];
    }
    
    keysTiming = [NSArray arrayWithArray:tempArray];
    
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:self.songURL error:nil];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [audioPlayer prepareToPlay];
    [self.lyricPlayer prepareToPlay];
    
    [self setTitle:self.lyric.title];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self stopAll];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)timerStick:(NSTimer *)timer {
    if ([audioPlayer isPlaying]) {
        CGFloat value = audioPlayer.currentTime / audioPlayer.duration;
        [self.slider setValue:value];
    }
}

- (void)starTimer {
    playerTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerStick:) userInfo:nil repeats:YES];
}

- (void)stopAll {
    [playerTimer invalidate];
    [audioPlayer stop];
    [self.lyricPlayer stop];
}

#pragma mark - LyricPlayer Data Source
- (NSArray *)timesForLyricPlayerView:(KSCLyricPlayerView *)lpv {
    return keysTiming;
}

- (KSCKaraokeLyricView *)lyricPlayerView:(KSCLyricPlayerView *)lpv lyricAtIndex:(NSInteger)index {
    KSCKaraokeLyricView *lyricView = [lpv reuseLyricView];
    // Config lyric view
    lyricView.textColor = [UIColor whiteColor];
    [lyricView setFillTextColor:[UIColor blueColor]];
    lyricView.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0];
    
    Sentence *sentence = [self.lyric.sentences objectAtIndex:index];
    lyricView.text = sentence.content;
    
    NSArray * keyTimes = sentence.keyTimes;
    NSArray * words = sentence.words;
    
    if (keyTimes.count == words.count) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        int index = 0;
        for (NSNumber *keyTime in keyTimes) {
            [dic setObject:words[index] forKey:keyTime];
            index++;
        }
        lyricView.lyricSegment = dic;
    }
    
    lyricView.duration = sentence.duration;
    
    return lyricView;
}

- (BOOL)lyricPlayerView:(KSCLyricPlayerView *)lpv allowLyricAnimationAtIndex:(NSInteger)index {
    // Allow all
    return YES;
}

#pragma mark - LyricPlayer Delegate
- (void)lyricPlayerViewDidStarted:(KSCLyricPlayerView *)lpv {
    [self.toogleButton setTitle:@"Pause" forState:UIControlStateNormal];
    self.toogleButton.tag = 1;
}

- (void)lyricPlayerViewDidStoped:(KSCLyricPlayerView *)lpv {
    //[playerTimer invalidate];
}

#pragma mark - Audio Player delegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [self stopAll];
}

#pragma mark - IBActions

- (IBAction)toogleTouched:(UIButton *)sender {
    if (self.toogleButton.tag == 0) {
        [audioPlayer play];
        [self.lyricPlayer start];
        
        [self starTimer];
        
    } else {
        if(![self.lyricPlayer isPlaying]) {
            [self.lyricPlayer resume];
            [audioPlayer play];
            
            [self starTimer];
            [self.toogleButton setTitle:@"Pause" forState:UIControlStateNormal];
        } else {
            [self.lyricPlayer pause];
            [audioPlayer pause];
            [playerTimer invalidate];
            [self.toogleButton setTitle:@"Resume" forState:UIControlStateNormal];
        }
    }
    
}

- (IBAction)sliderChanged:(UISlider *)sender {
    NSTimeInterval songDuration = [audioPlayer duration];
    NSTimeInterval currentTime = sender.value * songDuration;
    
    audioPlayer.currentTime = currentTime;
    [self.lyricPlayer setCurrentTime:currentTime];
}

@end
