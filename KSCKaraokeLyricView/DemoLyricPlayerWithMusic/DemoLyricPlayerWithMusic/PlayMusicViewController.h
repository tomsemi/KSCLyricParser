//
//  PlayMusicViewController.h
//  DemoLyricPlayerWithMusic
//
//  Created by Mich on 08/02/2018.
//  Copyright (c) 2018 Mich. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AVAsset;
@class KSCLyric;
@interface PlayMusicViewController : UIViewController
@property (strong, nonatomic) NSURL *songURL;
@property (strong, nonatomic) KSCLyric *lyric;
@end
