//
//  KSCKaraokeLyricView.h
//  
//
//  Created by Mich on 08/02/2018.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol KSCKaraokeLyricViewDelegate;

@interface KSCKaraokeLyricView : UILabel
@property (strong, nonatomic) UIColor *fillTextColor;
@property (nonatomic) CGFloat duration;
@property (nonatomic) NSDictionary *lyricSegment;
@property (weak, nonatomic) id<KSCKaraokeLyricViewDelegate> delegate;

- (void)startAnimation;
- (void)pauseAnimation;
- (void)resumeAnimation;
- (void)reset;
- (BOOL)isAnimating;
@end

@protocol KSCKaraokeLyricViewDelegate <NSObject>
- (void)karaokeLyricView:(KSCKaraokeLyricView*)lyricView didStartAnimation:(CAAnimation*)anim;
- (void)karaokeLyricView:(KSCKaraokeLyricView*)lyricView didStopAnimation:(CAAnimation*)anim finished:(BOOL)flag;
@end
