//
//  KSCLyric.h
//  
//
//  Created by Mich on 08/02/2018.
//
//

#import <UIKit/UIKit.h>
#import "Sentence.h"

@interface KSCLyric : NSObject
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *singer;
@property (strong, nonatomic) NSString *composer;
@property (strong, nonatomic) NSString *album;

@property (strong, nonatomic) NSDictionary *content;
@property (strong, nonatomic) NSMutableArray *sentences;


- (instancetype)initWithTitle:(NSString *)title
                       singer:(NSString *)singer
                     composer:(NSString *)composer
                        album:(NSString *)album;

@end
