//
//  Sentence.h
//  DemoKSCLyricPlayerWithMusic
//
//  Created by Mich on 08/02/2018.
//  Copyright © 2018 Mich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Sentence : NSObject

@property (nonatomic, copy) NSString * startTime;
@property (nonatomic, copy) NSString * endTime;
@property (nonatomic, copy) NSString * content;
@property (nonatomic, copy) NSString * interval;

@property (nonatomic, assign) float duration;

@property (nonatomic, copy) NSArray * words;
@property (nonatomic, copy) NSArray * keyTimes;

@end

