//
//  KSCLyricParser.h
//  
//
//  Created by Mich on 08/02/2018.
//
//

#import "KSCLyric.h"
@class KSCLyric;

@interface KSCLyricParser : NSObject

- (KSCLyric *)lyricFromLocalPathKSCFileName:(NSString *)KSC_FileName;
- (KSCLyric *)lyricFromKSCString:(NSString *)lrcString;

@end

@interface KSCBasicLyricParser : KSCLyricParser
@end
