//
//  AudioPlayer.h
//  WAYNE_IOS_SDK
//
//  Created by wayne on 14-8-5.
//  Copyright (c) 2014年 green wayne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@interface AudioPlayer : NSObject<AVAudioPlayerDelegate>
@property(nonatomic,assign)id<AVAudioPlayerDelegate>delegate;
//-----
-(void)playWithContentsOfURL:(NSURL *)url error:(NSError **)outError;
-(void)playWithData:(NSData *)data error:(NSError **)outError;
-(void)pause;
-(void)stop;
@end
