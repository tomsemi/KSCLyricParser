//
//  KSCLyric.m
//  
//
//  Created by Mich on 08/02/2018.
//
//

#import "KSCLyric.h"

@implementation KSCLyric
- (instancetype)initWithTitle:(NSString *)title singer:(NSString *)singer composer:(NSString *)composer album:(NSString *)album {
    self = [super init];
    if (self) {
        _title = title;
        _singer = singer;
        _composer = composer;
        _album = album;
    }
    
    return self;
}

- (instancetype)init {
    self = [self initWithTitle:@"" singer:@"" composer:@"" album:@""];
    return self;
}



@end
