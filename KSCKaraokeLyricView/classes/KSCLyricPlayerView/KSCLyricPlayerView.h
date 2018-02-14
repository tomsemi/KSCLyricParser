//
//  KSCLyricPlayerView.h
//  
//
//  Created by Mich on 08/02/2018.
//
//

#import <UIKit/UIKit.h>

@class KSCKaraokeLyricView;
@protocol KSCLyricPlayerViewDataSource;
@protocol KSCLyricPlayerViewDelegate;

static CGFloat kKSCLyricPlayerPadding = 8.0;

@interface KSCLyricPlayerView : UIView

@property (weak, nonatomic) id<KSCLyricPlayerViewDataSource> dataSource;
@property (weak, nonatomic) id<KSCLyricPlayerViewDelegate> delegate;

- (KSCKaraokeLyricView *)reuseLyricView;
- (BOOL)isPlaying;
- (void)prepareToPlay;
- (void)start;
- (void)stop;
- (void)pause;
- (void)resume;
- (void)setCurrentTime:(CFTimeInterval)cur_time;
@end


@protocol KSCLyricPlayerViewDataSource <NSObject>
@required
- (NSArray *)timesForLyricPlayerView:(KSCLyricPlayerView *)lpv;
- (KSCKaraokeLyricView *)lyricPlayerView:(KSCLyricPlayerView *)lpv lyricAtIndex:(NSInteger)index;
@optional
- (CFTimeInterval)lengthOfLyricPlayerView:(KSCLyricPlayerView *)lpv;
- (BOOL)lyricPlayerView:(KSCLyricPlayerView *)lpv allowLyricAnimationAtIndex:(NSInteger)index;
@end


@protocol KSCLyricPlayerViewDelegate <NSObject>
@optional
- (void)lyricPlayerViewDidStarted:(KSCLyricPlayerView*)lpv;
- (void)lyricPlayerViewDidStoped:(KSCLyricPlayerView*)lpv;
@end
