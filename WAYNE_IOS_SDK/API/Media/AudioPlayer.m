//
//  AudioPlayer.m
//  WAYNE_IOS_SDK
//
//  Created by wayne on 14-8-5.
//  Copyright (c) 2014年 green wayne. All rights reserved.
//

#import "AudioPlayer.h"
@implementation AudioPlayer{
    AVAudioPlayer *_player;//AVFileTypeAIFF
}
-(void)playWithContentsOfURL:(NSURL *)url error:(NSError *__autoreleasing *)outError{
    [self stop];
    _player = nil;
    _player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:outError];
    [_player play];
}
-(void)playWithData:(NSData *)data error:(NSError *__autoreleasing *)outError{
    _player = nil;
    _player = [[AVAudioPlayer alloc]initWithData:data error:outError];
    [_player play];
}
-(void)pause{
    if (_player) {
        [_player pause];
    }
}
-(void)stop{
    if (_player) {
        [_player stop];
    }
}
@end
