//
//  RootViewController.m
//  DemoLyricPlayerWithMusic
//
//  Created by Mich on 08/02/2018.
//  Copyright (c) 2018 Mich. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>

#import "RootViewController.h"
#import "AboutViewController.h"
#import "PlayMusicViewController.h"

#import "KSCLyricParser.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"tableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"一万次悲伤 (Live)";
            cell.detailTextLabel.text = @"徐歌阳";
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *destinationVC;
    
    if(indexPath.row == 2) {
        destinationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"aboutVC"];
    } else {
        PlayMusicViewController *pmvc = [self.storyboard instantiateViewControllerWithIdentifier:@"playMusicVC"];
        KSCLyricParser *lyricParser = [[KSCBasicLyricParser alloc] init];
        
      if(indexPath.row == 0) {
            NSURL *fileURL = [NSURL fileURLWithPath: [[NSBundle mainBundle] pathForResource:@"徐歌阳 - 一万次悲伤 (Live)" ofType:@"mp3"]];
            
            pmvc.songURL = fileURL;
            pmvc.lyric = [lyricParser lyricFromLocalPathKSCFileName:@"徐歌阳 - 一万次悲伤 (Live)"];
          
          if (pmvc.lyric.sentences.count > 0) {
              Sentence * sentence = [[Sentence alloc] init];
              sentence.startTime = @"0";
              sentence.endTime = ((Sentence *)[pmvc.lyric.sentences objectAtIndex:0]).startTime;
              sentence.content = @"• • •";
              sentence.keyTimes = @[@(1.0)];
              [pmvc.lyric.sentences insertObject:sentence atIndex:0];
          }
        }
        
        destinationVC = pmvc;
    }
    
    [self.navigationController pushViewController:destinationVC animated:YES];
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
