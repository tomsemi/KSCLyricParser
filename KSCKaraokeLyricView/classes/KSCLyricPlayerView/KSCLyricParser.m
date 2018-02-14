//
//  KSCLyricParser.m
//  
//
//  Created by Mich on 08/02/2018.
//
//

#import "KSCLyricParser.h"
#import "KSCLyric.h"
#import "Sentence.h"

@interface KSCLyricParser() {
    NSString *lrc_content;
}

@end

@implementation KSCLyricParser

- (KSCLyric *)lyricFromLocalPathKSCFileName:(NSString *)KSC_FileName {
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:KSC_FileName ofType:@"txt"];
    
    lrc_content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    return [self lyricFromKSCString:lrc_content];
}

- (KSCLyric *)lyricFromKSCString:(NSString *)lrcString {
    NSLog(@"need to implement at subclass");
    return nil;
}

- (CGFloat)doubleFromString:(NSString *)str {
    
    CGFloat result = 0;
    NSArray *timeParts = [str componentsSeparatedByString:@":"];
    
    if ([timeParts count] > 1) {
        CGFloat min = [[timeParts objectAtIndex:0] doubleValue];
        CGFloat sec = [[timeParts objectAtIndex:1] doubleValue];
        result = min*60 + sec;
    }
    
    return result;
}
@end


@implementation KSCBasicLyricParser

- (KSCLyric *)lyricFromKSCString:(NSString *)lrcString {
    KSCLyric *lyric = [[KSCLyric alloc] init];
    
    NSArray *lyricArr = [lrcString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];

    NSMutableArray * sentences = [[NSMutableArray alloc] init];

    for (NSInteger i = 0; i < [lyricArr count] ; i++) {
        NSString *phrase = [lyricArr objectAtIndex:i];
        
        if ([phrase hasPrefix:@"karaoke"]) {
            // Lyric info
            NSString *prefixSongname =@"karaoke.songname :=";
            NSString *prefixSinger =@"karaoke.singer :=";
            
            if ([phrase hasPrefix:prefixSongname] || [phrase hasPrefix:prefixSinger]) {
                if ([phrase hasPrefix:prefixSongname]) {
                    // 取得歌曲名信息
                    NSArray *tempArray = [phrase componentsSeparatedByString:@"\'"];
                    if (tempArray.count > 2) {
                        lyric.title = tempArray[1];
                    }
                } else if ([phrase hasPrefix:prefixSinger]) {
                    // 取得歌手信息
                    NSArray *tempArray = [phrase componentsSeparatedByString:@"\'"];
                    if (tempArray.count > 2) {
                        lyric.singer = tempArray[1];
                    }
                }
            } else {
                // get Lyric content
                NSString* pattern = @"^karaoke\\.add\\('(\\d{2}:\\d{2}\\.\\d{3})',\\s*'(\\d{2}:\\d{2}\\.\\d{3})',\\s*'(.*)',\\s*'(.*)'\\);";
                
                NSError *error = nil;
                NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                                       options:NSRegularExpressionCaseInsensitive
                                                                                         error:&error];
                if (error!=nil) {
                    NSLog(@"error:%@",error);
                } else {
                    NSArray *matches = [regex matchesInString:phrase
                                                      options:0
                                                        range:NSMakeRange(0, [phrase length])];
                    
                    for (NSTextCheckingResult *match in matches) {
                        // 获取起始时间
                        Sentence * sentence = [[Sentence alloc] init];
                        NSString * startTime = [phrase substringWithRange:[match rangeAtIndex:1]];
                        
                        CGFloat keyTime = [self doubleFromString:startTime];
                        sentence.startTime = [NSString stringWithFormat:@"%.3f", keyTime];

                        // 获取终止时间
                        NSString * endTime = [phrase substringWithRange:[match rangeAtIndex:2]];
                        keyTime = [self doubleFromString:endTime];
                        sentence.endTime = [NSString stringWithFormat:@"%.3f", keyTime];
                        
                        // 获取该行歌词内容
                        sentence.content = [phrase substringWithRange:[match rangeAtIndex:3]];
                        sentence.words = [self lyricsWords:sentence.content];
                        // 获取该行歌词中单字的持续时间
                        sentence.interval = [phrase substringWithRange:[match rangeAtIndex:4]];

                        sentence.duration = [self totalDuration:sentence.interval];
                        
                        sentence.keyTimes = [self keyTimes:sentence.interval];
                        
                        NSLog(@"startTime：%@,endTime:%@,content:%@,interval:%@", sentence.startTime,sentence.endTime,sentence.content,sentence.interval);
                        [sentences addObject:sentence];
                    }
                }
            }
        } else {
            continue;
        }
    }
    lyric.sentences = sentences;
    return lyric;
}

- (NSArray *)lyricsWords:(NSString *)lineLyricsStr {
    NSMutableArray * lineLyricsList = [[NSMutableArray alloc] init];
    NSString *temp = @"";
    BOOL isEnter = NO;
    
    for(int i = 0; i < [lineLyricsStr length]; i++)
    {
        NSString *c = [lineLyricsStr substringWithRange:NSMakeRange(i, 1)];
        if ((![c isEqualToString:@"["])&&(![c isEqualToString:@"]"])) {
            if (isEnter) {
                temp = [NSString stringWithFormat:@"%@%@",temp,c];
            } else {
                [lineLyricsList addObject:c];
            }
        } else if ([c isEqualToString:@"["]) {
            isEnter = YES;
        } else if ([c isEqualToString:@"]"]) {
            isEnter = NO;
            [lineLyricsList addObject:temp];
            temp = @"";
        } else {
            temp = [NSString stringWithFormat:@"%@%@",temp,c];
        }
    }
    return lineLyricsList;
}

- (float)totalDuration:(NSString *)interval {
    NSArray *intervalParts = [interval componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
    
    float sum = 0.0;
    for (NSString *item in intervalParts) {
        sum += [item floatValue];
    }
    return sum*1.0/1000;
}

- (NSArray *)keyTimes:(NSString *)interval {
    if (interval != nil) {
        NSMutableArray *mutableArray = [NSMutableArray array];
        NSArray *intervalParts = [interval componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
        
        float sum = 0.0;
        for (NSString *item in intervalParts) {
            sum += [item floatValue];
        }
        
        if (sum <= 0) {
            return mutableArray;
        }
        
        for (NSString *inter in intervalParts) {
            
            CGFloat tempTime = 0;
            if (mutableArray.count > 0) {
                tempTime = MIN(0.98, [inter floatValue] /sum + [mutableArray.lastObject floatValue]);
            } else {
                tempTime = MIN(0.98, [inter floatValue] /sum);
            }
            [mutableArray addObject:@(tempTime)];
        }
        return mutableArray;
    }
    return nil;
}

@end
